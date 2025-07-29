// Everything here is a best-effort approximation based on the timing information provided in the datasheets.
// It is very possible there may be bugs or behavioral differences compared to the official toolchain's timing model.
// As with all CMOS parts, input and output buffer timings can vary dramatically based on what the pin is connected to externally.

// TODO support ZE oscillator/timer

pub const Picoseconds = i32;

pub const Signal_Index = usize;

pub const Node = union (enum) {
    pad: Signal_Index,

    in: Signal_Index,
    oe_in: lc4k.GOE_Index,
    gclk: lc4k.Clock_Index,

    bclock0: lc4k.GLB_Index,
    bclock1: lc4k.GLB_Index,
    bclock2: lc4k.GLB_Index,
    bclock3: lc4k.GLB_Index,

    grp: Signal_Index,

    pt: lc4k.PT_Ref,
    sptoe: lc4k.GLB_Index, // a.k.a. BIE
    sptclk: lc4k.GLB_Index,
    sptinit: lc4k.GLB_Index,

    igoe0,
    igoe1,
    igoe2,
    igoe3,
    goe0,
    goe1,
    goe2,
    goe3,

    mc_cluster: lc4k.MC_Ref,
    mc_ca: lc4k.MC_Ref,
    mcd: lc4k.MC_Ref,
    mcd_setup: lc4k.MC_Ref,
    mc_clk: lc4k.MC_Ref,
    mc_clk_d_hold: lc4k.MC_Ref,
    mc_clk_ce_hold: lc4k.MC_Ref,
    mc_ce: lc4k.MC_Ref,
    mc_ce_setup: lc4k.MC_Ref,
    mc_init: lc4k.MC_Ref,
    mc_async: lc4k.MC_Ref,
    mc_oe: lc4k.MC_Ref,
    mcq: lc4k.MC_Ref,
    orm: lc4k.MC_Ref,
    
    fb: lc4k.MC_Ref,

    out: lc4k.MC_Ref,
    out_oe: lc4k.MC_Ref,
    out_en: lc4k.MC_Ref,
    out_dis: lc4k.MC_Ref,

    pub fn write_name(self: Node, writer: std.io.AnyWriter, comptime Device: type, names: *const naming.Names(Device)) !void {
        switch (self) {
            .pad, .in, .grp => |signal_index| {
                const signal: Device.Signal = @enumFromInt(signal_index);
                try writer.writeAll(names.get_signal_name(signal));
                try writer.writeByte(' ');
                try writer.writeAll(@tagName(self));
            },
            .oe_in => |oe_index| {
                try writer.print("OE {d}", .{ oe_index });
            },
            .gclk => |clock_index| {
                try writer.print("GCLK {d}", .{ clock_index });
            },
            .bclock0, .bclock1, .bclock2, .bclock3, .sptoe, .sptclk, .sptinit => |glb| {
                try writer.print("{s} {s}", .{ names.get_glb_name(glb), @tagName(self) });
            },
            .pt => |ptref| {
                try writer.print("{s} PT{}", .{ names.get_mc_name(ptref.mcref), ptref.pt });
            },
            .igoe0, .igoe1, .igoe2, .igoe3, .goe0, .goe1, .goe2, .goe3 => {
                try writer.writeAll(@tagName(self));
            },
            .mc_cluster, .mc_ca, .mcd, .mc_clk, .mc_ce, .mc_init, .mc_async,
            .mc_oe, .mcq, .orm, .fb, .out, .out_oe, .out_en, .out_dis => |mcref| {
                try writer.print("{s} {s}", .{ names.get_mc_name(mcref), @tagName(self) });
            },
            .mcd_setup => |mcref| {
                try writer.print("{s} Setup", .{ names.get_mc_name(mcref) });
            },
            .mc_ce_setup => |mcref| {
                try writer.print("{s} CE Setup", .{ names.get_mc_name(mcref) });
            },
            .mc_clk_d_hold => |mcref| {
                try writer.print("{s} Hold", .{ names.get_mc_name(mcref) });
            },
            .mc_clk_ce_hold => |mcref| {
                try writer.print("{s} CE Hold", .{ names.get_mc_name(mcref) });
            },
        }
    }
};

pub const Segment = struct {
    source: Node,
    dest: Node,
};

pub const Delay = struct {
    name: []const u8,
    segment: Segment,
    delay: Picoseconds,
};

pub const Path = struct {
    critical_path: []const Delay,
    delay: Picoseconds,

    pub const nil: Path = .{
        .critical_path = &.{},
        .delay = 0,
    };

    pub const invalid_segment_placeholder: Path = .{
        .critical_path = &.{},
        .delay = -1,
    };
};

pub fn Analyzer(comptime D: type, comptime speed_grade: comptime_int) type {
    const Timing = switch (D.family) {
        .low_power => switch (speed_grade) {
            25 => @import("timing/VBC-25.zig"),
            27 => @import("timing/VBC-27.zig"),
            30 => @import("timing/VBC-3.zig"),
            35 => @import("timing/VBC-35.zig"),
            50, 5, 6 => @import("timing/VBC-5.zig"),
            75, 7, 8 => @import("timing/VBC-75.zig"),
            100, 10 => @import("timing/VBC-10.zig"),
            else => @compileError("Invalid speed grade"),
        },
        .zero_power => switch (speed_grade) {
            35 => @import("timing/ZC-35.zig"),
            37 => @import("timing/ZC-37.zig"),
            42 => @import("timing/ZC-42.zig"),
            45 => @import("timing/ZC-45.zig"),
            50, 5, 6 => @import("timing/ZC-5.zig"),
            75, 7, 8 => @import("timing/ZC-75.zig"),
            else => @compileError("Invalid speed grade"),
        },
        .zero_power_enhanced => switch (speed_grade) {
            44 => if (D.num_glbs == 2) @import("timing/32ZE-4.zig") else @compileError("Invalid speed grade"),
            47 => if (D.num_glbs == 4) @import("timing/64ZE-4.zig") else @compileError("Invalid speed grade"),
            4 => switch (D.num_glbs) {
                2 => @import("timing/32ZE-4.zig"),
                4 => @import("timing/64ZE-4.zig"),
                else => @compileError("Invalid speed grade"),
            },
            58, 5, 6 => @import("timing/ZE-5.zig"),
            75, 7, 8 => @import("timing/ZE-75.zig"),
            else => @compileError("Invalid speed grade"),
        },
    };

    const Node_Set = std.AutoHashMap(Node, void);

    const Error = error {
        Invalid_Path,
        OutOfMemory,
    };

    return struct {
        arena: std.mem.Allocator,
        gpa: std.mem.Allocator,
        jedec: JEDEC_Data,
        cache: std.AutoHashMapUnmanaged(Segment, Path) = .{},

        const Self = @This();

        pub fn init(jedec_data: JEDEC_Data, arena: std.mem.Allocator, gpa: std.mem.Allocator) Self {
            return .{
                .arena = arena,
                .gpa = gpa,
                .jedec = jedec_data,
            };
        }

        pub fn deinit(self: *Self) void {
            self.cache.deinit(self.gpa);
        }

        pub fn get_critical_path(self: *Self, segment: Segment) Error!Path {
            if (std.meta.eql(segment.source, segment.dest)) return Path.nil;
            if (self.cache.get(segment)) |cached| {
                if (cached.critical_path.len == 0 and cached.delay != 0) return error.Invalid_Path;
                return cached;
            }

            var visited = Node_Set.init(self.gpa);
            defer visited.deinit();

            return try self.compute_and_cache_critical_path(segment.source, segment.dest, &visited);
        }
        
        fn maybe_find_critical_path(self: *Self, source: Node, dest: Node, visited: *Node_Set) Error!?Path {
            return self.find_critical_path(source, dest, visited) catch |err| switch (err) {
                error.Invalid_Path => null,
                else => err,
            };
        }

        fn find_critical_path(self: *Self, source: Node, dest: Node, visited: *Node_Set) Error!Path {
            if (std.meta.eql(source, dest)) return Path.nil;
            if (self.cache.get(.{
                .source = source,
                .dest = dest,
            })) |cached| {
                if (cached.critical_path.len == 0 and cached.delay != 0) return error.Invalid_Path;
                return cached;
            }

            return try self.compute_and_cache_critical_path(source, dest, visited);
        }

        fn compute_and_cache_critical_path(self: *Self, source: Node, dest: Node, visited: *Node_Set) Error!Path {
            const val = self.compute_critical_path(source, dest, visited) catch |err| switch (err) {
                error.Invalid_Path => Path.invalid_segment_placeholder,
                else => return err,
            };

            try self.cache.put(self.gpa, .{
                .source = source,
                .dest = dest,
            }, val);

            if (val.critical_path.len == 0 and val.delay != 0) {
                return error.Invalid_Path;
            } else {
                return val;
            }
        }

        fn compute_critical_path(self: *Self, source: Node, dest: Node, visited: *Node_Set) Error!Path {
            const gop = try visited.getOrPut(dest);
            if (gop.found_existing) {
                return error.Invalid_Path;
            } else {
                gop.key_ptr.* = dest;
            }

            switch (dest) {
                .out => |mcref| {
                    if (fuses.get_output_enable_source_range(D, mcref)) |range| {
                        if (disassembly.read_field(self.jedec, lc4k.Output_Enable_Mode, range) == .input_only) {
                            return error.Invalid_Path;
                        }
                    }
                    return try self.append_to_parent(source, .{ .orm = mcref }, dest, "tBUF", visited,
                        Timing.tBUF + self.tIOO(mcref) + self.tSLEW(mcref));
                },

                .out_en => |mcref| return try self.append_to_parent(source, .{ .out_oe = mcref }, dest, "tEN", visited,
                    Timing.tEN + self.tIOO(mcref) + self.tSLEW(mcref)),

                .out_dis => |mcref| return try self.append_to_parent(source, .{ .out_oe = mcref }, dest, "tDIS", visited,
                    Timing.tDIS + self.tIOO(mcref)),

                .out_oe => |mcref| {
                    if (fuses.get_output_enable_source_range(D, mcref)) |range| {
                        switch (disassembly.read_field(self.jedec, lc4k.Output_Enable_Mode, range)) {
                            .goe0 => return try self.clone_with_new_dest(source, .goe0, dest, visited),
                            .goe1 => return try self.clone_with_new_dest(source, .goe1, dest, visited),
                            .goe2 => return try self.clone_with_new_dest(source, .goe2, dest, visited),
                            .goe3 => return try self.clone_with_new_dest(source, .goe3, dest, visited),
                            .from_orm_active_high, .from_orm_active_low => {
                                const source_mcref = disassembly.unmap_orm(D, self.jedec, mcref) orelse mcref;
                                return try self.clone_with_new_dest(source, .{ .mc_oe = source_mcref }, dest, visited);
                            },
                            .output_only, .input_only => {},
                        }
                    }
                    return error.Invalid_Path;
                },

                .orm => |mcref| {
                    if (D.family != .zero_power_enhanced) {
                        if (fuses.get_output_routing_mode_range(D, mcref)) |range| {
                            switch (disassembly.read_field(self.jedec, lc4k.Output_Routing_Mode, range)) {
                                .same_as_oe => {},
                                .self => return try self.clone_with_new_dest(source, .{ .mcq = mcref }, dest, visited),
                                .five_pt_fast_bypass, .five_pt_fast_bypass_inverted => {
                                    return try self.append_to_parent(source, .{ .mc_cluster = mcref }, dest, "tPDb", visited, Timing.tPDb);
                                },
                            }
                        }
                    }
                    const source_mcref = disassembly.unmap_orm(D, self.jedec, mcref) orelse mcref;
                    return try self.append_to_parent(source, .{ .mcq = source_mcref }, dest, "tORP", visited, Timing.tORP);
                },

                .fb => |mcref| {
                    return try self.append_to_parent(source, .{ .mcq = mcref }, dest, "tFBK", visited, Timing.tFBK);
                },

                .mcq => |mcref| {
                    const range = fuses.get_macrocell_function_range(D, mcref);
                    switch (disassembly.read_field(self.jedec, lc4k.Macrocell_Function, range)) {
                        .combinational => {
                            return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tPDi", visited, Timing.tPDi);
                        },
                        .latch => {
                            var buf: [5]Path = undefined;
                            var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

                            if (try self.maybe_append_to_parent(source, .{ .mcd = mcref }, dest, "tPDLi", visited, Timing.tPDLi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_clk = mcref }, dest, "tGOi", visited, Timing.tGOi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_ce = mcref }, dest, "tGOi", visited, Timing.tGOi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_init = mcref }, dest, "tSRi", visited, Timing.tSRi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_async = mcref }, dest, "tSRi", visited, Timing.tSRi)) |path| {
                                options.appendAssumeCapacity(path);
                            }
                            
                            return try choose_critical_path(options.items);
                        },
                        .t_ff, .d_ff => {
                            var buf: [3]Path = undefined;
                            var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

                            if (try self.maybe_append_to_parent(source, .{ .mc_clk = mcref }, dest, "tCOi", visited, Timing.tCOi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_init = mcref }, dest, "tSRi", visited, Timing.tSRi)) |path| {
                                options.appendAssumeCapacity(path);
                            }

                            if (try self.maybe_append_to_parent(source, .{ .mc_async = mcref }, dest, "tSRi", visited, Timing.tSRi)) |path| {
                                options.appendAssumeCapacity(path);
                            }
                            
                            return try choose_critical_path(options.items);
                        },
                    }
                },

                .mc_oe => |mcref| {
                    return switch (disassembly.read_pt4_output_enable_source(D, self.jedec, mcref)) {
                        .pt4_active_high => try self.append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 4 } }, dest, "tPTOE", visited, Timing.tPTOE),
                        .always_low => error.Invalid_Path,
                    };
                },

                .mc_async => |mcref| {
                    return switch (disassembly.read_async_trigger_source(D, self.jedec, mcref)) {
                        .none => error.Invalid_Path,
                        .pt2_active_high => try self.append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 2 } }, dest, "tPTSR", visited, Timing.tPTSR),
                    };
                },

                .mc_init => |mcref| {
                    return switch (disassembly.read_init_source(D, self.jedec, mcref)) {
                        .pt3_active_high => try self.append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 3 } }, dest, "tPTSR", visited, Timing.tPTSR),
                        .shared_pt_init => try self.append_to_parent(source, .{ .sptinit = mcref.glb }, dest, "tBSR", visited, Timing.tBSR),
                    };
                },

                .mc_ce_setup => |mcref| {
                    return try self.append_to_parent(source, .{ .mc_ce = mcref }, dest, "tCES", visited, Timing.tCES);
                },

                .mc_ce => |mcref| {
                    switch (disassembly.read_clock_enable_source(D, self.jedec, mcref)) {
                        .always_active => return error.Invalid_Path,
                        .shared_pt_clock => {
                            return try self.append_to_parent(source, .{ .sptclk = mcref.glb }, dest, "tBCLK", visited, Timing.tBCLK);
                        },
                        .pt2_active_high, .pt2_active_low => {
                            return try self.append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 2 } }, dest, "tPTCLK", visited, Timing.tPTCLK);
                        },
                    }
                },

                .mc_clk_ce_hold => |mcref| {
                    return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tCEH", visited, Timing.tCEH);
                },

                .mc_clk_d_hold => |mcref| {
                    const range = fuses.get_macrocell_function_range(D, mcref);
                    switch (disassembly.read_field(self.jedec, lc4k.Macrocell_Function, range)) {
                        .combinational => return error.Invalid_Path,
                        .latch => {
                            return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tHL", visited, Timing.tHL);
                        },
                        .t_ff => {
                            return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tHT", visited, Timing.tHT);
                        },
                        .d_ff => {
                            const is_input_register = !self.jedec.is_set(fuses.get_input_bypass_range(D, mcref).min);
                            if (is_input_register) {
                                const is_ptclk = switch (disassembly.read_clock_source(D, self.jedec, mcref)) {
                                    .shared_pt_clock, .pt1_positive, .pt1_negative => true,
                                    .none, .bclock0, .bclock1, .bclock2, .bclock3 => false,
                                };
                                if (is_ptclk) {
                                    return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tHIR_PT", visited, Timing.tHIR_PT);
                                } else {
                                    return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tHIR", visited, Timing.tHIR);
                                }
                            } else {
                                return try self.append_to_parent(source, .{ .mc_clk = mcref }, dest, "tH", visited, Timing.tH);
                            }
                        },
                    }
                },

                .mc_clk => |mcref| {
                    switch (disassembly.read_clock_source(D, self.jedec, mcref)) {
                        .none => return error.Invalid_Path,
                        .shared_pt_clock => {
                            return try self.append_to_parent(source, .{ .sptclk = mcref.glb }, dest, "tBCLK", visited, Timing.tBCLK);
                        },
                        .pt1_positive, .pt1_negative => {
                            return try self.append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 1 } }, dest, "tPTCLK", visited, Timing.tPTCLK);
                        },
                        .bclock0 => return try self.clone_with_new_dest(source, .{ .bclock0 = mcref.glb }, dest, visited),
                        .bclock1 => return try self.clone_with_new_dest(source, .{ .bclock1 = mcref.glb }, dest, visited),
                        .bclock2 => return try self.clone_with_new_dest(source, .{ .bclock2 = mcref.glb }, dest, visited),
                        .bclock3 => return try self.clone_with_new_dest(source, .{ .bclock3 = mcref.glb }, dest, visited),
                    }
                },

                .mcd_setup => |mcref| {
                    const is_ptclk = switch (disassembly.read_clock_source(D, self.jedec, mcref)) {
                        .shared_pt_clock, .pt1_positive, .pt1_negative => true,
                        .none, .bclock0, .bclock1, .bclock2, .bclock3 => false,
                    };
                    const range = fuses.get_macrocell_function_range(D, mcref);
                    switch (disassembly.read_field(self.jedec, lc4k.Macrocell_Function, range)) {
                        .combinational => return error.Invalid_Path,
                        .latch => {
                            if (is_ptclk) {
                                return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tSL_PT", visited, Timing.tSL_PT);
                            } else {
                                return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tSL", visited, Timing.tSL);
                            }
                        },
                        .t_ff => {
                            if (is_ptclk) {
                                return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tST_PT", visited, Timing.tST_PT);
                            } else {
                                return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tST", visited, Timing.tST);
                            }
                        },
                        .d_ff => {
                            const is_input_register = !self.jedec.is_set(fuses.get_input_bypass_range(D, mcref).min);
                            if (is_input_register) {
                                if (is_ptclk) {
                                    return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tSIR_PT", visited, Timing.tSIR_PT);
                                } else {
                                    return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tSIR", visited, Timing.tSIR);
                                }
                            } else {
                                if (is_ptclk) {
                                    return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tS_PT", visited, Timing.tS_PT);
                                } else {
                                    return try self.append_to_parent(source, .{ .mcd = mcref }, dest, "tS", visited, Timing.tS);
                                }
                            }
                        },
                    }
                },

                .mcd => |mcref| {
                    var buf: [2]Path = undefined;
                    var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

                    if (!self.jedec.is_set(fuses.get_input_bypass_range(D, mcref).min)) {
                        const delay = Timing.tINREG + self.tINDIO();
                        if (try self.maybe_append_to_parent(source, .{ .in = @intFromEnum(D.Signal.mc_pad(mcref)) }, dest, "tINREG", visited, delay)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    } else if (!self.jedec.is_set(fuses.get_pt0_xor_range(D, mcref).min)) {
                        if (try self.maybe_append_to_parent(source, .{ .pt = .{ .mcref = mcref, .pt = 0 }}, dest, "tMCELL", visited, Timing.tMCELL)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    }

                    if (disassembly.read_field(self.jedec, lc4k.Wide_Routing, fuses.get_wide_routing_range(D, mcref)) == .self) {
                        if (try self.maybe_append_to_parent(source, .{ .mc_ca = mcref }, dest, "tMCELL", visited, Timing.tMCELL)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    }

                    return try choose_critical_path(options.items);
                },

                .mc_ca => |mcref| {
                    var buf: [5]Path = undefined;
                    var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

                    if (disassembly.read_field(self.jedec, lc4k.Cluster_Routing, fuses.get_cluster_routing_range(D, mcref)) == .self) {
                        if (try self.maybe_find_critical_path(source, .{ .mc_cluster = mcref }, visited)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    }

                    if (mcref.mc >= 1) {
                        const other_mcref = lc4k.MC_Ref.init(mcref.glb, mcref.mc - 1);
                        if (disassembly.read_field(self.jedec, lc4k.Cluster_Routing, fuses.get_cluster_routing_range(D, other_mcref)) == .self_plus_one) {
                            if (try self.maybe_find_critical_path(source, .{ .mc_cluster = other_mcref }, visited)) |path| {
                                options.appendAssumeCapacity(path);
                            }
                        }
                    }

                    if (mcref.mc < D.num_mcs_per_glb - 1) {
                        const other_mcref = lc4k.MC_Ref.init(mcref.glb, mcref.mc + 1);
                        if (disassembly.read_field(self.jedec, lc4k.Cluster_Routing, fuses.get_cluster_routing_range(D, other_mcref)) == .self_minus_one) {
                            if (try self.maybe_find_critical_path(source, .{ .mc_cluster = other_mcref }, visited)) |path| {
                                options.appendAssumeCapacity(path);
                            }
                        }
                    }

                    if (mcref.mc < D.num_mcs_per_glb - 2) {
                        const other_mcref = lc4k.MC_Ref.init(mcref.glb, mcref.mc + 2);
                        if (disassembly.read_field(self.jedec, lc4k.Cluster_Routing, fuses.get_cluster_routing_range(D, other_mcref)) == .self_minus_two) {
                            if (try self.maybe_find_critical_path(source, .{ .mc_cluster = other_mcref }, visited)) |path| {
                                options.appendAssumeCapacity(path);
                            }
                        }
                    }

                    const prev_wide_cluster = lc4k.MC_Ref.init(mcref.glb, (mcref.mc + D.num_mcs_per_glb - 4) % D.num_mcs_per_glb);
                    if (disassembly.read_field(self.jedec, lc4k.Wide_Routing, fuses.get_wide_routing_range(D, prev_wide_cluster)) == .self_plus_four) {
                        if (try self.maybe_append_to_parent(source, .{ .mc_ca = prev_wide_cluster }, dest, "tEXP", visited, Timing.tEXP)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    }

                    //return try choose_critical_path(options.items);
                    return try self.choose_critical_path_and_clone_with_new_dest(options.items, dest);
                },

                .mc_cluster => |mcref| {
                    var buf: [5]Path = undefined;
                    var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

                    if (self.jedec.is_set(fuses.get_pt0_xor_range(D, mcref).min)) {
                        if (try self.maybe_find_critical_path(source, .{ .pt = .{ .mcref = mcref, .pt = 0 }}, visited)) |path| {
                            options.appendAssumeCapacity(path);
                        }
                    }

                    switch (disassembly.read_clock_source(D, self.jedec, mcref)) {
                        .pt1_positive, .pt1_negative => {},
                        else => if (try self.maybe_find_critical_path(source, .{ .pt = .{ .mcref = mcref, .pt = 1 }}, visited)) |path| {
                            options.appendAssumeCapacity(path);
                        },
                    }

                    switch (disassembly.read_clock_enable_source(D, self.jedec, mcref)) {
                        .pt2_active_high, .pt2_active_low => {},
                        else => switch (disassembly.read_async_trigger_source(D, self.jedec, mcref)) {
                            .pt2_active_high => {},
                            .none => if (try self.maybe_find_critical_path(source, .{ .pt = .{ .mcref = mcref, .pt = 2 }}, visited)) |path| {
                                options.appendAssumeCapacity(path);
                            },
                        },
                    }

                    switch (disassembly.read_init_source(D, self.jedec, mcref)) {
                        .pt3_active_high => {},
                        else => if (try self.maybe_find_critical_path(source, .{ .pt = .{ .mcref = mcref, .pt = 3 }}, visited)) |path| {
                            options.appendAssumeCapacity(path);
                        },
                    }

                    switch (disassembly.read_field(self.jedec, lc4k.Macrocell_Output_Enable_Source, fuses.get_pt4_output_enable_range(D, mcref))) {
                        .pt4_active_high => {},
                        else => if (try self.maybe_find_critical_path(source, .{ .pt = .{ .mcref = mcref, .pt = 4 }}, visited)) |path| {
                            options.appendAssumeCapacity(path);
                        },
                    }

                    //return try choose_critical_path(options.items);
                    return try self.choose_critical_path_and_clone_with_new_dest(options.items, dest);
                },

                .goe0 => return try self.compute_goe_critical_path(source, dest, 0, visited),
                .goe1 => return try self.compute_goe_critical_path(source, dest, 1, visited),
                .goe2 => return try self.compute_goe_critical_path(source, dest, 2, visited),
                .goe3 => return try self.compute_goe_critical_path(source, dest, 3, visited),
                
                .igoe0 => return try self.compute_igoe_critical_path(source, dest, 0, visited),
                .igoe1 => return try self.compute_igoe_critical_path(source, dest, 1, visited),
                .igoe2 => return try self.compute_igoe_critical_path(source, dest, 2, visited),
                .igoe3 => return try self.compute_igoe_critical_path(source, dest, 3, visited),

                .pt => |ptref| return self.compute_pt_critical_path(source, dest, ptref.mcref.glb, ptref.mcref.mc * 5 + ptref.pt, visited),
                .sptoe => |glb| return self.compute_pt_critical_path(source, dest, glb, D.num_mcs_per_glb * 5 + 2, visited),
                .sptclk => |glb| return self.compute_pt_critical_path(source, dest, glb, D.num_mcs_per_glb * 5 + 1, visited),
                .sptinit => |glb| return self.compute_pt_critical_path(source, dest, glb, D.num_mcs_per_glb * 5 + 0, visited),

                .grp => |signal_index| {
                    const signal: D.Signal = @enumFromInt(signal_index);

                    var total_gis: usize = 0;
                    for (0..D.num_glbs) |glb| {
                        for (0.., D.gi_options) |gi, gi_options| {
                            const gi_fuses = D.get_gi_range(glb, gi);
                            var fuse_iter = gi_fuses.iterator();
                            for (gi_options) |gi_option| {
                                const fuse = fuse_iter.next().?;
                                if (gi_option == signal and !self.jedec.is_set(fuse)) {
                                    total_gis += 1;
                                    break;
                                }
                            }
                        }
                    }
                    if (total_gis == 0) return error.Invalid_Path;

                    const delay: i32 = @intCast(Timing.tROUTE + Timing.tBLA * (total_gis - 1));
                    if (signal.kind() == .mc) {
                        return try self.append_to_parent(source, .{ .fb = signal.mc() }, dest, "tROUTE", visited, delay);
                    } else {
                        return try self.append_to_parent(source, .{ .in = signal_index }, dest, "tROUTE", visited, delay);
                    }
                },

                .bclock0 => |glb| return try self.compute_bclock_critical_path(source, dest, 0, glb, visited),
                .bclock1 => |glb| return try self.compute_bclock_critical_path(source, dest, 1, glb, visited),
                .bclock2 => |glb| return try self.compute_bclock_critical_path(source, dest, 2, glb, visited),
                .bclock3 => |glb| return try self.compute_bclock_critical_path(source, dest, 3, glb, visited),

                .gclk => |index| {
                    // TODO tPGRT
                    const pin = D.clock_pins[index];
                    const signal_index = pin.info.signal_index.?;
                    const signal: D.Signal = @enumFromInt(signal_index);
                    const delay = Timing.tGCLK_IN + self.tIOI(signal);
                    return try self.append_to_parent(source, .{ .pad = signal_index }, dest, "tGCLK_IN", visited, delay);
                },

                .oe_in => |index| {
                    // TODO tPGRT
                    const pin = D.oe_pins[index];
                    const signal_index = pin.info.signal_index.?;
                    const signal: D.Signal = @enumFromInt(signal_index);
                    const delay = Timing.tGOE + self.tIOI(signal);
                    return try self.append_to_parent(source, .{ .pad = signal_index }, dest, "tGOE", visited, delay);
                },

                .in => |signal_index| {
                    // TODO tPGRT
                    const signal: D.Signal = @enumFromInt(signal_index);

                    if (signal.kind() == .io) {
                        const mcref = signal.mc();
                        if (fuses.get_output_enable_source_range(D, mcref)) |range| {
                            if (disassembly.read_field(self.jedec, lc4k.Output_Enable_Mode, range) == .output_only) {
                                return error.Invalid_Path;
                            }
                        }
                    }

                    const delay = Timing.tIN + self.tIOI(signal);
                    return try self.append_to_parent(source, .{ .pad = signal_index }, dest, "tIN", visited, delay);
                },

                .pad => {
                    return error.Invalid_Path;
                }
            }
        }

        fn compute_goe_critical_path(self: *Self, source: Node, dest: Node, goe: lc4k.GOE_Index, visited: *Node_Set) Error!Path {
            if (D.num_glbs == 2) {
                return switch (goe) {
                    0 => self.append_to_parent(source, .igoe0, dest, "tGPTOE", visited, Timing.tGPTOE),
                    1 => self.append_to_parent(source, .igoe1, dest, "tGPTOE", visited, Timing.tGPTOE),
                    2 => self.clone_with_new_dest(source, .{ .oe_in = 0 }, dest, visited),
                    3 => self.clone_with_new_dest(source, .{ .oe_in = 1 }, dest, visited),
                    else => unreachable,
                };
            } else {
                switch (goe) {
                    0, 1 => {
                        if (self.jedec.is_set(D.get_goe_source_fuse(goe))) {
                            return switch (goe) {
                                0 => self.append_to_parent(source, .igoe0, dest, "tGPTOE", visited, Timing.tGPTOE),
                                1 => self.append_to_parent(source, .igoe1, dest, "tGPTOE", visited, Timing.tGPTOE),
                                else => unreachable,
                            };
                        } else {
                            return self.clone_with_new_dest(source, .{ .oe_in = goe }, dest, visited);
                        }
                    },
                    2 => return self.append_to_parent(source, .igoe2, dest, "tGPTOE", visited, Timing.tGPTOE),
                    3 => return self.append_to_parent(source, .igoe3, dest, "tGPTOE", visited, Timing.tGPTOE),
                    else => unreachable,
                }
            }
        }

        fn compute_igoe_critical_path(self: *Self, source: Node, dest: Node, n: usize, visited: *Node_Set) Error!Path {
            if (n >= D.oe_bus_size) return error.Invalid_Path;

            var buf: [D.num_glbs]Path = undefined;
            var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

            for (0..D.num_glbs) |glb| {
                var fuse_iter = fuses.get_shared_enable_to_oe_bus_range(D, glb).iterator();
                for (0..n) |_| {
                    _ = fuse_iter.next();
                }
                const fuse = fuse_iter.next().?;
                if (!self.jedec.is_set(fuse)) {
                    if (try self.maybe_find_critical_path(source, .{ .sptoe = @intCast(glb) }, visited)) |path| {
                        options.appendAssumeCapacity(path);
                    }
                }
            }

            return try self.choose_critical_path_and_clone_with_new_dest(options.items, dest);
        }

        fn compute_bclock_critical_path(self: *Self, source: Node, dest: Node, n: lc4k.Clock_Index, glb: lc4k.GLB_Index, visited: *Node_Set) Error!Path {
            var fuse_iter = D.get_bclock_range(glb).iterator();
            for (0..n) |_| {
                _ = fuse_iter.next();
            }
            const fuse = fuse_iter.next().?;

            var src_clk = n;
            if (!self.jedec.is_set(fuse)) src_clk ^= 1;
            src_clk %= @intCast(D.clock_pins.len);

            return try self.clone_with_new_dest(source, .{ .gclk = src_clk }, dest, visited);
        }

        fn compute_pt_critical_path(self: *Self, source: Node, dest: Node, glb: lc4k.GLB_Index, pt_offset: usize, visited: *Node_Set) Error!Path {
            var buf: [D.num_gis_per_glb]Path = undefined;
            var options = std.ArrayListUnmanaged(Path).initBuffer(&buf);

            var gi_signals = [_]?D.Signal { null } ** D.num_gis_per_glb;
            for (0.., D.gi_options, &gi_signals) |gi, gi_options, *signal| {
                const gi_fuses = D.get_gi_range(glb, gi);
                var fuse_iter = gi_fuses.iterator();
                for (gi_options) |gi_option| {
                    const fuse = fuse_iter.next().?;
                    if (!self.jedec.is_set(fuse)) {
                        signal.* = gi_option;
                    }
                }
            }

            const range = fuses.get_pt_range(D, glb, pt_offset);
            var fuse_iter = range.iterator();
            for (gi_signals) |maybe_signal| {
                const active_high_fuse = fuse_iter.next().?;
                const active_low_fuse = fuse_iter.next().?;

                const when_high = !self.jedec.is_set(active_high_fuse);
                const when_low = !self.jedec.is_set(active_low_fuse);

                if (when_high == when_low) continue;

                if (maybe_signal) |signal| {
                    if (try self.maybe_find_critical_path(source, .{ .grp = @intFromEnum(signal) }, visited)) |path| {
                        options.appendAssumeCapacity(path);
                    }
                }
            }

            return try self.choose_critical_path_and_clone_with_new_dest(options.items, dest);
        }

        fn choose_critical_path(options: []const Path) Error!Path {
            if (options.len == 0) {
                return error.Invalid_Path;
            }

            var critical = options[0];

            for (options[1..]) |path| {
                if (path.delay > critical.delay) {
                    critical = path;
                }
            }

            return critical;
        }

        fn choose_critical_path_and_clone_with_new_dest(self: *Self, options: []const Path, new_dest: Node) Error!Path {
            const critical = try choose_critical_path(options);
            if (critical.critical_path.len == 0) return Path.nil;                    
            if (std.meta.eql(new_dest, critical.critical_path[critical.critical_path.len - 1].segment.dest)) return critical;

            const critical_path = try self.arena.dupe(Delay, critical.critical_path);
            critical_path[critical.critical_path.len - 1].segment.dest = new_dest;

            return .{
                .critical_path = critical_path,
                .delay = critical.delay,
            };
        }

        fn clone_with_new_dest(self: *Self, source: Node, dest: Node, new_dest: Node, visited: *Node_Set) Error!Path {
            const parent_path = try self.find_critical_path(source, dest, visited);
            const parent_len = parent_path.critical_path.len;
            if (parent_len == 0) return Path.nil;
            if (std.meta.eql(dest, new_dest)) return parent_path;

            var critical_path = try self.arena.dupe(Delay, parent_path.critical_path);
            critical_path[parent_len - 1].segment.dest = new_dest;
            return .{
                .critical_path = critical_path,
                .delay = parent_path.delay,
            };
        }

        fn maybe_append_to_parent(self: *Self, source: Node, parent_node: Node, dest: Node, name: []const u8, visited: *Node_Set, delay: Picoseconds) Error!?Path {
            return self.append_to_parent(source, parent_node, dest, name, visited, delay) catch |err| switch (err) {
                error.Invalid_Path => null,
                else => err,
            };
        }

        fn append_to_parent(self: *Self, source: Node, parent_node: Node, dest: Node, name: []const u8, visited: *Node_Set, delay: Picoseconds) Error!Path {
            const parent_path = try self.find_critical_path(source, parent_node, visited);
            const parent_len = parent_path.critical_path.len;

            var critical_path = try self.arena.alloc(Delay, parent_len + 1);
            @memcpy(critical_path.ptr, parent_path.critical_path);
            critical_path[parent_len] = .{
                .name = name,
                .segment = .{
                    .source = parent_node,
                    .dest = dest,
                },
                .delay = delay,
            };

            return .{
                .critical_path = critical_path,
                .delay = parent_path.delay + delay,
            };
        }

        fn tIOI(self: *Self, signal: D.Signal) Picoseconds {
            _ = self;
            _ = signal;
            // We're not including tIOO because input/output buffer delays are heavily dependent on trace length, capacitance, etc. anyway.
            //return Timing.tIOI_low;
            return 0;
        }

        fn tIOO(self: *Self, mcref: lc4k.MC_Ref) Picoseconds {
            _ = self;
            _ = mcref;
            // We're not including tIOO because input/output buffer delays are heavily dependent on trace length, capacitance, etc. anyway.
            //return Timing.tIOO;
            return 0;
        }

        fn tSLEW(self: *Self, mcref: lc4k.MC_Ref) Picoseconds {
            if (fuses.get_slew_rate_range(D, mcref)) |range| {
                if (disassembly.read_field(self.jedec, lc4k.Slew_Rate, range) == .slow) {
                    return Timing.tSLEW;
                }
            }
            return 0;
        }

        fn tINDIO(self: *Self) Picoseconds {
            const zero_hold_time = !self.jedec.is_set(D.get_zero_hold_time_fuse());
            return if (zero_hold_time) Timing.tINDIO else 0;
        }

    };
}

const JEDEC_Data = @import("JEDEC_Data.zig");
const disassembly = @import("disassembly.zig");
const naming = @import("naming.zig");
const fuses = @import("fuses.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
