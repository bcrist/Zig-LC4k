const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");
const common = @import("common.zig");
const routing = @import("routing.zig");
const internal = @import("internal.zig");
const fuses = @import("fuses.zig");

const LC4k = lc4k.LC4k;
const Factor = lc4k.Factor;
const PT = lc4k.PT;
const PTs = lc4k.PTBuilder;

pub const AssemblyError = struct {
    err: anyerror,
    details: []const u8,
    gi: ?common.GiIndex = null,
    glb: ?common.GlbIndex = null,
    mc: ?common.MacrocellIndex = null,
    // mc_pt: ?u8 = null,
};

pub const AssemblyResults = struct {
    jedec: jedec.JedecFile,
    errors: std.ArrayList(AssemblyError),
};

pub fn assemble(comptime Device: type, config: LC4k(Device.device_type), allocator: std.mem.Allocator) !AssemblyResults {
    var results = AssemblyResults {
        .jedec = jedec.JedecFile {
            .data = try jedec.JedecData.initFull(allocator, Device.jedec_dimensions),
        },
        .errors = std.ArrayList(AssemblyError).init(allocator),
    };

    var prng = std.rand.Xoroshiro128.init(0x0416_fff9_140b_a135); // random but consistent seed
    var rnd = prng.random();

    for (config.glb) |glb_config, glb| {
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
            for (mc_config.sum) |pt| {
                try routing.addSignalsFromPT(Device, &gi_routing, pt);
            }
            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (internal.getSpecialPT(Device, mc_config, special_pt)) |pt| {
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
        for (gi_routing) |maybe_signal, gi| if (maybe_signal) |signal| {
            const option_index = std.mem.indexOfScalar(Device.GRP, &Device.gi_options[gi], signal).?;
            const range = Device.getGiRange(glb, gi);
            var iter = range.iterator();
            iter.skip(option_index);
            results.jedec.data.put(iter.next().?, 0);
        };

        // Assign sum PTs to clusters to MCs and program routing fuses
        var router = routing.ClusterRouter.init(allocator, Device, glb_config);
        defer router.deinit();
        var cluster_routing = try router.route(&results);

        // Program PT fuses
        for (glb_config.mc) |mc_config, mc| {
             if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => |pts| {
                        var next_sum_pt: usize = 0;
                        var pt_index: usize = 0;
                        while (pt_index < 5) : (pt_index += 1) {
                            if (internal.getSpecialPT(Device, mc_config, pt_index)) |_| continue;
                            const glb_pt_offset = mc * 5 + pt_index;
                            if (next_sum_pt < pts.len) {
                                const pt = pts[next_sum_pt];
                                try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, pt);
                                next_sum_pt += 1;
                            } else if (!internal.isSumAlways(pts)) {
                                try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, PTs(Device).never());
                            }
                        }
                        if (next_sum_pt < pts.len and !internal.isSumAlways(pts)) {
                            return error.TooManySumPTs;
                        }
                    },
                }
            }
            {
                // sum PTs
                var next_sum_pt: usize = 0;
                var pt_iter = cluster_routing.iterator(Device, &glb_config, mc);
                while (pt_iter.next()) |glb_pt_offset| {
                    if (next_sum_pt < mc_config.sum.len) {
                        const pt = mc_config.sum[next_sum_pt];
                        try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, pt);
                        next_sum_pt += 1;
                    } else if (!internal.isSumAlways(mc_config.sum)) {
                        try writePTFuses(Device, &results, glb, glb_pt_offset, &gi_routing, PTs(Device).never());
                    }
                }
                if (next_sum_pt < mc_config.sum.len and !internal.isSumAlways(mc_config.sum)) {
                    return error.TooManySumPTs;
                }
            }

            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (internal.getSpecialPT(Device, mc_config, special_pt)) |pt| {
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
        for (glb_config.mc) |mc_config, mc| {
            const mcref = common.MacrocellRef.init(glb, mc);

            writeField(&results.jedec.data, common.ClusterRouting, cluster_routing.cluster[mc], fuses.getClusterRoutingRange(Device, mcref));
            writeField(&results.jedec.data, common.WideRouting, cluster_routing.wide[mc], fuses.getWideRoutingRange(Device, mcref));

            const pt0xor: u1 = switch (mc_config.xor) {
                .pt0, .pt0_inverted => 0,
                .none, .input, .invert => 1,
            };
            writeField(&results.jedec.data, u1, pt0xor, fuses.getPT0XorRange(Device, mcref));

            const invert: u1 = switch (mc_config.xor) {
                .invert, .pt0_inverted => 1,
                .none, .input, .pt0 => 0,
            };
            writeField(&results.jedec.data, u1, invert, fuses.getInvertRange(Device, mcref));

            const xor: u1 = switch (mc_config.xor) {
                .input => 0,
                .invert, .none, .pt0, .pt0_inverted => 1,
            };
            writeField(&results.jedec.data, u1, xor, fuses.getInputXorRange(Device, mcref));

            switch (mc_config.clock) {
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
                .bclock => |bclk| {
                    writeField(&results.jedec.data, u2, bclk, fuses.getClockSourceLowRange(Device, mcref));
                    writeField(&results.jedec.data, u1, 0, fuses.getClockSourceHighRange(Device, mcref));
                },
            }

            const ce: u2 = switch (mc_config.ce) {
                .pt2_active_high => 0,
                .pt2_active_low => 1,
                .shared_pt_clock => 2,
                .always_active => 3,
            };
            writeField(&results.jedec.data, u2, ce, fuses.getCERange(Device, mcref));

            const init_state: u1 = mc_config.init_state ^ 1;
            writeField(&results.jedec.data, u1, init_state, fuses.getInitStateRange(Device, mcref));
            const init_src: u1 = switch (mc_config.init_source) {
                .pt3_active_high => 0,
                .shared_pt_init => 1,
            };
            writeField(&results.jedec.data, u1, init_src, fuses.getInitSourceRange(Device, mcref));
            const async_src: u1 = switch (mc_config.async_source) {
                .pt2_active_high => 0,
                .none => 1,
            };
            writeField(&results.jedec.data, u1, async_src, fuses.getAsyncSourceRange(Device, mcref));

            writeField(&results.jedec.data, common.MacrocellFunction, mc_config.func, fuses.getMcFuncRange(Device, mcref));

            const oe: u1 = if (mc_config.pt4_oe == null) 1 else 0;
            writeField(&results.jedec.data, u1, oe, fuses.getPT4OERange(Device, mcref));

            if (fuses.getOESourceRange(Device, mcref)) |range| {
                writeField(&results.jedec.data, common.OutputEnableMode, mc_config.output.oe, range);
            }

            if (fuses.getOutputRoutingRange(Device, mcref)) |range| {
                const oe_routing = if (@TypeOf(mc_config.output) == lc4k.OutputConfigZE) mc_config.output.routing else mc_config.output.oe_routing;
                const relative = switch (oe_routing) {
                    .relative => |delta| delta,
                    .absolute => |src_mc| rel: {
                        const delta = @as(i32, src_mc) - mcref.mc;
                        if (delta < 0 or delta > 7) {
                            return error.InvalidOutputRouting;
                        }
                        break :rel @intCast(u3, delta);
                    },
                };
                writeField(&results.jedec.data, u3, relative, range);
            }

            if (@TypeOf(mc_config.output) != lc4k.OutputConfigZE) {
                if (fuses.getOutputRoutingModeRange(Device, mcref)) |range| {
                    const mode: u2 = switch (mc_config.output.routing) {
                        .same_as_oe => 2,
                        .self => 3,
                        .five_pt_fast_bypass => 0,
                        .five_pt_fast_bypass_inverted => 1,
                    };
                    writeField(&results.jedec.data, u2, mode, range);
                }
            }

            if (fuses.getSlewRateRange(Device, mcref)) |range| {
                const value = mc_config.output.slew_rate orelse config.default_slew_rate;
                writeField(&results.jedec.data, common.SlewRate, value, range);
            }

            if (fuses.getDriveTypeRange(Device, mcref)) |range| {
                const value = mc_config.output.drive_type orelse config.default_drive_type;
                writeField(&results.jedec.data, common.DriveType, value, range);
            }

            if (fuses.getInputThresholdRange(Device, mcref)) |range| {
                const value = mc_config.input.threshold orelse config.default_input_threshold;
                writeField(&results.jedec.data, common.InputThreshold, value, range);
            }

            if (@TypeOf(mc_config.input) == lc4k.InputConfigZE) {
                const value = mc_config.input.bus_maintenance orelse config.default_bus_maintenance;
                writeField(&results.jedec.data, common.BusMaintenance, value, fuses.getBusMaintenanceRange(Device, mcref));

                const pgdf = mc_config.input.power_guard orelse config.ext.default_power_guard;
                writeField(&results.jedec.data, common.PowerGuard, pgdf, fuses.getPowerGuardRange(Device, mcref));
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
        writeField(&results.jedec.data, u1, bclk0, Device.getBClockRange(glb).subRows(0, 1));
        const bclk1: u1 = switch (glb_config.bclock1) {
            .clk1_pos => 1,
            .clk0_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk1, Device.getBClockRange(glb).subRows(1, 1));
        const bclk2: u1 = switch (glb_config.bclock2) {
            .clk2_pos => 1,
            .clk3_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk2, Device.getBClockRange(glb).subRows(2, 1));
        const bclk3: u1 = switch (glb_config.bclock3) {
            .clk3_pos => 1,
            .clk2_neg => 0,
        };
        writeField(&results.jedec.data, u1, bclk3, Device.getBClockRange(glb).subRows(3, 1));
    }

    writeGoeFuses(Device, &results.jedec.data, config.goe0, 0);
    writeGoeFuses(Device, &results.jedec.data, config.goe1, 1);
    writeGoeFuses(Device, &results.jedec.data, config.goe2, 2);
    writeGoeFuses(Device, &results.jedec.data, config.goe3, 3);

    results.jedec.data.put(Device.getZeroHoldTimeFuse(), @boolToInt(!config.zero_hold_time));

    if (Device.family == .zero_power_enhanced) {

        if (config.ext.osctimer) |osctimer| {
            results.jedec.data.putRange(Device.getOscTimerEnableRange(), 0);
            writeField(&results.jedec.data, common.TimerDivisor, osctimer.timer_divisor, Device.getTimerDivRange());
            results.jedec.data.put(Device.getOscOutFuse(), @boolToInt(!osctimer.enable_osc_out_and_disable));
            results.jedec.data.put(Device.getTimerOutFuse(), @boolToInt(!osctimer.enable_timer_out_and_reset));
        }
    } else {
        writeField(&results.jedec.data, common.BusMaintenance, config.default_bus_maintenance, Device.getGlobalBusMaintenanceRange());
        if (config.default_bus_maintenance == .float) {
            for (Device.getExtraFloatInputFuses()) |fuse| {
                results.jedec.data.put(fuse, 0);
            }
        }
    }

    // Program clock/input fuses
    for (config.clock) |clock_config, clock_pin_index| {
        const pin_info = Device.clock_pins[clock_pin_index];
        writeDedicatedInputFuses(Device, &results.jedec.data, pin_info, &config, clock_config);
    }

    for (config.input) |input_config, input_pin_index| {
        const pin_info = Device.input_pins[input_pin_index];
        writeDedicatedInputFuses(Device, &results.jedec.data, pin_info, &config, input_config);
    }

    results.jedec.pin_count = Device.all_pins.len;
    results.jedec.usercode = config.usercode;
    results.jedec.security = @boolToInt(config.security);

    return results;
}

fn writeGoeFuses(comptime Device: type, data: *jedec.JedecData, goe_config: anytype, goe_index: usize) void {
    switch (@TypeOf(goe_config)) {
        lc4k.GOEConfigBusOrPin => switch (goe_config.source) {
            .input => {
                data.put(Device.getGOESourceFuse(goe_index), 0);
            },
            .none => {
                data.put(Device.getGOESourceFuse(goe_index), 1);
            },
            .glb_shared_pt_enable => |glb| {
                data.put(Device.getGOESourceFuse(goe_index), 1);
                writeField(data, u1, 0, fuses.getSharedEnableToOEBusRange(Device, glb).subRows(goe_index, 1));
            },
        },
        lc4k.GOEConfigBus => switch (goe_config.source) {
            .none => {},
            .glb_shared_pt_enable => |glb| {
                writeField(data, u1, 0, fuses.getSharedEnableToOEBusRange(Device, glb).subRows(goe_index, 1));
            },
        },
        else => {},
    }
    data.put(Device.getGOEPolarityFuse(goe_index), @boolToInt(goe_config.polarity == .active_high));
}

fn writeDedicatedInputFuses(comptime Device: type, data: *jedec.JedecData, pin_info: common.PinInfo, config: *const LC4k(Device.device_type), input_config: anytype) void {
    const grp = @intToEnum(Device.GRP, pin_info.grp_ordinal.?);

    const threshold = input_config.threshold orelse config.default_input_threshold;
    writeField(data, common.InputThreshold, threshold, jedec.FuseRange.fromFuse(Device.getInputThresholdFuse(grp)));

    if (@TypeOf(input_config) == lc4k.InputConfigZE) {
        const maintenance = input_config.bus_maintenance orelse config.default_bus_maintenance;
        writeField(data, common.BusMaintenance, maintenance, Device.getInputBusMaintenanceRange(grp));

        const pgdf = input_config.power_guard orelse config.ext.default_power_guard;
        writeField(data, common.PowerGuard, pgdf, jedec.FuseRange.fromFuse(Device.getInputPowerGuardFuse(grp)));
    }
}

fn writePTFuses(comptime Device: type, results: *AssemblyResults, glb: usize, glb_pt_offset: usize, gi_signals: *[Device.num_gis_per_glb]?Device.GRP, pt: PT(Device.GRP)) !void {
    if (internal.isAlways(pt)) {
        return;
    }

    const range = fuses.getPTRange(Device, glb, glb_pt_offset);


    var is_never = false;
    for (pt) |factor| switch (factor) {
        .always => {},
        .never => is_never = true,
        .when_high, .when_low => |grp| {
            const fuse = for (gi_signals) |maybe_grp, gi| {
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
    const v = if (@typeInfo(T) == .Enum) @enumToInt(value) else value;
    const IntT = std.meta.Int(.unsigned, @bitSizeOf(T));
    var int_value = @as(u64, @bitCast(IntT, v));
    var iter = range.iterator();
    while (iter.next()) |fuse| {
        data.put(fuse, @truncate(u1, int_value));
        int_value = int_value >> 1;
    }
}
