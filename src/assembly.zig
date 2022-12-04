const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");
const common = @import("common.zig");
const routing = @import("routing.zig");
const internal = @import("internal.zig");

const LC4k = lc4k.LC4k;
const Factor = lc4k.Factor;
const PT = lc4k.PT;
const PTs = lc4k.PTBuilder;

pub const AssemblyError = struct {
    err: anyerror,
    details: []const u8,
    glb: ?common.GlbIndex = null,
    mc: ?common.MacrocellIndex = null,
    mc_pt: ?u8 = null,
};

pub fn AssembledResults(comptime Device: type) type {
    return struct {
        jedec: jedec.JedecFile,
        gi_routing: [Device.num_glbs][Device.num_gis_per_glb]?Device.GRP,
        cluster_routing: routing.RoutingData,
        errors: std.ArrayList(AssemblyError),
    };
}

pub fn assemble(comptime Device: type, config: LC4k(Device.device_type), allocator: std.mem.Allocator) !AssembledResults(Device) {
    var results = AssembledResults(Device) {
        .jedec = jedec.JedecFile {
            .data = try jedec.JedecData.initFull(allocator, Device.jedec_dimensions),
        },
        .gi_routing = .{ .{ null } ** Device.num_gis_per_glb } ** Device.num_glbs,
        .cluster_routing = .{},
        .errors = std.ArrayList(AssemblyError).init(allocator),
    };

    var prng = std.rand.Xoroshiro128.init(0x0416_fff9_140b_a135); // random but consistent seed
    var rnd = prng.random();

    for (config.glb) |glb_config, glb| {
        // Compile list of GRP signals needed in this GLB:
        var gi_routing = &results.gi_routing[glb];
        switch (glb_config.shared_pt_init) {
            .active_high, .active_low => |pt| try routing.addSignalsFromPT(Device, gi_routing, pt),
        }
        switch (glb_config.shared_pt_clock) {
            .positive, .negative => |pt| try routing.addSignalsFromPT(Device, gi_routing, pt),
        }
        try routing.addSignalsFromPT(Device, gi_routing, glb_config.shared_pt_enable);

        for (glb_config.mc) |mc_config| {
            for (mc_config.sum) |pt| {
                try routing.addSignalsFromPT(Device, gi_routing, pt);
            }
            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (internal.getSpecialPT(Device, mc_config, special_pt)) |pt| {
                    try routing.addSignalsFromPT(Device, gi_routing, pt);
                }
            }
            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => |pts| for (pts) |pt| {
                        try routing.addSignalsFromPT(Device, gi_routing, pt);
                    },
                }
            }
        }

        // Route GRP signals to specific GI fuses:
        try routing.routeGIs(Device, gi_routing, rnd);
        for (gi_routing) |maybe_signal, gi| if (maybe_signal) |signal| {
            const option_index = std.mem.indexOfScalar(Device.GRP, &Device.gi_options[gi], signal) orelse unreachable;
            const range = Device.getGiRange(glb, gi);
            var iter = range.iterator();
            iter.skip(option_index);
            results.jedec.data.put(iter.next() orelse unreachable, 0);
        };

        // Assign sum PTs to clusters to MCs and program routing fuses
        var router = routing.ClusterRouter.init(allocator, Device, glb_config);
        defer router.deinit();
        try router.route(Device, &results);

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
                                try writePTFuses(Device, &results, glb, glb_pt_offset, gi_routing, pt);
                                next_sum_pt += 1;
                            } else if (!internal.isSumAlways(pts)) {
                                try writePTFuses(Device, &results, glb, glb_pt_offset, gi_routing, PTs(Device).never());
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
                var pt_iter = results.cluster_routing.iterator(Device, &glb_config, mc);
                while (pt_iter.next()) |glb_pt_offset| {
                    if (next_sum_pt < mc_config.sum.len) {
                        const pt = mc_config.sum[next_sum_pt];
                        try writePTFuses(Device, &results, glb, glb_pt_offset, gi_routing, pt);
                        next_sum_pt += 1;
                    } else if (!internal.isSumAlways(mc_config.sum)) {
                        try writePTFuses(Device, &results, glb, glb_pt_offset, gi_routing, PTs(Device).never());
                    }
                }
                if (next_sum_pt < mc_config.sum.len and !internal.isSumAlways(mc_config.sum)) {
                    return error.TooManySumPTs;
                }
            }

            var special_pt: usize = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (internal.getSpecialPT(Device, mc_config, special_pt)) |pt| {
                    try writePTFuses(Device, &results, glb, mc * 5 + special_pt, gi_routing, pt);
                }
            }
        }

        switch (glb_config.shared_pt_init) {
            .active_high, .active_low => |pt| try writePTFuses(Device, &results, glb, 80, gi_routing, pt),
        }
        switch (glb_config.shared_pt_clock) {
            .positive, .negative => |pt| try writePTFuses(Device, &results, glb, 81, gi_routing, pt),
        }
        try writePTFuses(Device, &results, glb, 82, gi_routing, glb_config.shared_pt_enable);

        // Program MC-slice configuration fuses (Replace default/unset parameters with the defaults)
        for (glb_config.mc) |mc_config, mc| {
            const mcref = common.MacrocellRef {
                .glb = @intCast(common.GlbIndex, glb),
                .mc = @intCast(common.MacrocellIndex, mc),
            };
            writeField(&results.jedec.data, common.ClusterRouting, results.cluster_routing.cluster[mc], getClusterRoutingRange(Device, mcref));
            writeField(&results.jedec.data, common.WideRouting, results.cluster_routing.wide[mc], getWideRoutingRange(Device, mcref));

            const pt0xor: u1 = switch (mc_config.xor) {
                .pt0, .pt0_inverted => 0,
                .none, .input, .invert => 1,
            };
            writeField(&results.jedec.data, u1, pt0xor, getPT0XorRange(Device, mcref));

            const invert: u1 = switch (mc_config.xor) {
                .invert, .pt0_inverted => 1,
                .none, .input, .pt0 => 0,
            };
            writeField(&results.jedec.data, u1, invert, getInvertRange(Device, mcref));

            const xor: u1 = switch (mc_config.xor) {
                .input => 0,
                .invert, .none, .pt0, .pt0_inverted => 1,
            };
            writeField(&results.jedec.data, u1, xor, getXorRange(Device, mcref));

            switch (mc_config.clock) {
                .none => {},
                .pt1_positive => {
                    writeField(&results.jedec.data, u2, 0, getClockSourceLowRange(Device, mcref));
                },
                .pt1_negative => {
                    writeField(&results.jedec.data, u2, 1, getClockSourceLowRange(Device, mcref));
                },
                .shared_pt_clock => {
                    writeField(&results.jedec.data, u2, 2, getClockSourceLowRange(Device, mcref));
                },
                .bclock => |bclk| {
                    writeField(&results.jedec.data, u2, bclk, getClockSourceLowRange(Device, mcref));
                    writeField(&results.jedec.data, u1, 0, getClockSourceHighRange(Device, mcref));
                },
            }

            const ce: u2 = switch (mc_config.ce) {
                .pt2_active_high => 0,
                .pt2_active_low => 1,
                .shared_pt_clock => 2,
                .always_active => 3,
            };
            writeField(&results.jedec.data, u2, ce, getCERange(Device, mcref));

            writeField(&results.jedec.data, u1, mc_config.init_state, getInitStateRange(Device, mcref));
            const init_src: u1 = switch (mc_config.init_source) {
                .pt3_active_high => 0,
                .shared_pt_init => 1,
            };
            writeField(&results.jedec.data, u1, init_src, getInitSourceRange(Device, mcref));
            const async_src: u1 = switch (mc_config.async_source) {
                .pt2_active_high => 0,
                .none => 1,
            };
            writeField(&results.jedec.data, u1, async_src, getAsyncSourceRange(Device, mcref));

            writeField(&results.jedec.data, common.MacrocellFunction, mc_config.func, getMcFuncRange(Device, mcref));

            const oe: u1 = if (mc_config.pt4_oe == null) 1 else 0;
            writeField(&results.jedec.data, u1, oe, getPT4OERange(Device, mcref));

            if (getOESourceRange(Device, mcref)) |range| {
                writeField(&results.jedec.data, common.OutputEnableMode, mc_config.output.oe, range);
            }

            if (getOutputRoutingRange(Device, mcref)) |range| {
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
                if (getOutputRoutingModeRange(Device, mcref)) |range| {
                    const mode: u2 = switch (mc_config.output.routing) {
                        .same_as_oe => 2,
                        .self => 3,
                        .five_pt_fast_bypass => 0,
                        .five_pt_fast_bypass_inverted => 1,
                    };
                    writeField(&results.jedec.data, u2, mode, range);
                }
            }

            if (getSlewRateRange(Device, mcref)) |range| {
                const value = mc_config.output.slew_rate orelse config.default_slew_rate;
                writeField(&results.jedec.data, common.SlewRate, value, range);
            }

            if (getDriveTypeRange(Device, mcref)) |range| {
                const value = mc_config.output.drive_type orelse config.default_drive_type;
                writeField(&results.jedec.data, common.DriveType, value, range);
            }

            if (getInputThresholdRange(Device, mcref)) |range| {
                const value = mc_config.input.threshold orelse config.default_input_threshold;
                writeField(&results.jedec.data, common.InputThreshold, value, range);
            }

            if (@TypeOf(mc_config.input) == lc4k.InputConfigZE) {
                const value = mc_config.input.bus_maintenance orelse config.default_bus_maintenance;
                writeField(&results.jedec.data, common.BusMaintenance, value, getBusMaintenanceRange(Device, mcref));

                const pgdf = mc_config.input.power_guard orelse config.ext.default_power_guard;
                writeField(&results.jedec.data, common.PowerGuard, pgdf, getPowerGuardRange(Device, mcref));
            }

        }

        const spt_init_pol: u1 = switch (glb_config.shared_pt_init) {
            .active_low => 0,
            .active_high => 1,
        };
        writeField(&results.jedec.data, u1, spt_init_pol, getSharedInitPolarityRange(Device, glb));

        const spt_clk_pol: u1 = switch (glb_config.shared_pt_clock) {
            .negative => 0,
            .positive => 1,
        };
        writeField(&results.jedec.data, u1, spt_clk_pol, getSharedClockPolarityRange(Device, glb));

        for (glb_config.shared_pt_enable_to_oe_bus) |enable, oe| {
            writeField(&results.jedec.data, u1, @boolToInt(!enable), getSharedEnableToOEBusRange(Device, glb).subRows(oe, 1));
        }

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

    results.jedec.data.put(Device.getGOEPolarityFuse(0), @boolToInt(config.goe0.polarity == .active_high));
    results.jedec.data.put(Device.getGOEPolarityFuse(1), @boolToInt(config.goe1.polarity == .active_high));
    results.jedec.data.put(Device.getGOEPolarityFuse(2), @boolToInt(config.goe2.polarity == .active_high));
    results.jedec.data.put(Device.getGOEPolarityFuse(3), @boolToInt(config.goe3.polarity == .active_high));

    if (@TypeOf(config.goe0) == lc4k.GOEConfigWithSource) {
        results.jedec.data.put(Device.getGOESourceFuse(0), @boolToInt(config.goe0.source == .bus));
    }
    if (@TypeOf(config.goe1) == lc4k.GOEConfigWithSource) {
        results.jedec.data.put(Device.getGOESourceFuse(1), @boolToInt(config.goe1.source == .bus));
    }
    if (@TypeOf(config.goe2) == lc4k.GOEConfigWithSource) {
        results.jedec.data.put(Device.getGOESourceFuse(2), @boolToInt(config.goe2.source == .bus));
    }
    if (@TypeOf(config.goe3) == lc4k.GOEConfigWithSource) {
        results.jedec.data.put(Device.getGOESourceFuse(3), @boolToInt(config.goe3.source == .bus));
    }

    if (Device.family == .zero_power_enhanced) {
        results.jedec.data.put(Device.getZeroHoldTimeFuse(), @boolToInt(!config.ext.zero_hold_time));

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

fn writePTFuses(comptime Device: type, results: *AssembledResults(Device), glb: usize, glb_pt_offset: usize, gi_signals: *[Device.num_gis_per_glb]?Device.GRP, pt: PT(Device.GRP)) !void {
    if (internal.isAlways(pt)) {
        return;
    }

    const fuses = Device.getGlbRange(glb).subColumns(glb_pt_offset, 1);

    var is_never = false;
    for (pt) |factor| switch (factor) {
        .always => {},
        .never => is_never = true,
        .when_high, .when_low => |grp| {
            const fuse = for (gi_signals) |maybe_grp, gi| {
                if (maybe_grp) |gi_grp| {
                    if (gi_grp == grp) {
                        const gi_fuses = fuses.subRows(gi * 2, 2); // should be exactly 2 fuses stacked vertically
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
        results.jedec.data.putRange(fuses.subRows(0, Device.num_gis_per_glb * 2), 0);
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

fn getSharedClockPolarityRange(comptime Device: type, glb: usize) jedec.FuseRange {
    const starting_row = Device.num_gis_per_glb * 2;
    return Device.getGlbRange(glb).subRows(starting_row, 1).subColumns(82, 1);
}

fn getSharedEnableToOEBusRange(comptime Device: type, glb: usize) jedec.FuseRange {
    const starting_row = Device.num_gis_per_glb * 2 + 1;
    return Device.getGlbRange(glb).subRows(starting_row, Device.oe_bus_size).subColumns(82, 1);
}

fn getSharedInitPolarityRange(comptime Device: type, glb: usize) jedec.FuseRange {
    const starting_row = Device.num_gis_per_glb * 2 + 1 + Device.oe_bus_size;
    return Device.getGlbRange(glb).subRows(starting_row, 1).subColumns(82, 1);
}

fn getMacrocellRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    const starting_row = Device.num_gis_per_glb * 2;
    const range = Device.getGlbRange(mcref.glb).subRows(starting_row, Device.jedec_dimensions.height() - starting_row);
    return switch (@truncate(u1, mcref.mc)) {
        0 => range.subColumns(mcref.mc * 5 + 4, 1),
        1 => range.subColumns(mcref.mc * 5, 1)
    };
}

fn getPT0XorRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(0, 1);
}
fn getInvertRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(1, 1);
}
fn getClusterRoutingRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(2, 2);
}
fn getClockSourceLowRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(4, 2);
}
fn getInitStateRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(6, 1);
}
fn getMcFuncRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(7, 2);
}
fn getClockSourceHighRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(9, 1);
}
fn getAsyncSourceRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(10, 1);
}
fn getInitSourceRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(11, 1);
}
fn getPT4OERange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(12, 1);
}
fn getXorRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(13, 1);
}
fn getCERange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(14, 2);
}
fn getWideRoutingRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    return getMacrocellRange(Device, mcref).subRows(16, 1);
}
fn getOutputRoutingRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.jedec_dimensions.height() == 95 and @truncate(u1, mcref.mc) == 1) {
        return null;
    } else {
        return getMacrocellRange(Device, mcref).subRows(17, 3);
    }
}
fn getOutputRoutingModeRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.family == .zero_power_enhanced) {
        return null;
    } else if (Device.jedec_dimensions.height() == 95) {
        if (@truncate(u1, mcref.mc) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subRows(20, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(23, 2);
    }
}
fn getOESourceRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.jedec_dimensions.height() == 95) {
        if (@truncate(u1, mcref.mc) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subColumns(1, 1).subRows(17, 3);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(20, 3);
    }
}
fn getBusMaintenanceRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    std.debug.assert(Device.family == .zero_power_enhanced);
    return getMacrocellRange(Device, mcref).subRows(23, 2);
}
fn getSlewRateRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.jedec_dimensions.height() == 95) {
        if (@truncate(u1, mcref.mc) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subColumns(1, 1).subRows(21, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(25, 1);
    }
}
fn getDriveTypeRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.jedec_dimensions.height() == 95) {
        if (@truncate(u1, mcref.mc) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).subRows(21, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(26, 1);
    }
}
fn getInputThresholdRange(comptime Device: type, mcref: common.MacrocellRef) ?jedec.FuseRange {
    if (Device.jedec_dimensions.height() == 95) {
        if (@truncate(u1, mcref.mc) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).subRows(22, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(27, 1);
    }
}
fn getPowerGuardRange(comptime Device: type, mcref: common.MacrocellRef) jedec.FuseRange {
    std.debug.assert(Device.family == .zero_power_enhanced);
    const range = Device.getGlbRange(mcref.glb).subRows(Device.jedec_dimensions.max.row, 1);
    return range.subColumns(mcref.mc * 5 + 3, 1);
}
