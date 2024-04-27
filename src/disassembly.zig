const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");
const fuses = @import("fuses.zig");
const internal = @import("internal.zig");
const routing = @import("routing.zig");
const PT = lc4k.Product_Term;
const Factor = lc4k.Factor;
const assert = std.debug.assert;

pub const DisassemblyError = struct {
    err: anyerror,
    details: []const u8,
    fuse: ?jedec.Fuse = null,
    gi: ?lc4k.GI_Index = null,
    glb: ?lc4k.GLB_Index = null,
    mc: ?lc4k.MC_Index = null,
    // mc_pt: ?u8 = null,
};

pub fn Disassembly_Results(comptime Device: type) type {
    return struct {
        config: lc4k.LC4k(Device.device_type),
        gi_routing: [Device.num_glbs][Device.num_gis_per_glb]?Device.GRP,
        sum_routing: [Device.num_glbs]routing.RoutingData,
        errors: std.ArrayList(DisassemblyError),
    };
}

pub fn disassemble(comptime Device: type, allocator: std.mem.Allocator, file: jedec.Jedec_File) !Disassembly_Results(Device) {
    var results = Disassembly_Results(Device) {
        .config = .{},
        .gi_routing = .{ .{ null } ** Device.num_gis_per_glb } ** Device.num_glbs,
        .sum_routing = .{ .{} } ** Device.num_glbs,
        .errors = std.ArrayList(DisassemblyError).init(allocator),
    };

    if (!file.data.extents.eql(Device.jedec_dimensions)) {
        try results.errors.append(.{
            .err = error.MalformedJedec_File,
            .details = "JEDEC file fuse range does not match expected dimensions for this device!",
        });
        return results;
    }

    results.config.zero_hold_time = !file.data.isSet(Device.getZeroHoldTimeFuse());

    if (Device.family == .zero_power_enhanced) {
        const osctimer_enable = readField(file.data, u2, Device.getOscTimerEnableRange());
        const timer_div = readField(file.data, lc4k.Timer_Divisor, Device.getTimerDivRange());
        const enable_osc_out_and_disable = !file.data.isSet(Device.getOscOutFuse());
        const enable_timer_out_and_reset = !file.data.isSet(Device.getTimerOutFuse());

        if (osctimer_enable == 0) {
            results.config.ext.osctimer = lc4k.Oscillator_Timer_Config(Device) {
                .enable_osc_out_and_disable = enable_osc_out_and_disable,
                .enable_timer_out_and_reset = enable_timer_out_and_reset,
                .timer_divisor = timer_div,
            };
        } else if (osctimer_enable == 3) {
            if (@intFromEnum(timer_div) != 3) {
                try results.errors.append(.{
                    .err = error.InvalidOscTimerFuses,
                    .details = "OSCTIMER is disabled, but timer divisor has been set",
                });
            }
            if (enable_osc_out_and_disable) {
                try results.errors.append(.{
                    .err = error.InvalidOscTimerFuses,
                    .details = "OSCTIMER is disabled, but oscillator output is enabled",
                });
            }
            if (enable_timer_out_and_reset) {
                try results.errors.append(.{
                    .err = error.InvalidOscTimerFuses,
                    .details = "OSCTIMER is disabled, but timer output is enabled",
                });
            }
        } else {
            try results.errors.append(.{
                .err = error.InvalidOscTimerFuses,
                .details = try std.fmt.allocPrint(allocator, "Expected both OSCTIMER enable fuses to have the same value (found {})", .{ osctimer_enable }),
            });
        }
    } else {
        results.config.default_bus_maintenance = readField(file.data, lc4k.Bus_Maintenance, Device.getGlobalBus_MaintenanceRange());
        if (results.config.default_bus_maintenance == .float) {
            for (Device.getExtraFloatInputFuses()) |fuse| {
                if (file.data.isSet(fuse)) {
                    try results.errors.append(.{
                        .err = error.FloatingBuriedInput,
                        .details = "When no bus maintenance is enabled, this fuse should be cleared to prevent oscillation, as this signal is not connected to any pad.",
                        .fuse = fuse,
                    });
                }
            }
        }
    }

    // Program clock/input fuses
    for (results.config.clock, 0..) |*clock_config, clock_pin_index| {
        const pin_info = Device.clock_pins[clock_pin_index];
        const grp: Device.GRP = @enumFromInt(pin_info.grp_ordinal.?);

        const threshold_range = jedec.FuseRange.fromFuse(Device.getInput_ThresholdFuse(grp));
        clock_config.threshold = readField(file.data, lc4k.Input_Threshold, threshold_range);

        if (@TypeOf(clock_config) == *lc4k.Input_Config_ZE) {
            const maintenance_range = Device.getInputBus_MaintenanceRange(grp);
            clock_config.bus_maintenance = readField(file.data, lc4k.Bus_Maintenance, maintenance_range);

            const pgdf_range = jedec.FuseRange.fromFuse(Device.getInputPower_GuardFuse(grp));
            clock_config.power_guard = readField(file.data, lc4k.Power_Guard, pgdf_range);
        }
    }

    for (results.config.input, 0..) |*input_config, input_pin_index| {
        const pin_info = Device.input_pins[input_pin_index];
        const grp: Device.GRP = @enumFromInt(pin_info.grp_ordinal.?);

        const threshold_range = jedec.FuseRange.fromFuse(Device.getInput_ThresholdFuse(grp));
        input_config.threshold = readField(file.data, lc4k.Input_Threshold, threshold_range);

        if (@TypeOf(input_config) == *lc4k.Input_Config_ZE) {
            const maintenance_range = Device.getInputBus_MaintenanceRange(grp);
            input_config.bus_maintenance = readField(file.data, lc4k.Bus_Maintenance, maintenance_range);

            const pgdf_range = jedec.FuseRange.fromFuse(Device.getInputPower_GuardFuse(grp));
            input_config.power_guard = readField(file.data, lc4k.Power_Guard, pgdf_range);
        }
    }

    results.config.usercode = file.usercode;
    if (file.security) |security| {
        results.config.security = security != 0;
    }

    for (results.config.glb, 0..) |*glb_config, glb| {
        // Parse GI routing fuses
        for (Device.gi_options, 0..) |options, gi| {
            const gi_fuses = Device.getGiRange(glb, gi);
            assert(options.len == gi_fuses.count());
            var fuse_iter = gi_fuses.iterator();
            for (options) |grp| {
                const fuse = fuse_iter.next().?;
                if (!file.data.isSet(fuse)) {
                    if (results.gi_routing[glb][gi]) |_| {
                        try results.errors.append(.{
                            .err = error.TooManyGIFuses,
                            .details = "Multiple fuses active for this GI",
                            .fuse = fuse,
                            .gi = @intCast(gi),
                            .glb = @intCast(glb),
                        });
                    } else {
                        results.gi_routing[glb][gi] = grp;
                    }
                }
            }
        }
        const gi_routing = &results.gi_routing[glb];

        {
            // parse shared_pt_init
            const pt = try parsePTFuses(Device, allocator, glb, 80, gi_routing, file.data, &results);
            glb_config.shared_pt_init = switch (file.data.get(fuses.getSharedInitPolarityRange(Device, glb).min)) {
                0 => .{ .active_low = pt },
                1 => .{ .active_high = pt },
            };
        }

        {
            // parse shared_pt_clock
            const pt = try parsePTFuses(Device, allocator, glb, 81, gi_routing, file.data, &results);
            glb_config.shared_pt_clock = switch (file.data.get(fuses.getSharedClockPolarityRange(Device, glb).min)) {
                0 => .{ .negative = pt },
                1 => .{ .positive = pt },
            };
        }

        glb_config.shared_pt_enable = try parsePTFuses(Device, allocator, glb, 82, gi_routing, file.data, &results);

        try readGoeConfig(Device, file.data, &results.config.goe0, 0, &results);
        try readGoeConfig(Device, file.data, &results.config.goe1, 1, &results);
        try readGoeConfig(Device, file.data, &results.config.goe2, 2, &results);
        try readGoeConfig(Device, file.data, &results.config.goe3, 3, &results);

        glb_config.bclock0 = switch (readField(file.data, u1, Device.getBClockRange(glb).subRows(0, 1))) {
            0 => .clk1_neg,
            1 => .clk0_pos,
        };
        glb_config.bclock1 = switch (readField(file.data, u1, Device.getBClockRange(glb).subRows(1, 1))) {
            0 => .clk0_neg,
            1 => .clk1_pos,
        };
        glb_config.bclock2 = switch (readField(file.data, u1, Device.getBClockRange(glb).subRows(2, 1))) {
            0 => .clk3_neg,
            1 => .clk2_pos,
        };
        glb_config.bclock3 = switch (readField(file.data, u1, Device.getBClockRange(glb).subRows(3, 1))) {
            0 => .clk2_neg,
            1 => .clk3_pos,
        };

        for (glb_config.mc, 0..) |*mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            const cluster_routing = readField(file.data, lc4k.Cluster_Routing, fuses.getCluster_RoutingRange(Device, mcref));
            const wide_routing = readField(file.data, lc4k.Wide_Routing, fuses.getWide_RoutingRange(Device, mcref));
            mc_config.sum_routing = cluster_routing;
            mc_config.wide_sum_routing = wide_routing;
            results.sum_routing[glb].cluster[mc] = cluster_routing;
            results.sum_routing[glb].wide[mc] = wide_routing;

            mc_config.func = switch (readField(file.data, lc4k.Macrocell_Function, fuses.getMcFuncRange(Device, mcref))) {
                .combinational => .{ .combinational = {} },
                .latch => .{ .latch = .{} },
                .t_ff => .{ .t_ff = .{} },
                .d_ff => .{ .d_ff = .{} },
            };

            {
                // parse mc_config.xor

                const pt0xor_fuse = fuses.getPT0XorRange(Device, mcref).min;
                const invert_fuse = fuses.getInvertRange(Device, mcref).min;
                const input_bypass_fuse = fuses.getInputBypassRange(Device, mcref).min;

                const pt0xor = !file.data.isSet(pt0xor_fuse);
                const invert = file.data.isSet(invert_fuse);

                if (!file.data.isSet(input_bypass_fuse)) {
                    mc_config.logic = .{ .input_buffer = {} };
                    if (mc_config.func == .combinational) {
                        try results.errors.append(.{
                            .err = error.InvalidLogicConfig,
                            .details = "Input bypass fuse should not be active when macrocell is combinational",
                            .fuse = input_bypass_fuse,
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    if (pt0xor) {
                        try results.errors.append(.{
                            .err = error.InvalidLogicConfig,
                            .details = "PT0 should not be assigned to XOR when using fast input register",
                            .fuse = pt0xor_fuse,
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    if (invert) {
                        try results.errors.append(.{
                            .err = error.InvalidLogicConfig,
                            .details = "The XOR invert fuse has no effect when using fast input register",
                            .fuse = invert_fuse,
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                } else if (pt0xor) {
                    const pt = try parsePTFuses(Device, allocator, glb, mc * 5, gi_routing, file.data, &results);
                    if (invert) {
                        mc_config.logic = .{ .pt0_inverted = pt };
                    } else {
                        mc_config.logic = .{ .pt0 = pt };
                    }
                } else if (invert) {
                    mc_config.logic = .{ .sum_inverted = &.{} };
                } else {
                    mc_config.logic = .{ .sum = &.{} };
                }
            }

            const Register_Config = lc4k.Register_Config(Device.GRP);

            const clock: @TypeOf((Register_Config {}).clock) = switch (read_clock_source(Device, file.data, mcref)) {
                .pt1_positive => .{ .pt1_positive = try parsePTFuses(Device, allocator, glb, mc * 5 + 1, gi_routing, file.data, &results) },
                .pt1_negative => .{ .pt1_negative = try parsePTFuses(Device, allocator, glb, mc * 5 + 1, gi_routing, file.data, &results) },
                inline else => |t| t,
            };

            const ce: @TypeOf((Register_Config {}).ce) = switch (read_ce_source(Device, file.data, mcref)) {
                .pt2_active_high => .{ .pt2_active_high = try parsePTFuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
                .pt2_active_low => .{ .pt2_active_low = try parsePTFuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
                inline else => |t| t,
            };

            const init_state: u1 = 1 ^ readField(file.data, u1, fuses.getInitStateRange(Device, mcref));
            const init_source: @TypeOf((Register_Config {}).init_source) = switch (read_init_source(Device, file.data, mcref)) {
                .pt3_active_high => .{ .pt3_active_high = try parsePTFuses(Device, allocator, glb, mc * 5 + 3, gi_routing, file.data, &results) },
                .shared_pt_init => .shared_pt_init,
            };

            const async_source: @TypeOf((Register_Config {}).async_source) = switch (read_async_source(Device, file.data, mcref)) {
                .pt2_active_high => .{ .pt2_active_high = try parsePTFuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
                .none => .none,
            };

            switch (mc_config.func) {
                .combinational => {
                    if (clock != .none) {
                        try results.errors.append(.{
                            .err = error.InvalidRegister_Config,
                            .details = "Macrocell is combinational, but has a clock defined",
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    if (ce != .always_active) {
                        try results.errors.append(.{
                            .err = error.InvalidRegister_Config,
                            .details = "Macrocell is combinational, but has a CE defined",
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    if (init_source != .shared_pt_init) {
                        try results.errors.append(.{
                            .err = error.InvalidRegister_Config,
                            .details = "Macrocell is combinational, but uses shared PT init",
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    if (async_source != .none) {
                        try results.errors.append(.{
                            .err = error.InvalidRegister_Config,
                            .details = "Macrocell is combinational, but has PT2 async source defined",
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                },
                .latch, .t_ff, .d_ff => |*reg_config| {
                    reg_config.clock = clock;
                    reg_config.ce = ce;
                    reg_config.init_state = init_state;
                    reg_config.init_source = init_source;
                    reg_config.async_source = async_source;
                },
            }

            switch (read_pt4_oe_source(Device, file.data, mcref)) {
                .pt4_active_high => {
                    mc_config.pt4_oe = try parsePTFuses(Device, allocator, glb, mc * 5 + 4, gi_routing, file.data, &results);
                },
                else => {},
            }
            if (fuses.getOESourceRange(Device, mcref)) |range| {
                mc_config.output.oe = readField(file.data, lc4k.Output_Enable_Mode, range);
            }
            if (unmap_orm(Device, mcref)) |source_mcref| {
                if (@TypeOf(mc_config.output) == lc4k.Output_Config_ZE) {
                    mc_config.output.routing = .{ .absolute = source_mcref.mc };
                } else {
                    mc_config.output.oe_routing = .{ .absolute = source_mcref.mc };
                }
            }

            if (@TypeOf(mc_config.output) != lc4k.Output_Config_ZE) {
                if (fuses.getOutput_Routing_ModeRange(Device, mcref)) |range| {
                    mc_config.output.routing = switch (readField(file.data, lc4k.Output_Routing_Mode, range)) {
                        .five_pt_fast_bypass => .{ .five_pt_fast_bypass = &.{} },
                        .five_pt_fast_bypass_inverted => .{ .five_pt_fast_bypass_inverted = &.{} },
                        .same_as_oe => .same_as_oe,
                        .self => .self,
                    };
                }
            }

            if (fuses.getSlew_RateRange(Device, mcref)) |range| {
                mc_config.output.slew_rate = readField(file.data, lc4k.Slew_Rate, range);
            }

            if (fuses.getDrive_TypeRange(Device, mcref)) |range| {
                mc_config.output.drive_type = readField(file.data, lc4k.Drive_Type, range);
            }

            if (fuses.getInput_ThresholdRange(Device, mcref)) |range| {
                mc_config.input.threshold = readField(file.data, lc4k.Input_Threshold, range);
            }

            if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                mc_config.input.bus_maintenance = readField(file.data, lc4k.Bus_Maintenance, fuses.getBus_MaintenanceRange(Device, mcref));
                mc_config.input.power_guard = readField(file.data, lc4k.Power_Guard, fuses.getPower_GuardRange(Device, mcref));
            }
        }

        // after all MC fuses have been parsed, collect all routed logic PTs
        for (glb_config.mc, 0..) |*mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => {
                        var pts = try allocator.alloc(PT(Device.GRP), 5);
                        var pt_index: usize = 0;
                        var num_pts: usize = 0;
                        var sum_is_always = false;
                        while (pt_index < 5) : (pt_index += 1) {
                            if (internal.getSpecialPT(Device, mc_config.*, pt_index)) |_| continue;
                            const pt = try parsePTFuses(Device, allocator, glb, mc * 5 + pt_index, gi_routing, file.data, &results);
                            if (!internal.isNever(pt) and !(sum_is_always and internal.isAlways(pt))) {
                                pts[num_pts] = pt;
                                num_pts += 1;
                                if (internal.isAlways(pt)) {
                                    sum_is_always = true;
                                }
                            }
                        }
                        pts.len = num_pts;
                        if (num_pts > 1 and sum_is_always) {
                            try results.errors.append(.{
                                .err = error.IrrelevantPT,
                                .details = "5-PT fast path needlessly uses more than one PT (constant high)",
                                .glb = mcref.glb,
                                .mc = mcref.mc,
                            });
                        }
                        switch (mc_config.output.routing) {
                            .same_as_oe, .self => {},
                            .five_pt_fast_bypass => {
                                mc_config.output.routing = .{ .five_pt_fast_bypass = pts };
                            },
                            .five_pt_fast_bypass_inverted => {
                                mc_config.output.routing = .{ .five_pt_fast_bypass_inverted = pts };
                            },
                        }
                    },
                }
            }
            {
                // sum PTs
                var num_pts: usize = 0;
                var pt_iter = results.sum_routing[glb].iterator(Device, glb_config, mc);
                var sum_is_always = false;
                while (pt_iter.next()) |glb_pt_offset| {
                    switch (getPTTypeFromFuses(Device, glb, glb_pt_offset, gi_routing, file.data)) {
                        .never => {},
                        .always => sum_is_always = true,
                        .conditional => num_pts += 1,
                    }
                }
                if (sum_is_always) num_pts += 1;

                const pts = if (num_pts > 0) blk: {
                    var pts = try allocator.alloc(PT(Device.GRP), num_pts);
                    var next_pt_index: usize = 0;
                    sum_is_always = false;
                    pt_iter = results.sum_routing[glb].iterator(Device, glb_config, mc);
                    while (pt_iter.next()) |glb_pt_offset| {
                        const pt = try parsePTFuses(Device, allocator, glb, glb_pt_offset, gi_routing, file.data, &results);
                        if (!internal.isNever(pt) and !(sum_is_always and internal.isAlways(pt))) {
                            pts[next_pt_index] = pt;
                            next_pt_index += 1;
                            if (internal.isAlways(pt)) {
                                sum_is_always = true;
                            }
                        }
                    }
                    assert(next_pt_index == num_pts);
                    if (num_pts > 1 and sum_is_always) {
                        const details = try std.fmt.allocPrint(allocator, "Logic sum needlessly uses {} PTs (constant high requires only one)", .{
                            num_pts
                        });
                        try results.errors.append(.{
                            .err = error.IrrelevantPT,
                            .details = details,
                            .glb = mcref.glb,
                            .mc = mcref.mc,
                        });
                    }
                    break :blk pts;
                } else &[_]PT(Device.GRP) {};

                mc_config.logic = switch (mc_config.logic) {
                    .sum => .{ .sum = pts },
                    .sum_inverted => .{ .sum_inverted = pts },
                    .input_buffer => blk: {
                        if (pts.len > 0) {
                            try results.errors.append(.{
                                .err = error.TooManySumPTs,
                                .details = "Macrocell is configured for input bypass, but there are sum PTs",
                                .glb = mcref.glb,
                                .mc = mcref.mc,
                            });
                        }
                        break :blk .{ .input_buffer = {} };
                    },
                    .pt0 => |pt0| .{ .sum_xor_pt0 = .{
                        .pt0 = pt0,
                        .sum = pts,
                    }},
                    .pt0_inverted => |pt0| .{ .sum_xor_pt0_inverted = .{
                        .pt0 = pt0,
                        .sum = pts,
                    }},
                    .sum_xor_pt0 => |logic| .{ .sum_xor_pt0 = .{
                        .pt0 = logic.pt0,
                        .sum = pts,
                    }},
                    .sum_xor_pt0_inverted => |logic| .{ .sum_xor_pt0_inverted = .{
                        .pt0 = logic.pt0,
                        .sum = pts,
                    }},
                };
            }
        }
    }

    return results;
}

const PTType = enum {
    always,
    never,
    conditional,
};
fn getPTTypeFromFuses(
    comptime Device: type,
    glb: usize,
    glb_pt_offset: usize,
    gi_signals: *[Device.num_gis_per_glb]?Device.GRP,
    jed: jedec.JedecData,
) PTType {
    const range = fuses.getPTRange(Device, glb, glb_pt_offset);
    assert(range.count() == gi_signals.len * 2);

    var pt_type = PTType.always;

    var fuse_iter = range.iterator();
    for (gi_signals) |_| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.isSet(active_high_fuse);
        const when_low = !jed.isSet(active_low_fuse);

        if (when_high and when_low) {
            return .never;
        } else if (when_high != when_low) {
            pt_type = .conditional;
        }
    }

    return pt_type;
}

pub fn parsePTFuses(
    comptime Device: type,
    allocator: std.mem.Allocator,
    glb: usize,
    glb_pt_offset: usize,
    gi_signals: *const [Device.num_gis_per_glb]?Device.GRP,
    jed: jedec.JedecData,
    maybe_results: ?*Disassembly_Results(Device),
) !PT(Device.GRP) {
    const GRP = Device.GRP;
    const range = fuses.getPTRange(Device, glb, glb_pt_offset);
    assert(range.count() == gi_signals.len * 2);

    var num_factors: usize = 0;

    var fuse_iter = range.iterator();
    for (gi_signals) |_| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.isSet(active_high_fuse);
        const when_low = !jed.isSet(active_low_fuse);

        if (when_high and when_low) {
            return &[_]Factor(GRP) { .{ .never = {} } };
        } else if (when_high or when_low) {
            num_factors += 1;
        }
    }

    var pt: []Factor(GRP) = try allocator.alloc(Factor(GRP), num_factors);

    var factor_index: usize = 0;
    fuse_iter = range.iterator();
    for (gi_signals, 0..) |maybe_grp, gi| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.isSet(active_high_fuse);
        const when_low = !jed.isSet(active_low_fuse);

        if (when_high != when_low) {
            if (maybe_grp) |grp| {
                if (when_high) {
                    pt[factor_index] = .{ .when_high = grp };
                } else {
                    pt[factor_index] = .{ .when_low = grp };
                }
            } else if (maybe_results) |results| {
                try results.errors.append(.{
                    .err = error.UnroutedGI,
                    .details = "No signal driving GI",
                    .glb = @intCast(glb),
                    .gi = @intCast(gi),
                });
            }
            factor_index += 1;
        }
    }

    return pt;
}

fn readGoeConfig(comptime Device: type, data: jedec.JedecData, goe_config: anytype, goe_index: usize, results: *Disassembly_Results(Device)) !void {
    switch (@TypeOf(goe_config.*)) {
        lc4k.GOE_Config_Bus_Or_Pin => switch (data.get(Device.getGOESourceFuse(goe_index))) {
            0 => goe_config.source = .{ .input = {} },
            1 => try readGoeSourceBus(Device, data, goe_config, goe_index, results),
        },
        lc4k.GOE_Config_Bus => try readGoeSourceBus(Device, data, goe_config, goe_index, results),
        lc4k.GOE_Config_Pin => {},
        else => unreachable,
    }
    goe_config.polarity = switch (data.get(Device.getGOE_PolarityFuse(goe_index))) {
        0 => .active_low,
        1 => .active_high,
    };
}

fn readGoeSourceBus(comptime Device: type, data: jedec.JedecData, goe_config: anytype, goe_index: usize, results: *Disassembly_Results(Device)) !void {
    goe_config.source = .{ .constant_high = {}};
    var glb: lc4k.GLB_Index = 0;
    var already_reported_goe_collision = false;
    while (glb < Device.num_glbs) : (glb += 1) {
        switch (readField(data, u1, fuses.getSharedEnableToOEBusRange(Device, glb).subRows(goe_index, 1))) {
            0 => {
                switch (goe_config.source) {
                    .glb_shared_pt_enable => |old_glb| {
                        if (!already_reported_goe_collision) {
                            already_reported_goe_collision = true;
                            try results.errors.append(.{
                                .err = error.GOECollision,
                                .details = "Multiple GLBs' shared enable PT are driving the same PT OE bus line",
                                .glb = @intCast(old_glb),
                            });
                        }
                        try results.errors.append(.{
                            .err = error.GOECollision,
                            .details = "Multiple GLBs' shared enable PT are driving the same PT OE bus line",
                            .glb = @intCast(glb),
                        });
                    },
                    else => goe_config.source = .{ .glb_shared_pt_enable = glb },
                }
            },
            1 => {},
        }
    }
}

pub fn read_pt4_oe_source(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) lc4k.Macrocell_Output_Enable_Source {
    return readField(data, lc4k.Macrocell_Output_Enable_Source, fuses.getPT4OERange(Device, mcref));
}

pub fn read_ce_source(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) lc4k.Clock_Enable_Source {
    return readField(data, lc4k.Clock_Enable_Source, fuses.getCERange(Device, mcref));
}

pub fn read_init_source(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) lc4k.Init_Source {
    return readField(data, lc4k.Init_Source, fuses.getInitSourceRange(Device, mcref));
}

pub fn read_async_source(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) lc4k.Async_Trigger_Source {
    return readField(data, lc4k.Async_Trigger_Source, fuses.getAsyncSourceRange(Device, mcref));
}

pub fn read_clock_source(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) lc4k.Clock_Source {
    const low_range = fuses.getClockSourceLowRange(Device, mcref);
    const high_fuse = fuses.getClockSourceHighRange(Device, mcref).min;

    const low_data = readField(data, u2, low_range);

    if (data.isSet(high_fuse)) {
        return switch (low_data) {
            0 => .pt1_positive,
            1 => .pt1_negative,
            2 => .shared_pt_clock,
            3 => .none,
        };
    } else {
        return switch (low_data) {
            0 => .bclock0,
            1 => .bclock1,
            2 => .bclock2,
            3 => .bclock3,
        };
    }
}

pub fn unmap_orm(comptime Device: type, data: jedec.JedecData, mcref: lc4k.MC_Ref) ?lc4k.MC_Ref {
    if (fuses.getOutput_RoutingRange(Device, mcref)) |range| {
        const relative = readField(data, u3, range);
        const absolute: lc4k.MC_Index = @intCast((@as(u32, mcref.mc) + relative) % Device.num_mcs_per_glb);
        return lc4k.MC_Ref.init(mcref.glb, absolute);
    }
    return null;
}

pub fn readField(data: jedec.JedecData, comptime T: type, range: jedec.FuseRange) T {
    assert(@bitSizeOf(T) == range.count());
    var int_value: u64 = 0;
    var bit_value: u64 = 1;
    var iter = range.iterator();
    while (iter.next()) |fuse| {
        if (data.isSet(fuse)) {
            int_value |= bit_value;
        }
        bit_value = bit_value << 1;
    }

    return if (@typeInfo(T) == .Enum) @enumFromInt(int_value) else @intCast(int_value);
}
