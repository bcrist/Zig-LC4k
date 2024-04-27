const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");
const fuses = @import("fuses.zig");
const assembly = @import("assembly.zig");
const internal = @import("internal.zig");
const routing = @import("routing.zig");
const disassembly = @import("disassembly.zig");

const Jedec_File = jedec.Jedec_File;
const JedecData = jedec.JedecData;
const MC_Ref = lc4k.MC_Ref;
const get_glb_name = lc4k.get_glb_name;

pub fn Write_Options(comptime Device: type) type {
    return struct {
        design_name: []const u8 = "",
        design_version: []const u8 = "",
        notes: []const u8 = "",
        assembly_errors: []const assembly.AssemblyError = &[_]assembly.AssemblyError{},
        macrocellNameMapper: *const fn(lc4k.MC_Ref) []const u8 = defaultMacrocellNameMapper(Device),
        signalNameMapper: *const fn(Device.GRP) []const u8 = defaultSignalNameMapper(Device.GRP),
    };
}

pub fn defaultMacrocellNameMapper(comptime Device: type) fn(lc4k.MC_Ref) []const u8 {
    return struct {
        pub fn func(mcref: lc4k.MC_Ref) []const u8 {
            return @tagName(Device.mc_signals[mcref.glb][mcref.mc])[3..];
        }
    }.func;
}

// TODO move this to lc4k.Device, call it getSignalName, and have it take a context type which it will search for decls
pub fn defaultSignalNameMapper(comptime GRP: type) fn(GRP) []const u8 {
    return struct {
        pub fn func(grp: GRP) []const u8 {
            return @tagName(grp);
        }
    }.func;
}

const PTUsage = enum {
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

fn ReportData(comptime Device: type) type {
    const GRP = Device.GRP;

    const GlbReportData = struct {
        const num_pts = Device.num_mcs_per_glb * 5 + 3;

        gi_routing: [Device.num_gis_per_glb]?GRP,
        sum_routing: routing.RoutingData,
        pts: [num_pts]lc4k.PT(GRP),
        pt_usage: [num_pts]PTUsage,
        uses_bie: bool,
    };

    const shared_init_pt = Device.num_mcs_per_glb * 5 + 0;
    const shared_clock_pt = Device.num_mcs_per_glb * 5 + 1;
    const shared_enable_pt = Device.num_mcs_per_glb * 5 + 2;

    return struct {
        jed: JedecData,
        config: lc4k.LC4k(Device.device_type),
        disassembly_errors: std.ArrayList(disassembly.DisassemblyError),

        mc_pin_info: std.AutoHashMap(lc4k.MC_Ref, lc4k.Pin_Info),

        glb: [Device.num_glbs]GlbReportData = undefined,

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

        pub fn init(alloc: std.mem.Allocator, file: Jedec_File) !Self {
            std.debug.assert(file.data.extents.eql(Device.jedec_dimensions));

            const dis = try disassembly.disassemble(Device, alloc, file);

            var self = Self {
                .jed = file.data,
                .config = dis.config,
                .disassembly_errors = dis.errors,
                .mc_pin_info = std.AutoHashMap(lc4k.MC_Ref, lc4k.Pin_Info).init(alloc),
            };

            for (Device.all_pins) |pin_info| {
                switch (pin_info.func) {
                    .io, .io_oe0, .io_oe1 => |mc| {
                        try self.mc_pin_info.put(lc4k.MC_Ref.init(pin_info.glb.?, mc), pin_info);
                    },
                    else => {},
                }
            }

            var mcs_used = std.EnumSet(GRP) {};
            var ios_used = std.EnumSet(GRP) {};
            var inputs_used = std.EnumSet(GRP) {};
            var clocks_used = std.EnumSet(GRP) {};
            inline for (dis.config.glb, 0..) |glb_config, glb| {
                var glb_data = GlbReportData {
                    .gi_routing = dis.gi_routing[glb],
                    .sum_routing = dis.sum_routing[glb],
                    .pts = undefined,
                    .pt_usage = undefined,
                    .uses_bie = false,
                };

                for (dis.gi_routing[glb]) |maybe_grp| {
                    if (maybe_grp) |grp| {
                        self.num_gis_used += 1;
                        if (std.mem.startsWith(u8, @tagName(grp), "io_")) {
                            ios_used.insert(grp);
                        } else if (std.mem.startsWith(u8, @tagName(grp), "mc_")) {
                            mcs_used.insert(grp);
                        } else if (std.mem.startsWith(u8, @tagName(grp), "clk")) {
                            clocks_used.insert(grp);
                        } else if (std.mem.startsWith(u8, @tagName(grp), "in")) {
                            inputs_used.insert(grp);
                        }
                    }
                }

                glb_data.pts[shared_init_pt] = try disassembly.parsePTFuses(Device, alloc, glb, shared_init_pt, &glb_data.gi_routing, self.jed, null);
                glb_data.pts[shared_clock_pt] = try disassembly.parsePTFuses(Device, alloc, glb, shared_clock_pt, &glb_data.gi_routing, self.jed, null);
                glb_data.pts[shared_enable_pt] = try disassembly.parsePTFuses(Device, alloc, glb, shared_enable_pt, &glb_data.gi_routing, self.jed, null);

                glb_data.pt_usage[shared_init_pt] = .none;
                glb_data.pt_usage[shared_clock_pt] = .none;
                glb_data.pt_usage[shared_enable_pt] = .none;

                inline for (glb_config.mc, 0..) |mc_config, mc| {
                    const mcref = lc4k.MC_Ref.init(glb, mc);

                    const glb_pt_base = mc * 5;
                    var pt_offset: usize = 0;
                    while (pt_offset < 5) : (pt_offset += 1) {
                        const glb_pt_offset = glb_pt_base + pt_offset;
                        const pt = try disassembly.parsePTFuses(Device, alloc, glb, glb_pt_offset, &glb_data.gi_routing, self.jed, null);
                        glb_data.pts[glb_pt_offset] = pt;
                        glb_data.pt_usage[glb_pt_offset] = .sum;
                        if (@TypeOf(mc_config.output) == lc4k.Output_Config(Device.GRP)) {
                            switch (mc_config.output.routing) {
                                .same_as_oe, .self => {},
                                .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => {
                                    glb_data.pt_usage[glb_pt_offset] = .fast;
                                },
                            }
                        }
                    }

                    if (mc_config.func != .combinational) {
                        self.num_registers_used += 1;
                        mcs_used.insert(Device.mc_signals[mcref.glb][mcref.mc]);
                    }

                    if (mc_config.output.oe != .input_only) {
                        if (Device.mc_output_signals[mcref.glb][mcref.mc]) |grp| {
                            ios_used.insert(grp);
                        }

                        const output_routing = if (@TypeOf(mc_config.output) == lc4k.Output_Config_ZE)
                            mc_config.output.routing
                        else
                            mc_config.output.oe_routing;

                        const src_mcref = lc4k.MC_Ref.init(glb, output_routing.absolute);
                        mcs_used.insert(Device.mc_signals[src_mcref.glb][src_mcref.mc]);
                    }

                    switch (mc_config.logic) {
                        .sum, .sum_inverted, .input_buffer => {},
                        .pt0, .pt0_inverted, .sum_xor_pt0, .sum_xor_pt0_inverted => {
                            glb_data.pt_usage[mc * 5] = .xor;
                        },
                    }

                    switch (mc_config.func) {
                        .combinational => {},
                        .latch, .t_ff, .d_ff => |reg_config| {
                            switch (reg_config.clock) {
                                .none, .bclock => {},
                                .shared_pt_clock => {
                                    glb_data.pt_usage[shared_clock_pt] = switch (glb_data.pt_usage[shared_clock_pt]) {
                                        .ce => .clock_and_ce,
                                        else => .clock,
                                    };
                                },
                                .pt1_positive, .pt1_negative => {
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
                                .pt2_active_low, .pt2_active_high => {
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

                parseGoePtUsage(dis.config.goe0, glb, &glb_data);
                parseGoePtUsage(dis.config.goe1, glb, &glb_data);
                parseGoePtUsage(dis.config.goe2, glb, &glb_data);
                parseGoePtUsage(dis.config.goe3, glb, &glb_data);

                inline for (glb_config.mc, 0..) |_, mc| {
                    const glb_pt_base = mc * 5;
                    var cluster_used = false;
                    var pt_offset: usize = 0;
                    while (pt_offset < 5) : (pt_offset += 1) {
                        const glb_pt_offset = glb_pt_base + pt_offset;
                        switch (glb_data.pt_usage[glb_pt_offset]) {
                            .none => {},
                            .sum => {
                                if (!internal.isAlways(glb_data.pts[glb_pt_offset]) and
                                    !internal.isNever(glb_data.pts[glb_pt_offset])
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

            for (Device.all_pins) |pin_info| {
                switch (pin_info.func) {
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

            return self;
        }

        fn parseGoePtUsage(goe_config: anytype, glb: usize, glb_data: *GlbReportData) void {
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

pub fn write(comptime Device: type, file: Jedec_File, writer: anytype, options: Write_Options(Device)) !void {
    var temp = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer temp.deinit();
    const alloc = temp.allocator();

    const data = try ReportData(Device).init(alloc, file);

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

    try beginSection(writer, "Design Summary", .{}, .{});
    try writer.writeAll("<table>\n");

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
    if (options.notes.len > 0) {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Notes</th>");
        try writer.print("<td>{s}</td>", .{ options.notes });
        try writer.writeAll("</tr>\n");
    }

    try writer.writeAll("<tr>");
    try writer.writeAll("<th>Device</th>");
    try writer.print("<td>{s}</td>", .{ @tagName(Device.device_type) });
    try writer.writeAll("</tr>\n");

    if (file.usercode) |usercode| {
        try writer.writeAll("<tr>");
        try writer.writeAll("<th>Usercode</th>");
        try writer.print("<td>0x{X:0>8}</td>", .{ usercode });
        try writer.writeAll("</tr>\n");
    }

    try writeSummaryLine(writer, "I/Os Used", data.num_ios_used, data.num_ios);
    if (Device.input_pins.len > 0) {
        try writeSummaryLine(writer, "Inputs Used", data.num_inputs_used, Device.input_pins.len);
    }
    try writeSummaryLine(writer, "Clocks Used", data.num_clocks_used, 4);
    try writeSummaryLine(writer, "GIs Used", data.num_gis_used, Device.num_glbs * Device.num_gis_per_glb);
    try writeSummaryLine(writer, "PTs Used", data.num_pts_used, Device.num_glbs * (Device.num_mcs_per_glb * 5 + 3));
    try writeSummaryLine(writer, "PT Clusters Used", data.num_clusters_used, Device.num_glbs * Device.num_mcs_per_glb);
    try writeSummaryLine(writer, "Macrocells Used", data.num_mcs_used, Device.num_glbs * Device.num_mcs_per_glb);
    try writeSummaryLine(writer, "Registers Used", data.num_registers_used, Device.num_glbs * Device.num_mcs_per_glb);

    try writer.writeAll("</table>\n");
    try endSection(writer);

    if (options.assembly_errors.len > 0) {
        try beginSection(writer, "Assembly Errors", .{}, .{});
        try beginTable(writer);
        try tableHeader(writer, .{ "Error", "Details", "Context" });
        for (options.assembly_errors) |err| {
            try writer.print("<tr><td>{s}</td><td>{s}</td><td>", .{ @errorName(err.err), err.details });
            if (err.glb) |glb| {
                if (err.mc) |mc| {
                    const mc_name = options.macrocellNameMapper(lc4k.MC_Ref.init(glb, mc));
                    try writer.print("{s} ", .{ mc_name });
                } else {
                    try writer.print("GLB {s} ", .{ lc4k.get_glb_name(glb) });
                    if (err.gi) |gi| {
                        try writer.print("GI {} ", .{ gi });
                    }
                }
            }
            // if (err.fuse) |fuse| {
            //     try writer.print("({},{})", .{ fuse.row, fuse.col });
            // }
            try writer.writeAll("</td></tr>\n");
        }
        try endTable(writer);
        try endSection(writer);
    }

    if (data.disassembly_errors.items.len > 0) {
        try beginSection(writer, "Disassembly Errors", .{}, .{});
        try beginTable(writer);
        try tableHeader(writer, .{ "Error", "Details", "Context" });
        for (data.disassembly_errors.items) |err| {
            try writer.print("<tr><td>{s}</td><td>{s}</td><td>", .{ @errorName(err.err), err.details });
            if (err.glb) |glb| {
                if (err.mc) |mc| {
                    const mc_name = options.macrocellNameMapper(lc4k.MC_Ref.init(glb, mc));
                    try writer.print("{s} ", .{ mc_name });
                } else {
                    try writer.print("GLB {s} ", .{ lc4k.get_glb_name(glb) });
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
        try endTable(writer);
        try endSection(writer);
    }

    try writeGlobals(writer, Device, data, options);
    try writeInputs(writer, Device, data, options);
    try writeMacrocells(writer, Device, data, options);
    try writePTs(writer, Device, data, options);
    try writeGlbRouting(writer, Device, data, options);

    try writer.writeAll("<footer>\n");
    try writer.writeAll("Generated by <a href=\"https://github.com/bcrist/Zig-LC4k\">Zig-LC4k</a>\n");
    try writer.writeAll("</footer>\n");
    try writer.writeAll("<script>\n//<!--\n");
    try writer.writeAll(@embedFile("report.js"));
    try writer.writeAll("//--></script>\n");
    try writer.writeAll("</body>\n");
    try writer.writeAll("</html>\n");
}

fn writeGlobals(writer: anytype, comptime Device: type, data: ReportData(Device), options: Write_Options(Device)) !void {
    try beginSection(writer, "Global Resources", .{}, .{});

    try beginSection(writer, "Global Output Enables", .{}, .{ .tier = 3, .class = "inline" });
    try beginTable(writer);

    try tableHeader(writer, .{ "GOE", "Equation" });

    try writeGOE(writer, Device, false, 0, data.config.goe0, options);
    try writeGOE(writer, Device, true,  1, data.config.goe1, options);
    try writeGOE(writer, Device, false, 2, data.config.goe2, options);
    try writeGOE(writer, Device, true,  3, data.config.goe3, options);

    try endTable(writer);
    try endSection(writer);

    if (Device.family == .zero_power_enhanced) {
        if (data.config.ext.osctimer) |config| {
            try beginSection(writer, "Oscillator/Timer", .{}, .{ .tier = 3, .class = "inline" });
            try beginTable(writer);

            const osc_frequency = 5_000_000;

            try writer.writeAll("<tr>");
            try writer.writeAll("<th>Nominal oscillator frequency</th>");
            try writer.print("<td>{} Hz</td>", .{ osc_frequency });
            try writer.writeAll("</tr>\n");

            if (config.enable_osc_out_and_disable) {
                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Oscillator disable/output signal</th>");
                try writer.print("<td>{s}</td>", .{ options.signalNameMapper(lc4k.Oscillator_Timer_Config(Device).signals.osc_out) });
                try writer.writeAll("</tr>\n");
            }
            if (config.enable_timer_out_and_reset) {
                try writer.writeAll("<tr>");
                try writer.writeAll("<th>Timer reset/output signal</th>");
                try writer.print("<td>{s}</td>", .{ options.signalNameMapper(lc4k.Oscillator_Timer_Config(Device).signals.timer_out) });
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

            try endTable(writer);
            try endSection(writer);
        }
    }

    try endSection(writer);
}

fn writeGOE(writer: anytype, comptime Device: type, highlight: bool, goe_index: usize, goe_config: anytype, options: Write_Options(Device)) !void {
    try beginRow(writer, .{ .highlight = highlight });

    try beginCell(writer, .{});
    try writer.print("<kbd class=\"oe goe-{}\">GOE {}</kbd>", .{ goe_index, goe_index });
    try endCell(writer);

    try beginCell(writer, .{ .class = "left" });
    switch (@TypeOf(goe_config)) {
        lc4k.GOE_Config_Bus_Or_Pin => switch (goe_config.source) {
            .constant_high => try writeUnusedGOEEquation(writer, goe_config.polarity),
            .input => try writePinGOEEquation(writer, Device, goe_config.polarity, Device.oe_pins[goe_index], options),
            .glb_shared_pt_enable => |glb| try writeBusGOEEquation(writer, goe_config.polarity, glb),
        },
        lc4k.GOE_Config_Bus => switch (goe_config.source) {
            .constant_high => try writeUnusedGOEEquation(writer, goe_config.polarity),
            .glb_shared_pt_enable => |glb| try writeBusGOEEquation(writer, goe_config.polarity, glb),
        },
        lc4k.GOE_Config_Pin => {
            var oe_bus_index = goe_index;
            if (goe_index >= Device.oe_bus_size) {
                oe_bus_index -= 2;
            }
            try writePinGOEEquation(writer, Device, goe_config.polarity, Device.oe_pins[oe_bus_index], options);
        },
        else => unreachable,
    }
    try endCell(writer);

    try endRow(writer);
}

fn writeBusGOEEquation(writer: anytype, polarity: lc4k.GOE_Polarity, glb: usize) !void {
    try writer.writeAll(switch (polarity) {
        .active_high => "<abbr>",
        .active_low => "<abbr><u>",
    });

    try writer.print("glb{}_shared_oe_pt", .{ glb });

    try writer.writeAll(switch (polarity) {
        .active_high => "</abbr>",
        .active_low => "</u></abbr>",
    });
}

fn writeUnusedGOEEquation(writer: anytype, polarity: lc4k.GOE_Polarity) !void {
    try writer.writeAll(switch (polarity) {
        .active_high => "<abbr>true</abbr>",
        .active_low => "<abbr>false</abbr>",
    });
}

fn writePinGOEEquation(writer: anytype, comptime Device: type, polarity: lc4k.GOE_Polarity, pin_info: lc4k.Pin_Info, options: Write_Options(Device)) !void {
    try writer.writeAll(switch (polarity) {
        .active_high => "<abbr>",
        .active_low => "<abbr><u>",
    });

    try writer.writeAll(options.signalNameMapper(@enumFromInt(pin_info.grp_ordinal.?)));

    try writer.writeAll(switch (polarity) {
        .active_high => "</abbr>",
        .active_low => "</u></abbr>",
    });
}

fn writeInputs(writer: anytype, comptime Device: type, data: ReportData(Device), options: Write_Options(Device)) !void {
    try beginSection(writer, "Clocks &amp; Dedicated Inputs", .{}, .{});

    try beginSection(writer, "Clock &amp; Input Pins", .{}, .{ .tier = 3, .class = "inline" });
    try beginTable(writer);

    if (Device.family == .zero_power_enhanced) {
        try tableHeader(writer, .{ "Pin", "Signal", "Threshold", "Term", "PG" });
    } else {
        try tableHeader(writer, .{ "Pin", "Signal", "Threshold", "Term" });
    }

    var n: usize = 0;
    for (Device.clock_pins, 0..) |pin_info, i| {
        const config = data.config.clock[i];
        switch (@TypeOf(config)) {
            lc4k.Input_Config => try writeInputPin(writer, (n & 1) == 1, Device, pin_info, config.threshold.?, data.config.default_bus_maintenance, null, options),
            lc4k.Input_Config_ZE => try writeInputPin(writer, (n & 1) == 1, Device, pin_info, config.threshold.?, config.bus_maintenance.?, config.power_guard.?, options),
            else => unreachable,
        }
        n += 1;
    }

    for (Device.input_pins, 0..) |pin_info, i| {
        const config = data.config.input[i];
        switch (@TypeOf(config)) {
            lc4k.Input_Config => try writeInputPin(writer, (n & 1) == 1, Device, pin_info, config.threshold.?, data.config.default_bus_maintenance, null, options),
            lc4k.Input_Config_ZE => try writeInputPin(writer, (n & 1) == 1, Device, pin_info, config.threshold.?, config.bus_maintenance.?, config.power_guard.?, options),
            else => unreachable,
        }
        n += 1;
    }

    try endTable(writer);
    try endSection(writer);

    for (data.config.glb, 0..) |glb_config, glb| {
        try beginGlbSection(writer, glb);
        try beginTable(writer);

        try tableHeader(writer, .{ "Block Clock", "Equation" });

        try writeBlockClock(writer, Device, false, 0, glb_config.bclock0, options);
        try writeBlockClock(writer, Device, true,  1, glb_config.bclock1, options);
        try writeBlockClock(writer, Device, false, 2, glb_config.bclock2, options);
        try writeBlockClock(writer, Device, true,  3, glb_config.bclock3, options);

        try endTable(writer);
        try endSection(writer);
    }

    try endSection(writer);
}

fn writeBlockClock(writer: anytype, comptime Device: type, highlight: bool, bclk_index: usize, value: anytype, options: Write_Options(Device)) !void {
    try beginRow(writer, .{ .highlight = highlight });

    try beginCell(writer, .{});
    try writer.print("<kbd class=\"clk bclk{}\">BCLK {}</kbd>", .{ bclk_index, bclk_index });
    try endCell(writer);

    try beginCell(writer, .{ .class = "left" });
    const name = comptime @tagName(value);
    const grp: Device.GRP = switch (name[3]) {
        '0' => .clk0,
        '1' => .clk1,
        '2' => .clk2,
        '3' => .clk3,
        else => unreachable,
    };
    if (std.mem.endsWith(u8, name, "_neg")) {
        try writer.print("<abbr><u>{s}</u></abbr>", .{ options.signalNameMapper(grp) });
    } else {
        try writer.print("<abbr>{s}</abbr>", .{ options.signalNameMapper(grp) });
    }
    try endCell(writer);

    try endRow(writer);
}

fn writeInputPin(writer: anytype, highlight: bool, comptime Device: type, pin_info: lc4k.Pin_Info,
    threshold: lc4k.Input_Threshold,
    bus_maintenance: lc4k.Bus_Maintenance,
    power_guard: ?lc4k.Power_Guard,
    options: Write_Options(Device),
) !void {
    try beginRow(writer, .{
        .highlight = highlight,
    });

    try beginCell(writer, .{});
    try writer.writeAll(pin_info.id);
    try endCell(writer);

    try beginCell(writer, .{});
    if (pin_info.grp_ordinal) |grp_ordinal| {
        try writer.writeAll(options.signalNameMapper(@enumFromInt(grp_ordinal)));
    }
    try endCell(writer);

    try beginCell(writer, .{});
    try writeInput_Threshold(writer, Device, threshold);
    try endCell(writer);

    try beginCell(writer, .{});
    try writeBus_Maintenance(writer, bus_maintenance);
    try endCell(writer);

    if (Device.family == .zero_power_enhanced) {
        try beginCell(writer, .{});
        if (power_guard) |pg| {
            try writePower_Guard(writer, pg);
        }
        try endCell(writer);
    }

    try endRow(writer);
}

fn writeInput_Threshold(writer: anytype, comptime Device: type, threshold: lc4k.Input_Threshold) !void {
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

fn writeBus_Maintenance(writer: anytype, maint: lc4k.Bus_Maintenance) !void {
    try writer.writeAll(switch (maint) {
        .pulldown => "<kbd class=\"maintenance pulldown\">Pulldown</kbd>",
        .float => "<kbd class=\"maintenance float\">Float</kbd>",
        .keeper => "<kbd class=\"maintenance keeper\">Keeper</kbd>",
        .pullup => "<kbd class=\"maintenance pullup\">Pullup</kbd>",
    });
}

fn writePower_Guard(writer: anytype, pg: lc4k.Power_Guard) !void {
    try writer.writeAll(switch (pg) {
        .from_bie => "<kbd class=\"power-guard enabled\">Enabled</kbd>",
        .disabled => "<kbd class=\"power-guard disabled\">Disabled</kbd>",
    });
}

fn writePTs(writer: anytype, comptime Device: type, data: ReportData(Device), options: Write_Options(Device)) !void {
    try beginSection(writer, "Product Terms", .{}, .{});
    for (data.glb, 0..) |glb_data, glb| {
        try beginGlbSection(writer, glb);
        try beginTable(writer);
        try tableHeader(writer, .{ "MC", "PT", "Usage", "Equation" });

        var mc: usize = 0;
        while (mc < Device.num_mcs_per_glb) : (mc += 1) {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            var pt_index: usize = 0;
            while (pt_index < 5) : (pt_index += 1) {
                try beginRow(writer, .{ .highlight = (mc & 1) == 1 });

                if (pt_index == 0) {
                    try writer.print("<td rowspan=\"5\">{s}</td>", .{ options.macrocellNameMapper(mcref) });
                }

                try writer.print("<td>{}</td>", .{ pt_index });
                const glb_pt_offset = mc * 5 + pt_index;

                try writer.writeAll("<td>");
                try writePTUsage(writer, glb_data.pt_usage[glb_pt_offset]);
                try writer.writeAll("</td>");

                try writePTEquation(writer, Device, glb_data.pts[glb_pt_offset], options);
                try endRow(writer);
            }
        }

        try beginRow(writer, .{});
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 });
        try writePTUsage(writer, glb_data.pt_usage[mc * 5]);
        try writer.writeAll("</td>");
        try writePTEquation(writer, Device, glb_data.pts[mc * 5], options);
        try endRow(writer);

        try beginRow(writer, .{ .highlight = true });
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 + 1 });
        try writePTUsage(writer, glb_data.pt_usage[mc * 5 + 1]);
        try writer.writeAll("</td>");
        try writePTEquation(writer, Device, glb_data.pts[mc * 5 + 1], options);
        try endRow(writer);

        try beginRow(writer, .{});
        try writer.print("<td></td><td>{}</td><td>", .{ mc * 5 + 2 });
        if (glb_data.uses_bie) {
            try writer.writeAll("<kbd class=\"pt-usage bie\">BIE</kbd> ");
        }
        try writePTUsage(writer, glb_data.pt_usage[mc * 5 + 2]);
        try writer.writeAll("</td>");
        try writePTEquation(writer, Device, glb_data.pts[mc * 5 + 2], options);
        try endRow(writer);

        try endTable(writer);
        try endSection(writer);
    }
    try endSection(writer);
}

fn writePTUsage(writer: anytype, usage: PTUsage) !void {
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

fn writePTEquation(writer: anytype, comptime Device: type, pt: lc4k.PT(Device.GRP), options: Write_Options(Device)) !void {
    try writer.writeAll("<td class=\"left\">");

    var first = true;
    for (pt) |factor| {
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
                try writer.print("<abbr>{s}</abbr>", .{ options.signalNameMapper(grp) });
            },
            .when_low => |grp| {
                try writer.print("<abbr><u>{s}</u></abbr>", .{ options.signalNameMapper(grp) });
            },
        }
    }

    if (first) {
        try writer.writeAll("<abbr>true</abbr>");
    }

    try writer.writeAll("</td>");
}

fn writeGlbRouting(writer: anytype, comptime Device: type, data: ReportData(Device), options: Write_Options(Device)) !void {
    try beginSection(writer, "GI Routing", .{}, .{});
    for (data.config.glb, 0..) |_, glb| {
        try beginGlbSection(writer, glb);
        try beginTable(writer);
        try tableHeader(writer, .{
            .GI = 1,
            .Fuses = Device.gi_mux_size,
            .Signal = 1,
            .Fanout = 1,
        });

        for (Device.gi_options, 0..) |gi_options, gi| {
            const fuse_range = Device.getGiRange(glb, gi);
            var fuse_iter = fuse_range.iterator();
            var active: ?Device.GRP = null;
            try beginRow(writer, .{ .highlight = (gi & 1) == 1 });

            try writer.print("<td>{}</td>", .{ gi });
            for (gi_options) |grp| {
                const fuse = fuse_iter.next().?;
                var mark: []const u8 = "";
                if (data.jed.get(fuse) == 0) {
                    mark = "&#9679;";
                    active = grp;
                }
                try writer.print("<td class=\"fuse\" title=\"{s}\">{s}</td>", .{ options.signalNameMapper(grp), mark });
            }

            if (active) |grp| {
                var fanout: usize = 0;
                const pt_range = Device.getGlbRange(glb).subRows(gi * 2, 2);
                var col: usize = 0;
                while (col < pt_range.width()) : (col += 1) {
                    if (data.jed.countUnsetInRange(pt_range.subColumns(col, 1)) == 1) {
                        fanout += 1;
                    }
                }
                try writer.print("<td>{s}</td><td>{}</td>", .{ options.signalNameMapper(grp), fanout });
            } else {
                try writer.writeAll("<td></td><td></td>");
            }

            try endRow(writer);
        }

        try endTable(writer);
        try endSection(writer);
    }
    try endSection(writer);
}

fn writeMacrocells(writer: anytype, comptime Device: type, data: ReportData(Device), options: Write_Options(Device)) !void {
    try beginSection(writer, "Macrocells", .{}, .{});

    for (data.config.glb, 0..) |glb_config, glb| {
        try beginGlbSection(writer, glb);
        try writer.writeAll("<div class=\"hover-root\">\n");
        try beginTable(writer);
        if (Device.family == .zero_power_enhanced) {
            try tableHeader(writer, .{
                .@"&nbsp;" = 1,
                .Target = 1,
                .Sum = 1,
                .Macrocell = 6,
                .@"&nbsp; " = 1,
                .Output = 4,
                .Input = 3,
            });
            try tableHeader(writer, .{
                "MC", "Cluster", "PTs",
                "Logic", "Type", "Clock", "CE", "Init", "Async",
                "Pin",
                "From", "OE", "Slew", "Drive",
                "Threshold", "Term",
                "PG", 
            });
        } else {
            try tableHeader(writer, .{
                .@"&nbsp;" = 1,
                .Target = 1,
                .Sum = 1,
                .Macrocell = 6,
                .@"&nbsp; " = 1,
                .Output = 4,
                .Input = 2,
            });
            try tableHeader(writer, .{
                "MC", "Cluster", "PTs",
                "Logic", "Type", "Clock", "CE", "Init", "Async",
                "Pin",
                "From", "OE", "Slew", "Drive",
                "Threshold", "Term",
            });
        }

        for (glb_config.mc, 0..) |mc_config, mc| {
            const mcref = lc4k.MC_Ref.init(glb, mc);

            var ca_jumps: usize = 0;
            var dest: ?usize = null;
            if (routing.getCAForCluster(mc, data.glb[glb].sum_routing.cluster[mc])) |initial_ca| {
                var ca = routing.getCADestination(initial_ca, data.glb[glb].sum_routing.wide[initial_ca]);
                while (ca != initial_ca) {
                    ca_jumps += 1;
                    const dest_ca = routing.getCADestination(ca, data.glb[glb].sum_routing.wide[ca]);
                    if (dest_ca == ca) break;
                    ca = dest_ca;
                }
                dest = ca;
            }

            try beginRow(writer, .{
                .highlight = (mc & 1) == 1,
            });

            var temp_buf: [64]u8 = undefined;
            const mc_class = try std.fmt.bufPrint(&temp_buf, ".mc-{}", .{ mc });
            const cell_options = CellOptions {
                .class = mc_class[1..],
                .hover_selector = mc_class,
            };

            try beginCell(writer, cell_options);
            try writer.writeAll(options.macrocellNameMapper(mcref));
            try endCell(writer);

            if (dest) |ca| {
                var temp_buf_2: [64]u8 = undefined;
                var temp_buf_3: [64]u8 = undefined;
                const ca_selector = try std.fmt.bufPrint(&temp_buf_2, ".mc-{}", .{ ca });
                const ca_class = try std.fmt.bufPrint(&temp_buf_3, "ca-depth-{} mc-{}", .{ ca_jumps, ca });
                try beginCell(writer, .{
                    .class = ca_class,
                    .hover_selector = ca_selector,
                });
                try writer.writeAll(options.macrocellNameMapper(lc4k.MC_Ref.init(glb, ca)));
            } else {
                try beginCell(writer, .{});
            }
            try endCell(writer);

            var sum_pts: usize = 0;
            switch (mc_config.logic) {
                .sum, .sum_inverted => |sum| for (sum) |pt| {
                    if (!internal.isAlways(pt)) sum_pts += 1;
                },
                .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| for (logic.sum) |pt| {
                    if (!internal.isAlways(pt)) sum_pts += 1;
                },
                .input_buffer, .pt0, .pt0_inverted => {},
            }

            if (@TypeOf(mc_config.output) != lc4k.Output_Config_ZE) {
                switch (mc_config.output.routing) {
                    .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => |pts| {
                        for (pts) |pt| {
                            if (!internal.isAlways(pt)) sum_pts += 1;
                        }
                    },
                    .same_as_oe, .self => {},
                }
            }
            try beginCell(writer, cell_options);
            try writer.print("{}", .{ sum_pts });
            try endCell(writer);

            try beginCell(writer, cell_options);
            try writer.writeAll(switch (mc_config.logic) {
                .sum          => "<kbd class=\"logic sum\">Sum</kbd>",
                .sum_inverted => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic invert\">Invert</kbd>",
                .input_buffer => "<kbd class=\"logic input\">Input</kbd>",
                .pt0          => "<kbd class=\"logic pt\">PT</kbd>",
                .pt0_inverted => "<kbd class=\"logic pt\">PT</kbd> <kbd class=\"logic invert\">Invert</kbd>",
                .sum_xor_pt0  => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic xor-pt\">XOR PT</kbd>",
                .sum_xor_pt0_inverted => "<kbd class=\"logic sum\">Sum</kbd> <kbd class=\"logic xor-pt\">XOR PT</kbd> <kbd class=\"logic invert\">Invert</kbd>",
            });
            try endCell(writer);

            try beginCell(writer, cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "<kbd class=\"func comb\">Comb</kbd>",
                .latch => "<kbd class=\"func latch\">Latch</kbd>",
                .t_ff => "<kbd class=\"func tff\">T FF</kbd>",
                .d_ff => "<kbd class=\"func dff\">D FF</kbd>",
            });
            try endCell(writer);

            try beginCell(writer, cell_options);
            const clock_invert: ?bool = switch (mc_config.func) {
                .combinational => null,
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.clock) {
                    .none => null,
                    .shared_pt_clock => blk: {
                        try writer.writeAll("<kbd class=\"clk shared-pt\">Shared PT</kbd>");
                        break :blk switch (glb_config.shared_pt_clock) {
                            .positive => false,
                            .negative => true,
                        };
                    },
                    .pt1_positive => blk: {
                        try writer.writeAll("<kbd class=\"clk pt\">PT</kbd>");
                        break :blk false;
                    },
                    .pt1_negative => blk: {
                        try writer.writeAll("<kbd class=\"clk pt\">PT</kbd>");
                        break :blk true;
                    },
                    .bclock => |bclk| blk: {
                        try writer.print("<kbd class=\"clk bclk{}\">BCLK {}</kbd>", .{ bclk, bclk });
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
            try endCell(writer);

            try beginCell(writer, cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "",
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.ce) {
                    .pt2_active_high => "<kbd class=\"ce pt\">PT</kbd> <kbd class=\"ce pos\">Active High</kbd>",
                    .pt2_active_low => "<kbd class=\"ce pt\">PT</kbd> <kbd class=\"ce neg\">Active Low</kbd>",
                    .shared_pt_clock => switch (glb_config.shared_pt_clock) {
                        .positive => "<kbd class=\"ce shared-pt\">Shared PT</kbd> <kbd class=\"ce pos\">Active High</kbd>",
                        .negative => "<kbd class=\"ce shared-pt\">Shared PT</kbd> <kbd class=\"ce neg\">Active Low</kbd>",
                    },
                    .always_active => "",
                },
            });
            try endCell(writer);

            try beginCell(writer, cell_options);
            switch (mc_config.func) {
                .combinational => {},
                .latch, .t_ff, .d_ff => |reg_config| {
                    try writer.print("{}", .{ reg_config.init_state });
                    try writer.writeAll(switch (reg_config.init_source) {
                        .pt3_active_high => " <kbd class=\"init pt\">PT</kbd> <kbd class=\"init pos\">Active High</kbd>",
                        .shared_pt_init => switch (glb_config.shared_pt_init) {
                            .active_high => " <kbd class=\"init shared-pt\">Shared PT</kbd> <kbd class=\"init pos\">Active High</kbd>",
                            .active_low => " <kbd class=\"init shared-pt\">Shared PT</kbd> <kbd class=\"init neg\">Active Low</kbd>",
                        },
                    });
                },
            }
            try endCell(writer);

            try beginCell(writer, cell_options);
            try writer.writeAll(switch (mc_config.func) {
                .combinational => "",
                .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.async_source) {
                    .none => "",
                    .pt2_active_high => "<kbd class=\"async pt\">PT</kbd> <kbd class=\"async pos\">Active High</kbd>",
                },
            });
            try endCell(writer);

            if (data.mc_pin_info.get(mcref)) |pin_info| {
                try beginCell(writer, cell_options);
                try writer.writeAll(pin_info.id);
            } else {
                try beginCell(writer, .{});
            }
            try endCell(writer);


            var out_mcref = mcref;
            var out_options = cell_options;
            var out_mc_delta: usize = 0;
            var out_from_extra: []const u8 = "";
            var temp_out_buf: [64]u8 = undefined;

            var oe_mcref = mcref;
            var oe_options = cell_options;
            var oe_mc_delta: usize = 0;
            var temp_oe_buf: [64]u8 = undefined;

            if (@TypeOf(mc_config.output) == lc4k.Output_Config_ZE) {
                const abs_output_mc = mc_config.output.routing.absolute;
                out_mcref = lc4k.MC_Ref.init(glb, abs_output_mc);
                out_mc_delta = if (abs_output_mc < mc)
                    abs_output_mc + Device.num_mcs_per_glb - mc
                else
                    abs_output_mc - mc
                ;

                const out_mc_class = try std.fmt.bufPrint(&temp_out_buf, ".mc-{}", .{ abs_output_mc });
                out_options = CellOptions {
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
                const abs_oe_mc = mc_config.output.oe_routing.absolute;
                oe_mcref = lc4k.MC_Ref.init(glb, abs_oe_mc);
                oe_mc_delta = if (abs_oe_mc < mc)
                    abs_oe_mc + Device.num_mcs_per_glb - mc
                else
                    abs_oe_mc - mc
                ;

                const oe_mc_class = try std.fmt.bufPrint(&temp_oe_buf, ".mc-{}", .{ abs_oe_mc });
                oe_options = CellOptions {
                    .class = oe_mc_class[1..],
                    .hover_selector = oe_mc_class,
                };

                switch (mc_config.output.routing) {
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

            try beginCell(writer, out_options);
            if (mc_config.output.oe != .input_only) {
                if (out_mc_delta != 0) {
                    try writer.print("<kbd class=\"out routing\">+{}</kbd> ", .{ out_mc_delta });
                }
                try writer.writeAll(options.macrocellNameMapper(out_mcref));
            }
            try writer.writeAll(out_from_extra);
            try endCell(writer);

            try beginCell(writer, oe_options);
            switch (mc_config.output.oe) {
                .goe0 => try writer.writeAll("<kbd class=\"oe goe0\">GOE 0</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                .goe1 => try writer.writeAll("<kbd class=\"oe goe1\">GOE 1</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                .goe2 => try writer.writeAll("<kbd class=\"oe goe2\">GOE 2</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                .goe3 => try writer.writeAll("<kbd class=\"oe goe3\">GOE 3</kbd> <kbd class=\"oe pos\">Active High</kbd>"),
                .from_orm_active_high => {
                    if (oe_mc_delta != 0) {
                        try writer.print("<kbd class=\"oe routing\">+{}</kbd> ", .{ oe_mc_delta });
                    }
                    try writer.writeAll(options.macrocellNameMapper(oe_mcref));
                    try writer.writeAll(" <kbd class=\"oe from-orm\">PT</kbd> <kbd class=\"oe pos\">Active High</kbd>");
                },
                .from_orm_active_low => {
                    if (oe_mc_delta != 0) {
                        try writer.print("<kbd class=\"oe routing\">+{}</kbd> ", .{ oe_mc_delta });
                    }
                    try writer.writeAll(options.macrocellNameMapper(oe_mcref));
                    try writer.writeAll(" <kbd class=\"oe from-orm\">PT</kbd> <kbd class=\"oe neg\">Active Low</kbd>");
                },
                .output_only => try writer.writeAll("<kbd class=\"oe output-only\">Output</kbd>"),
                .input_only => try writer.writeAll("<kbd class=\"oe input-only\">Input</kbd>"),
            }
            try endCell(writer);

            try beginCell(writer, out_options);
            if (mc_config.output.oe != .input_only) {
                try writer.writeAll(switch (mc_config.output.slew_rate.?) {
                    .slow => "<kbd class=\"slew slow\">Slow</kbd>",
                    .fast => "<kbd class=\"slew fast\">Fast</kbd>",
                });
            }
            try endCell(writer);

            try beginCell(writer, out_options);
            if (mc_config.output.oe != .input_only) {
                try writer.writeAll(switch (mc_config.output.drive_type.?) {
                    .push_pull => "<kbd class=\"drive push-pull\">TP</kbd>",
                    .open_drain => "<kbd class=\"drive open-drain\">OD</kbd>",
                });
            }
            try endCell(writer);

            try beginCell(writer, cell_options);
            if (mc_config.output.oe != .output_only) {
                try writeInput_Threshold(writer, Device, mc_config.input.threshold.?);
            }
            try endCell(writer);

            if (@TypeOf(mc_config.input) == lc4k.Input_Config_ZE) {
                try beginCell(writer, cell_options);
                if (mc_config.output.oe != .output_only) {
                    try writeBus_Maintenance(writer, mc_config.input.bus_maintenance.?);
                }
                try endCell(writer);

                try beginCell(writer, cell_options);
                try writePower_Guard(writer, mc_config.input.power_guard.?);
                try endCell(writer);
            } else {
                try beginCell(writer, cell_options);
                if (mc_config.output.oe != .output_only) {
                    try writeBus_Maintenance(writer, data.config.default_bus_maintenance);
                }
                try endCell(writer);
            }

            try endRow(writer);
        }

        try endTable(writer);
        try writer.writeAll("</div>\n");
        try endSection(writer);
    }
    try endSection(writer);
}



////////////////////////////////////////////////////

const SectionOptions = struct {
    tier: usize = 1,
    class: []const u8 = "",
};

fn beginSection(writer: anytype, comptime fmt: []const u8, args: anytype, options: SectionOptions) !void {
    if (options.class.len > 0) {
        try writer.print("<section class=\"{s}\">\n", .{ options.class });
    } else {
        try writer.writeAll("<section>\n");
    }
    try writer.print("<h{}>", .{ options.tier });
    try writer.print(fmt, args);
    try writer.print("</h{}>\n<div>\n", .{ options.tier });
}

fn beginGlbSection(writer: anytype, glb: usize) !void {
    try beginSection(writer, "GLB {} ({s})", .{ glb, lc4k.get_glb_name(glb) }, .{ .tier = 3, .class = "inline" });
}

fn endSection(writer: anytype) !void {
    try writer.writeAll("</div>\n</section>\n");
}

fn writeSummaryLine(writer: anytype, label: []const u8, numerator: usize, denominator: usize) !void {
    try writer.writeAll("<tr>");
    try writer.print("<th>{s}</th>", .{ label });
    try writer.print("<td>{} / {}</td>", .{ numerator, denominator });
    try writer.writeAll("</tr>\n");
}


fn beginTable(writer: anytype) !void {
    try writer.writeAll("<table>\n");
}

fn tableHeader(writer: anytype, columns: anytype) !void {
    const ColumnsType = @TypeOf(columns);
    const columns_info = @typeInfo(ColumnsType).Struct;

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

const RowOptions = struct {
    highlight: bool = false,
    class: []const u8 = "",
    hover_selector: []const u8 = "",
};

fn beginRow(writer: anytype, options: RowOptions) !void {
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

fn endRow(writer: anytype) !void {
    try writer.writeAll("</tr>\n");
}

const CellOptions = struct {
    class: []const u8 = "",
    hover_selector: []const u8 = "",
};

fn beginCell(writer: anytype, options: CellOptions) !void {
    try writer.writeAll("<td");
    if (options.class.len > 0) {
        try writer.print(" class=\"{s}\"", .{ options.class });
    }
    if (options.hover_selector.len > 0) {
        try writer.print(" data-hover=\"{s}\"", .{ options.hover_selector });
    }
    try writer.writeAll(">");
}

fn endCell(writer: anytype) !void {
    try writer.writeAll("</td>");
}

fn endTable(writer: anytype) !void {
    try writer.writeAll("</table>\n");
}
