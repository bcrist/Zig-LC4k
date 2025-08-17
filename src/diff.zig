
pub fn Write_Options(comptime Device: type) type {
    return struct {
        check_usercode: bool = false,
        skip_gis: bool = false,
        skip_pts: bool = false,
        skip_mcs: bool = false,
        skip_ios: bool = false,
        single_glb: ?GLB_Index = null,
        names: ?*const Device.Names = null,
    };
}

pub fn write(temp: std.mem.Allocator, comptime Device: type, a: JEDEC_File, b: JEDEC_File, writer: std.io.AnyWriter, raw_options: Write_Options(Device)) !void {
    var diff: JEDEC_Data = try .init_diff(temp, a.data, b.data);
    defer diff.deinit(temp);

    var options = raw_options;
    options.names = raw_options.names orelse Device.get_names();

    if (options.check_usercode and !std.meta.eql(a.usercode, b.usercode)) {
        try writer.print("Usercode mismatch: {?X:0>8} -> {?X:0>8}\n", .{ a.usercode, b.usercode });
    }

    const flipped_bits = diff.count_set();
    if (flipped_bits == 0) {
        try writer.writeAll("No differences found in JEDEC fuse data!\n");
        return;
    }
    
    for (0..Device.num_glbs) |glb| {
        if (options.single_glb) |wanted_glb| {
            if (glb != wanted_glb) continue;
        }
        try write_glb(temp, Device, a.data, b.data, diff, @intCast(glb), writer, options);
    }

    for (std.enums.values(Device.Signal)) |signal| {
        switch (signal.kind()) {
            .clk, .in => {
                if (Device.family == .zero_power_enhanced) {
                    if (Device.get_input_bus_maintenance_range(signal)) |pull_range| {
                        const a_pull = disassembly.read_field(a, lc4k.Bus_Maintenance, pull_range);
                        const b_pull = disassembly.read_field(b, lc4k.Bus_Maintenance, pull_range);
                        if (a_pull != b_pull) {
                            try writer.print("{s} ({s}) Input:\n", .{
                                options.names.?.get_signal_name(signal),
                                @tagName(signal),
                            });
                            try write_fuse_diff(b.data, diff, pull_range, writer);
                            try writer.print("       Pull: {s} -> {s}\n", .{
                                @tagName(a_pull),
                                @tagName(b_pull),
                            });
                            try writer.writeByte('\n');
                        }
                    }

                    if (Device.get_input_power_guard_fuse(signal)) |fuse| {
                        const a_pg = disassembly.read_field(a.data, lc4k.Power_Guard, fuse.range());
                        const b_pg = disassembly.read_field(b.data, lc4k.Power_Guard, fuse.range());
                        if (a_pg != b_pg) {
                            try writer.print("{s} ({s}) Input:\n", .{
                                options.names.?.get_signal_name(signal),
                                @tagName(signal),
                            });
                            try write_fuse_diff(b.data, diff, fuse.range(), writer);
                            try writer.print("         PG: {s} -> {s}\n", .{
                                @tagName(a_pg),
                                @tagName(b_pg),
                            });
                            try writer.writeByte('\n');
                        }
                    }
                }

                if (Device.get_input_threshold_fuse(signal)) |fuse| {
                    const a_threshold = disassembly.read_field(a.data, lc4k.Input_Threshold, fuse.range());
                    const b_threshold = disassembly.read_field(b.data, lc4k.Input_Threshold, fuse.range());
                    if (a_threshold != b_threshold) {
                        try writer.print("{s} ({s}) Input:\n", .{
                            options.names.?.get_signal_name(signal),
                            @tagName(signal),
                        });
                        try write_fuse_diff(b.data, diff, fuse.range(), writer);
                        try writer.print("  Threshold: {s} -> {s}\n", .{
                            @tagName(a_threshold),
                            @tagName(b_threshold),
                        });
                        try writer.writeByte('\n');
                    }
                }
            },
            .mc, .io => {},
        }
    }

    if (Device.family != .zero_power_enhanced) {
        const range = Device.get_global_bus_maintenance_range();
        if (diff.count_set_in_range(range) > 0) {
            try writer.print("Global Input Config:\n", .{});
            try write_fuse_diff(b.data, diff, range, writer);

            const a_mode = disassembly.read_field(a.data, lc4k.Bus_Maintenance, range);
            const b_mode = disassembly.read_field(b.data, lc4k.Bus_Maintenance, range);
            if (a_mode != b_mode) {
                try writer.print("       Pull: {s} -> {s}\n", .{
                    @tagName(a_mode),
                    @tagName(b_mode),
                });
            }
            try writer.writeByte('\n');
        }
    }

    const zerohold_fuse: Fuse = Device.get_zero_hold_time_fuse();
    if (a.data.get(zerohold_fuse) != b.data.get(zerohold_fuse)) {
        try writer.print("Zero Hold Time:\n", .{});
        try write_fuse_diff(b.data, diff, zerohold_fuse.range(), writer);
        try writer.writeByte('\n');
    }
    
    var goe_range: Fuse_Range = .empty;
    for (0..4) |goe| {
        goe_range = goe_range.expand_to_contain(Device.get_goe_polarity_fuse(goe));
        if (Device.get_goe_source_fuse(goe)) |fuse| goe_range = goe_range.expand_to_contain(fuse);
    }
    if (diff.count_set_in_range(goe_range) > 0) {
        try writer.print("GOE Config:\n", .{});
        try write_fuse_diff(b.data, diff, goe_range, writer);

        for (0..4) |goe| {
            const polarity_fuse = Device.get_goe_polarity_fuse(goe);
            const a_pol = disassembly.read_field(a.data, lc4k.Polarity, polarity_fuse.range());
            const b_pol = disassembly.read_field(b.data, lc4k.Polarity, polarity_fuse.range());
            if (a_pol != b_pol) {
                try writer.print("   GOE{} pol: {s} -> {s}\n", .{
                    goe,
                    @tagName(a_pol),
                    @tagName(b_pol),
                });
            }

            if (Device.get_goe_source_fuse(goe)) |fuse| {
                const Source = enum (u1) {
                    input = 0,
                    bus = 1,
                };
                const a_src = disassembly.read_field(a.data, Source, fuse.range());
                const b_src = disassembly.read_field(b.data, Source, fuse.range());
                if (a_src != b_src) {
                    try writer.print("   GOE{} src: {s} -> {s}\n", .{
                        goe,
                        @tagName(a_pol),
                        @tagName(b_pol),
                    });
                }
            }
        }

        try writer.writeByte('\n');
    }

    // TODO osctimer

    try writer.print("{} total bit differences found in JEDEC fuse data!\n", .{ flipped_bits });
}

fn write_glb(temp: std.mem.Allocator, comptime Device: type, a: JEDEC_Data, b: JEDEC_Data, diff: JEDEC_Data, glb: GLB_Index, writer: std.io.AnyWriter, options: Write_Options(Device)) !void {
    var context: struct {
        glb: GLB_Index,
        writer: std.io.AnyWriter,
        options: Write_Options(Device),
        should_write_heading: bool = true,

        pub fn maybe_write_heading(self: *@This()) !void {
            if (self.should_write_heading) {
                try self.writer.print("GLB {s} ({}):\n", .{ self.options.names.?.get_glb_name(self.glb), self.glb });
                self.should_write_heading = false;
            }
        }

        pub fn end(self: @This()) !void {
            if (!self.should_write_heading) {
                // we wrote some output, so make sure there's an extra newline before the next GLB:
                try self.writer.writeByte('\n');
            }
        }
    } = .{ .glb = glb, .writer = writer, .options = options };

    if (!options.skip_gis) {
        for (0..Device.num_gis_per_glb) |gi| {
            const range = Device.get_gi_range(glb, gi);
            if (diff.count_set_in_range(range) > 0) {
                try context.maybe_write_heading();
                try writer.print("   GI {}:\n", .{ gi });
                try write_fuse_diff(b, diff, range, writer);

                var a_gi_sig: ?Device.Signal = null;
                var b_gi_sig: ?Device.Signal = null;
                var iter = range.iterator();
                var i: usize = 0;
                while (iter.next()) |gi_fuse| {
                    if (a_gi_sig == null and !a.is_set(gi_fuse)) a_gi_sig = Device.gi_options[gi][i];
                    if (b_gi_sig == null and !b.is_set(gi_fuse)) b_gi_sig = Device.gi_options[gi][i];
                    i += 1;
                }

                if (a_gi_sig == null) {
                    try writer.print("     Signal: unrouted -> {s} ({s})\n", .{
                        options.names.?.get_signal_name(b_gi_sig.?), @tagName(b_gi_sig.?),
                    });
                } else if (b_gi_sig == null) {
                    try writer.print("     Signal: {s} ({s}) -> unrouted\n", .{
                        options.names.?.get_signal_name(a_gi_sig.?), @tagName(a_gi_sig.?),
                    });
                } else {
                    try writer.print("     Signal: {s} ({s}) -> {s} ({s})\n", .{
                        options.names.?.get_signal_name(a_gi_sig.?), @tagName(a_gi_sig.?),
                        options.names.?.get_signal_name(b_gi_sig.?), @tagName(b_gi_sig.?),
                    });
                }

                try writer.writeAll("\n");
            }
        }
    }

    if (!options.skip_pts) {
        for (0..Device.num_mcs_per_glb) |mc| {
            const mcref: MC_Ref = .init(glb, mc);
            for (0..5) |pt| {
                if (diff.count_set_in_range(fuses.get_pt_range(Device, glb, mc * 5 + pt)) > 0) {
                    try context.maybe_write_heading();
                    try writer.print("   {s} (MC {}) PT {} ({}):\n", .{ options.names.?.get_mc_name(mcref), mc, pt, mc * 5 + pt });
                    try write_pt_diff(temp, Device, a, b, diff, glb, mc * 5 + pt, writer, options);
                }
            }
        }

        if (diff.count_set_in_range(fuses.get_pt_range(Device, glb, 80)) > 0) {
            try context.maybe_write_heading();
            try writer.writeAll("   Shared init PT (80):\n");
            try write_pt_diff(temp, Device, a, b, diff, glb, 80, writer, options);
        }

        if (diff.count_set_in_range(fuses.get_pt_range(Device, glb, 81)) > 0) {
            try context.maybe_write_heading();
            try writer.writeAll("   Shared clock PT (81):\n");
            try write_pt_diff(temp, Device, a, b, diff, glb, 81, writer, options);
        }

        if (diff.count_set_in_range(fuses.get_pt_range(Device, glb, 82)) > 0) {
            try context.maybe_write_heading();
            try writer.writeAll("   Shared enable PT (82):\n");
            try write_pt_diff(temp, Device, a, b, diff, glb, 82, writer, options);
        }
    }

    const bclock_range = Device.get_bclock_range(glb);
    if (diff.count_set_in_range(bclock_range) > 0) {
        try context.maybe_write_heading();
        try writer.writeAll("   Block clock config:\n");
        try write_fuse_diff(b, diff, bclock_range, writer);

        const a0 = disassembly.read_bclock0(Device, a, glb);
        const b0 = disassembly.read_bclock0(Device, b, glb);
        if (a0 != b0) {
            try writer.print("   BClock 0: {s} -> {s}\n", .{
                @tagName(a0),
                @tagName(b0),
            });
        }

        const a1 = disassembly.read_bclock1(Device, a, glb);
        const b1 = disassembly.read_bclock1(Device, b, glb);
        if (a1 != b1) {
            try writer.print("   BClock 0: {s} -> {s}\n", .{
                @tagName(a1),
                @tagName(b1),
            });
        }

        const a2 = disassembly.read_bclock2(Device, a, glb);
        const b2 = disassembly.read_bclock2(Device, b, glb);
        if (a2 != b2) {
            try writer.print("   BClock 2: {s} -> {s}\n", .{
                @tagName(a2),
                @tagName(b2),
            });
        }

        const a3 = disassembly.read_bclock3(Device, a, glb);
        const b3 = disassembly.read_bclock3(Device, b, glb);
        if (a3 != b3) {
            try writer.print("   BClock 3: {s} -> {s}\n", .{
                @tagName(a3),
                @tagName(b3),
            });
        }
        try writer.writeByte('\n');
    }

    const shared_clock_polarity_range = fuses.get_shared_clock_polarity_range(Device, glb);
    if (diff.count_set_in_range(shared_clock_polarity_range) > 0) {
        try context.maybe_write_heading();
        try writer.writeAll("   Shared clock PT polarity:\n");
        try write_fuse_diff(b, diff, shared_clock_polarity_range, writer);
        const a_mode = disassembly.read_field(a, lc4k.Polarity, shared_clock_polarity_range);
        const b_mode = disassembly.read_field(b, lc4k.Polarity, shared_clock_polarity_range);
        if (a_mode != b_mode) {
            try writer.print("   Polarity: {s} -> {s}\n", .{
                @tagName(a_mode),
                @tagName(b_mode),
            });
        }
        try writer.writeByte('\n');
    }

    const shared_init_polarity_range = fuses.get_shared_init_polarity_range(Device, glb);
    if (diff.count_set_in_range(shared_init_polarity_range) > 0) {
        try context.maybe_write_heading();
        try writer.writeAll("   Shared init PT polarity:\n");
        try write_fuse_diff(b, diff, shared_init_polarity_range, writer);
        const a_mode = disassembly.read_field(a, lc4k.Polarity, shared_init_polarity_range);
        const b_mode = disassembly.read_field(b, lc4k.Polarity, shared_init_polarity_range);
        if (a_mode != b_mode) {
            try writer.print("   Polarity: {s} -> {s}\n", .{
                @tagName(a_mode),
                @tagName(b_mode),
            });
        }
        try writer.writeByte('\n');
    }

    const shared_enable_routing_range = fuses.get_shared_enable_to_oe_bus_range(Device, glb);
    if (diff.count_set_in_range(shared_enable_routing_range) > 0) {
        try context.maybe_write_heading();
        try writer.writeAll("   Shared enable PT routing:\n");
        try write_fuse_diff(b, diff, shared_enable_routing_range, writer);
        var iter = shared_enable_routing_range.iterator();
        var i: usize = 0;
        while (iter.next()) |fuse| {
            const a_val = !a.is_set(fuse);
            const b_val = !b.is_set(fuse);
            if (a_val != b_val) {
                try writer.print("   GOE{}: {} -> {}\n", .{
                    i,
                    a_val,
                    b_val,
                });
            }
            i += 1;
        }

        try writer.writeByte('\n');
    }

    if (!options.skip_mcs) {
        for (0..Device.num_mcs_per_glb) |mc| {
            const mcref: MC_Ref = .init(glb, mc);
            const range = fuses.get_macrocell_range_without_io(Device, mcref);
            if (diff.count_set_in_range(range) > 0) {
                try context.maybe_write_heading();
                try writer.print("   {s} (MC {}) Config:\n", .{ options.names.?.get_mc_name(mcref), mc });
                try write_fuse_diff(b, diff, range, writer);

                {
                    const cluster_range = fuses.get_cluster_routing_range(Device, mcref);
                    const a_mode = disassembly.read_field(a, lc4k.Cluster_Routing, cluster_range);
                    const b_mode = disassembly.read_field(b, lc4k.Cluster_Routing, cluster_range);
                    if (a_mode != b_mode) {
                        try writer.print("    Cluster: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const wide_range = fuses.get_wide_routing_range(Device, mcref);
                    const a_mode = disassembly.read_field(a, lc4k.Wide_Routing, wide_range);
                    const b_mode = disassembly.read_field(b, lc4k.Wide_Routing, wide_range);
                    if (a_mode != b_mode) {
                        try writer.print("       Wide: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_pt0_xor(Device, a, mcref);
                    const b_mode = disassembly.read_pt0_xor(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("   PT 0 XOR: {} -> {}\n", .{
                            a_mode,
                            b_mode,
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_invert(Device, a, mcref);
                    const b_mode = disassembly.read_invert(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("     Invert: {} -> {}\n", .{
                            a_mode,
                            b_mode,
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_input_bypass(Device, a, mcref);
                    const b_mode = disassembly.read_input_bypass(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("  In Bypass: {} -> {}\n", .{
                            a_mode,
                            b_mode,
                        });
                    }
                }

                {
                    const mode_range = fuses.get_macrocell_function_range(Device, mcref);
                    const a_mode = disassembly.read_field(a, lc4k.Macrocell_Function, mode_range);
                    const b_mode = disassembly.read_field(b, lc4k.Macrocell_Function, mode_range);
                    if (a_mode != b_mode) {
                        try writer.print("       Func: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const mode_range = fuses.get_init_state_range(Device, mcref);
                    const a_mode = disassembly.read_field(a, u1, mode_range);
                    const b_mode = disassembly.read_field(b, u1, mode_range);
                    if (a_mode != b_mode) {
                        try writer.print("       Init: {} -> {}\n", .{
                            a_mode,
                            b_mode,
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_async_trigger_source(Device, a, mcref);
                    const b_mode = disassembly.read_async_trigger_source(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("  Async src: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_init_source(Device, a, mcref);
                    const b_mode = disassembly.read_init_source(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("   Init src: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_clock_source(Device, a, mcref);
                    const b_mode = disassembly.read_clock_source(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("      Clock: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                {
                    const a_mode = disassembly.read_clock_enable_source(Device, a, mcref);
                    const b_mode = disassembly.read_clock_enable_source(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("         CE: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }
                
                {
                    const a_mode = disassembly.read_pt4_output_enable_source(Device, a, mcref);
                    const b_mode = disassembly.read_pt4_output_enable_source(Device, b, mcref);
                    if (a_mode != b_mode) {
                        try writer.print("    PT 4 OE: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }

                try writer.writeAll("\n");
            }
        }
    }

    if (!options.skip_ios) {
        for (0..Device.num_mcs_per_glb) |mc| {
            const mcref: MC_Ref = .init(glb, mc);
            if (fuses.get_io_range(Device, mcref)) |range| {
                if (diff.count_set_in_range(range) > 0) {
                    try context.maybe_write_heading();
                    if (Device.Signal.maybe_mc_pad(mcref)) |pad| {
                        try writer.print("   {s} (I/O {}) Config:\n", .{ options.names.?.get_signal_name(pad), mc });
                    } else {
                        try writer.print("   internal I/O {} Config:\n", .{ mc });
                    }
                    try write_fuse_diff(b, diff, range, writer);

                    if (fuses.get_output_routing_mode_range(Device, mcref)) |orm_mode_range| {
                        const a_mode = disassembly.read_field(a, lc4k.Output_Routing_Mode, orm_mode_range);
                        const b_mode = disassembly.read_field(b, lc4k.Output_Routing_Mode, orm_mode_range);
                        if (a_mode != b_mode) {
                            try writer.print("   ORM Mode: {s} -> {s}\n", .{
                                @tagName(a_mode),
                                @tagName(b_mode),
                            });
                        }
                    }

                    if (disassembly.unmap_orm(Device, a, mcref)) |a_orm_mcref| {
                        const b_orm_mcref = disassembly.unmap_orm(Device, b, mcref).?;
                        if (!std.meta.eql(a_orm_mcref, b_orm_mcref)) {
                            const a_orm_sig = Device.Signal.mc_fb(a_orm_mcref);
                            const b_orm_sig = Device.Signal.mc_fb(b_orm_mcref);
                            try writer.print("        ORM: {s} ({s}) -> {s} ({s})\n", .{
                                options.names.?.get_signal_name(a_orm_sig), @tagName(a_orm_sig),
                                options.names.?.get_signal_name(b_orm_sig), @tagName(b_orm_sig),
                            });
                        }
                    }

                    if (fuses.get_output_enable_source_range(Device, mcref)) |oe_range| {
                        const a_oe = disassembly.read_field(a, lc4k.Output_Enable_Mode, oe_range);
                        const b_oe = disassembly.read_field(b, lc4k.Output_Enable_Mode, oe_range);
                        if (a_oe != b_oe) {
                            try writer.print("         OE: {s} -> {s}\n", .{
                                @tagName(a_oe),
                                @tagName(b_oe),
                            });
                        }
                    }

                    if (fuses.get_bus_maintenance_range(Device, mcref)) |pull_range| {
                        const a_pull = disassembly.read_field(a, lc4k.Bus_Maintenance, pull_range);
                        const b_pull = disassembly.read_field(b, lc4k.Bus_Maintenance, pull_range);
                        if (a_pull != b_pull) {
                            try writer.print("       Pull: {s} -> {s}\n", .{
                                @tagName(a_pull),
                                @tagName(b_pull),
                            });
                        }
                    }

                    if (fuses.get_slew_rate_range(Device, mcref)) |slew_range| {
                        const a_slew = disassembly.read_field(a, lc4k.Slew_Rate, slew_range);
                        const b_slew = disassembly.read_field(b, lc4k.Slew_Rate, slew_range);
                        if (a_slew != b_slew) {
                            try writer.print("       Slew: {s} -> {s}\n", .{
                                @tagName(a_slew),
                                @tagName(b_slew),
                            });
                        }
                    }

                    if (fuses.get_drive_type_range(Device, mcref)) |drive_range| {
                        const a_drive = disassembly.read_field(a, lc4k.Drive_Type, drive_range);
                        const b_drive = disassembly.read_field(b, lc4k.Drive_Type, drive_range);
                        if (a_drive != b_drive) {
                            try writer.print("      Drive: {s} -> {s}\n", .{
                                @tagName(a_drive),
                                @tagName(b_drive),
                            });
                        }
                    }

                    if (fuses.get_input_threshold_range(Device, mcref)) |threshold_range| {
                        const a_threshold = disassembly.read_field(a, lc4k.Input_Threshold, threshold_range);
                        const b_threshold = disassembly.read_field(b, lc4k.Input_Threshold, threshold_range);
                        if (a_threshold != b_threshold) {
                            try writer.print("  Threshold: {s} -> {s}\n", .{
                                @tagName(a_threshold),
                                @tagName(b_threshold),
                            });
                        }
                    }

                    try writer.writeAll("\n");
                }
            }

            if (fuses.get_power_guard_range(Device, mcref)) |range| {
                if (diff.count_set_in_range(range) > 0) {
                    try context.maybe_write_heading();
                    if (Device.Signal.maybe_mc_pad(mcref)) |pad| {
                        try writer.print("   {s} (I/O {}) Power Guard:\n", .{ options.names.?.get_signal_name(pad), mc });
                    } else {
                        try writer.print("   internal I/O {} Power Guard:\n", .{ mc });
                    }
                    try write_fuse_diff(b, diff, range, writer);
                    const a_mode = disassembly.read_field(a, lc4k.Power_Guard, range);
                    const b_mode = disassembly.read_field(b, lc4k.Power_Guard, range);
                    if (a_mode != b_mode) {
                        try writer.print("         PG: {s} -> {s}\n", .{
                            @tagName(a_mode),
                            @tagName(b_mode),
                        });
                    }
                }
            }
        }
    }

    try context.end();
}

fn write_pt_diff(temp: std.mem.Allocator, comptime Device: type, a: JEDEC_Data, b: JEDEC_Data, diff: JEDEC_Data, glb: usize, glb_pt_offset: usize, writer: std.io.AnyWriter, options: Write_Options(Device)) !void {
    const range = fuses.get_pt_range(Device, glb, glb_pt_offset);
    try write_fuse_diff(b, diff, range, writer);

    var arena: std.heap.ArenaAllocator = .init(temp);
    defer arena.deinit();

    const a_gi_signals = try disassembly.read_gi_routing(Device, glb, a, null);
    const a_pt = try disassembly.read_pt_fuses(Device, arena.allocator(), glb, glb_pt_offset, &a_gi_signals, a, null);

    const b_gi_signals = try disassembly.read_gi_routing(Device, glb, b, null);
    const b_pt = try disassembly.read_pt_fuses(Device, arena.allocator(), glb, glb_pt_offset, &b_gi_signals, b, null);

    try writer.writeAll("        old: ");
    try report.write_pt_equation(writer, Device, a_pt, .{ .style = .console }, .{ .names = options.names });
    try writer.writeByte('\n');

    try writer.writeAll("        new: ");
    try report.write_pt_equation(writer, Device, b_pt, .{ .style = .console }, .{ .names = options.names });
    try writer.writeByte('\n');

    try writer.writeAll("\n");
}

fn write_fuse_diff(data: JEDEC_Data, diff: JEDEC_Data, range: Fuse_Range, writer: std.io.AnyWriter) !void {
    const width = range.width();
    const height = range.height();
    std.debug.assert(width > 0);
    std.debug.assert(height > 0);
    std.debug.assert(diff.count_set_in_range(range) > 0);

    const default_color: console.Style = .{};
    const diff_color = (console.Style { .fg = .bright_yellow }).with_flag(.bold);
    const no_diff_color: console.Style = .{ .fg = .bright_black };

    var style: console.Style = default_color;

    if (height > 4 and height < 80 and height * 16 / width > 25) {
        // transpose rows/columns to reduce number of lines of output
        try default_color.apply(writer);
        try write_table_column_header('R', range.min.row, range.max.row, writer);
        for (0..width) |col| {
            try write_table_row_header('C', range.min.col + col, writer);
            for (0..height) |row| {
                const fuse = range.at(row, col);
                const wanted_style = if (diff.is_set(fuse)) diff_color else no_diff_color;
                if (!std.meta.eql(style, wanted_style)) {
                    try wanted_style.apply(writer);
                    style = wanted_style;
                }
                try writer.print("{}", .{ data.get(fuse) });
            }
            if (!std.meta.eql(style, default_color)) {
                try default_color.apply(writer);
                style = default_color;
            }
            try writer.writeByte('\n');
        }
    } else {
        try default_color.apply(writer);
        try write_table_column_header('C', range.min.col, range.max.col, writer);
        for (0..height) |row| {
            try write_table_row_header('R', range.min.row + row, writer);
            for (0..width) |col| {
                const fuse = range.at(row, col);
                const wanted_style = if (diff.is_set(fuse)) diff_color else no_diff_color;
                if (!std.meta.eql(style, wanted_style)) {
                    try wanted_style.apply(writer);
                    style = wanted_style;
                }
                try writer.print("{}", .{ data.get(fuse) });
                if (width <= 3) try writer.writeByte(' ');
            }
            if (!std.meta.eql(style, default_color)) {
                try default_color.apply(writer);
                style = default_color;
            }
            try writer.writeByte('\n');
        }
    }

    try default_color.apply(writer);
}

fn write_table_column_header(prefix: u8, first: usize, last: usize, writer: std.io.AnyWriter) !void {
    std.debug.assert(last >= first);

    var first_buf: [32]u8 = undefined;
    var last_buf: [32]u8 = undefined;
    const first_str = std.fmt.bufPrint(&first_buf, "{c}{}", .{ prefix, first }) catch unreachable;
    const last_str = std.fmt.bufPrint(&last_buf, " {c}{}", .{ prefix, last }) catch unreachable;

    var target_width = last - first + 1;
    if (target_width > 1 and target_width <= 3) target_width += target_width - 1;

    var min_width = first_str.len;
    if (first != last) min_width += last_str.len;

    var prefix_width: usize = fuse_diff_horizontal_header_width;
    if (min_width > target_width) {
        const extra_width = (min_width - target_width) / 2;
        if (extra_width < fuse_diff_horizontal_header_width) {
            prefix_width -= extra_width;
        } else {
            prefix_width = 0;
        }
    }

    const used_width = prefix_width + min_width;
    const inner_width = if (used_width < fuse_diff_horizontal_header_width + target_width)
        fuse_diff_horizontal_header_width + target_width - used_width else 0;

    try writer.writeByteNTimes(' ', prefix_width);
    try writer.writeAll(first_str);
    if (first != last) {
        try writer.writeByteNTimes(' ', inner_width);
        try writer.writeAll(last_str);
    }
    if (prefix == 'R') try writer.writeAll(" (transposed)");
    try writer.writeByte('\n');
}

fn write_table_row_header(prefix: u8, label: usize, writer: std.io.AnyWriter) !void {
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{c}{}", .{ prefix, label }) catch unreachable;

    if (str.len + 2 < fuse_diff_horizontal_header_width) {
        try writer.writeByteNTimes(' ', fuse_diff_horizontal_header_width - str.len - 2);
    }
    try writer.writeAll(str);    
    try writer.writeAll(": ");
}

const fuse_diff_horizontal_header_width = 13;

const MC_Ref = lc4k.MC_Ref;
const MC_Index = lc4k.MC_Index;
const GLB_Index = lc4k.GLB_Index;
const Fuse = @import("Fuse.zig");
const Fuse_Range = @import("Fuse_Range.zig");
const JEDEC_Data = @import("JEDEC_Data.zig");
const JEDEC_File = @import("JEDEC_File.zig");
const report = @import("report.zig");
const disassembly = @import("disassembly.zig");
const fuses = @import("fuses.zig");
const lc4k = @import("lc4k.zig");
const console = @import("console");
const std = @import("std");
