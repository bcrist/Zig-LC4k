pub fn Write_Options(comptime Device: type) type {
    return struct {
        design_name: []const u8 = "",
        design_version: []const u8 = "",
        notes: []const u8 = "",
        assembly_errors: []const assembly.Assembly_Error = &[_]assembly.Assembly_Error{},
        names: ?*const Device.Names = null,

        pub fn get_names(self: @This()) *const Device.Names {
            return self.names orelse Device.get_names();
        }
    };
}

const PT_Usage = enum {
    none,
    sum,
    xor,
    fast,
    init,
    @"async",
    clock,
    ce,
    clock_and_ce,
    oe,
};

const Signal_Usage = enum (u8) {
    input_reg = std.math.maxInt(u8) - 1,
    orm = std.math.maxInt(u8),
    _, // 0..n correspond to usage as a GI in GLB 0..n

    pub fn init_glb(index: lc4k.GLB_Index) Signal_Usage {
        std.debug.assert(index != @intFromEnum(Signal_Usage.input_reg));
        std.debug.assert(index != @intFromEnum(Signal_Usage.orm));
        return @enumFromInt(index);
    }

    pub fn glb_index(self: Signal_Usage) ?lc4k.GLB_Index {
        return switch (self) {
            .input_reg, .orm => null,
            else => @intFromEnum(self),
        };
    }
};

fn Report_Data(comptime Device: type) type {
    const Signal = Device.Signal;

    const GLB_Report_Data = struct {
        const num_pts = Device.num_mcs_per_glb * 5 + 3;

        gi_routing: [Device.num_gis_per_glb]?Signal,
        sum_routing: routing.Routing_Data,
        pts: [num_pts]lc4k.Product_Term(Signal),
        pt_usage: [num_pts]PT_Usage,
        mc_usage: std.StaticBitSet(Device.num_mcs_per_glb),
        uses_bie: bool,
    };

    const shared_init_pt = Device.num_mcs_per_glb * 5 + 0;
    const shared_clock_pt = Device.num_mcs_per_glb * 5 + 1;
    const shared_enable_pt = Device.num_mcs_per_glb * 5 + 2;

    return struct {
        jed: JEDEC_Data,
        config: lc4k.Chip_Config(Device.device_type),
        disassembly_errors: std.ArrayList(disassembly.Disassembly_Error),

        glb: [Device.num_glbs]GLB_Report_Data = undefined,

        signal_usage: std.EnumArray(Device.Signal, std.EnumSet(Signal_Usage)) = .initFill(.initEmpty()),

        num_gis_used: u16 = 0,
        num_pts_used: u16 = 0,
        num_clusters_used: u16 = 0,
        num_mcs_used: u16 = 0,
        num_registers_used: u16 = 0,

        num_ios: u16 = 0,
        num_ios_used: u16 = 0,
        num_inputs_used: u16 = 0,
        num_clocks_used: u8 = 0,

        const Self = @This();

        pub fn init(alloc: std.mem.Allocator, file: JEDEC_File) !Self {
            std.debug.assert(file.data.extents.eql(Device.jedec_dimensions));

            const dis = try disassembly.disassemble(Device, alloc, file);

            var self = Self {
                .jed = file.data,
                .config = dis.config,
                .disassembly_errors = dis.errors,
            };

            var mcs_used = std.EnumSet(Signal) {};
            var ios_used = std.EnumSet(Signal) {};
            var inputs_used = std.EnumSet(Signal) {};
            var clocks_used = std.EnumSet(Signal) {};
            inline for (dis.config.glb, 0..) |glb_config, glb| {
                var glb_data = GLB_Report_Data {
                    .gi_routing = dis.gi_routing[glb],
                    .sum_routing = dis.sum_routing[glb],
                    .pts = undefined,
                    .pt_usage = undefined,
                    .mc_usage = .initEmpty(),
                    .uses_bie = false,
                };

                for (dis.gi_routing[glb]) |maybe_signal| {
                    if (maybe_signal) |signal| {
                        self.num_gis_used += 1;
                        switch (signal.kind()) {
                            .io => ios_used.insert(signal),
                            .mc => mcs_used.insert(signal),
                            .clk => clocks_used.insert(signal),
                            .in => inputs_used.insert(signal),
                        }
                        self.signal_usage.getPtr(signal).insert(.init_glb(@intCast(glb)));
                    }
                }

                glb_data.pts[shared_init_pt] = try disassembly.read_pt_fuses(Device, alloc, glb, shared_init_pt, &glb_data.gi_routing, self.jed, null);
                glb_data.pts[shared_clock_pt] = try disassembly.read_pt_fuses(Device, alloc, glb, shared_clock_pt, &glb_data.gi_routing, self.jed, null);
                glb_data.pts[shared_enable_pt] = try disassembly.read_pt_fuses(Device, alloc, glb, shared_enable_pt, &glb_data.gi_routing, self.jed, null);

                glb_data.pt_usage[shared_init_pt] = .none;
                glb_data.pt_usage[shared_clock_pt] = .none;
                glb_data.pt_usage[shared_enable_pt] = .none;

                inline for (glb_config.mc, 0..) |mc_config, mc| {
                    const mcref = lc4k.MC_Ref.init(glb, mc);

                    const glb_pt_base = mc * 5;
                    var pt_offset: usize = 0;
                    while (pt_offset < 5) : (pt_offset += 1) {
                        const glb_pt_offset = glb_pt_base + pt_offset;
                        const pt = try disassembly.read_pt_fuses(Device, alloc, glb, glb_pt_offset, &glb_data.gi_routing, self.jed, null);
                        glb_data.pts[glb_pt_offset] = pt;
                        glb_data.pt_usage[glb_pt_offset] = .sum;
                        if (@TypeOf(mc_config.output) == lc4k.Output_Config(Device.Signal)) {
                            switch (mc_config.output.routing) {
                                .same_as_oe, .self => {},
                                .five_pt_fast_bypass => {
                                    glb_data.pt_usage[glb_pt_offset] = .fast;
                                },
                            }
                        }
                    }

                    if (mc_config.func != .combinational) {
                        self.num_registers_used += 1;
                        mcs_used.insert(Device.Signal.mc_fb(mcref));
                    }

                    if (mc_config.output.oe != .input_only) {
                        if (Device.Signal.maybe_mc_pad(mcref)) |signal| {
                            ios_used.insert(signal);
                            self.signal_usage.getPtr(signal).insert(.orm);
                        }

                        const output_routing = if (Device.family == .zero_power_enhanced) mc_config.output.routing else mc_config.output.oe_routing;
                        const output_source_mc = output_routing.to_absolute(mcref);
                        mcs_used.insert(output_source_mc);

                        self.signal_usage.getPtr(output_source_mc).insert(.orm);
                    }

                    switch (mc_config.logic) {
                        .sum => {},
                        .input_buffer, .sum_xor_input_buffer => {
                            if (Device.Signal.maybe_mc_pad(mcref)) |signal| {
                                self.signal_usage.getPtr(signal).insert(.input_reg);
                            } else {
                                // TODO should this be reported in disassembly errors?
                            }
                        },
                        .pt0, .sum_xor_pt0 => {
                            glb_data.pt_usage[mc * 5] = .xor;
                        },
                    }

                    switch (mc_config.func) {
                        .combinational => {},
                        .latch, .t_ff, .d_ff => |reg_config| {
                            switch (reg_config.clock) {
                                .none => {},
                                .bclock0 => clocks_used.insert(switch (glb_config.bclock0) {
                                    .clk0_pos => .clk0,
                                    .clk1_neg => .clk1,
                                }),
                                .bclock1 => clocks_used.insert(switch (glb_config.bclock1) {
                                    .clk0_neg => .clk0,
                                    .clk1_pos => .clk1,
                                }),
                                .bclock2 => clocks_used.insert(switch (glb_config.bclock2) {
                                    .clk2_pos => .clk2,
                                    .clk3_neg => .clk3,
                                }),
                                .bclock3 => clocks_used.insert(switch (glb_config.bclock3) {
                                    .clk2_neg => .clk2,
                                    .clk3_pos => .clk3,
                                }),
                                .shared_pt_clock => {
                                    glb_data.pt_usage[shared_clock_pt] = switch (glb_data.pt_usage[shared_clock_pt]) {
                                        .ce => .clock_and_ce,
                                        else => .clock,
                                    };
                                },
                                .pt1 => {
                                    glb_data.pt_usage[mc * 5 + 1] = .clock;
                                },
                            }
                            switch (reg_config.ce) {
                                .always_active => {
                                    switch (reg_config.async_source) {
                                        .none => {},
                                        .pt2_active_high => {
                                            glb_data.pt_usage[mc * 5 + 2] = .@"async";
                                        },
                                    }
                                },
                                .shared_pt_clock => {
                                    glb_data.pt_usage[shared_clock_pt] = switch (glb_data.pt_usage[shared_clock_pt]) {
                                        .clock => .clock_and_ce,
                                        else => .ce,
                                    };
                                    switch (reg_config.async_source) {
                                        .none => {},
                                        .pt2_active_high => {
                                            glb_data.pt_usage[mc * 5 + 2] = .@"async";
                                        },
                                    }
                                },
                                .pt2 => {
                                    glb_data.pt_usage[mc * 5 + 2] = .ce;
                                },
                            }
                            switch (reg_config.init_source) {
                                .shared_pt_init => {
                                    glb_data.pt_usage[shared_init_pt] = .init;
                                },
                                .pt3_active_high => {
                                    glb_data.pt_usage[mc * 5 + 3] = .init;
                                },
                            }
                        },
                    }

                    if (mc_config.pt4_oe) |_| {
                        glb_data.pt_usage[mc * 5 + 4] = .oe;
                    }

                    if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                        if (mc_config.input.power_guard.? == .from_bie) {
                            glb_data.uses_bie = true;
                        }
                    }
                }

                parse_goe_pt_usage(dis.config.goe0, glb, &glb_data);
                parse_goe_pt_usage(dis.config.goe1, glb, &glb_data);
                parse_goe_pt_usage(dis.config.goe2, glb, &glb_data);
                parse_goe_pt_usage(dis.config.goe3, glb, &glb_data);

                @setEvalBranchQuota(10000);

                inline for (glb_config.mc, 0..) |_, mc| {
                    const glb_pt_base = mc * 5;
                    var cluster_used = false;
                    var pt_offset: usize = 0;
                    while (pt_offset < 5) : (pt_offset += 1) {
                        const glb_pt_offset = glb_pt_base + pt_offset;
                        switch (glb_data.pt_usage[glb_pt_offset]) {
                            .none => {},
                            .sum => {
                                if (!glb_data.pts[glb_pt_offset].is_always() and
                                    !glb_data.pts[glb_pt_offset].is_never()
                                ) {
                                    self.num_pts_used += 1;
                                    cluster_used = true;
                                }
                            },
                            else => {
                                self.num_pts_used += 1;
                                cluster_used = true;
                            },
                        }
                    }
                    if (cluster_used) {
                        self.num_clusters_used += 1;
                    }
                }

                if (glb_data.pt_usage[shared_init_pt] != .none) {
                    self.num_pts_used += 1;
                }
                if (glb_data.pt_usage[shared_clock_pt] != .none) {
                    self.num_pts_used += 1;
                }
                if (glb_data.pt_usage[shared_enable_pt] != .none) {
                    self.num_pts_used += 1;
                }

                self.glb[glb] = glb_data;
            }

            for (Device.all_pins) |pin| {
                switch (pin.info.func) {
                    .io, .io_oe0, .io_oe1, .input, .clock
                        => self.num_ios += 1,
                    .no_connect, .gnd, .vcc_core, .vcco, .tck, .tms, .tdi, .tdo
                        => continue,
                }
            }
            self.num_ios_used = @intCast(ios_used.count());
            self.num_inputs_used = @intCast(inputs_used.count());
            self.num_clocks_used = @intCast(clocks_used.count());
            self.num_mcs_used = @intCast(mcs_used.count());

            var mcs_used_iter = mcs_used.iterator();
            while (mcs_used_iter.next()) |signal| {
                const mcref = signal.mc();

                self.glb[mcref.glb].mc_usage.set(mcref.mc);
            }

            return self;
        }

        fn parse_goe_pt_usage(goe_config: anytype, glb: usize, glb_data: *GLB_Report_Data) void {
            switch (@TypeOf(goe_config)) {
                lc4k.GOE_Config_Bus_Or_Pin => switch (goe_config.source) {
                    .input, .constant_high => {},
                    .glb_shared_pt_enable => |goe_glb| {
                        if (glb == goe_glb) glb_data.pt_usage[shared_enable_pt] = .oe;
                    },
                },
                lc4k.GOE_Config_Bus => switch (goe_config.source) {
                    .constant_high => {},
                    .glb_shared_pt_enable => |goe_glb| {
                        if (glb == goe_glb) glb_data.pt_usage[shared_enable_pt] = .oe;
                    },
                },
                lc4k.GOE_Config_Pin => {},
                else => unreachable,
            }
        }
    };
}

pub fn write(comptime Device: type, comptime speed_grade: comptime_int, file: JEDEC_File, writer: std.io.AnyWriter, options: Write_Options(Device)) !void {
    var temp = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer temp.deinit();
    const alloc = temp.allocator();

    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer std.debug.assert(gpa.deinit() == .ok);

    const data = try Report_Data(Device).init(alloc, file);
    var timing_data = timing.Analyzer(Device, speed_grade).init(file.data, alloc, gpa.allocator());
    defer timing_data.deinit();

    try writer.writeAll("<html>\n");
    try writer.writeAll("<head>\n");
    if (options.design_name.len > 0) {
        try writer.print("<title>CPLD Design Report: {s}</title>\n", .{ options.design_name });
    } else {
        try writer.writeAll("<title>CPLD Design Report</title>\n");
    }
    try writer.writeAll("<style>\n");
    try writer.writeAll(@embedFile("report.css"));
    try writer.writeAll("</style>\n");
    try writer.writeAll("</head>\n");
    try writer.writeAll("<body>\n");

    try begin_section(writer, "Design Summary", .{}, .{});
    try writer.writeAll("<table class=\"inline\">\n");

    if (options.design_name.len > 0) {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Design Name</th>");
        try writer.print("<td>{s}</td>", .{ options.design_name });
        try writer.writeAll("</tr>\n");
    }
    if (options.design_version.len > 0) {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Design Version</th>");
        try writer.print("<td>{s}</td>", .{ options.design_version });
        try writer.writeAll("</tr>\n");
    }

    try writer.writeAll("<tr>");
    try writer.writeAll("<th>Device</th>");
    try writer.print("<td>{s}</td>", .{ @tagName(Device.device_type) });
    try writer.writeAll("</tr>\n");

    if (speed_grade != 0) {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Speed Grade</th>");
        try writer.print("<td>{d}</td>", .{ speed_grade });
        try writer.writeAll("</tr>\n");
    }

    if (file.usercode) |usercode| {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Usercode</th>");
        try writer.print("<td>0x{X:0>8}</td>", .{ usercode });
        try writer.writeAll("</tr>\n");
    }

    try write_summary_line(writer, "I/Os Used", data.num_ios_used, data.num_ios);
    if (Device.input_pins.len > 0) {
        try write_summary_line(writer, "Inputs Used", data.num_inputs_used, Device.input_pins.len);
    }
    try write_summary_line(writer, "Clocks Used", data.num_clocks_used, 4);
    try write_summary_line(writer, "GIs Used", data.num_gis_used, Device.num_glbs * Device.num_gis_per_glb);
    try write_summary_line(writer, "PTs Used", data.num_pts_used, Device.num_glbs * (Device.num_mcs_per_glb * 5 + 3));
    try write_summary_line(writer, "PT Clusters Used", data.num_clusters_used, Device.num_glbs * Device.num_mcs_per_glb);
    try write_summary_line(writer, "Macrocells Used", data.num_mcs_used, Device.num_glbs * Device.num_mcs_per_glb);
    try write_summary_line(writer, "Registers Used", data.num_registers_used, Device.num_glbs * Device.num_mcs_per_glb);

    try writer.writeAll("</table>\n");

    if (options.notes.len > 0) {
        try begin_section(writer, "Notes", .{}, .{ .tier = 3, .class = "inline" });
        try writer.writeAll(options.notes);
        try end_section(writer);
    }
    try end_section(writer);

    if (options.assembly_errors.len > 0) {
        try begin_section(writer, "Assembly Errors", .{}, .{});
        try begin_table(writer);
        try table_header(writer, .{ "Error", "Details", "Context" });
        for (options.assembly_errors) |err| {
            try writer.print("<tr><td>{s}</td><td>{s}</td><td>", .{ @errorName(err.err), err.details });
            if (err.glb) |glb| {
                if (err.mc) |mc| {
                    const mc_name = options.get_names().get_mc_name(lc4k.MC_Ref.init(glb, mc));
                    try writer.print("<div>MC: {s}</div>", .{ mc_name });
                } else {
                    try writer.print("<div>GLB: {s}</div>", .{ options.get_names().get_glb_name(glb) });
                    if (err.gi) |gi| {
                        try writer.print("<div>GI: {}</div>", .{ gi });
                    }
                }
            }
            if (err.grp_ordinal) |grp_ordinal| {
                const name = options.get_names().get_signal_name(@enumFromInt(grp_ordinal));
                try writer.print("<div>Signal: {s}</div> ", .{ name });
            }
            // if (err.fuse) |fuse| {
            //     try writer.print("({},{})", .{ fuse.row, fuse.col });
            // }
            try writer.writeAll("</td></tr>\n");
        }
        try end_table(writer);
        try end_section(writer);
    }

    if (data.disassembly_errors.items.len > 0) {
        try begin_section(writer, "Disassembly Errors", .{}, .{});
        try begin_table(writer);
        try table_header(writer, .{ "Error", "Details", "Context" });
        for (data.disassembly_errors.items) |err| {
            try writer.print("<tr><td>{s}</td><td>{s}</td><td>", .{ @errorName(err.err), err.details });
            if (err.glb) |glb| {
                if (err.mc) |mc| {
                    const mc_name = options.get_names().get_mc_name(lc4k.MC_Ref.init(glb, mc));
                    try writer.print("{s} ", .{ mc_name });
                } else {
                    try writer.print("GLB {s} ", .{ options.get_names().get_glb_name(glb) });
                    if (err.gi) |gi| {
                        try writer.print("GI {} ", .{ gi });
                    }
                }
            }
            if (err.fuse) |fuse| {
                try writer.print("({},{})", .{ fuse.row, fuse.col });
            }
            try writer.writeAll("</td></tr>\n");
        }
        try end_table(writer);
        try end_section(writer);
    }

    try write_globals_and_inputs(writer, Device, data, options);
    try write_macrocells(writer, Device, data, options);
    try write_product_terms(writer, Device, data, options);
    try write_glb_routing(writer, Device, data, options);

    try write_timing(writer, Device, speed_grade, data, &timing_data, options);

    try writer.writeAll("<footer>\n");
    try writer.writeAll("Generated by <a href=\"https://github.com/bcrist/Zig-LC4k\">Zig-LC4k</a>\n");
    try writer.writeAll("</footer>\n");
    try writer.writeAll("<script>\n//<!--\n");
    try writer.writeAll(@embedFile("report.js"));
    try writer.writeAll("//--></script>\n");
    try writer.writeAll("</body>\n");
    try writer.writeAll("</html>\n");
}

fn write_globals_and_inputs(writer: std.io.AnyWriter, comptime Device: type, data: Report_Data(Device), options: Write_Options(Device)) !void {
    try begin_section(writer, "Global Resources", .{}, .{});

    try begin_section(writer, "Global Output Enables", .{}, .{ .tier = 3, .class = "inline" });
    try begin_table(writer);

    try table_header(writer, .{ "GOE", "Equation" });

    try write_goe(writer, Device, false, 0, data.config.goe0, options);
    try write_goe(writer, Device, true,  1, data.config.goe1, options);
    try write_goe(writer, Device, false, 2, data.config.goe2, options);
    try write_goe(writer, Device, true,  3, data.config.goe3, options);

    try end_table(writer);
    try end_section(writer);

    if (Device.family == .zero_power_enhanced) {
        if (data.config.ext.osctimer) |config| {
            try begin_section(writer, "Oscillator/Timer", .{}, .{ .tier = 3, .class = "inline" });
            try begin_table(writer);

            const osc_frequency = 5_000_000;

            try writer.writeAll("<tr>");
            try writer.writeAll("<th>Nominal oscillator frequency</th>");
            try writer.print("<td>{} Hz</td>", .{ osc_frequency });
            try writer.writeAll("</tr>\n");

            if (config.enable_osc_out_and_disable) {
                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Oscillator disable/output signal</th>");
                try writer.print("<td>{s}</td>", .{ options.get_names().get_signal_name(lc4k.Oscillator_Timer_Config(Device).signals.osc_out) });
                try writer.writeAll("</tr>\n");
            }
            if (config.enable_timer_out_and_reset) {
                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Timer reset/output signal</th>");
                try writer.print("<td>{s}</td>", .{ options.get_names().get_signal_name(lc4k.Oscillator_Timer_Config(Device).signals.timer_out) });
                try writer.writeAll("</tr>\n");

                const divisor: usize = switch (config.timer_divisor) {
                    .div_128 => 128,
                    .div_1024 => 1024,
                    .div_1048576 => 1048576,
                    else => 1,
                };
                const timer_frequency = (osc_frequency + divisor / 2) / divisor;
                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Timer divisor</th>");
                try writer.print("<td>{}</td>", .{ divisor });
                try writer.writeAll("</tr>\n");

                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Nominal timer frequency</th>");
                try writer.print("<td>{} Hz</td>", .{ timer_frequency });
                try writer.writeAll("</tr>\n");
            }

            try end_table(writer);
            try end_section(writer);
        }
    }

    try begin_section(writer, "Clock &amp; Input Pins", .{}, .{ .tier = 3, .class = "inline" });
    try begin_table(writer);

    if (Device.family == .zero_power_enhanced) {
        try table_header(writer, .{ "Pin", "Signal", "Threshold", "Term", "PG" });
    } else {
        try table_header(writer, .{ "Pin", "Signal", "Threshold", "Term" });
    }

    var n: usize = 0;
    for (Device.clock_pins, 0..) |pin, i| {
        const config = data.config.clock[i];
        switch (@TypeOf(config)) {
            lc4k.Input_Config => try write_input_pin(writer, (n & 1) == 1, Device, pin, config.threshold.?, data.config.default_bus_maintenance, null, options),
            lc4k.Input_Config_ZE => try write_input_pin(writer, (n & 1) == 1, Device, pin, config.threshold.?, config.bus_maintenance.?, config.power_guard.?, options),
            else => unreachable,
        }
        n += 1;
    }

    for (Device.input_pins, 0..) |pin, i| {
        const config = data.config.input[i];
        switch (@TypeOf(config)) {
            lc4k.Input_Config => try write_input_pin(writer, (n & 1) == 1, Device, pin, config.threshold.?, data.config.default_bus_maintenance, null, options),
            lc4k.Input_Config_ZE => try write_input_pin(writer, (n & 1) == 1, Device, pin, config.threshold.?, config.bus_maintenance.?, config.power_guard.?, options),
            else => unreachable,
        }
        n += 1;
    }

    try end_table(writer);
    try end_section(writer);

    for (data.config.glb, 0..) |glb_config, glb| {
        try begin_glb_section(writer, glb, options.get_names().get_glb_name(@intCast(glb)));
        try begin_table(writer);

        try table_header(writer, .{ "Block Clock", "Equation" });

        try write_block_clock(writer, Device, false, 0, glb_config.bclock0, options);
        try write_block_clock(writer, Device, true,  1, glb_config.bclock1, options);
        try write_block_clock(writer, Device, false, 2, glb_config.bclock2, options);
        try write_block_clock(writer, Device, true,  3, glb_config.bclock3, options);

        try end_table(writer);
        try end_section(writer);
    }

    try end_section(writer);
}

fn write_goe(writer: std.io.AnyWriter, comptime Device: type, highlight: bool, goe_index: usize, goe_config: anytype, options: Write_Options(Device)) !void {
    try begin_row(writer, .{ .highlight = highlight });

    try begin_cell(writer, .{});
    try writer.print("<kbd class=\"oe goe-{}\">GOE {}</kbd>", .{ goe_index, goe_index });
    try end_cell(writer);

    try begin_cell(writer, .{ .class = "left" });
    switch (@TypeOf(goe_config)) {
        lc4k.GOE_Config_Bus_Or_Pin => switch (goe_config.source) {
            .constant_high => try write_unused_goe_equation(writer, goe_config.polarity),
            .input => try write_pin_goe_equation(writer, Device, goe_config.polarity, Device.oe_pins[goe_index], options),
            .glb_shared_pt_enable => |glb| try write_bus_goe_equation(writer, goe_config.polarity, glb),
        },
        lc4k.GOE_Config_Bus => switch (goe_config.source) {
            .constant_high => try write_unused_goe_equation(writer, goe_config.polarity),
            .glb_shared_pt_enable => |glb| try write_bus_goe_equation(writer, goe_config.polarity, glb),
        },
        lc4k.GOE_Config_Pin => {
            var oe_bus_index = goe_index;
            if (goe_index >= Device.oe_bus_size) {
                oe_bus_index -= 2;
            }
            try write_pin_goe_equation(writer, Device, goe_config.polarity, Device.oe_pins[oe_bus_index], options);
        },
        else => unreachable,
    }
    try end_cell(writer);

    try end_row(writer);
}

fn write_bus_goe_equation(writer: std.io.AnyWriter, polarity: lc4k.Polarity, glb: usize) !void {
    try writer.writeAll(switch (polarity) {
        .positive => "<abbr>",
        .negative => "<abbr><u>",
    });

    try writer.print("glb{}_shared_oe_pt", .{ glb });

    try writer.writeAll(switch (polarity) {
        .positive => "</abbr>",
        .negative => "</u></abbr>",
    });
}

fn write_unused_goe_equation(writer: std.io.AnyWriter, polarity: lc4k.Polarity) !void {
    try writer.writeAll(switch (polarity) {
        .positive => "<abbr>true</abbr>",
        .negative => "<abbr>false</abbr>",
    });
}

fn write_pin_goe_equation(writer: std.io.AnyWriter, comptime Device: type, polarity: lc4k.Polarity, pin: Device.Pin, options: Write_Options(Device)) !void {
    try writer.writeAll(switch (polarity) {
        .positive => "<abbr>",
        .negative => "<abbr><u>",
    });

    try writer.writeAll(options.get_names().get_signal_name(pin.pad()));

    try writer.writeAll(switch (polarity) {
        .positive => "</abbr>",
        .negative => "</u></abbr>",
    });
}

fn write_block_clock(writer: std.io.AnyWriter, comptime Device: type, highlight: bool, bclk_index: usize, value: anytype, options: Write_Options(Device)) !void {
    try begin_row(writer, .{ .highlight = highlight });

    try begin_cell(writer, .{});
    try writer.print("<kbd class=\"clk bclk{}\">BCLK {}</kbd>", .{ bclk_index, bclk_index });
    try end_cell(writer);

    try begin_cell(writer, .{ .class = "left" });
    const name = @tagName(value);
    const grp: Device.Signal = switch (name[3]) {
        '0' => .clk0,
        '1' => .clk1,
        '2' => .clk2,
        '3' => .clk3,
        else => unreachable,
    };
    if (std.mem.endsWith(u8, name, "_neg")) {
        try writer.print("<abbr><u>{s}</u></abbr>", .{ options.get_names().get_signal_name(grp) });
    } else {
        try writer.print("<abbr>{s}</abbr>", .{ options.get_names().get_signal_name(grp) });
    }
    try end_cell(writer);

    try end_row(writer);
}

fn write_input_pin(writer: std.io.AnyWriter, highlight: bool, comptime Device: type, pin: Device.Pin,
    threshold: lc4k.Input_Threshold,
    bus_maintenance: lc4k.Bus_Maintenance,
    power_guard: ?lc4k.Power_Guard,
    options: Write_Options(Device),
) !void {
    try begin_row(writer, .{
        .highlight = highlight,
    });

    try begin_cell(writer, .{});
    try writer.writeAll(pin.id());
    try end_cell(writer);

    try begin_cell(writer, .{});
    if (pin.info.grp_ordinal) |grp_ordinal| {
        try writer.writeAll(options.get_names().get_signal_name(@enumFromInt(grp_ordinal)));
    }
    try end_cell(writer);

    try begin_cell(writer, .{});
    try write_input_threshold(writer, Device, threshold);
    try end_cell(writer);

    try begin_cell(writer, .{});
    try write_bus_maintenance(writer, bus_maintenance);
    try end_cell(writer);

    if (Device.family == .zero_power_enhanced) {
        try begin_cell(writer, .{});
        if (power_guard) |pg| {
            try write_power_guard(writer, pg);
        }
        try end_cell(writer);
    }

    try end_row(writer);
}

fn write_input_threshold(writer: std.io.AnyWriter, comptime Device: type, threshold: lc4k.Input_Threshold) !void {
    switch (Device.family) {
        .zero_power_enhanced => {
            try writer.writeAll(switch (threshold) {
                .low => "<kbd class=\"threshold low\">0.5&times;Vcc</kbd>",
                .high => "<kbd class=\"threshold high\">&#8595;0.68&times;Vcc &#8593;0.79&times;Vcc</kbd>",
            });
        },
        .zero_power => {
            try writer.writeAll(switch (threshold) {
                .low => "<kbd class=\"threshold low\">0.5&times;Vc</kbd>",
                .high => "<kbd class=\"threshold high\">0.73&times;Vcc</kbd>",
            });
        },
        .low_power => {
            try writer.writeAll(switch (threshold) {
                .low => "<kbd class=\"threshold low\">0.9 V</kbd>",
                .high => "<kbd class=\"threshold high\">1.3 V</kbd>",
            });
        },
    }
}

fn write_bus_maintenance(writer: std.io.AnyWriter, maint: lc4k.Bus_Maintenance) !void {
    try writer.writeAll(switch (maint) {
        .pulldown => "<kbd class=\"maintenance pulldown\">Pulldown</kbd>",
        .float => "<kbd class=\"maintenance float\">Float</kbd>",
        .keeper => "<kbd class=\"maintenance keeper\">Keeper</kbd>",
        .pullup => "<kbd class=\"maintenance pullup\">Pullup</kbd>",
    });
}

fn write_power_guard(writer: std.io.AnyWriter, pg: lc4k.Power_Guard) !void {
    try writer.writeAll(switch (pg) {
        .from_bie => "<kbd class=\"power-guard enabled\">Enabled</kbd>",
        .disabled => "<kbd class=\"power-guard disabled\">Disabled</kbd>",
    });
}

fn write_product_terms(writer: std.io.AnyWriter, comptime Device: type, data: Report_Data(Device), options: Write_Options(Device)) !void {
    try begin_section(writer, "Product Terms", .{}, .{});
    for (data.glb, 0..) |glb_data, glb| {
        try begin_glb_section(writer, glb, options.get_names().get_glb_name(@intCast(glb)));
        try begin_table(writer);
        try table_header(writer, .{ "MC", "PT", "Usage", "Equation" });

        var mc: usize = 0;
        while (mc < Device.num_mcs_per_glb) : (mc += 1) {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            var pt_index: usize = 0;
            while (pt_index < 5) : (pt_index += 1) {
                try begin_row(writer, .{ .highlight = (mc & 1) == 1 });

                if (pt_index == 0) {
                    try writer.print("<td rowspan=\"5\">{s}</td>", .{ options.get_names().get_mc_name(mcref) });
                }

                try writer.print("<td>{}</td>", .{ pt_index });
                const glb_pt_offset = mc * 5 + pt_index;

                try writer.writeAll("<td>");
                try write_pt_usage(writer, glb_data.pt_usage[glb_pt_offset]);
                try writer.writeAll("</td>");

                try write_pt_equation(writer, Device, glb_data.pts[glb_pt_offset], options);
                try end_row(writer);
            }
        }

        try begin_row(writer, .{});
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 });
        try write_pt_usage(writer, glb_data.pt_usage[mc * 5]);
        try writer.writeAll("</td>");
        try write_pt_equation(writer, Device, glb_data.pts[mc * 5], options);
        try end_row(writer);

        try begin_row(writer, .{ .highlight = true });
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 + 1 });
        try write_pt_usage(writer, glb_data.pt_usage[mc * 5 + 1]);
        try writer.writeAll("</td>");
        try write_pt_equation(writer, Device, glb_data.pts[mc * 5 + 1], options);
        try end_row(writer);

        try begin_row(writer, .{});
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 + 2 });
        if (glb_data.uses_bie) {
            try writer.writeAll("<kbd class=\"pt-usage bie\">BIE</kbd> ");
        }
        try write_pt_usage(writer, glb_data.pt_usage[mc * 5 + 2]);
        try writer.writeAll("</td>");
        try write_pt_equation(writer, Device, glb_data.pts[mc * 5 + 2], options);
        try end_row(writer);

        try end_table(writer);
        try end_section(writer);
    }
    try end_section(writer);
}

fn write_pt_usage(writer: std.io.AnyWriter, usage: PT_Usage) !void {
    try writer.writeAll(switch (usage) {
        .none     => return,
        .sum      => "<kbd class=\"pt-usage sum\">Sum</kbd>",
        .xor      => "<kbd class=\"pt-usage xor\">XOR</kbd>",
        .fast     => "<kbd class=\"pt-usage fast\">Fast-Bypass</kbd>",
        .init     => "<kbd class=\"pt-usage init\">Init</kbd>",
        .@"async" => "<kbd class=\"pt-usage async\">Async</kbd>",
        .clock    => "<kbd class=\"pt-usage clock\">Clock</kbd>",
        .ce       => "<kbd class=\"pt-usage ce\">CE</kbd>",
        .oe       => "<kbd class=\"pt-usage oe\">OE</kbd>",
        .clock_and_ce => "<kbd class=\"pt-usage clock\">Clock</kbd> <kbd class=\"pt-usage ce\">CE</kbd>",
    });
}

fn write_pt_equation(writer: std.io.AnyWriter, comptime Device: type, pt: lc4k.Product_Term(Device.Signal), options: Write_Options(Device)) !void {
    try writer.writeAll("<td class=\"left\">");

    var first = true;
    for (pt.factors) |factor| {
        if (first) {
            first = false;
        } else {
            try writer.writeAll(" &middot; ");
        }
        switch (factor) {
            .never => {
                try writer.writeAll("<abbr>false</abbr>");
            },
            .always => {
                try writer.writeAll("<abbr>true</abbr>");
            },
            .when_high => |grp| {
                try writer.print("<abbr>{s}</abbr>", .{ options.get_names().get_signal_name(grp) });
            },
            .when_low => |grp| {
                try writer.print("<abbr><u>{s}</u></abbr>", .{ options.get_names().get_signal_name(grp) });
            },
        }
    }

    if (first) {
        try writer.writeAll("<abbr>true</abbr>");
    }

    try writer.writeAll("</td>");
}

fn write_glb_routing(writer: std.io.AnyWriter, comptime Device: type, data: Report_Data(Device), options: Write_Options(Device)) !void {
    try begin_section(writer, "GI Routing", .{}, .{});
    for (data.config.glb, 0..) |_, glb| {
        try begin_glb_section(writer, glb, options.get_names().get_glb_name(@intCast(glb)));
        try begin_table(writer);
        try table_header(writer, .{
            .GI = 1,
            .Fuses = Device.gi_mux_size,
            .Signal = 1,
            .Fanout = 1,
        });

        for (Device.gi_options, 0..) |gi_options, gi| {
            const fuse_range = Device.get_gi_range(glb, gi);
            var fuse_iter = fuse_range.iterator();
            var active: ?Device.Signal = null;
            try begin_row(writer, .{ .highlight = (gi & 1) == 1 });

            try writer.print("<td>{}</td>", .{ gi });
            for (gi_options) |grp| {
                const fuse = fuse_iter.next().?;
                var mark: []const u8 = "";
                if (data.jed.get(fuse) == 0) {
                    mark = "&#9679;";
                    active = grp;
                }
                try writer.print("<td class=\"fuse\" title=\"{s}\">{s}</td>", .{ options.get_names().get_signal_name(grp), mark });
            }

            if (active) |grp| {
                var fanout: usize = 0;
                const pt_range = Device.get_glb_range(glb).sub_rows(gi * 2, 2);
                var col: usize = 0;
                while (col < pt_range.width()) : (col += 1) {
                    if (data.jed.count_unset_in_range(pt_range.sub_columns(col, 1)) == 1) {
                        fanout += 1;
                    }
                }
                try writer.print("<td>{s}</td><td>{}</td>", .{ options.get_names().get_signal_name(grp), fanout });
            } else {
                try writer.writeAll("<td></td><td></td>");
            }

            try end_row(writer);
        }

        try end_table(writer);
        try end_section(writer);
    }
    try end_section(writer);
}

fn write_macrocells(writer: std.io.AnyWriter, comptime Device: type, data: Report_Data(Device), options: Write_Options(Device)) !void {
    try begin_section(writer, "Macrocells", .{}, .{});

    for (data.config.glb, 0..) |glb_config, glb| {
        try begin_glb_section(writer, glb, options.get_names().get_glb_name(@intCast(glb)));
        try writer.writeAll("<div class=\"hover-root\">\n");
        try begin_table(writer);
        if (Device.family == .zero_power_enhanced) {
            try table_header(writer, .{
                .@"&nbsp;" = 4,
                .Target = 1,
                .Sum = 1,
                .Macrocell = 6,
                .Output = 4,
                .Input = 3,
            });
            try table_header(writer, .{
                "Pin", "I/O", "FB",
                "MC", "Cluster", "PTs",
                "Logic", "Type", "Clock", "CE", "Init", "Async",
                "From", "OE", "Slew", "Drive",
                "Threshold", "Term",
                "PG", 
            });
        } else {
            try table_header(writer, .{
                .@"&nbsp;" = 4,
                .Target = 1,
                .Sum = 1,
                .Macrocell = 6,
                .Output = 4,
                .Input = 2,
            });
            try table_header(writer, .{
                "Pin", "I/O", "FB",
                "MC", "Cluster", "PTs",
                "Logic", "Type", "Clock", "CE", "Init", "Async",
                "From", "OE", "Slew", "Drive",
                "Threshold", "Term",
            });
        }

        for (glb_config.mc, 0..) |mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            var ca_jumps: usize = 0;
            var dest: ?usize = null;
            if (routing.get_ca_for_cluster(mc, data.glb[glb].sum_routing.cluster[mc])) |initial_ca| {
                var ca = routing.get_ca_destination(initial_ca, data.glb[glb].sum_routing.wide[initial_ca]);
                while (ca != initial_ca) {
                    ca_jumps += 1;
                    const dest_ca = routing.get_ca_destination(ca, data.glb[glb].sum_routing.wide[ca]);
                    if (dest_ca == ca) break;
                    ca = dest_ca;
                }
                dest = ca;
            }

            try begin_row(writer, .{
                .highlight = (mc & 1) == 1,
            });

            var temp_buf: [64]u8 = undefined;
            const mc_class = try std.fmt.bufPrint(&temp_buf, ".mc-{}", .{ mc });
            const cell_options = Cell_Options {
                .class = mc_class[1..],
                .hover_selector = mc_class,
            };

            if (Device.Signal.maybe_mc_pad(mcref)) |pad| {
                const usage = data.signal_usage.get(pad);

                try begin_cell(writer, cell_options);
                if (pad.maybe_pin()) |pi| try writer.writeAll(pi.id());
                try end_cell(writer);

                // I/O Name
                var io_cell_options = cell_options;
                if (usage.count() == 0) {
                    io_cell_options.additional_classes = &.{ "unused" };
                }
                try begin_cell(writer, io_cell_options);
                try writer.writeAll(options.get_names().get_signal_name(pad));
                try end_cell(writer);
            } else {
                try begin_cell(writer, .{});
                try end_cell(writer);
                try begin_cell(writer, .{});
                try end_cell(writer);
            }

            {
                // FB Name
                const signal = Device.Signal.mc_fb(mcref);
                const usage = data.signal_usage.get(signal);

                var fb_name_cell_options = cell_options;
                if (usage.count() == 0) {
                    fb_name_cell_options.additional_classes = &.{ "unused" };
                }

                try begin_cell(writer, fb_name_cell_options);
                try writer.writeAll(options.get_names().get_signal_name(signal));
                try end_cell(writer);
            }


            var mc_cell_options = cell_options;
            if (!data.glb[glb].mc_usage.isSet(mc)) {
                mc_cell_options.additional_classes = &.{ "unused" };
            }

            // MC Name
            try begin_cell(writer, mc_cell_options);
            try writer.writeAll(options.get_names().get_mc_name(mcref));
            try end_cell(writer);

            if (dest) |ca| {
                var temp_buf_2: [64]u8 = undefined;
                var temp_buf_3: [64]u8 = undefined;
                const ca_selector = try std.fmt.bufPrint(&temp_buf_2, ".mc-{}", .{ ca });
                const ca_class = try std.fmt.bufPrint(&temp_buf_3, "ca-depth-{} mc-{}", .{ ca_jumps, ca });

                var dest_cell_options: Cell_Options = .{
                    .class = ca_class,
                    .hover_selector = ca_selector,
                };
                if (!data.glb[glb].mc_usage.isSet(ca)) {
                    dest_cell_options.additional_classes = &.{ "unused" };
                }
                try begin_cell(writer, dest_cell_options);
                try writer.writeAll(options.get_names().get_mc_name(lc4k.MC_Ref.init(glb, ca)));
            } else {
                try begin_cell(writer, .{});
            }
            try end_cell(writer);

            var sum_pts: usize = 0;
            switch (mc_config.logic) {
                .sum => |sp| for (sp.sum) |pt| {
                    if (!pt.is_always()) sum_pts += 1;
                },
                .sum_xor_pt0 => |sxpt| for (sxpt.sum) |pt| {
                    if (!pt.is_always()) sum_pts += 1;
                },
                .sum_xor_input_buffer => |sum| for (sum) |pt| {
                    if (!pt.is_always()) sum_pts += 1;
                },
                .input_buffer, .pt0 => {},
            }

            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .five_pt_fast_bypass => |sp| {
                        for (sp.sum) |pt| {
                            if (!pt.is_always()) sum_pts += 1;
                        }
                    },
                    .same_as_oe, .self => {},
                }
            }
            try begin_cell(writer, mc_cell_options);
            try writer.print("{}", .{ sum_pts });
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            try writer.writeAll(switch (mc_config.logic) {
                .sum => |sp| switch (sp.polarity) {
                    .positive => "<kbd class=\"logic sum\">Sum</kbd>",
                    .negative => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic invert\">Invert</kbd>",
                },
                .pt0 => |ptp| switch (ptp.polarity) {
                    .positive => "<kbd class=\"logic pt\">PT</kbd>",
                    .negative => "<kbd class=\"logic pt\">PT</kbd> <kbd class=\"logic invert\">Invert</kbd>",
                },
                .sum_xor_pt0 => |sxpt| switch (sxpt.polarity) {
                    .positive => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic xor-pt\">XOR PT</kbd>",
                    .negative => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic xor-pt\">XOR PT</kbd> <kbd class=\"logic invert\">Invert</kbd>",
                },
                .input_buffer => "<kbd class=\"logic input\">Input</kbd>",
                .sum_xor_input_buffer => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic xor-input\">XOR Input</kbd>",
            });
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "<kbd class=\"func comb\">Comb</kbd>",
                .latch => "<kbd class=\"func latch\">Latch</kbd>",
                .t_ff => "<kbd class=\"func tff\">T FF</kbd>",
                .d_ff => "<kbd class=\"func dff\">D FF</kbd>",
            });
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            const clock_invert: ?bool = switch (mc_config.func) {
                .combinational => null,
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.clock) {
                    .none => null,
                    .shared_pt_clock => blk: {
                        try writer.writeAll("<kbd class=\"clk shared-pt\">Shared PT</kbd>");
                        break :blk switch (glb_config.shared_pt_clock.polarity) {
                            .positive => false,
                            .negative => true,
                        };
                    },
                    .pt1 => |ptp| blk: {
                        try writer.writeAll("<kbd class=\"clk pt\">PT</kbd>");
                        break :blk switch (ptp.polarity) {
                            .positive => false,
                            .negative => true,
                        };
                    },
                    .bclock0 => blk: {
                        try writer.writeAll("<kbd class=\"clk bclk0\">BCLK 0</kbd>");
                        break :blk false;
                    },
                    .bclock1 => blk: {
                        try writer.writeAll("<kbd class=\"clk bclk1\">BCLK 1</kbd>");
                        break :blk false;
                    },
                    .bclock2 => blk: {
                        try writer.writeAll("<kbd class=\"clk bclk2\">BCLK 2</kbd>");
                        break :blk false;
                    },
                    .bclock3 => blk: {
                        try writer.writeAll("<kbd class=\"clk bclk3\">BCLK 3</kbd>");
                        break :blk false;
                    },
                },
            };
            if (clock_invert) |invert| {
                try writer.writeAll(switch (mc_config.func) {
                    .latch => if (invert) " <kbd class=\"clk latch neg\">Transparent Low</kbd>" else " <kbd class=\"clk latch pos\">Transparent High</kbd>",
                    else => if (invert) " <kbd class=\"clk neg\">Falling Edge</kbd>" else " <kbd class=\"clk pos\">Rising Edge</kbd>",
                });
            }
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "",
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.ce) {
                    .pt2 => |ptp| switch (ptp.polarity) {
                        .positive => "<kbd class=\"ce pt\">PT</kbd> <kbd class=\"ce pos\">Active High</kbd>",
                        .negative => "<kbd class=\"ce pt\">PT</kbd> <kbd class=\"ce neg\">Active Low</kbd>",
                    },
                    .shared_pt_clock => switch (glb_config.shared_pt_clock.polarity) {
                        .positive => "<kbd class=\"ce shared-pt\">Shared PT</kbd> <kbd class=\"ce pos\">Active High</kbd>",
                        .negative => "<kbd class=\"ce shared-pt\">Shared PT</kbd> <kbd class=\"ce neg\">Active Low</kbd>",
                    },
                    .always_active => "",
                },
            });
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            switch (mc_config.func) {
                .combinational => {},
                .latch, .t_ff, .d_ff => |reg_config| {
                    try writer.print("{}", .{ reg_config.init_state });
                    try writer.writeAll(switch (reg_config.init_source) {
                        .pt3_active_high => " <kbd class=\"init pt\">PT</kbd> <kbd class=\"init pos\">Active High</kbd>",
                        .shared_pt_init => switch (glb_config.shared_pt_init.polarity) {
                            .positive => " <kbd class=\"init shared-pt\">Shared PT</kbd> <kbd class=\"init pos\">Active High</kbd>",
                            .negative => " <kbd class=\"init shared-pt\">Shared PT</kbd> <kbd class=\"init neg\">Active Low</kbd>",
                        },
                    });
                },
            }
            try end_cell(writer);

            try begin_cell(writer, mc_cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "",
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.async_source) {
                    .none => "",
                    .pt2_active_high => "<kbd class=\"async pt\">PT</kbd> <kbd class=\"async pos\">Active High</kbd>",
                },
            });
            try end_cell(writer);

            if (Device.Signal.maybe_mc_pad(mcref)) |pad| {
                var out_mcref = mcref;
                var out_options = cell_options;
                var out_mc_delta: usize = 0;
                var out_from_extra: []const u8 = "";
                var temp_out_buf: [64]u8 = undefined;

                var oe_mcref = mcref;
                var oe_options = cell_options;
                var oe_mc_delta: usize = 0;
                var temp_oe_buf: [64]u8 = undefined;

                var in_options = cell_options;

                if (Device.family == .zero_power_enhanced) {
                    out_mcref = mc_config.output.routing.to_absolute(mcref).mc();
                    out_mc_delta = mc_config.output.routing.to_relative(mcref) orelse 0;

                    const out_mc_class = try std.fmt.bufPrint(&temp_out_buf, ".mc-{}", .{ out_mcref.mc });
                    out_options = Cell_Options {
                        .class = out_mc_class[1..],
                        .hover_selector = out_mc_class,
                    };

                    oe_options = switch (mc_config.output.oe) {
                        .from_orm_active_high, .from_orm_active_low => out_options,
                        else => .{},
                    };
                    oe_mcref = out_mcref;
                    oe_mc_delta = out_mc_delta;
                } else {
                    oe_mcref = mc_config.output.oe_routing.to_absolute(mcref).mc();
                    oe_mc_delta = mc_config.output.oe_routing.to_relative(mcref) orelse 0;

                    const oe_mc_class = try std.fmt.bufPrint(&temp_oe_buf, ".mc-{}", .{ oe_mcref.mc });
                    oe_options = Cell_Options {
                        .class = oe_mc_class[1..],
                        .hover_selector = oe_mc_class,
                    };

                    switch (mc_config.output.routing.mode()) {
                        .same_as_oe => {
                            out_mcref = oe_mcref;
                            out_mc_delta = oe_mc_delta;
                            out_options = oe_options;
                        },
                        .self => {},
                        .five_pt_fast_bypass => out_from_extra = " <kbd class=\"out fast\">Fast-Bypass</kbd>",
                        .five_pt_fast_bypass_inverted => out_from_extra = " <kbd class=\"out fast\">Fast-Bypass</kbd> <kbd class=\"out invert\">Invert</kbd>",
                    }

                    switch (mc_config.output.oe) {
                        .from_orm_active_high, .from_orm_active_low => {},
                        else => oe_options = .{},
                    }
                }

                if (mc_config.output.oe == .input_only) {
                    out_options = .{};
                    oe_options = .{};
                }

                if (data.signal_usage.get(pad).count() == 0) {
                    out_options.additional_classes = &.{ "unused" };
                    oe_options.additional_classes = &.{ "unused" };
                    in_options.additional_classes = &.{ "unused" };
                }

                try begin_cell(writer, out_options);
                if (mc_config.output.oe != .input_only) {
                    if (out_mc_delta != 0) {
                        try writer.print("<kbd class=\"out routing\">+{}</kbd> ", .{ out_mc_delta });
                    }
                    try writer.writeAll(options.get_names().get_mc_name(out_mcref));
                }
                try writer.writeAll(out_from_extra);
                try end_cell(writer);

                try begin_cell(writer, oe_options);
                switch (mc_config.output.oe) {
                    .goe0 => try writer.writeAll("<kbd class=\"oe goe0\">GOE 0</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                    .goe1 => try writer.writeAll("<kbd class=\"oe goe1\">GOE 1</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                    .goe2 => try writer.writeAll("<kbd class=\"oe goe2\">GOE 2</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                    .goe3 => try writer.writeAll("<kbd class=\"oe goe3\">GOE 3</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                    .from_orm_active_high => {
                        if (oe_mc_delta != 0) {
                            try writer.print("<kbd class=\"oe routing\">+{}</kbd> ", .{ oe_mc_delta });
                        }
                        try writer.writeAll(options.get_names().get_mc_name(oe_mcref));
                        try writer.writeAll(" <kbd class=\"oe from-orm\">PT</kbd> <kbd class=\"oe pos\">Active High</kbd>");
                    },
                    .from_orm_active_low => {
                        if (oe_mc_delta != 0) {
                            try writer.print("<kbd class=\"oe routing\">+{}</kbd> ", .{ oe_mc_delta });
                        }
                        try writer.writeAll(options.get_names().get_mc_name(oe_mcref));
                        try writer.writeAll(" <kbd class=\"oe from-orm\">PT</kbd> <kbd class=\"oe neg\">Active Low</kbd>");
                    },
                    .output_only => try writer.writeAll("<kbd class=\"oe output-only\">Output</kbd>"),
                    .input_only => try writer.writeAll("<kbd class=\"oe input-only\">Input</kbd>"),
                }
                try end_cell(writer);

                try begin_cell(writer, out_options);
                if (mc_config.output.oe != .input_only) {
                    try writer.writeAll(switch (mc_config.output.slew_rate.?) {
                        .slow => "<kbd class=\"slew slow\">Slow</kbd>",
                        .fast => "<kbd class=\"slew fast\">Fast</kbd>",
                    });
                }
                try end_cell(writer);

                try begin_cell(writer, out_options);
                if (mc_config.output.oe != .input_only) {
                    try writer.writeAll(switch (mc_config.output.drive_type.?) {
                        .push_pull => "<kbd class=\"drive push-pull\">TP</kbd>",
                        .open_drain => "<kbd class=\"drive open-drain\">OD</kbd>",
                    });
                }
                try end_cell(writer);

                try begin_cell(writer, in_options);
                if (mc_config.output.oe != .output_only) {
                    try write_input_threshold(writer, Device, mc_config.input.threshold.?);
                }
                try end_cell(writer);

                if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                    try begin_cell(writer, in_options);
                    if (mc_config.output.oe != .output_only) {
                        try write_bus_maintenance(writer, mc_config.input.bus_maintenance.?);
                    }
                    try end_cell(writer);

                    try begin_cell(writer, in_options);
                    try write_power_guard(writer, mc_config.input.power_guard.?);
                    try end_cell(writer);
                } else {
                    try begin_cell(writer, in_options);
                    if (mc_config.output.oe != .output_only) {
                        try write_bus_maintenance(writer, data.config.default_bus_maintenance);
                    }
                    try end_cell(writer);
                }
            } else {
                // Output columns:
                try begin_cell(writer, .{}); // From
                try end_cell(writer);

                try begin_cell(writer, .{}); // OE
                try end_cell(writer);

                try begin_cell(writer, .{}); // Slew
                try end_cell(writer);

                try begin_cell(writer, .{}); // Drive
                try end_cell(writer);

                // Input columns:
                try begin_cell(writer, .{}); // Threshold
                try end_cell(writer);

                try begin_cell(writer, .{}); // Term
                try end_cell(writer);
            }

            try end_row(writer);
        }

        try end_table(writer);
        try writer.writeAll("</div>\n");
        try end_section(writer);
    }
    try end_section(writer);
}

fn write_timing(writer: std.io.AnyWriter, comptime Device: type, comptime speed: comptime_int, data: Report_Data(Device), timing_data: *timing.Analyzer(Device, speed), options: Write_Options(Device)) !void {
    try begin_section(writer, "Critical Path Timing", .{}, .{});
    for (data.config.glb, 0..) |glb_config, glb| {
        try begin_glb_section(writer, glb, options.get_names().get_glb_name(@intCast(glb)));
        try begin_table(writer);
        try table_header(writer, .{
            .Source = 1,
            .Target = 1,
            .Delay = 1,
        });

        var highlight = false;
        for (glb_config.mc, 0..) |_, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            var found_path = try write_timing_for_target(writer, Device, speed, .{ .out = mcref }, data, timing_data, options, highlight) != null;
            found_path = try write_timing_for_target(writer, Device, speed, .{ .out_en = mcref }, data, timing_data, options, highlight) != null or found_path;
            found_path = try write_timing_for_target(writer, Device, speed, .{ .out_dis = mcref }, data, timing_data, options, highlight) != null or found_path;

            if (data.config.glb[mcref.glb].mc[mcref.mc].func != .combinational) {
                const clk_path = try write_timing_for_target(writer, Device, speed, .{ .mc_clk = mcref }, data, timing_data, options, highlight);
                if (clk_path) |path| {
                    const clk_source = path.critical_path[0].segment.source;

                    try write_setup_hold_timing(writer, Device, speed, .{ .mcd_setup = mcref }, .{ .mc_clk_d_hold = mcref }, clk_source, data, timing_data, options, highlight);
                    try write_setup_hold_timing(writer, Device, speed, .{ .mc_ce_setup = mcref }, .{ .mc_clk_ce_hold = mcref }, clk_source, data, timing_data, options, highlight);
                }
            }

            if (found_path) highlight = !highlight;
        }

        try end_table(writer);
        try end_section(writer);
    }
    try end_section(writer);

}

fn write_timing_for_target(writer: std.io.AnyWriter, comptime Device: type, comptime speed: comptime_int, target: timing.Node, data: Report_Data(Device), timing_data: *timing.Analyzer(Device, speed), options: Write_Options(Device), highlight: bool) !?timing.Path {
    var shortest_path: ?timing.Path = null;

    for (std.enums.values(Device.Signal)) |grp| {
        const source: timing.Node = switch (grp.kind()) {
            .io, .in, .clk => .{ .pad = @intFromEnum(grp) },
            .mc => .{ .mcq = grp.mc() },
        };

        if (source == .mcq) {
            const mcref = grp.mc();
            switch(data.config.glb[mcref.glb].mc[mcref.mc].func) {
                .combinational, .latch => continue,
                .t_ff, .d_ff => {},
            }
        }

        if (timing_data.get_critical_path(.{ .source = source, .dest = target })) |path| {
            if (shortest_path) |shortest| {
                if (path.delay < shortest.delay) {
                    shortest_path = path;
                }
            } else {
                shortest_path = path;
            }

            try begin_row(writer, .{ .highlight = highlight, .class = "details-root" });

            try begin_cell(writer, .{});
            try source.write_name(writer, Device, options.get_names());
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.source.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            try end_cell(writer);

            try begin_cell(writer, .{});
            try target.write_name(writer, Device, options.get_names());
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.dest.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            try end_cell(writer);

            try begin_cell(writer, .{});
            try writer.print("{d} ns", .{ @as(f64, @floatFromInt(path.delay)) / 1000 });
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try writer.print("{d} ns ({s})", .{ @as(f64, @floatFromInt(delay.delay)) / 1000, delay.name });
                try end_details(writer);
            }
            try end_cell(writer);

            try end_row(writer);
        } else |_| {}
    }

    return shortest_path;
}

fn write_setup_hold_timing(writer: std.io.AnyWriter, comptime Device: type, comptime speed: comptime_int, setup: timing.Node, hold: timing.Node, clk_source: timing.Node, data: Report_Data(Device), timing_data: *timing.Analyzer(Device, speed), options: Write_Options(Device), highlight: bool) !void {
    const clk_mcref = switch (hold) {
        .mc_clk_d_hold, .mc_clk_ce_hold => |mcref| mcref,
        else => unreachable,
    };

    const clk_path = try timing_data.get_critical_path(.{ .source = clk_source, .dest = .{ .mc_clk = clk_mcref }});
    const hold_path = try timing_data.get_critical_path(.{ .source = clk_source, .dest = hold });

    for (std.enums.values(Device.Signal)) |grp| {
        const source: timing.Node = switch (grp.kind()) {
            .io, .in, .clk => .{ .pad = @intFromEnum(grp) },
            .mc => source: {
                const mcref = grp.mc();
                switch(data.config.glb[mcref.glb].mc[mcref.mc].func) {
                    .combinational => continue,
                    .latch, .t_ff, .d_ff => {
                        break :source .{ .mc_clk = mcref };
                    },
                }
            },
        };

        if (std.meta.eql(source, clk_source)) continue;

        if (timing_data.get_critical_path(.{ .source = source, .dest = setup })) |path| {
            try begin_row(writer, .{ .highlight = highlight, .class = "details-root" });

            try begin_cell(writer, .{});
            try source.write_name(writer, Device, options.get_names());
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.source.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            for (clk_path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.source.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            try end_cell(writer);

            try begin_cell(writer, .{});
            try setup.write_name(writer, Device, options.get_names());
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.dest.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            for (clk_path.critical_path) |delay| {
                try begin_details(writer, .{});
                try delay.segment.dest.write_name(writer, Device, options.get_names());
                try end_details(writer);
            }
            try end_cell(writer);

            try begin_cell(writer, .{});
            var setup_ps: f64 = @floatFromInt(path.delay);
            setup_ps -= @floatFromInt(clk_path.delay);
            try writer.print("{d} ns", .{ setup_ps / 1000 });
            for (path.critical_path) |delay| {
                try begin_details(writer, .{});
                try writer.print("{d} ns ({s})", .{ @as(f64, @floatFromInt(delay.delay)) / 1000, delay.name });
                try end_details(writer);
            }
            for (clk_path.critical_path) |delay| {
                try begin_details(writer, .{});
                try writer.print("-{d} ns ({s})", .{ @as(f64, @floatFromInt(delay.delay)) / 1000, delay.name });
                try end_details(writer);
            }
            try end_cell(writer);

            try end_row(writer);

            const dest: timing.Node = switch (setup) {
                .mcd_setup => |mcref| .{ .mcd = mcref },
                .mc_ce_setup => |mcref| .{ .mc_ce = mcref },
                else => unreachable,
            };
            const pre_setup_path = try timing_data.get_critical_path(.{ .source = source, .dest = dest });
            var hold_ps: f64 = @floatFromInt(hold_path.delay);
            hold_ps -= @floatFromInt(pre_setup_path.delay);

            if (hold_ps > 0) {
                try begin_row(writer, .{ .highlight = highlight, .class = "details-root" });

                try begin_cell(writer, .{});
                try source.write_name(writer, Device, options.get_names());
                for (hold_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try delay.segment.source.write_name(writer, Device, options.get_names());
                    try end_details(writer);
                }
                for (pre_setup_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try delay.segment.source.write_name(writer, Device, options.get_names());
                    try end_details(writer);
                }
                try end_cell(writer);

                try begin_cell(writer, .{});
                try hold.write_name(writer, Device, options.get_names());
                for (hold_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try delay.segment.dest.write_name(writer, Device, options.get_names());
                    try end_details(writer);
                }
                for (pre_setup_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try delay.segment.dest.write_name(writer, Device, options.get_names());
                    try end_details(writer);
                }
                try end_cell(writer);

                try begin_cell(writer, .{});
                try writer.print("{d} ns", .{ hold_ps / 1000 });
                for (hold_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try writer.print("{d} ns ({s})", .{ @as(f64, @floatFromInt(delay.delay)) / 1000, delay.name });
                    try end_details(writer);
                }
                for (pre_setup_path.critical_path) |delay| {
                    try begin_details(writer, .{});
                    try writer.print("-{d} ns ({s})", .{ @as(f64, @floatFromInt(delay.delay)) / 1000, delay.name });
                    try end_details(writer);
                }
                try end_cell(writer);

                try end_row(writer);
            }
        } else |_| {}
    }
}

////////////////////////////////////////////////////

const Section_Options = struct {
    tier: usize = 1,
    class: []const u8 = "",
};

fn begin_section(writer: std.io.AnyWriter, comptime fmt: []const u8, args: anytype, options: Section_Options) !void {
    if (options.class.len > 0) {
        try writer.print("<section class=\"{s}\">\n", .{ options.class });
    } else {
        try writer.writeAll("<section>\n");
    }
    try writer.print("<h{}>", .{ options.tier });
    try writer.print(fmt, args);
    try writer.print("</h{}>\n<div>\n", .{ options.tier });
}

fn begin_glb_section(writer: std.io.AnyWriter, glb: usize, name: []const u8) !void {
    try begin_section(writer, "GLB {} ({s})", .{ glb, name }, .{ .tier = 3, .class = "inline" });
}

fn end_section(writer: std.io.AnyWriter) !void {
    try writer.writeAll("</div>\n</section>\n");
}

fn write_summary_line(writer: std.io.AnyWriter, label: []const u8, numerator: usize, denominator: usize) !void {
    try writer.writeAll("<tr>");
    try writer.print("<th>{s}</th>", .{ label });
    try writer.print("<td>{} / {}</td>", .{ numerator, denominator });
    try writer.writeAll("</tr>\n");
}


fn begin_table(writer: std.io.AnyWriter) !void {
    try writer.writeAll("<table>\n");
}

fn table_header(writer: std.io.AnyWriter, columns: anytype) !void {
    const ColumnsType = @TypeOf(columns);
    const columns_info = @typeInfo(ColumnsType).@"struct";

    try writer.writeAll("<tr class=\"header\">");

    if (columns_info.is_tuple) {
        inline for (columns) |col| {
            try writer.print("<th>{s}</th>", .{ col });
        }
    } else {
        inline for (columns_info.fields) |field| {
            const colspan: usize = @field(columns, field.name);
            if (colspan > 1) {
                try writer.print("<th colspan=\"{}\">{s}</th>", .{ colspan, field.name });
            } else {
                try writer.print("<th>{s}</th>", .{ field.name });
            }
        }
    }

    try writer.writeAll("</tr>\n");
}

const Row_Options = struct {
    highlight: bool = false,
    class: []const u8 = "",
    hover_selector: []const u8 = "",
};

fn begin_row(writer: std.io.AnyWriter, options: Row_Options) !void {
    try writer.writeAll("<tr");
    if (options.highlight or options.class.len > 0) {
        try writer.writeAll(" class=\"");
        if (options.highlight) {
            try writer.writeAll("highlight");
            if (options.class.len > 0) {
                try writer.print(" {s}", .{ options.class });
            }
        } else {
            try writer.print("{s}", .{ options.class });
        }
        try writer.writeAll("\"");
    }
    if (options.hover_selector.len > 0) {
        try writer.print(" data-hover=\"{s}\"", .{ options.hover_selector });
    }
    try writer.writeAll(">\n");
}

fn end_row(writer: std.io.AnyWriter) !void {
    try writer.writeAll("</tr>\n");
}

const Cell_Options = struct {
    class: []const u8 = "",
    additional_classes: []const []const u8 = &.{},
    hover_selector: []const u8 = "",
};

fn begin_cell(writer: std.io.AnyWriter, options: Cell_Options) !void {
    try writer.writeAll("<td");
    if (options.class.len > 0 or options.additional_classes.len > 0) {
        try writer.print(" class=\"{s}", .{ options.class });
        for (options.additional_classes) |class| {
            try writer.writeByte(' ');
            try writer.writeAll(class);
        }
        try writer.writeByte('"');
    }
    if (options.hover_selector.len > 0) {
        try writer.print(" data-hover=\"{s}\"", .{ options.hover_selector });
    }
    try writer.writeAll(">");
}

fn end_cell(writer: std.io.AnyWriter) !void {
    try writer.writeAll("</td>");
}

fn end_table(writer: std.io.AnyWriter) !void {
    try writer.writeAll("</table>\n");
}

const Details_Options = struct {
    class: []const u8 = "",
    hover_selector: []const u8 = "",
};
fn begin_details(writer: std.io.AnyWriter, options: Details_Options) !void {
    try writer.writeAll("<div class=\"details");
    if (options.class.len > 0) {
        try writer.print(" {s}", .{ options.class });
    }
    try writer.writeAll("\"");
    if (options.hover_selector.len > 0) {
        try writer.print(" data-hover=\"{s}\"", .{ options.hover_selector });
    }
    try writer.writeAll(">");
}

fn end_details(writer: std.io.AnyWriter) !void {
    try writer.writeAll("</div>\n");
}

const MC_Ref = lc4k.MC_Ref;
const JEDEC_File = @import("JEDEC_File.zig");
const JEDEC_Data = @import("JEDEC_Data.zig");
const naming = @import("naming.zig");
const timing = @import("timing.zig");
const assembly = @import("assembly.zig");
const disassembly = @import("disassembly.zig");
const routing = @import("routing.zig");
const fuses = @import("fuses.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
