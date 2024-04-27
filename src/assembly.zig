const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");
const routing = @import("routing.zig");
const fuses = @import("fuses.zig");

const Chip_Config = lc4k.Chip_Config;
const Factor = lc4k.Factor;
const Product_Term = lc4k.Product_Term;

pub const AssemblyError = struct {
    err: anyerror,
    details: []const u8,
    gi: ?lc4k.GI_Index = null,
    glb: ?lc4k.GLB_Index = null,
    mc: ?lc4k.MC_Index = null,
    // mc_pt: ?u8 = null,
};

pub const Assembly_Results = struct {
    jedec: jedec.Jedec_File,
    errors: std.ArrayList(AssemblyError),
};

pub fn assemble(comptime Device: type, config: Chip_Config(Device.device_type), allocator: std.mem.Allocator) !Assembly_Results {
    var results = Assembly_Results {
        .jedec = jedec.Jedec_File {
            .data = try jedec.JedecData.initFull(allocator, Device.jedec_dimensions),
        },
        .errors = std.ArrayList(AssemblyError).init(allocator),
    };

    var prng = std.rand.Xoroshiro128.init(0x0416_fff9_140b_a135); // random but consistent seed
    const rnd = prng.random();

    for (config.glb, 0..) |glb_config, glb| {
        // Compile list of GRP signals needed in this GLB:
        var gi_routing = [_]?Device.GRP { null } ** Device.num_gis_per_glb;
        switch (glb_config.shared_pt_init) {
            .active_high, .active_low => |pt| try routing.addSignalsFromPT(Device, &gi_routing, pt),
        }
        switch (glb_config.shared_pt_clock) {
            .positive, .negative => |pt| try routing.addSignalsFromPT(Device, &gi_routing, pt),
        }
        try routing.addSignalsFromPT(Device, &gi_routing, glb_config.shared_pt_enable);

        for (glb_config.mc) |mc_config| {
            switch (mc_config.logic) {
                .sum, .sum_inverted => |sum| {
                    for (sum) |pt| {
                        try routing.addSignalsFromPT(Device, &gi_routing, pt);
                    }
                },
                .pt0, .pt0_inverted => |pt| {
                    try routing.addSignalsFromPT(Device, &gi_routing, pt);
                },
                .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| {
                    try routing.addSignalsFromPT(Device, &gi_routing, logic.pt0);
                    for (logic.sum) |pt| {
                        try routing.addSignalsFromPT(Device, &gi_routing, pt);
                    }
                },
                .sum_xor_input_buffer => |sum| {
                    for (sum) |pt| {
                        try routing.addSignalsFromPT(Device, &gi_routing, pt);
                    }
                },
                .input_buffer => {},
            }
            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (getSpecialPT(Device, mc_config, special_pt)) |pt| {
                    try routing.addSignalsFromPT(Device, &gi_routing, pt);
                }
            }
            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => |pts| for (pts) |pt| {
                        try routing.addSignalsFromPT(Device, &gi_routing, pt);
                    },
                }
            }
        }

        // Route GRP signals to specific GI fuses:
        try routing.routeGIs(Device, &gi_routing, rnd);
        for (gi_routing, 0..) |maybe_signal, gi| if (maybe_signal) |signal| {
            const option_index = std.mem.indexOfScalar(Device.GRP, &Device.gi_options[gi], signal).?;
            const range = Device.get_gi_range(glb, gi);
            var iter = range.iterator();
            iter.skip(option_index);
            results.jedec.data.put(iter.next().?, 0);
        };

        // Assign sum PTs to clusters to MCs and program routing fuses
        var router = routing.ClusterRouter.init(allocator, Device, glb_config);
        defer router.deinit();
        var cluster_routing = try router.route(&results);

        // Program PT fuses
        for (glb_config.mc, 0..) |mc_config, mc| {
             if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => |pts| {
                        var next_sum_pt: usize = 0;
                        var pt_index: usize = 0;
                        while (pt_index < 5) : (pt_index += 1) {
                            if (getSpecialPT(Device, mc_config, pt_index)) |_| continue;
                            const glb_pt_offset = mc * 5 + pt_index;
                            if (next_sum_pt < pts.len) {
                                const pt = pts[next_sum_pt];
                                try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, pt);
                                next_sum_pt += 1;
                            } else if (!lc4k.is_sum_always(pts)) {
                                try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, Product_Term(Device.GRP).never());
                            }
                        }
                        if (next_sum_pt < pts.len and !lc4k.is_sum_always(pts)) {
                            return error.TooManySumPTs;
                        }
                    },
                }
            }
            {
                const sum_pts = switch (mc_config.logic) {
                    .sum, .sum_inverted, .sum_xor_input_buffer => |sum| sum,
                    .input_buffer, .pt0, .pt0_inverted => &[_]Product_Term(Device.GRP) {},
                    .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| logic.sum,
                };
                var next_sum_pt: usize = 0;
                var pt_iter = cluster_routing.iterator(Device, &glb_config, mc);
                while (pt_iter.next()) |glb_pt_offset| {
                    if (next_sum_pt < sum_pts.len) {
                        const pt = sum_pts[next_sum_pt];
                        try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, pt);
                        next_sum_pt += 1;
                    } else if (!lc4k.is_sum_always(sum_pts)) {
                        try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, Product_Term(Device.GRP).never());
                    }
                }
                if (next_sum_pt < sum_pts.len and !lc4k.is_sum_always(sum_pts)) {
                    return error.TooManySumPTs;
                }
            }

            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (getSpecialPT(Device, mc_config, special_pt)) |pt| {
                    try writePTFuses(Device, &results, glb, mc * 5 + special_pt, &gi_routing, pt);
                }
            }
        }

        switch (glb_config.shared_pt_init) {
            .active_high, .active_low => |pt| try writePTFuses(Device, &results, glb, 80, &gi_routing, pt),
        }
        switch (glb_config.shared_pt_clock) {
            .positive, .negative => |pt| try writePTFuses(Device, &results, glb, 81, &gi_routing, pt),
        }
        try writePTFuses(Device, &results, glb, 82, &gi_routing, glb_config.shared_pt_enable);

        // Program MC-slice configuration fuses (Replace default/unset parameters with the defaults)
        for (glb_config.mc, 0..) |mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            writeField(&results.jedec.data, lc4k.Cluster_Routing, cluster_routing.cluster[mc], fuses.getCluster_RoutingRange(Device, mcref));
            writeField(&results.jedec.data, lc4k.Wide_Routing, cluster_routing.wide[mc], fuses.getWide_RoutingRange(Device, mcref));

            const pt0xor: u1 = switch (mc_config.logic) {
                .pt0, .pt0_inverted, .sum_xor_pt0, .sum_xor_pt0_inverted => 0,
                .sum, .sum_inverted, .sum_xor_input_buffer, .input_buffer => 1,
            };
            writeField(&results.jedec.data, u1, pt0xor, fuses.getPT0XorRange(Device, mcref));

            const invert: u1 = switch (mc_config.logic) {
                .sum_inverted, .pt0_inverted, .sum_xor_pt0_inverted => 1,
                .sum, .input_buffer, .pt0, .sum_xor_pt0, .sum_xor_input_buffer => 0,
            };
            writeField(&results.jedec.data, u1, invert, fuses.getInvertRange(Device, mcref));

            const input_bypass: u1 = switch (mc_config.logic) {
                .input_buffer => 0,
                else => 1,
            };
            writeField(&results.jedec.data, u1, input_bypass, fuses.getInputBypassRange(Device, mcref));

            writeField(&results.jedec.data, lc4k.Macrocell_Function, mc_config.func, fuses.getMcFuncRange(Device, mcref));
            switch (mc_config.func) {
                .combinational => {},
                .latch, .t_ff, .d_ff => |reg_config| {
                    switch (reg_config.clock) {
                        .none => {},
                        .pt1_positive => {
                            writeField(&results.jedec.data, u2, 0, fuses.getClockSourceLowRange(Device, mcref));
                        },
                        .pt1_negative => {
                            writeField(&results.jedec.data, u2, 1, fuses.getClockSourceLowRange(Device, mcref));
                        },
                        .shared_pt_clock => {
                            writeField(&results.jedec.data, u2, 2, fuses.getClockSourceLowRange(Device, mcref));
                        },
                        .bclock0 => {
                            writeField(&results.jedec.data, u2, 0, fuses.getClockSourceLowRange(Device, mcref));
                            writeField(&results.jedec.data, u1, 0, fuses.getClockSourceHighRange(Device, mcref));
                        },
                        .bclock1 => {
                            writeField(&results.jedec.data, u2, 1, fuses.getClockSourceLowRange(Device, mcref));
                            writeField(&results.jedec.data, u1, 0, fuses.getClockSourceHighRange(Device, mcref));
                        },
                        .bclock2 => {
                            writeField(&results.jedec.data, u2, 2, fuses.getClockSourceLowRange(Device, mcref));
                            writeField(&results.jedec.data, u1, 0, fuses.getClockSourceHighRange(Device, mcref));
                        },
                        .bclock3 => {
                            writeField(&results.jedec.data, u2, 3, fuses.getClockSourceLowRange(Device, mcref));
                            writeField(&results.jedec.data, u1, 0, fuses.getClockSourceHighRange(Device, mcref));
                        },
                    }
                    const ce: u2 = switch (reg_config.ce) {
                        .pt2_active_high => 0,
                        .pt2_active_low => 1,
                        .shared_pt_clock => 2,
                        .always_active => 3,
                    };
                    writeField(&results.jedec.data, u2, ce, fuses.getCERange(Device, mcref));

                    const init_state: u1 = reg_config.init_state ^ 1;
                    writeField(&results.jedec.data, u1, init_state, fuses.getInitStateRange(Device, mcref));
                    const init_src: u1 = switch (reg_config.init_source) {
                        .pt3_active_high => 0,
                        .shared_pt_init => 1,
                    };
                    writeField(&results.jedec.data, u1, init_src, fuses.getInitSourceRange(Device, mcref));
                    const async_src: u1 = switch (reg_config.async_source) {
                        .pt2_active_high => 0,
                        .none => 1,
                    };
                    writeField(&results.jedec.data, u1, async_src, fuses.getAsyncSourceRange(Device, mcref));
                },
            }

            const oe: u1 = if (mc_config.pt4_oe == null) 1 else 0;
            writeField(&results.jedec.data, u1, oe, fuses.getPT4OERange(Device, mcref));

            if (fuses.getOESourceRange(Device, mcref)) |range| {
                writeField(&results.jedec.data, lc4k.Output_Enable_Mode, mc_config.output.oe, range);
            }

            if (fuses.getOutput_RoutingRange(Device, mcref)) |range| {
                const oe_routing = if (@TypeOf(mc_config.output) == lc4k.Output_Config_ZE) mc_config.output.routing else mc_config.output.oe_routing;
                const relative: u3 = switch (oe_routing) {
                    .relative => |delta| delta,
                    .absolute => |src_mc| rel: {
                        const delta = @as(i32, src_mc) - mcref.mc;
                        if (delta < 0 or delta > 7) {
                            return error.InvalidOutput_Routing;
                        }
                        break :rel @intCast(delta);
                    },
                };
                writeField(&results.jedec.data, u3, relative, range);
            }

            if (@TypeOf(mc_config.output) != lc4k.Output_Config_ZE) {
                if (fuses.getOutput_Routing_ModeRange(Device, mcref)) |range| {
                    const mode: u2 = switch (mc_config.output.routing) {
                        .same_as_oe => 2,
                        .self => 3,
                        .five_pt_fast_bypass => 0,
                        .five_pt_fast_bypass_inverted => 1,
                    };
                    writeField(&results.jedec.data, u2, mode, range);
                }
            }

            if (fuses.getSlew_RateRange(Device, mcref)) |range| {
                const value = mc_config.output.slew_rate orelse config.default_slew_rate;
                writeField(&results.jedec.data, lc4k.Slew_Rate, value, range);
            }

            if (fuses.getDrive_TypeRange(Device, mcref)) |range| {
                const value = mc_config.output.drive_type orelse config.default_drive_type;
                writeField(&results.jedec.data, lc4k.Drive_Type, value, range);
            }

            if (fuses.getInput_ThresholdRange(Device, mcref)) |range| {
                const value = mc_config.input.threshold orelse config.default_input_threshold;
                writeField(&results.jedec.data, lc4k.Input_Threshold, value, range);
            }

            if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                const value = mc_config.input.bus_maintenance orelse config.default_bus_maintenance;
                writeField(&results.jedec.data, lc4k.Bus_Maintenance, value, fuses.getBus_MaintenanceRange(Device, mcref));

                const pgdf = mc_config.input.power_guard orelse config.ext.default_power_guard;
                writeField(&results.jedec.data, lc4k.Power_Guard, pgdf, fuses.getPower_GuardRange(Device, mcref));
            }

        }

        const spt_init_pol: u1 = switch (glb_config.shared_pt_init) {
            .active_low => 0,
            .active_high => 1,
        };
        writeField(&results.jedec.data, u1, spt_init_pol, fuses.getSharedInitPolarityRange(Device, glb));

        const spt_clk_pol: u1 = switch (glb_config.shared_pt_clock) {
            .negative => 0,
            .positive => 1,
        };
        writeField(&results.jedec.data, u1, spt_clk_pol, fuses.getSharedClockPolarityRange(Device, glb));

        const bclk0: u1 = switch (glb_config.bclock0) {
            .clk0_pos => 1,
            .clk1_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk0, Device.get_bclock_range(glb).subRows(0, 1));
        const bclk1: u1 = switch (glb_config.bclock1) {
            .clk1_pos => 1,
            .clk0_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk1, Device.get_bclock_range(glb).subRows(1, 1));
        const bclk2: u1 = switch (glb_config.bclock2) {
            .clk2_pos => 1,
            .clk3_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk2, Device.get_bclock_range(glb).subRows(2, 1));
        const bclk3: u1 = switch (glb_config.bclock3) {
            .clk3_pos => 1,
            .clk2_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk3, Device.get_bclock_range(glb).subRows(3, 1));
    }

    writeGoeFuses(Device, &results.jedec.data, config.goe0, 0);
    writeGoeFuses(Device, &results.jedec.data, config.goe1, 1);
    writeGoeFuses(Device, &results.jedec.data, config.goe2, 2);
    writeGoeFuses(Device, &results.jedec.data, config.goe3, 3);

    results.jedec.data.put(Device.get_zero_hold_time_fuse(), @intFromBool(!config.zero_hold_time));

    if (Device.family == .zero_power_enhanced) {

        if (config.ext.osctimer) |osctimer| {
            results.jedec.data.putRange(Device.getOscTimerEnableRange(), 0);
            writeField(&results.jedec.data, lc4k.Timer_Divisor, osctimer.timer_divisor, Device.getTimerDivRange());
            results.jedec.data.put(Device.getOscOutFuse(), @intFromBool(!osctimer.enable_osc_out_and_disable));
            results.jedec.data.put(Device.getTimerOutFuse(), @intFromBool(!osctimer.enable_timer_out_and_reset));
        }
    } else {
        writeField(&results.jedec.data, lc4k.Bus_Maintenance, config.default_bus_maintenance, Device.get_global_bus_maintenance_range());
        if (config.default_bus_maintenance == .float) {
            for (Device.get_extra_float_input_fuses()) |fuse| {
                results.jedec.data.put(fuse, 0);
            }
        }
    }

    // Program clock/input fuses
    for (config.clock, 0..) |clock_config, clock_pin_index| {
        const pin = Device.clock_pins[clock_pin_index];
        writeDedicatedInputFuses(Device, &results.jedec.data, pin.info, &config, clock_config);
    }

    for (config.input, 0..) |input_config, input_pin_index| {
        const pin = Device.input_pins[input_pin_index];
        writeDedicatedInputFuses(Device, &results.jedec.data, pin.info, &config, input_config);
    }

    results.jedec.pin_count = Device.all_pins.len;
    results.jedec.usercode = config.usercode;
    results.jedec.security = @intFromBool(config.security);

    return results;
}

pub fn getSpecialPT(
    comptime Device: type, 
    mc_config: lc4k.Macrocell_Config(Device.family, Device.GRP),
    pt_index: usize
) ?lc4k.Product_Term(Device.GRP) {
    return switch (pt_index) {
        0 => switch (mc_config.logic) {
            .pt0, .pt0_inverted => |pt| pt,
            .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| logic.pt0,
            .sum, .sum_inverted, .sum_xor_input_buffer, .input_buffer => null,
        },
        1 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.clock) {
                .none, .shared_pt_clock, .bclock0, .bclock1, .bclock2, .bclock3 => null,
                .pt1_positive, .pt1_negative => |pt| pt,
            },
        },
        2 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.ce) {
                .always_active, .shared_pt_clock => switch (reg_config.async_source) {
                    .none => null,
                    .pt2_active_high => |pt| pt,
                },
                .pt2_active_low, .pt2_active_high => |pt| pt,
            },
        },
        3 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.init_source) {
                .shared_pt_init => null,
                .pt3_active_high => |pt| pt,
            },
        },
        4 => if (mc_config.pt4_oe) |pt| pt else null,
        else => unreachable,
    };
}

fn writeGoeFuses(comptime Device: type, data: *jedec.JedecData, goe_config: anytype, goe_index: usize) void {
    switch (@TypeOf(goe_config)) {
        lc4k.GOE_Config_Bus_Or_Pin => switch (goe_config.source) {
            .input => {
                data.put(Device.get_goe_source_fuse(goe_index), 0);
            },
            .constant_high => {
                data.put(Device.get_goe_source_fuse(goe_index), 1);
            },
            .glb_shared_pt_enable => |glb| {
                data.put(Device.get_goe_source_fuse(goe_index), 1);
                writeField(data, u1, 0, fuses.getSharedEnableToOEBusRange(Device, glb).subRows(goe_index, 1));
            },
        },
        lc4k.GOE_Config_Bus => switch (goe_config.source) {
            .constant_high => {},
            .glb_shared_pt_enable => |glb| {
                writeField(data, u1, 0, fuses.getSharedEnableToOEBusRange(Device, glb).subRows(goe_index, 1));
            },
        },
        else => {},
    }
    data.put(Device.get_goe_polarity_fuse(goe_index), @intFromBool(goe_config.polarity == .active_high));
}

fn writeDedicatedInputFuses(comptime Device: type, data: *jedec.JedecData, pin_info: lc4k.Pin_Info, config: *const Chip_Config(Device.device_type), input_config: anytype) void {
    const grp: Device.GRP = @enumFromInt(pin_info.grp_ordinal.?);

    const threshold = input_config.threshold orelse config.default_input_threshold;
    writeField(data, lc4k.Input_Threshold, threshold, jedec.FuseRange.fromFuse(Device.get_input_threshold_fuse(grp)));

    if (@TypeOf(input_config) == lc4k.Input_Config_ZE) {
        const maintenance = input_config.bus_maintenance orelse config.default_bus_maintenance;
        writeField(data, lc4k.Bus_Maintenance, maintenance, Device.getInputBus_MaintenanceRange(grp));

        const pgdf = input_config.power_guard orelse config.ext.default_power_guard;
        writeField(data, lc4k.Power_Guard, pgdf, jedec.FuseRange.fromFuse(Device.getInputPower_GuardFuse(grp)));
    }
}

fn writePTFuses(comptime Device: type, results: *Assembly_Results, glb: usize, glb_pt_offset: usize, gi_signals: *[Device.num_gis_per_glb]?Device.GRP, pt: Product_Term(Device.GRP)) !void {
    if (pt.is_always()) return;

    const range = fuses.getPTRange(Device, glb, glb_pt_offset);

    var is_never = false;
    for (pt.factors) |factor| switch (factor) {
        .always => {},
        .never => is_never = true,
        .when_high, .when_low => |grp| {
            const fuse = for (gi_signals, 0..) |maybe_grp, gi| {
                if (maybe_grp) |gi_grp| {
                    if (gi_grp == grp) {
                        const gi_fuses = range.subRows(gi * 2, 2); // should be exactly 2 fuses stacked vertically
                        if (factor == .when_low) {
                            break gi_fuses.max;
                        } else {
                            break gi_fuses.min;
                        }
                    }
                }
            } else {
                return error.SignalNotRouted;
            };
            results.jedec.data.put(fuse, 0);
        },
    };

    // TODO check for PT factors that should have been turned into .never?

    if (is_never) {
        results.jedec.data.putRange(range.subRows(0, Device.num_gis_per_glb * 2), 0);
    }
}

fn writeField(data: *jedec.JedecData, comptime T: type, value: T, range: jedec.FuseRange) void {
    std.debug.assert(@bitSizeOf(T) == range.count());
    const v = if (@typeInfo(T) == .Enum) @intFromEnum(value) else value;
    const IntT = std.meta.Int(.unsigned, @bitSizeOf(T));
    var int_value = @as(u64, @as(IntT, @bitCast(v)));
    var iter = range.iterator();
    while (iter.next()) |fuse| {
        data.put(fuse, @truncate(int_value));
        int_value = int_value >> 1;
    }
}
