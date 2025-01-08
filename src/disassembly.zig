pub const Disassembly_Error = struct {
    err: anyerror,
    details: []const u8,
    fuse: ?Fuse = null,
    gi: ?lc4k.GI_Index = null,
    glb: ?lc4k.GLB_Index = null,
    mc: ?lc4k.MC_Index = null,
    // mc_pt: ?u8 = null,
};

pub fn Disassembly_Results(comptime Device: type) type {
    return struct {
        config: lc4k.Chip_Config(Device.device_type),
        gi_routing: [Device.num_glbs][Device.num_gis_per_glb]?Device.Signal,
        sum_routing: [Device.num_glbs]routing.Routing_Data,
        errors: std.ArrayList(Disassembly_Error),
    };
}

pub fn disassemble(comptime Device: type, allocator: std.mem.Allocator, file: JEDEC_File) !Disassembly_Results(Device) {
    var results = Disassembly_Results(Device) {
        .config = .{},
        .gi_routing = .{ .{ null } ** Device.num_gis_per_glb } ** Device.num_glbs,
        .sum_routing = .{ .{} } ** Device.num_glbs,
        .errors = std.ArrayList(Disassembly_Error).init(allocator),
    };

    if (!file.data.extents.eql(Device.jedec_dimensions)) {
        try results.errors.append(.{
            .err = error.Malformed_JEDEC_File,
            .details = "JEDEC file fuse range does not match expected dimensions for this device!",
        });
        return results;
    }

    results.config.zero_hold_time = !file.data.is_set(Device.get_zero_hold_time_fuse());

    if (Device.family == .zero_power_enhanced) {
        const osctimer_enable = read_field(file.data, u2, Device.getOscTimerEnableRange());
        const timer_div = read_field(file.data, lc4k.Timer_Divisor, Device.getTimerDivRange());
        const enable_osc_out_and_disable = !file.data.is_set(Device.getOscOutFuse());
        const enable_timer_out_and_reset = !file.data.is_set(Device.getTimerOutFuse());

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
        results.config.default_bus_maintenance = read_field(file.data, lc4k.Bus_Maintenance, Device.get_global_bus_maintenance_range());
        if (results.config.default_bus_maintenance == .float) {
            for (Device.get_extra_float_input_fuses()) |fuse| {
                if (file.data.is_set(fuse)) {
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
    for (&results.config.clock, 0..) |*clock_config, clock_pin_index| {
        const pin = Device.clock_pins[clock_pin_index];
        const grp: Device.Signal = pin.pad();

        const threshold_range = Device.get_input_threshold_fuse(grp).range();
        clock_config.threshold = read_field(file.data, lc4k.Input_Threshold, threshold_range);

        if (@TypeOf(clock_config) == *lc4k.Input_Config_ZE) {
            const maintenance_range = Device.getInputBus_MaintenanceRange(grp);
            clock_config.bus_maintenance = read_field(file.data, lc4k.Bus_Maintenance, maintenance_range);

            const pgdf_range = Device.getInputPower_GuardFuse(grp).range();
            clock_config.power_guard = read_field(file.data, lc4k.Power_Guard, pgdf_range);
        }
    }

    for (&results.config.input, 0..) |*input_config, input_pin_index| {
        const pin = Device.input_pins[input_pin_index];
        const grp: Device.Signal = pin.pad();

        const threshold_range = Device.get_input_threshold_fuse(grp).range();
        input_config.threshold = read_field(file.data, lc4k.Input_Threshold, threshold_range);

        if (@TypeOf(input_config) == *lc4k.Input_Config_ZE) {
            const maintenance_range = Device.getInputBus_MaintenanceRange(grp);
            input_config.bus_maintenance = read_field(file.data, lc4k.Bus_Maintenance, maintenance_range);

            const pgdf_range = Device.getInputPower_GuardFuse(grp).range();
            input_config.power_guard = read_field(file.data, lc4k.Power_Guard, pgdf_range);
        }
    }

    results.config.usercode = file.usercode;
    if (file.security) |security| {
        results.config.security = security != 0;
    }

    for (&results.config.glb, 0..) |*glb_config, glb| {
        // Parse GI routing fuses
        for (Device.gi_options, 0..) |options, gi| {
            const gi_fuses = Device.get_gi_range(glb, gi);
            std.debug.assert(options.len == gi_fuses.count());
            var fuse_iter = gi_fuses.iterator();
            for (options) |grp| {
                const fuse = fuse_iter.next().?;
                if (!file.data.is_set(fuse)) {
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
            const pt = try read_pt_fuses(Device, allocator, glb, 80, gi_routing, file.data, &results);
            glb_config.shared_pt_init = switch (file.data.get(fuses.get_shared_init_polarity_range(Device, glb).min)) {
                0 => .{ .active_low = pt },
                1 => .{ .active_high = pt },
            };
        }

        {
            // parse shared_pt_clock
            const pt = try read_pt_fuses(Device, allocator, glb, 81, gi_routing, file.data, &results);
            glb_config.shared_pt_clock = switch (file.data.get(fuses.get_shared_clock_polarity_range(Device, glb).min)) {
                0 => .{ .negative = pt },
                1 => .{ .positive = pt },
            };
        }

        glb_config.shared_pt_enable = try read_pt_fuses(Device, allocator, glb, 82, gi_routing, file.data, &results);

        try read_goe_config(Device, file.data, &results.config.goe0, 0, &results);
        try read_goe_config(Device, file.data, &results.config.goe1, 1, &results);
        try read_goe_config(Device, file.data, &results.config.goe2, 2, &results);
        try read_goe_config(Device, file.data, &results.config.goe3, 3, &results);

        glb_config.bclock0 = switch (read_field(file.data, u1, Device.get_bclock_range(glb).sub_rows(0, 1))) {
            0 => .clk1_neg,
            1 => .clk0_pos,
        };
        glb_config.bclock1 = switch (read_field(file.data, u1, Device.get_bclock_range(glb).sub_rows(1, 1))) {
            0 => .clk0_neg,
            1 => .clk1_pos,
        };
        glb_config.bclock2 = switch (read_field(file.data, u1, Device.get_bclock_range(glb).sub_rows(2, 1))) {
            0 => .clk3_neg,
            1 => .clk2_pos,
        };
        glb_config.bclock3 = switch (read_field(file.data, u1, Device.get_bclock_range(glb).sub_rows(3, 1))) {
            0 => .clk2_neg,
            1 => .clk3_pos,
        };

        for (&glb_config.mc, 0..) |*mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            const cluster_routing = read_field(file.data, lc4k.Cluster_Routing, fuses.get_cluster_routing_range(Device, mcref));
            const wide_routing = read_field(file.data, lc4k.Wide_Routing, fuses.get_wide_routing_range(Device, mcref));
            mc_config.sum_routing = cluster_routing;
            mc_config.wide_sum_routing = wide_routing;
            results.sum_routing[glb].cluster[mc] = cluster_routing;
            results.sum_routing[glb].wide[mc] = wide_routing;

            mc_config.func = switch (read_field(file.data, lc4k.Macrocell_Function, fuses.get_macrocell_function_range(Device, mcref))) {
                .combinational => .combinational,
                .latch => .{ .latch = .{} },
                .t_ff => .{ .t_ff = .{} },
                .d_ff => .{ .d_ff = .{} },
            };

            {
                // parse mc_config.xor

                const pt0xor_fuse = fuses.get_pt0_xor_range(Device, mcref).min;
                const invert_fuse = fuses.get_invert_range(Device, mcref).min;
                const input_bypass_fuse = fuses.get_input_bypass_range(Device, mcref).min;

                const pt0xor = !file.data.is_set(pt0xor_fuse);
                const invert = file.data.is_set(invert_fuse);

                if (!file.data.is_set(input_bypass_fuse)) {
                    mc_config.logic = .input_buffer;
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
                    const pt = try read_pt_fuses(Device, allocator, glb, mc * 5, gi_routing, file.data, &results);
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

            const Register_Config = lc4k.Register_Config(Device.Signal);

            const clock: @TypeOf((Register_Config {}).clock) = switch (read_clock_source(Device, file.data, mcref)) {
                .pt1_positive => .{ .pt1_positive = try read_pt_fuses(Device, allocator, glb, mc * 5 + 1, gi_routing, file.data, &results) },
                .pt1_negative => .{ .pt1_negative = try read_pt_fuses(Device, allocator, glb, mc * 5 + 1, gi_routing, file.data, &results) },
                inline else => |t| t,
            };

            const ce: @TypeOf((Register_Config {}).ce) = switch (read_clock_enable_source(Device, file.data, mcref)) {
                .pt2_active_high => .{ .pt2_active_high = try read_pt_fuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
                .pt2_active_low => .{ .pt2_active_low = try read_pt_fuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
                inline else => |t| t,
            };

            const init_state: u1 = 1 ^ read_field(file.data, u1, fuses.get_init_state_range(Device, mcref));
            const init_source: @TypeOf((Register_Config {}).init_source) = switch (read_init_source(Device, file.data, mcref)) {
                .pt3_active_high => .{ .pt3_active_high = try read_pt_fuses(Device, allocator, glb, mc * 5 + 3, gi_routing, file.data, &results) },
                .shared_pt_init => .shared_pt_init,
            };

            const async_source: @TypeOf((Register_Config {}).async_source) = switch (read_async_trigger_source(Device, file.data, mcref)) {
                .pt2_active_high => .{ .pt2_active_high = try read_pt_fuses(Device, allocator, glb, mc * 5 + 2, gi_routing, file.data, &results) },
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

            switch (read_pt4_output_enable_source(Device, file.data, mcref)) {
                .pt4_active_high => {
                    mc_config.pt4_oe = try read_pt_fuses(Device, allocator, glb, mc * 5 + 4, gi_routing, file.data, &results);
                },
                else => {},
            }
            if (fuses.get_output_enable_source_range(Device, mcref)) |range| {
                mc_config.output.oe = read_field(file.data, lc4k.Output_Enable_Mode, range);
            }
            if (unmap_orm(Device, file.data, mcref)) |source_mcref| {
                if (@TypeOf(mc_config.output) == lc4k.Output_Config_ZE) {
                    mc_config.output.routing = .{ .absolute = source_mcref.mc };
                } else {
                    mc_config.output.oe_routing = .{ .absolute = source_mcref.mc };
                }
            }

            if (@TypeOf(mc_config.output) != lc4k.Output_Config_ZE) {
                if (fuses.get_output_routing_mode_range(Device, mcref)) |range| {
                    mc_config.output.routing = switch (read_field(file.data, lc4k.Output_Routing_Mode, range)) {
                        .five_pt_fast_bypass => .{ .five_pt_fast_bypass = &.{} },
                        .five_pt_fast_bypass_inverted => .{ .five_pt_fast_bypass_inverted = &.{} },
                        .same_as_oe => .same_as_oe,
                        .self => .self,
                    };
                }
            }

            if (fuses.get_slew_rate_range(Device, mcref)) |range| {
                mc_config.output.slew_rate = read_field(file.data, lc4k.Slew_Rate, range);
            }

            if (fuses.get_drive_type_range(Device, mcref)) |range| {
                mc_config.output.drive_type = read_field(file.data, lc4k.Drive_Type, range);
            }

            if (fuses.get_input_threshold_range(Device, mcref)) |range| {
                mc_config.input.threshold = read_field(file.data, lc4k.Input_Threshold, range);
            }

            if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                mc_config.input.bus_maintenance = read_field(file.data, lc4k.Bus_Maintenance, fuses.get_bus_maintenance_range(Device, mcref));
                mc_config.input.power_guard = read_field(file.data, lc4k.Power_Guard, fuses.get_power_guard_range(Device, mcref));
            }
        }

        // after all MC fuses have been parsed, collect all routed logic PTs
        for (&glb_config.mc, 0..) |*mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => {
                        var pts = try allocator.alloc(Product_Term(Device.Signal), 5);
                        var pt_index: usize = 0;
                        var num_pts: usize = 0;
                        var sum_is_always = false;
                        while (pt_index < 5) : (pt_index += 1) {
                            if (assembly.get_special_pt(Device, mc_config.*, pt_index)) |_| continue;
                            const pt = try read_pt_fuses(Device, allocator, glb, mc * 5 + pt_index, gi_routing, file.data, &results);
                            if (!pt.is_never() and !(sum_is_always and pt.is_always())) {
                                pts[num_pts] = pt;
                                num_pts += 1;
                                if (pt.is_always()) {
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
                    switch (get_pt_type_from_fuses(Device, glb, glb_pt_offset, gi_routing, file.data)) {
                        .never => {},
                        .always => sum_is_always = true,
                        .conditional => num_pts += 1,
                    }
                }
                if (sum_is_always) num_pts += 1;

                const pts = if (num_pts > 0) blk: {
                    var pts = try allocator.alloc(Product_Term(Device.Signal), num_pts);
                    var next_pt_index: usize = 0;
                    sum_is_always = false;
                    pt_iter = results.sum_routing[glb].iterator(Device, glb_config, mc);
                    while (pt_iter.next()) |glb_pt_offset| {
                        const pt = try read_pt_fuses(Device, allocator, glb, glb_pt_offset, gi_routing, file.data, &results);
                        if (!pt.is_never() and !(sum_is_always and pt.is_always())) {
                            pts[next_pt_index] = pt;
                            next_pt_index += 1;
                            if (pt.is_always()) {
                                sum_is_always = true;
                            }
                        }
                    }
                    std.debug.assert(next_pt_index == num_pts);
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
                } else &[_]Product_Term(Device.Signal) {};

                switch (mc_config.logic) {
                    .sum, .sum_inverted, .sum_xor_input_buffer => |*sum| {
                        sum.* = pts;
                    },
                    .sum_xor_pt0, .sum_xor_pt0_inverted => |*logic| {
                        logic.sum = pts;
                    },
                    .input_buffer => if (pts.len > 0) {
                        mc_config.logic = .{ .sum_xor_input_buffer = pts };
                    },
                    .pt0 => |pt0| {
                        mc_config.logic = .{ .sum_xor_pt0 = .{ .pt0 = pt0, .sum = pts }};
                    },
                    .pt0_inverted => |pt0| {
                        mc_config.logic = .{ .sum_xor_pt0_inverted = .{ .pt0 = pt0, .sum = pts }};
                    },
                }
            }
        }
    }

    return results;
}

const PT_Type = enum {
    always,
    never,
    conditional,
};
fn get_pt_type_from_fuses(
    comptime Device: type,
    glb: usize,
    glb_pt_offset: usize,
    gi_signals: *[Device.num_gis_per_glb]?Device.Signal,
    jed: JEDEC_Data,
) PT_Type {
    const range = fuses.get_pt_range(Device, glb, glb_pt_offset);
    std.debug.assert(range.count() == gi_signals.len * 2);

    var pt_type = PT_Type.always;

    var fuse_iter = range.iterator();
    for (gi_signals) |_| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.is_set(active_high_fuse);
        const when_low = !jed.is_set(active_low_fuse);

        if (when_high and when_low) {
            return .never;
        } else if (when_high != when_low) {
            pt_type = .conditional;
        }
    }

    return pt_type;
}

pub fn read_pt_fuses(
    comptime Device: type,
    allocator: std.mem.Allocator,
    glb: usize,
    glb_pt_offset: usize,
    gi_signals: *const [Device.num_gis_per_glb]?Device.Signal,
    jed: JEDEC_Data,
    maybe_results: ?*Disassembly_Results(Device),
) !Product_Term(Device.Signal) {
    const Signal = Device.Signal;
    const range = fuses.get_pt_range(Device, glb, glb_pt_offset);
    std.debug.assert(range.count() == gi_signals.len * 2);

    var num_factors: usize = 0;

    var fuse_iter = range.iterator();
    for (gi_signals) |_| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.is_set(active_high_fuse);
        const when_low = !jed.is_set(active_low_fuse);

        if (when_high and when_low) {
            return Product_Term(Signal).never();
        } else if (when_high or when_low) {
            num_factors += 1;
        }
    }

    var factors: []Factor(Signal) = try allocator.alloc(Factor(Signal), num_factors);

    var factor_index: usize = 0;
    fuse_iter = range.iterator();
    for (gi_signals, 0..) |maybe_grp, gi| {
        const active_high_fuse = fuse_iter.next().?;
        const active_low_fuse = fuse_iter.next().?;

        const when_high = !jed.is_set(active_high_fuse);
        const when_low = !jed.is_set(active_low_fuse);

        if (when_high != when_low) {
            if (maybe_grp) |grp| {
                if (when_high) {
                    factors[factor_index] = .{ .when_high = grp };
                } else {
                    factors[factor_index] = .{ .when_low = grp };
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

    return .{ .factors = factors };
}

fn read_goe_config(comptime Device: type, data: JEDEC_Data, goe_config: anytype, goe_index: usize, results: *Disassembly_Results(Device)) !void {
    switch (@TypeOf(goe_config.*)) {
        lc4k.GOE_Config_Bus_Or_Pin => switch (data.get(Device.get_goe_source_fuse(goe_index))) {
            0 => goe_config.source = .input,
            1 => try read_goe_source_bus(Device, data, goe_config, goe_index, results),
        },
        lc4k.GOE_Config_Bus => try read_goe_source_bus(Device, data, goe_config, goe_index, results),
        lc4k.GOE_Config_Pin => {},
        else => unreachable,
    }
    goe_config.polarity = switch (data.get(Device.get_goe_polarity_fuse(goe_index))) {
        0 => .active_low,
        1 => .active_high,
    };
}

fn read_goe_source_bus(comptime Device: type, data: JEDEC_Data, goe_config: anytype, goe_index: usize, results: *Disassembly_Results(Device)) !void {
    goe_config.source = .constant_high;
    var glb: lc4k.GLB_Index = 0;
    var already_reported_goe_collision = false;
    while (glb < Device.num_glbs) : (glb += 1) {
        switch (read_field(data, u1, fuses.get_shared_enable_to_oe_bus_range(Device, glb).sub_rows(goe_index, 1))) {
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

pub fn read_pt4_output_enable_source(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) lc4k.Macrocell_Output_Enable_Source {
    return read_field(data, lc4k.Macrocell_Output_Enable_Source, fuses.get_pt4_output_enable_range(Device, mcref));
}

pub fn read_clock_enable_source(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) lc4k.Clock_Enable_Source {
    return read_field(data, lc4k.Clock_Enable_Source, fuses.get_clock_enable_range(Device, mcref));
}

pub fn read_init_source(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) lc4k.Init_Source {
    return read_field(data, lc4k.Init_Source, fuses.get_init_source_range(Device, mcref));
}

pub fn read_async_trigger_source(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) lc4k.Async_Trigger_Source {
    return read_field(data, lc4k.Async_Trigger_Source, fuses.get_async_trigger_source_range(Device, mcref));
}

pub fn read_clock_source(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) lc4k.Clock_Source {
    const low_range = fuses.get_clock_source_range_low(Device, mcref);
    const high_fuse = fuses.get_clock_source_range_high(Device, mcref).min;

    const low_data = read_field(data, u2, low_range);

    if (data.is_set(high_fuse)) {
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

pub fn unmap_orm(comptime Device: type, data: JEDEC_Data, mcref: lc4k.MC_Ref) ?lc4k.MC_Ref {
    if (fuses.get_output_routing_range(Device, mcref)) |range| {
        const relative = read_field(data, u3, range);
        const absolute: lc4k.MC_Index = @intCast((@as(u32, mcref.mc) + relative) % Device.num_mcs_per_glb);
        return lc4k.MC_Ref.init(mcref.glb, absolute);
    }
    return null;
}

pub fn read_field(data: JEDEC_Data, comptime T: type, range: Fuse_Range) T {
    std.debug.assert(@bitSizeOf(T) == range.count());
    var int_value: u64 = 0;
    var bit_value: u64 = 1;
    var iter = range.iterator();
    while (iter.next()) |fuse| {
        if (data.is_set(fuse)) {
            int_value |= bit_value;
        }
        bit_value = bit_value << 1;
    }

    return if (@typeInfo(T) == .@"enum") @enumFromInt(int_value) else @intCast(int_value);
}

const Product_Term = lc4k.Product_Term;
const Factor = lc4k.Factor;
const JEDEC_Data = @import("JEDEC_Data.zig");
const JEDEC_File = @import("JEDEC_File.zig");
const Fuse = @import("Fuse.zig");
const Fuse_Range = @import("Fuse_Range.zig");
const assembly = @import("assembly.zig");
const fuses = @import("fuses.zig");
const routing = @import("routing.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
