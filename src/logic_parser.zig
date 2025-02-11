pub const Options = struct {
    max_product_terms: u8 = 80,
    optimize: bool = false,
    dont_care: []const u8 = "",
};

pub fn Logic_Parser(comptime Device: type) type {
    return struct {
        gpa: std.mem.Allocator,
        arena: std.heap.ArenaAllocator,
        names: *const Device.Names,
        optimization_signal_limit: u5 = 16,

        const LP = @This();
        const Names = naming.Names(Device);
        const Logic = lc4k.Macrocell_Logic(Device.Signal);
        const PT = lc4k.Product_Term(Device.Signal);
        const F = lc4k.Factor(Device.Signal);

        pub fn pt(self: *LP, equation: []const u8, options: Options) !PT {
            var pd = try Parse_Data.parse(self, equation);
            defer pd.deinit();

            _ = try pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            var ir = try pd.build_ir(&ir_data, 0);
            ir = try ir_data.normalize(ir, .{ .max_xor_depth = 0 });

            const dc_ir = if (options.dont_care.len > 0) dc_ir: {
                var dc_pd = try Parse_Data.parse(self, options.dont_care);
                defer dc_pd.deinit();

                _ = try dc_pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });

                const dc = try dc_pd.build_ir(&ir_data, 0);
                break :dc_ir try ir_data.normalize(dc, .{ .max_xor_depth = 0 });
            } else null;

            const optimization_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;

            ir = try qmc.optimize(&ir_data, ir, dc_ir, optimization_signal_limit);

            const num_pts = ir_data.count_pts(ir);
            if (num_pts > 1) {
                pd.report_node_error_fmt(pd.root.?, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ num_pts });
                try ir_data.debug(ir, 0, false, std.io.getStdErr().writer().any());
                return error.TooManyProductTerms;
            }

            return try ir_data.get_pt(Device.Signal, self.arena.allocator(), ir, 0);
        }

        pub fn sum(self: *LP, equation: []const u8, options: Options) ![]PT {
            var pd = try Parse_Data.parse(self, equation);
            defer pd.deinit();

            _ = try pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            var ir = try pd.build_ir(&ir_data, 0);
            ir = try ir_data.normalize(ir, .{ .max_xor_depth = 0 });

            const dc_ir = if (options.dont_care.len > 0) dc_ir: {
                var dc_pd = try Parse_Data.parse(self, options.dont_care);
                defer dc_pd.deinit();

                _ = try dc_pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });

                const dc = try dc_pd.build_ir(&ir_data, 0);
                break :dc_ir try ir_data.normalize(dc, .{ .max_xor_depth = 0 });
            } else null;

            const optimization_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;
            
            ir = try qmc.optimize(&ir_data, ir, dc_ir, optimization_signal_limit);
                
            const allocator = self.arena.allocator();
            const num_pts = ir_data.count_pts(ir);
            if (num_pts > options.max_product_terms) {
                pd.report_node_error_fmt(pd.root.?, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    num_pts,
                    options.max_product_terms,
                });
                try ir_data.debug(ir, 0, false, std.io.getStdErr().writer().any());
                return error.TooManyProductTerms;
            }
            const pts = try allocator.alloc(PT, num_pts);
            for (0.., pts) |i, *term| {
                term.* = try ir_data.get_pt(Device.Signal, allocator, ir, i);
            }
            return pts;
        }

        pub fn logic(self: *LP, equation: []const u8, options: Options) !Logic {
            var pd = try Parse_Data.parse(self, equation);
            defer pd.deinit();

            _ = try pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });

            var dc_pd: Parse_Data = .{
                .gpa = self.gpa,
                .names = self.names,
                .eqn = "",
                .tokens = &.{},
                .token_offsets = &.{},
            };
            defer if (dc_pd.eqn.len > 0) dc_pd.deinit();

            const maybe_dc_pd: ?*Parse_Data = if (options.dont_care.len > 0) ptr: {
                dc_pd = try Parse_Data.parse(self, options.dont_care);
                _ = try dc_pd.infer_and_check_bit_widths(.{ .max_result_bits = 1 });
                break :ptr &dc_pd;
            } else null;

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            return try self.find_best_logic(&pd, maybe_dc_pd, &ir_data, 0, options);
        }
        
        pub fn assign_logic(self: *LP, chip: *lc4k.Chip_Config(Device), mc_signals: []const Device.Signal, equation: []const u8, options: Options) !void {
            var pd = try Parse_Data.parse(self, equation);
            defer pd.deinit();

            _ = try pd.infer_and_check_bit_widths(.{
                .min_result_bits = mc_signals.len,
                .max_result_bits = mc_signals.len,
            });

            var dc_pd: Parse_Data = .{
                .gpa = self.gpa,
                .names = self.names,
                .eqn = "",
                .tokens = &.{},
                .token_offsets = &.{},
            };
            defer if (dc_pd.eqn.len > 0) dc_pd.deinit();

            const maybe_dc_pd: ?*Parse_Data = if (options.dont_care.len > 0) ptr: {
                dc_pd = try Parse_Data.parse(self, options.dont_care);
                _ = try dc_pd.infer_and_check_bit_widths(.{
                    .min_result_bits = mc_signals.len,
                    .max_result_bits = mc_signals.len,
                });
                break :ptr &dc_pd;
            } else null;

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            for (0.., mc_signals) |bit_index, signal| {
                chip.mc(signal.mc()).logic = try self.find_best_logic(&pd, maybe_dc_pd, &ir_data, bit_index, options);
            }
        }

        fn find_best_logic(self: *LP, pd: *Parse_Data, maybe_dc_pd: ?*Parse_Data, ir_data: *IR_Data, bit_index: u6, options: Options) !Logic {
            const allocator = self.arena.allocator();

            const optimization_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;

            const ir = try ir_data.normalize(try pd.build_ir(ir_data, bit_index), .{
                .max_xor_depth = 0xFFFF,
                .demorgan = false,
                .distribute = false,
            });

            const dc_ir = if (maybe_dc_pd) |dc_pd| try ir_data.normalize(try dc_pd.build_ir(ir_data, bit_index), .{ .max_xor_depth = 0 }) else null;

            var ir_sum = try ir_data.normalize(ir, .{ .max_xor_depth = 0 });
            ir_sum = try qmc.optimize(ir_data, ir_sum, dc_ir, optimization_signal_limit);
            const ir_sum_pts = ir_data.count_pts(ir_sum);
            if (ir_sum_pts == 1) {
                return .{ .pt0 = try ir_data.get_pt(Device.Signal, allocator, ir_sum, 0) };
            }

            var best_ir = ir_sum;
            var best_ir_pts = ir_sum_pts;
            var best_ir_kind: std.meta.Tag(lc4k.Macrocell_Logic(Device.Signal)) = .sum;

            var ir_sum_inverted = try ir_data.normalize(try ir_data.make_complement(ir), .{ .max_xor_depth = 0 });
            ir_sum_inverted = try qmc.optimize(ir_data, ir_sum_inverted, dc_ir, optimization_signal_limit);
            const ir_sum_inverted_pts = ir_data.count_pts(ir_sum_inverted);
            if (ir_sum_inverted_pts == 1) {
                return .{ .pt0_inverted = try ir_data.get_pt(Device.Signal, allocator, ir_sum_inverted, 0) };
            } else if (ir_sum_inverted_pts < best_ir_pts) {
                best_ir = ir_sum_inverted;
                best_ir_pts = ir_sum_inverted_pts;
                best_ir_kind = .sum_inverted;
            }

            switch (ir_data.get(ir)) {
                .xor => |raw_xor_bin| {
                    const lhs, const rhs = bin: {
                        const xor_bin = ir_data.get(try ir_data.normalize(ir, .{})).xor;
                        break :bin .{
                            try qmc.optimize(ir_data, xor_bin.lhs, dc_ir, optimization_signal_limit),
                            try qmc.optimize(ir_data, xor_bin.rhs, dc_ir, optimization_signal_limit),
                        };
                    };
                    const lhs_pts = ir_data.count_pts(lhs);
                    const rhs_pts = ir_data.count_pts(rhs);

                    const lhs_inverted, const rhs_inverted = bin: {
                        const lhs_inverted = try ir_data.normalize(try ir_data.make_complement(raw_xor_bin.lhs), .{ .max_xor_depth = 0 });
                        const rhs_inverted = try ir_data.normalize(try ir_data.make_complement(raw_xor_bin.rhs), .{ .max_xor_depth = 0 });
                        break :bin .{
                            try qmc.optimize(ir_data, lhs_inverted, dc_ir, optimization_signal_limit),
                            try qmc.optimize(ir_data, rhs_inverted, dc_ir, optimization_signal_limit),
                        };
                    };
                    const lhs_inverted_pts = ir_data.count_pts(lhs_inverted);
                    const rhs_inverted_pts = ir_data.count_pts(rhs_inverted);

                    if (lhs_pts == 1) {
                        if (rhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs);
                            best_ir_pts = rhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                        }
                        if (rhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs_inverted);
                            best_ir_pts = rhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0_inverted;
                        }
                    }
                    if (rhs_pts == 1) {
                        if (lhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs);
                            best_ir_pts = lhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                        }
                        if (lhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs);
                            best_ir_pts = lhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0_inverted;
                        }
                    }
                    if (lhs_inverted_pts == 1) {
                        if (rhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs_inverted);
                            best_ir_pts = rhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                        }
                        if (rhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs);
                            best_ir_pts = rhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0_inverted;
                        }
                    }
                    if (rhs_inverted_pts == 1) {
                        if (lhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs_inverted);
                            best_ir_pts = lhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                        }
                        if (lhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs_inverted);
                            best_ir_pts = lhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0_inverted;
                        }
                    }
                },
                else => {}
            }

            if (best_ir_pts > options.max_product_terms) {
                pd.report_node_error_fmt(pd.root.?, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    best_ir_pts,
                    options.max_product_terms,
                });
                try ir_data.debug(best_ir, 0, false, std.io.getStdErr().writer().any());
                return error.TooManyProductTerms;
            }

            switch (best_ir_kind) {
                .sum => {
                    const pts = try allocator.alloc(PT, best_ir_pts);
                    for (0.., pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, best_ir, i);
                    }
                    return .{ .sum = pts };
                },
                .sum_inverted => {
                    const pts = try allocator.alloc(PT, best_ir_pts);
                    for (0.., pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, best_ir, i);
                    }
                    return .{ .sum_inverted = pts };
                },
                .sum_xor_pt0 => {
                    const xor_bin = ir_data.get(best_ir).xor;
                    var pt0_ir = xor_bin.lhs;
                    var sum_ir = xor_bin.rhs;
                    if (ir_data.count_pts(xor_bin.lhs) > 1) {
                        pt0_ir = xor_bin.rhs;
                        sum_ir = xor_bin.lhs;
                    }
                    const sum_pts = try allocator.alloc(PT, best_ir_pts - 1);
                    for (0.., sum_pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, sum_ir, i);
                    }
                    return .{ .sum_xor_pt0 = .{
                        .sum = sum_pts,
                        .pt0 = try ir_data.get_pt(Device.Signal, allocator, pt0_ir, 0),
                    }};
                },
                .sum_xor_pt0_inverted => {
                    const xor_bin = ir_data.get(best_ir).xor;
                    var pt0_ir = xor_bin.lhs;
                    var sum_ir = xor_bin.rhs;
                    if (ir_data.count_pts(xor_bin.lhs) > 1) {
                        pt0_ir = xor_bin.rhs;
                        sum_ir = xor_bin.lhs;
                    }
                    const sum_pts = try allocator.alloc(PT, best_ir_pts - 1);
                    for (0.., sum_pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, sum_ir, i);
                    }
                    return .{ .sum_xor_pt0_inverted = .{
                        .sum = sum_pts,
                        .pt0 = try ir_data.get_pt(Device.Signal, allocator, pt0_ir, 0),
                    }};
                },
                else => unreachable,
            }
        }

        pub const Parse_Error = error {
            InvalidEquation,
        } || std.mem.Allocator.Error;

        pub const Node = struct {
            begin_token_offset: u32,
            end_token_offset: u32,

            kind: Node_Kind,
            result_bits: ?u6 = null,

            data: union {
                literal: u64,
                bit_range: struct {
                    first: ?u6,
                    last: ?u6,
                },
                signal: Device.Signal,
                bus_ref: [*]const Device.Signal,
                unary: Node.ID,
                binary: struct {
                    lhs: Node.ID,
                    rhs: Node.ID,
                },
                nary: struct {
                    offset: u32,
                    len: u32,
                },
            },

            pub const ID = enum (u32) {
                _,
            };
        };

        pub const Parse_Data = struct {
            gpa: std.mem.Allocator,
            names: *const Device.Names,
            eqn: []const u8,
            tokens: []const Token,
            token_offsets: []const u32,
            next_token: u32 = 0,
            nodes: std.MultiArrayList(Node) = .{},
            extra_children: std.ArrayListUnmanaged(Node.ID) = .{},
            temp_nodes: std.ArrayListUnmanaged(Node.ID) = .{},
            root: ?Node.ID = null,

            pub fn parse(g: *LP, equation: []const u8) Parse_Error!Parse_Data {
                const tokens, const token_offsets = try lex(g.gpa, equation);
                var self: Parse_Data = .{
                    .gpa = g.gpa,
                    .names = g.names,
                    .eqn = equation,
                    .tokens = tokens,
                    .token_offsets = token_offsets,
                };
                errdefer self.deinit();

                self.root = try self.try_sum();
                if (!self.try_token(.eof)) {
                    self.report_token_error(self.next_token, "Expected end of equation");
                    return error.InvalidEquation;
                }

                return self;
            }

            pub fn deinit(self: *Parse_Data) void {
                self.gpa.free(self.tokens);
                self.gpa.free(self.token_offsets);
                self.nodes.deinit(self.gpa);
                self.extra_children.deinit(self.gpa);
                self.temp_nodes.deinit(self.gpa);
            }

            pub const Check_Bit_Widths_Options = struct {
                min_result_bits: u6 = 1,
                max_result_bits: u6 = std.math.maxInt(u6),
            };
            pub fn infer_and_check_bit_widths(self: *Parse_Data, options: Check_Bit_Widths_Options) !u6 {
                const slice = self.nodes.slice();
                const result_bits = try self.infer_and_check_node_bit_width(slice, self.root.?);
                if (result_bits > options.max_result_bits) {
                    if (options.max_result_bits == 1) {
                        self.report_node_error_fmt(self.root.?, "Result has width of {} bits, but expected width of 1 bit", .{
                            result_bits,
                        });
                    } else {
                        self.report_node_error_fmt(self.root.?, "Result has width of {} bits, but expected width of {} bits or less", .{
                            result_bits,
                            options.max_result_bits,
                        });
                    }
                    return error.InvalidEquation;
                } else if (result_bits < options.min_result_bits) {
                    if (options.min_result_bits == 1) {
                        self.report_node_error_fmt(self.root.?, "Result has width of {} bits, but expected width of at least 1 bit", .{
                            result_bits,
                        });
                    } else {
                        self.report_node_error_fmt(self.root.?, "Result has width of {} bits, but expected width of at least {} bits", .{
                            result_bits,
                            options.min_result_bits,
                        });
                    }
                    return error.InvalidEquation;
                }
                return result_bits;
            }
            fn infer_and_check_node_bit_width(self: *Parse_Data, slice: std.MultiArrayList(Node).Slice, node: Node.ID) !u6 {
                const node_index = @intFromEnum(node);
                if (slice.items(.result_bits)[node_index]) |bits| return bits;
                switch (slice.items(.kind)[node_index]) {
                    .literal, .bit_range, .signal, .bus_ref => unreachable, // .result_bits should have been set when the node was created

                    .complement, .subexpr => {
                        const child_node = slice.items(.data)[node_index].unary;
                        const child_bits = try self.infer_and_check_node_bit_width(slice, child_node);
                        slice.items(.result_bits)[node_index] = child_bits;
                        return child_bits;
                    },

                    .unary_sum, .unary_product, .unary_xor => {
                        const child_node = slice.items(.data)[node_index].unary;
                        _ = try self.infer_and_check_node_bit_width(slice, child_node);
                        slice.items(.result_bits)[node_index] = 1;
                        return 1;
                    },

                    .equals, .not_equals => {
                        const data = slice.items(.data)[node_index].binary;
                        const lhs_bits = try self.infer_and_check_node_bit_width(slice, data.lhs);
                        const rhs_bits = try self.infer_and_check_node_bit_width(slice, data.rhs);
                        if (lhs_bits != rhs_bits) {
                            self.report_node_error_fmt_3(
                                node, "Both sides of a comparison operator must have the same bit width", .{},
                                data.lhs, "Left side has width of {} bits", .{ lhs_bits },
                                data.rhs, "Right side has width of {} bits", .{ rhs_bits });
                            return error.InvalidEquation;
                        }

                        slice.items(.result_bits)[node_index] = 1;
                        return 1;
                    },

                    .binary_sum, .binary_product, .binary_xor => {
                        const data = slice.items(.data)[node_index].binary;
                        const lhs_bits = try self.infer_and_check_node_bit_width(slice, data.lhs);
                        const rhs_bits = try self.infer_and_check_node_bit_width(slice, data.rhs);
                        if (lhs_bits != rhs_bits) {
                            self.report_node_error_fmt_3(
                                node, "Both sides of binary operator must have the same bit width", .{},
                                data.lhs, "Left side has width of {} bits", .{ lhs_bits },
                                data.rhs, "Right side has width of {} bits", .{ rhs_bits });
                            return error.InvalidEquation;
                        }

                        slice.items(.result_bits)[node_index] = lhs_bits;
                        return lhs_bits;
                    },

                    .binary_concat_be, .binary_concat_le => {
                        const data = slice.items(.data)[node_index].binary;
                        const lhs_bits = try self.infer_and_check_node_bit_width(slice, data.lhs);
                        const rhs_bits = try self.infer_and_check_node_bit_width(slice, data.rhs);

                        slice.items(.result_bits)[node_index] = lhs_bits + rhs_bits;
                        return lhs_bits + rhs_bits;
                    },

                    .extract, .extract_be, .extract_le => {
                        const data = slice.items(.data)[node_index].binary;
                        const bus_bits = try self.infer_and_check_node_bit_width(slice, data.lhs);
                        const extracted_bits, _ = try self.validate_and_count_bit_indices(slice, data.rhs, data.lhs, bus_bits, null, switch (slice.items(.kind)[node_index]) {
                            .extract => null,
                            .extract_be => .big,
                            .extract_le => .little,
                            else => unreachable,
                        });

                        slice.items(.result_bits)[node_index] = extracted_bits;
                        return extracted_bits;
                    },

                    .sum, .product, .xor => {
                        const data = slice.items(.data)[node_index].nary;
                        const children = self.extra_children.items[data.offset..][0..data.len];
                        const lhs_bits = try self.infer_and_check_node_bit_width(slice, children[0]);
                        for (children[1..], 2..) |child, i| {
                            const child_bits = try self.infer_and_check_node_bit_width(slice, child);
                            if (lhs_bits != child_bits) {
                                self.report_node_error_fmt_3(
                                    node, "All items in compound operator must have the same bit width", .{},
                                    children[0], "Item 1 has width of {} bits", .{ lhs_bits },
                                    child, "Item {} has width of {} bits", .{ i, child_bits });
                                return error.InvalidEquation;
                            }
                        }

                        slice.items(.result_bits)[node_index] = lhs_bits;
                        return lhs_bits;
                    },

                    .concat_be, .concat_le => {
                        const data = slice.items(.data)[node_index].nary;
                        const children = self.extra_children.items[data.offset..][0..data.len];
                        var bits: u6 = 0;
                        for (children) |child| {
                            bits += try self.infer_and_check_node_bit_width(slice, child);
                        }

                        slice.items(.result_bits)[node_index] = bits;
                        return bits;
                    },

                    .multi_extract, .multi_extract_be, .multi_extract_le => {
                        const data = slice.items(.data)[node_index].nary;
                        const children = self.extra_children.items[data.offset..][0..data.len];
                        const bus_bits = try self.infer_and_check_node_bit_width(slice, children[0]);
                        const endianness: ?std.builtin.Endian = switch (slice.items(.kind)[node_index]) {
                            .multi_extract => null,
                            .multi_extract_be => .big,
                            .multi_extract_le => .little,
                            else => unreachable,
                        };
                        var prev_index: ?u6 = null;
                        var extracted_bits: u6 = 0;
                        for (children[1..]) |child| {
                            const child_bits, prev_index = try self.validate_and_count_bit_indices(slice, child, children[0], bus_bits, prev_index, endianness);
                            extracted_bits += child_bits;
                        }

                        slice.items(.result_bits)[node_index] = extracted_bits;
                        return extracted_bits;
                    },
                }
            }

            fn validate_and_count_bit_indices(self: *Parse_Data, slice: std.MultiArrayList(Node).Slice, node: Node.ID, bus_node: Node.ID, bus_bits: u6, prev_index: ?u6, endianness: ?std.builtin.Endian) !struct { u6, u6 } {
                const node_index = @intFromEnum(node);
                switch (slice.items(.kind)[node_index]) {
                    .literal => {
                        const value: u6 = @intCast(slice.items(.data)[node_index].literal); // range has already been checked at parse time
                        if (value >= bus_bits) {
                            self.report_node_error_fmt_2(
                                node, "Bit index out of range", .{},
                                bus_node, "Bus has width of {} bits", .{ bus_bits });
                            return error.InvalidEquation;
                        }
                        if (prev_index) |prev| {
                            if (endianness == null and value > prev) {
                                self.report_node_error_fmt(node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{});
                                return error.InvalidEquation;
                            }
                        }
                        return .{ 1, value };
                    },
                    .bit_range => {
                        const range = slice.items(.data)[node_index].bit_range;

                        const first = range.first orelse if (endianness) |e| switch (e) {
                            .little => 0,
                            .big => bus_bits - 1,
                        } else bus_bits - 1;
                        if (first >= bus_bits) {
                            self.report_node_error_fmt_2(
                                node, "First bit index out of range", .{},
                                bus_node, "Bus has width of {} bits", .{ bus_bits });
                            return error.InvalidEquation;
                        }

                        const last = range.last orelse if (endianness) |e| switch (e) {
                            .little => bus_bits - 1,
                            .big => 0,
                        } else 0;
                        if (last >= bus_bits) {
                            self.report_node_error_fmt_2(
                                node, "Last bit index out of range", .{},
                                bus_node, "Bus has width of {} bits", .{ bus_bits });
                            return error.InvalidEquation;
                        }

                        if (prev_index) |prev| {
                            if (endianness == null and first > prev) {
                                self.report_node_error_fmt(node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{});
                                return error.InvalidEquation;
                            }
                        }

                        if (endianness == null and last > first) {
                            self.report_node_error_fmt(node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{});
                            return error.InvalidEquation;
                        }

                        return .{ @intCast(@abs(@as(i32, last) - first) + 1), last };
                    },
                    else => unreachable,
                }
            }

            pub fn build_ir(self: *Parse_Data, irdata: *IR_Data, bit_index: u6) !IR.ID {
                const slice = self.nodes.slice();
                return try self.build_node_ir(irdata, slice, self.root.?, bit_index);
            }
            fn build_node_ir(self: *Parse_Data, irdata: *IR_Data, slice: std.MultiArrayList(Node).Slice, node: Node.ID, bit_index: u6) !IR.ID {
                const node_index = @intFromEnum(node);
                const data = slice.items(.data)[node_index];
                const result_bits: []?u6 = slice.items(.result_bits);
                switch (slice.items(.kind)[node_index]) {
                    .literal => {
                        std.debug.assert(bit_index < result_bits[node_index].?);
                        const value: u1 = @truncate(data.literal >> bit_index);
                        return switch (value) {
                            0 => .zero,
                            1 => .one,
                        };
                    },

                    .signal => {
                        std.debug.assert(bit_index == 0);
                        return try irdata.make_signal(@intFromEnum(data.signal));
                    },

                    .bus_ref => {
                        const bus = data.bus_ref[0..result_bits[node_index].?];
                        return try irdata.make_signal(@intFromEnum(bus[bit_index]));
                    },

                    .complement => {
                        const inner = try self.build_node_ir(irdata, slice, data.unary, bit_index);
                        return try irdata.make_complement(inner);
                    },

                    .unary_sum => {
                        std.debug.assert(bit_index == 0);
                        var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                        for (1..result_bits[@intFromEnum(data.unary)].?) |inner_bit_index| {
                            const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                            result = try irdata.make_binary(.sum, result, inner);
                        }
                        return result;
                    },

                    .unary_product => {
                        std.debug.assert(bit_index == 0);
                        var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                        for (1..result_bits[@intFromEnum(data.unary)].?) |inner_bit_index| {
                            const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                            result = try irdata.make_binary(.product, result, inner);
                        }
                        return result;
                    },
                    .unary_xor => {
                        std.debug.assert(bit_index == 0);
                        var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                        for (1..result_bits[@intFromEnum(data.unary)].?) |inner_bit_index| {
                            const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                            result = try irdata.make_binary(.xor, result, inner);
                        }
                        return result;
                    },
                    .subexpr => {
                        return try self.build_node_ir(irdata, slice, data.unary, bit_index);
                    },

                    .equals => {
                        std.debug.assert(bit_index == 0);
                        const lhs0 = try self.build_node_ir(irdata, slice, data.binary.lhs, 0);
                        const rhs0 = try self.build_node_ir(irdata, slice, data.binary.rhs, 0);
                        var result = try irdata.make_binary(.xor, lhs0, rhs0);
                        result = try irdata.make_complement(result);
                        for (1..result_bits[@intFromEnum(data.binary.lhs)].?) |inner_bit_index| {
                            const lhs = try self.build_node_ir(irdata, slice, data.binary.lhs, @intCast(inner_bit_index));
                            const rhs = try self.build_node_ir(irdata, slice, data.binary.rhs, @intCast(inner_bit_index));
                            const xor = try irdata.make_binary(.xor, lhs, rhs);
                            const xnor = try irdata.make_complement(xor);
                            result = try irdata.make_binary(.product, result, xnor);
                        }
                        return result;
                    },

                    .not_equals => {
                        std.debug.assert(bit_index == 0);
                        const lhs0 = try self.build_node_ir(irdata, slice, data.binary.lhs, 0);
                        const rhs0 = try self.build_node_ir(irdata, slice, data.binary.rhs, 0);
                        var result = try irdata.make_binary(.xor, lhs0, rhs0);
                        for (1..result_bits[@intFromEnum(data.binary.lhs)].?) |inner_bit_index| {
                            const lhs = try self.build_node_ir(irdata, slice, data.binary.lhs, @intCast(inner_bit_index));
                            const rhs = try self.build_node_ir(irdata, slice, data.binary.rhs, @intCast(inner_bit_index));
                            const xor = try irdata.make_binary(.xor, lhs, rhs);
                            result = try irdata.make_binary(.sum, result, xor);
                        }
                        return result;
                    },

                    .binary_sum => {
                        const lhs = try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index);
                        const rhs = try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index);
                        return try irdata.make_binary(.sum, lhs, rhs);
                    },

                    .binary_product => {
                        const lhs = try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index);
                        const rhs = try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index);
                        return try irdata.make_binary(.product, lhs, rhs);
                    },

                    .binary_xor => {
                        const lhs = try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index);
                        const rhs = try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index);
                        return try irdata.make_binary(.xor, lhs, rhs);
                    },

                    .binary_concat_be => {
                        const rhs_bits = result_bits[@intFromEnum(data.binary.rhs)].?;
                        if (bit_index < rhs_bits) {
                            return try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index);
                        } else {
                            return try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index - rhs_bits);
                        }
                    },

                    .binary_concat_le => {
                        const lhs_bits = result_bits[@intFromEnum(data.binary.lhs)].?;
                        if (bit_index < lhs_bits) {
                            return try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index);
                        } else {
                            return try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index - lhs_bits);
                        }
                    },

                    .extract, .extract_be, .extract_le => {
                        switch (slice.items(.kind)[@intFromEnum(data.binary.rhs)]) {
                            .literal => {
                                std.debug.assert(bit_index == 0);
                                const new_bit_index: u6 = @intCast(slice.items(.data)[@intFromEnum(data.binary.rhs)].literal);
                                return try self.build_node_ir(irdata, slice, data.binary.lhs, new_bit_index);
                            },
                            .bit_range => {
                                const endianness: std.builtin.Endian = if (slice.items(.kind)[node_index] == .extract_le) .little else .big;
                                const range = slice.items(.data)[@intFromEnum(data.binary.rhs)].bit_range;
                                const lhs_bits = slice.items(.result_bits)[@intFromEnum(data.binary.lhs)].?;
                                var first_bit = range.first orelse switch (endianness) {
                                    .big => lhs_bits - 1,
                                    .little => 0,
                                };
                                var last_bit = range.last orelse switch (endianness) {
                                    .big => 0,
                                    .little => lhs_bits - 1,
                                };

                                if (endianness == .big) {
                                    const temp = first_bit;
                                    first_bit = last_bit;
                                    last_bit = temp;
                                }

                                const new_bit_index = if (first_bit < last_bit) first_bit + bit_index else first_bit - bit_index;
                                return try self.build_node_ir(irdata, slice, data.binary.lhs, new_bit_index);
                            },
                            else => unreachable,
                        }
                    },

                    // N-ary
                    .sum => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var result = try self.build_node_ir(irdata, slice, children[0], bit_index);
                        for (children[1..]) |child| {
                            const rhs = try self.build_node_ir(irdata, slice, child, bit_index);
                            result = try irdata.make_binary(.sum, result, rhs);
                        }
                        return result;
                    },
                    .product => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var result = try self.build_node_ir(irdata, slice, children[0], bit_index);
                        for (children[1..]) |child| {
                            const rhs = try self.build_node_ir(irdata, slice, child, bit_index);
                            result = try irdata.make_binary(.product, result, rhs);
                        }
                        return result;
                    },
                    .xor => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var result = try self.build_node_ir(irdata, slice, children[0], bit_index);
                        for (children[1..]) |child| {
                            const rhs = try self.build_node_ir(irdata, slice, child, bit_index);
                            result = try irdata.make_binary(.xor, result, rhs);
                        }
                        return result;
                    },
                    .concat_be => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var remaining_bit_index = bit_index;
                        for (0..children.len) |child_index| {
                            const child = children[children.len - child_index - 1];
                            const child_bits = result_bits[@intFromEnum(child)].?;
                            if (remaining_bit_index < child_bits) {
                                return try self.build_node_ir(irdata, slice, child, remaining_bit_index);
                            } else {
                                remaining_bit_index -= child_bits;
                            }
                        }
                        unreachable; // if we reach here bit_index was out of range
                    },
                    .concat_le => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var remaining_bit_index = bit_index;
                        for (children) |child| {
                            const child_bits = result_bits[@intFromEnum(child)].?;
                            if (remaining_bit_index < child_bits) {
                                return try self.build_node_ir(irdata, slice, child, remaining_bit_index);
                            } else {
                                remaining_bit_index -= child_bits;
                            }
                        }
                        unreachable; // if we reach here bit_index was out of range
                    },
                    .multi_extract_le => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var remaining_bit_index: u6 = bit_index;
                        for (children[1..]) |child| {
                            switch (slice.items(.kind)[@intFromEnum(child)]) {
                                .literal => {
                                    if (remaining_bit_index == 0) {
                                        const new_bit_index: u6 = @intCast(slice.items(.data)[@intFromEnum(child)].literal);
                                        return try self.build_node_ir(irdata, slice, children[0], new_bit_index);
                                    } else {
                                        remaining_bit_index -= 1;
                                    }
                                },
                                .bit_range => {
                                    const range = slice.items(.data)[@intFromEnum(child)].bit_range;
                                    const lhs_bits = slice.items(.result_bits)[@intFromEnum(children[0])].?;
                                    const first_bit = range.first orelse 0;
                                    const last_bit = range.last orelse lhs_bits - 1;
                                    const range_bits = @max(first_bit, last_bit) - @min(first_bit, last_bit) + 1;
                                    if (remaining_bit_index < range_bits) {
                                        const new_bit_index = if (first_bit < last_bit) first_bit + remaining_bit_index else first_bit - remaining_bit_index;
                                        return try self.build_node_ir(irdata, slice, children[0], new_bit_index);
                                    } else {
                                        remaining_bit_index -= range_bits;
                                    }
                                },
                                else => unreachable,
                            }
                        }
                        unreachable; // if we reach here bit_index was out of range
                    },
                    .multi_extract, .multi_extract_be => {
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                        var remaining_bit_index: u6 = bit_index;
                        for (1..children.len) |child_offset| {
                            const child = children[children.len - child_offset];
                            switch (slice.items(.kind)[@intFromEnum(child)]) {
                                .literal => {
                                    if (remaining_bit_index == 0) {
                                        const new_bit_index: u6 = @intCast(slice.items(.data)[@intFromEnum(child)].literal);
                                        return try self.build_node_ir(irdata, slice, children[0], new_bit_index);
                                    } else {
                                        remaining_bit_index -= 1;
                                    }
                                },
                                .bit_range => {
                                    const range = slice.items(.data)[@intFromEnum(child)].bit_range;
                                    const lhs_bits = slice.items(.result_bits)[@intFromEnum(children[0])].?;
                                    const first_bit = range.first orelse lhs_bits - 1;
                                    const last_bit = range.last orelse 0;
                                    const range_bits = @max(first_bit, last_bit) - @min(first_bit, last_bit) + 1;
                                    if (remaining_bit_index < range_bits) {
                                        const new_bit_index = if (first_bit > last_bit) last_bit + remaining_bit_index else last_bit - remaining_bit_index;
                                        return try self.build_node_ir(irdata, slice, children[0], new_bit_index);
                                    } else {
                                        remaining_bit_index -= range_bits;
                                    }
                                },
                                else => unreachable,
                            }
                        }
                        unreachable; // if we reach here bit_index was out of range
                    },

                    .bit_range => unreachable,
                }
            }

            pub fn debug(self: *Parse_Data, w: std.io.AnyWriter) !void {
                const slice = self.nodes.slice();
                try self.debug_node(slice, self.root, 0, w);
            }
            fn debug_node(self: *Parse_Data, slice: std.MultiArrayList(Node).Slice, maybe_node: ?Node.ID, indent: usize, w: std.io.AnyWriter) !void {
                if (maybe_node) |node| {
                    const node_index = @intFromEnum(node);
                    const kind = slice.items(.kind)[node_index];
                    const start_offset = slice.items(.begin_token_offset)[node_index];
                    const end_token_offset = slice.items(.end_token_offset)[node_index];
                    const end_offset = end_token_offset + token_span(self.eqn, end_token_offset).len;

                    try w.print("{d}-{d} {s}", .{ start_offset, end_offset, @tagName(kind) });

                    const result_bits = slice.items(.result_bits)[node_index];
                    if (result_bits) |bits| {
                        try w.print(" ({d}b)", .{ bits });
                    }

                    const data = slice.items(.data)[node_index];
                    switch (kind) {
                        .literal => {
                            try w.print(" 0b{b}\n", .{ data.literal });
                        },
                        .bit_range => {
                            try w.print(" {?}:{?}\n", .{ data.bit_range.first, data.bit_range.last });
                        },
                        .signal => {
                            try w.print(" {s}\n", .{ @tagName(data.signal) });
                        },
                        .bus_ref => {
                            if (result_bits) |bits| {
                                try w.writeAll(" <");
                                for (data.bus_ref[0..bits]) |signal| {
                                    try w.print(" {s}", .{ @tagName(signal) });
                                }
                                try w.writeByte('\n');
                            } else {
                                try w.print(" #{X:0>16}\n", .{ @intFromPtr(data.bus_ref) });
                            }
                        },
                        .complement, .unary_sum, .unary_product, .unary_xor, .subexpr => {
                            try w.writeAll(": ");
                            try self.debug_node(slice, data.unary, indent, w);
                        },
                        .equals, .not_equals, .binary_sum, .binary_product, .binary_xor, .binary_concat_be, .binary_concat_le, .extract, .extract_be, .extract_le => {
                            try w.writeAll(":\n");
                            const new_indent = indent + 1;

                            try w.writeByteNTimes(' ', new_indent * 3);
                            try w.writeAll("[0] ");
                            try self.debug_node(slice, data.binary.lhs, new_indent, w);

                            try w.writeByteNTimes(' ', new_indent * 3);
                            try w.writeAll("[1] ");
                            try self.debug_node(slice, data.binary.rhs, new_indent, w);
                        },
                        .sum, .product, .xor, .concat_be, .concat_le, .multi_extract, .multi_extract_be, .multi_extract_le => {
                            try w.writeAll(":\n");
                            const new_indent = indent + 1;
                            const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];

                            for (children, 0..) |child, i| {
                                try w.writeByteNTimes(' ', new_indent * 3);
                                try w.print("[{d}] ", .{ i });
                                try self.debug_node(slice, child, new_indent, w);
                            }
                        },
                    }
                } else {
                    try w.writeAll("null\n");
                }
            }

            // product
            // product | product ...
            // product + product ...
            // product ^ product ...
            fn try_sum(self: *Parse_Data) Parse_Error!?Node.ID {
                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

                if (try self.try_product()) |lhs| {
                    try self.temp_nodes.append(self.gpa, lhs);

                    while (true) {
                        var stop_parsing = true;

                        var operator_token = self.next_token;
                        if (self.try_token(.sum)) {
                            stop_parsing = false;
                            while (try self.try_product()) |rhs| {
                                try self.temp_nodes.append(self.gpa, rhs);
                                operator_token = self.next_token;
                                if (!self.try_token(.sum)) break;
                            } else {
                                self.report_token_error_2(self.next_token, "Expected product expression", operator_token, "for OR operator here");
                                return error.InvalidEquation;
                            }

                            const children = self.temp_nodes.items[initial_temp_nodes_len..];
                            const new_node = try self.create_binary_or_nary_node(children, .binary_sum, .sum, .{});
                            self.temp_nodes.items.len = initial_temp_nodes_len;
                            self.temp_nodes.appendAssumeCapacity(new_node);
                        }

                        if (self.try_token(.xor)) {
                            stop_parsing = false;
                            while (try self.try_product()) |rhs| {
                                try self.temp_nodes.append(self.gpa, rhs);
                                operator_token = self.next_token;
                                if (!self.try_token(.xor)) break;
                            } else {
                                self.report_token_error_2(self.next_token, "Expected product expression", operator_token, "for XOR operator here");
                                return error.InvalidEquation;
                            }

                            const children = self.temp_nodes.items[initial_temp_nodes_len..];
                            const new_node = try self.create_binary_or_nary_node(children, .binary_xor, .xor, .{});
                            self.temp_nodes.items.len = initial_temp_nodes_len;
                            self.temp_nodes.appendAssumeCapacity(new_node);
                        }

                        if (stop_parsing) break;
                    }

                    std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len + 1);
                    const final_node = self.temp_nodes.items[initial_temp_nodes_len];
                    self.temp_nodes.items.len = initial_temp_nodes_len;
                    return final_node;
                }
                return null;
            }

            // equality
            // equality & equality ...
            // equality * equality ...
            fn try_product(self: *Parse_Data) Parse_Error!?Node.ID {
                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

                if (try self.try_equality()) |lhs| {
                    try self.temp_nodes.append(self.gpa, lhs);

                    while (self.try_token(.product)) {
                        const operator_token = self.next_token - 1;
                        if (try self.try_equality()) |rhs| {
                            try self.temp_nodes.append(self.gpa, rhs);
                        } else {
                            self.report_token_error_2(self.next_token, "Expected comparison expression", operator_token, "for AND operator here");
                            return error.InvalidEquation;
                        }
                    }

                    const children = self.temp_nodes.items[initial_temp_nodes_len..];
                    const final_node = if (children.len == 1) children[0] else try self.create_binary_or_nary_node(children, .binary_product, .product, .{});
                    self.temp_nodes.items.len = initial_temp_nodes_len;
                    return final_node;
                }
                return null;
            }

            // unary
            // equality == unary
            // equality != unary
            fn try_equality(self: *Parse_Data) Parse_Error!?Node.ID {
                var result: ?Node.ID = null;
                if (try self.try_unary()) |lhs| {
                    result = lhs;

                    while (true) {
                        const operator_token = self.next_token;
                        if (self.try_token(.equals)) {
                            if (try self.try_unary()) |rhs| {
                                result = try self.create_binary_node(result.?, rhs, .equals, .{});
                            } else {
                                self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for equality operator here");
                                return error.InvalidEquation;
                            }
                            continue;
                        } else if (self.try_token(.not_equals)) {
                            if (try self.try_unary()) |rhs| {
                                result = try self.create_binary_node(result.?, rhs, .not_equals, .{});
                            } else {
                                self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for inequality operator here");
                                return error.InvalidEquation;
                            }
                            continue;
                        }

                        break;
                    }
                }
                return result;
            }

            // extraction
            // |unary
            // +unary
            // ^unary
            // &unary
            // *unary
            // ~unary
            // !unary
            fn try_unary(self: *Parse_Data) Parse_Error!?Node.ID {
                const operator_token = self.next_token;
                switch (self.peek_token()) {
                    .sum => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for reduction OR here");
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_sum, .{ .token_offset = offset });
                    },
                    .xor => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for reduction XOR here");
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_xor, .{ .token_offset = offset });
                    },
                    .product => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for reduction AND here");
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_product, .{ .token_offset = offset });
                    },
                    .complement => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            self.report_token_error_2(self.next_token, "Expected unary expression", operator_token, "for complement here");
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .complement, .{ .token_offset = offset });
                    },
                    else => return try self.try_extraction(),
                }
            }

            // atom
            // atom extract
            fn try_extraction(self: *Parse_Data) Parse_Error!?Node.ID {
                var result: ?Node.ID = null;
                if (try self.try_atom()) |lhs| {
                    result = lhs;

                    while (try self.try_extract(result.?)) |new_result| {
                        result = new_result;
                    }
                }
                return result;
            }

            // lhs [ literal_range ]
            // lhs [ > literal_range ]
            // lhs [ < literal_range ]
            // lhs [ literal_range > ]
            // lhs [ literal_range < ]
            // lhs [ literal_range literal_range ... ]
            // lhs [ > literal_range literal_range ... ]
            // lhs [ < literal_range literal_range ... ]
            // lhs [ literal_range > literal_range ... ]
            // lhs [ literal_range < literal_range ... ]
            // lhs [ > literal_range > literal_range ... ]
            // lhs [ < literal_range < literal_range ... ]
            fn try_extract(self: *Parse_Data, lhs: Node.ID) Parse_Error!?Node.ID {
                const begin_token = self.next_token;
                if (!self.try_token(.begin_extract)) return null;

                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

                try self.temp_nodes.append(self.gpa, lhs);

                var maybe_endianness: ?std.builtin.Endian = null;
                var first_endianness_token: u32 = 0;

                while (!self.try_token(.end_extract)) {
                    if (try self.try_bit_range()) |node| {
                        try self.temp_nodes.append(self.gpa, node);
                    } else if (self.try_token(.little_endian)) {
                        if (maybe_endianness) |endianness| {
                            if (endianness == .big) {
                                self.report_token_error_2(self.next_token - 1, "Can't select little-endian mode here", first_endianness_token, "big-endian was previously requested here");
                                return error.InvalidEquation;
                            }
                        } else {
                            maybe_endianness = .little;
                            first_endianness_token = self.next_token - 1;
                        }
                    } else if (self.try_token(.big_endian)) {
                        if (maybe_endianness) |endianness| {
                            if (endianness == .little) {
                                self.report_token_error_2(self.next_token - 1, "Can't select big-endian mode here", first_endianness_token, "little-endian was previously requested here");
                                return error.InvalidEquation;
                            }
                        } else {
                            maybe_endianness = .big;
                            first_endianness_token = self.next_token - 1;
                        }
                    } else {
                        if (self.temp_nodes.items.len > initial_temp_nodes_len + 1) {
                            self.report_token_error_2(self.next_token, "Expected bit literal or range, or closing ']'", begin_token, "for extraction beginning here");
                        } else {
                            self.report_token_error_2(self.next_token, "Expected bit literal or range", begin_token, "for extraction beginning here");
                        }
                        return error.InvalidEquation;
                    }
                }

                const create_options: Create_Node_Options = .{
                    .end_token_offset = self.token_offsets[self.next_token - 1],
                };

                const children = self.temp_nodes.items[initial_temp_nodes_len..];
                if (children.len < 2) {
                    self.report_token_error_2(self.next_token - 1, "Expected at least one bit literal or range", begin_token, "for extraction beginning here");
                    return error.InvalidEquation;
                }
                const new_node = if (maybe_endianness) |e| switch (e) {
                    .big => try self.create_binary_or_nary_node(children, .extract_be, .multi_extract_be, create_options),
                    .little => try self.create_binary_or_nary_node(children, .extract_le, .multi_extract_le, create_options),
                } else try self.create_binary_or_nary_node(children, .extract, .multi_extract, create_options);
                self.temp_nodes.items.len = initial_temp_nodes_len;
                return new_node;
            }

            fn try_bit_range(self: *Parse_Data) Parse_Error!?Node.ID {
                const token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.literal)) {
                    const text = token_span(self.eqn, token_offset);
                    const lit = Literal.parse(text) catch |err| {
                        switch (err) {
                            error.Overflow => self.report_token_error(self.next_token - 1, "Literal value overflows bit width"),
                            error.InvalidCharacter => self.report_token_error(self.next_token - 1, "Invalid literal"),
                        }
                        return error.InvalidEquation;
                    };

                    const first_bit_index = std.math.cast(u6, lit.value) orelse {
                        self.report_token_error(self.next_token - 1, "Bit index is too large");
                        return error.InvalidEquation;
                    };

                    if (self.try_token(.range)) {
                        const end_token_offset = self.token_offsets[self.next_token];
                        if (self.try_token(.literal)) {
                            const text2 = token_span(self.eqn, end_token_offset);
                            const lit2 = Literal.parse(text2) catch |err| {
                                switch (err) {
                                    error.Overflow => self.report_token_error(self.next_token - 1, "Literal value overflows bit width"),
                                    error.InvalidCharacter => self.report_token_error(self.next_token - 1, "Invalid literal"),
                                }
                                return error.InvalidEquation;
                            };

                            const last_bit_index = std.math.cast(u6, lit2.value) orelse {
                                self.report_token_error(self.next_token - 1, "Bit index is too large");
                                return error.InvalidEquation;
                            };

                            return try self.create_bit_range_node(first_bit_index, last_bit_index, token_offset, end_token_offset);
                        } else {
                            return try self.create_bit_range_node(first_bit_index, null, token_offset, self.token_offsets[self.next_token - 1]);
                        }
                    } else {
                        return try self.create_literal_node(lit, token_offset);
                    }
                } else if (self.try_token(.range)) {
                    const end_token_offset = self.token_offsets[self.next_token];
                    if (self.try_token(.literal)) {
                        const text2 = token_span(self.eqn, end_token_offset);
                        const lit2 = Literal.parse(text2) catch |err| {
                            switch (err) {
                                error.Overflow => self.report_token_error(self.next_token - 1, "Literal value overflows bit width"),
                                error.InvalidCharacter => self.report_token_error(self.next_token - 1, "Invalid literal"),
                            }
                            return error.InvalidEquation;
                        };

                        const last_bit_index = std.math.cast(u6, lit2.value) orelse {
                            self.report_token_error(self.next_token - 1, "Bit index is too large");
                            return error.InvalidEquation;
                        };

                        return try self.create_bit_range_node(null, last_bit_index, token_offset, end_token_offset);
                    } else {
                        return try self.create_bit_range_node(null, null, token_offset, self.token_offsets[self.next_token - 1]);
                    }
                }
                return null;
            }

            // ref
            // literal
            // paren_expr
            // concat
            fn try_atom(self: *Parse_Data) Parse_Error!?Node.ID {
                return switch (self.peek_token()) {
                    .id => try self.try_ref(),
                    .literal => try self.try_literal(),
                    .begin_subexpr => try self.try_paren_expr(),
                    .begin_concat => try self.try_concat(),
                    else => null,
                };
            }

            fn try_ref(self: *Parse_Data) Parse_Error!?Node.ID {
                const token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.id)) {
                    const text = token_span(self.eqn, token_offset);
                    if (self.names.lookup_bus(text)) |bus| {
                        return try self.create_bus_ref_node(bus, token_offset);
                    } else if (self.names.lookup_signal(text)) |signal| {
                        return try self.create_signal_node(signal, token_offset);
                    } else {
                        self.report_token_error(self.next_token - 1, "Undefined signal/bus");
                        return error.InvalidEquation;
                    }
                }
                return null;
            }

            fn try_literal(self: *Parse_Data) Parse_Error!?Node.ID {
                const token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.literal)) {
                    const text = token_span(self.eqn, token_offset);
                    const lit = Literal.parse(text) catch |err| {
                        switch (err) {
                            error.Overflow => self.report_token_error(self.next_token - 1, "Literal value overflows bit width"),
                            error.InvalidCharacter => self.report_token_error(self.next_token - 1, "Invalid literal"),
                        }
                        return error.InvalidEquation;
                    };
                    return try self.create_literal_node(lit, token_offset);
                }
                return null;
            }

            // ( sum )
            fn try_paren_expr(self: *Parse_Data) Parse_Error!?Node.ID {
                const begin_token = self.next_token;
                const begin_token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.begin_subexpr)) {
                    const inner = (try self.try_sum()) orelse {
                        self.report_token_error_2(self.next_token, "Expected sum expression", begin_token, "for parenthesis here");
                        return error.InvalidEquation;
                    };
                    const end_token_offset = self.token_offsets[self.next_token];
                    if (!self.try_token(.end_subexpr)) {
                        self.report_token_error_2(self.next_token, "Expected ')'", begin_token, "for parenthesized subexpression starting here");
                        return error.InvalidEquation;
                    }
                    return try self.create_unary_node(inner, .subexpr, .{
                        .begin_token_offset = begin_token_offset,
                        .end_token_offset = end_token_offset,
                    });
                }
                return null;
            }

            // { sum sum ... }
            // { > sum sum ... }
            // { < sum sum ... }
            // { sum > sum ... }
            // { sum < sum ... }
            // { > sum > sum ... }
            // { < sum < sum ... }
            fn try_concat(self: *Parse_Data) Parse_Error!?Node.ID {
                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

                const begin_token = self.next_token;
                const begin_token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.begin_concat)) {
                    var maybe_endianness: ?std.builtin.Endian = null;
                    var first_endianness_token: u32 = 0;

                    while (!self.try_token(.end_concat)) {
                        if (try self.try_sum()) |node| {
                            try self.temp_nodes.append(self.gpa, node);
                        } else if (self.try_token(.little_endian)) {
                            if (maybe_endianness) |endianness| {
                                if (endianness == .big) {
                                    self.report_token_error_2(self.next_token - 1, "Can't select little-endian mode here", first_endianness_token, "big-endian was previously requested here");
                                    return error.InvalidEquation;
                                }
                            } else {
                                maybe_endianness = .little;
                                first_endianness_token = self.next_token - 1;
                            }
                        } else if (self.try_token(.big_endian)) {
                            if (maybe_endianness) |endianness| {
                                if (endianness == .little) {
                                    self.report_token_error_2(self.next_token - 1, "Can't select big-endian mode here", first_endianness_token, "little-endian was previously requested here");
                                    return error.InvalidEquation;
                                }
                            } else {
                                maybe_endianness = .big;
                                first_endianness_token = self.next_token - 1;
                            }
                        } else {
                            if (self.temp_nodes.items.len > initial_temp_nodes_len + 1) {
                                self.report_token_error_2(self.next_token, "Expected sum expression or closing '}'", begin_token, "for concatenation beginning here");
                            } else {
                                self.report_token_error_2(self.next_token, "Expected sum expression", begin_token, "for concatenation beginning here");
                            }
                            return error.InvalidEquation;
                        }
                    }

                    const create_options: Create_Node_Options = .{
                        .begin_token_offset = begin_token_offset,
                        .end_token_offset = self.token_offsets[self.next_token - 1],
                    };

                    const children = self.temp_nodes.items[initial_temp_nodes_len..];
                    if (children.len < 2) {
                        self.report_token_error_2(self.next_token - 1, "Expected at least two items to concatenate", begin_token, "for concatenation beginning here");
                        return error.InvalidEquation;
                    }
                    const new_node = switch (maybe_endianness orelse .big) {
                        .big => try self.create_binary_or_nary_node(children, .binary_concat_be, .concat_be, create_options),
                        .little => try self.create_binary_or_nary_node(children, .binary_concat_le, .concat_le, create_options),
                    };
                    self.temp_nodes.items.len = initial_temp_nodes_len;
                    return new_node;
                }
                return null;
            }

            fn peek_token(self: *Parse_Data) Token {
                return self.tokens[self.next_token];
            }
            fn consume_token(self: *Parse_Data) void {
                self.next_token += 1;
            }
            fn try_token(self: *Parse_Data, expected: Token) bool {
                if (self.tokens[self.next_token] == expected) {
                    self.next_token += 1;
                    return true;
                } else return false;
            }

            const Create_Node_Options = struct {
                token_offset: ?u32 = null,
                begin_token_offset: ?u32 = null,
                end_token_offset: ?u32 = null,
            };

            fn create_binary_or_nary_node(self: *Parse_Data, children: []const Node.ID, binary_type: Node_Kind, nary_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
                std.debug.assert(children.len >= 1);
                if (children.len == 2) {
                    return self.create_binary_node(children[0], children[1], binary_type, options);
                } else {
                    var begin_token_offset = self.nodes.items(.begin_token_offset)[@intFromEnum(children[0])];
                    var end_token_offset = self.nodes.items(.end_token_offset)[@intFromEnum(children[children.len - 1])];

                    if (options.begin_token_offset orelse options.token_offset) |offset| {
                        begin_token_offset = @min(begin_token_offset, offset);
                    }
                    if (options.end_token_offset orelse options.token_offset) |offset| {
                        end_token_offset = @max(end_token_offset, offset);
                    }

                    const id: Node.ID = @enumFromInt(self.nodes.len);
                    const extra_children_offset = self.extra_children.items.len;
                    try self.extra_children.appendSlice(self.gpa, children);
                    try self.nodes.append(self.gpa, .{
                        .begin_token_offset = begin_token_offset,
                        .end_token_offset = end_token_offset,
                        .kind = nary_type,
                        .data = .{ .nary = .{
                            .offset = @intCast(extra_children_offset),
                            .len = @intCast(children.len),
                        }},
                    });
                    return id;
                }
            }

            fn create_binary_node(self: *Parse_Data, lhs: Node.ID, rhs: Node.ID, node_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
                var begin_token_offset = self.nodes.items(.begin_token_offset)[@intFromEnum(lhs)];
                var end_token_offset = self.nodes.items(.end_token_offset)[@intFromEnum(rhs)];

                if (options.begin_token_offset orelse options.token_offset) |offset| {
                    begin_token_offset = @min(begin_token_offset, offset);
                }
                if (options.end_token_offset orelse options.token_offset) |offset| {
                    end_token_offset = @max(end_token_offset, offset);
                }

                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = begin_token_offset,
                    .end_token_offset = end_token_offset,
                    .kind = node_type,
                    .data = .{ .binary = .{
                        .lhs = lhs,
                        .rhs = rhs,
                    }},
                });
                return id;
            }

            fn create_unary_node(self: *Parse_Data, inner: Node.ID, node_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
                var begin_token_offset = self.nodes.items(.begin_token_offset)[@intFromEnum(inner)];
                var end_token_offset = self.nodes.items(.end_token_offset)[@intFromEnum(inner)];

                if (options.begin_token_offset orelse options.token_offset) |offset| {
                    begin_token_offset = @min(begin_token_offset, offset);
                }
                if (options.end_token_offset orelse options.token_offset) |offset| {
                    end_token_offset = @max(end_token_offset, offset);
                }

                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = begin_token_offset,
                    .end_token_offset = end_token_offset,
                    .kind = node_type,
                    .data = .{ .unary = inner },
                });
                return id;
            }

            fn create_literal_node(self: *Parse_Data, literal: Literal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .literal,
                    .data = .{ .literal = literal.value },
                    .result_bits = literal.bits,
                });
                return id;
            }

            fn create_bit_range_node(self: *Parse_Data, first_bit: ?u6, last_bit: ?u6, begin_token_offset: u32, end_token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = begin_token_offset,
                    .end_token_offset = end_token_offset,
                    .kind = .bit_range,
                    .data = .{ .bit_range = .{
                        .first = first_bit,
                        .last = last_bit,
                    }},
                    .result_bits = 0,
                });
                return id;
            }

            fn create_signal_node(self: *Parse_Data, signal: Device.Signal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .signal,
                    .data = .{ .signal = signal },
                    .result_bits = 1,
                });
                return id;
            }

            fn create_bus_ref_node(self: *Parse_Data, bus: []const Device.Signal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .bus_ref,
                    .data = .{ .bus_ref = bus.ptr },
                    .result_bits = @intCast(bus.len),
                });
                return id;
            }

            fn report_node_error_fmt(self: *Parse_Data, node: Node.ID, comptime format: []const u8, args: anytype) void {
                const w = std.io.getStdErr().writer();
                w.writeAll(" \n") catch {};
                const node_index = @intFromEnum(node);
                const slice = self.nodes.slice();
                const offset = slice.items(.begin_token_offset)[node_index];
                const end_token_offset = slice.items(.end_token_offset)[node_index];
                const len = end_token_offset - offset + token_span(self.eqn, end_token_offset).len;
                const msg = std.fmt.allocPrint(self.gpa, format, args) catch return;
                defer self.gpa.free(msg);
                console.print_context(self.eqn, &.{
                    .{ .offset = offset, .len = len, .note = msg },
                }, w, 160, .{}) catch {};
            }

            fn report_node_error_fmt_2(self: *Parse_Data,
                node: Node.ID, comptime format: []const u8, args: anytype,
                node2: Node.ID, comptime format2: []const u8, args2: anytype,
            ) void {
                const w = std.io.getStdErr().writer();
                w.writeAll(" \n") catch {};
                const slice = self.nodes.slice();

                const node_index = @intFromEnum(node);
                const offset = slice.items(.begin_token_offset)[node_index];
                const end_token_offset = slice.items(.end_token_offset)[node_index];
                const len = end_token_offset - offset + token_span(self.eqn, end_token_offset).len;
                const msg = std.fmt.allocPrint(self.gpa, format, args) catch return;
                defer self.gpa.free(msg);

                const node_index2 = @intFromEnum(node2);
                const offset2 = slice.items(.begin_token_offset)[node_index2];
                const end_token_offset2 = slice.items(.end_token_offset)[node_index2];
                const len2 = end_token_offset2 - offset2 + token_span(self.eqn, end_token_offset2).len;
                const msg2 = std.fmt.allocPrint(self.gpa, format2, args2) catch return;
                defer self.gpa.free(msg2);

                console.print_context(self.eqn, &.{
                    .{ .offset = offset, .len = len, .note = msg },
                    .{ .offset = offset2, .len = len2, .note = msg2, .style = .{ .fg = .yellow }, .note_style = .{ .fg = .yellow } },
                }, w, 160, .{}) catch {};
            }

            fn report_node_error_fmt_3(self: *Parse_Data,
                node: Node.ID, comptime format: []const u8, args: anytype,
                node2: Node.ID, comptime format2: []const u8, args2: anytype,
                node3: Node.ID, comptime format3: []const u8, args3: anytype,
            ) void {
                const w = std.io.getStdErr().writer();
                w.writeAll(" \n") catch {};
                const slice = self.nodes.slice();

                const node_index = @intFromEnum(node);
                const offset = slice.items(.begin_token_offset)[node_index];
                const end_token_offset = slice.items(.end_token_offset)[node_index];
                const len = end_token_offset - offset + token_span(self.eqn, end_token_offset).len;
                const msg = std.fmt.allocPrint(self.gpa, format, args) catch return;
                defer self.gpa.free(msg);

                const node_index2 = @intFromEnum(node2);
                const offset2 = slice.items(.begin_token_offset)[node_index2];
                const end_token_offset2 = slice.items(.end_token_offset)[node_index2];
                const len2 = end_token_offset2 - offset2 + token_span(self.eqn, end_token_offset2).len;
                const msg2 = std.fmt.allocPrint(self.gpa, format2, args2) catch return;
                defer self.gpa.free(msg2);

                const node_index3 = @intFromEnum(node3);
                const offset3 = slice.items(.begin_token_offset)[node_index3];
                const end_token_offset3 = slice.items(.end_token_offset)[node_index3];
                const len3 = end_token_offset3 - offset3 + token_span(self.eqn, end_token_offset3).len;
                const msg3 = std.fmt.allocPrint(self.gpa, format3, args3) catch return;
                defer self.gpa.free(msg3);

                console.print_context(self.eqn, &.{
                    .{ .offset = offset, .len = len, .note = msg, .style = .{ .fg = .yellow }, .note_style = .{ .fg = .yellow } },
                    .{ .offset = offset2, .len = len2, .note = msg2 },
                    .{ .offset = offset3, .len = len3, .note = msg3 },
                }, w, 160, .{}) catch {};
            }

            fn report_token_error(self: *Parse_Data, token: u32, msg: []const u8) void {
                const w = std.io.getStdErr().writer();
                w.writeAll(" \n") catch {};
                const offset = self.token_offsets[token];
                console.print_context(self.eqn, &.{
                    .{
                        .offset = offset,
                        .len = token_span(self.eqn, offset).len,
                        .note = msg,
                    },
                }, w, 160, .{}) catch {};
            }

            fn report_token_error_2(self: *Parse_Data, token: u32, msg: []const u8, note_token: u32, note: []const u8) void {
                const w = std.io.getStdErr().writer();
                w.writeAll(" \n") catch {};
                const offset = self.token_offsets[token];
                const note_offset = self.token_offsets[note_token];
                console.print_context(self.eqn, &.{
                    .{
                        .offset = offset,
                        .len = token_span(self.eqn, offset).len,
                        .note = msg,
                    },
                    .{
                        .offset = note_offset,
                        .len = token_span(self.eqn, note_offset).len,
                        .note = note,
                        .style = .{ .fg = .yellow },
                        .note_style = .{ .fg = .yellow },
                    },
                }, w, 160, .{}) catch {};
            }

        };
    };
}

pub const Token = enum (u8) {
    eof,
    invalid,
    literal,
    id,
    product,
    sum,
    xor,
    complement,
    equals,
    not_equals,
    begin_subexpr,
    end_subexpr,
    begin_concat,
    end_concat,
    begin_extract,
    end_extract,
    range,
    big_endian,
    little_endian,
};

pub const Lex_Error = std.mem.Allocator.Error;

pub fn lex(gpa: std.mem.Allocator, equation: []const u8) Lex_Error!struct { []const Token, []const u32 } {
    const Token_Data = struct {
        what: Token,
        where: u32,
    };
    var data: std.MultiArrayList(Token_Data) = .{};
    defer data.deinit(gpa);

    var chi: u32 = 0;
    while (chi < equation.len) {
        const token: Token = switch (equation[chi]) {
            0...' ' => {
                // whitespace
                chi += 1;
                while (chi < equation.len and equation[chi] <= ' ') chi += 1;
                continue;
            },
            ';' => {
                // comment
                chi += 1;
                while (chi < equation.len and equation[chi] != '\n') chi += 1;
                if (chi < equation.len) chi += 1; // skip final \n
                continue;
            },
            '0' ... '9', '\'', '-', '#', => {
                // literal
                try data.append(gpa, .{ .what = .literal, .where = chi });
                chi += 1;
                while (chi < equation.len and is_literal_char(equation[chi])) chi += 1;
                continue;
            },
            'a' ... 'z', 'A' ... 'Z', '_' => {
                // identifier
                try data.append(gpa, .{ .what = .id, .where = chi });
                chi += 1;
                while (chi < equation.len and is_identifier_char(equation[chi])) chi += 1;
                continue;
            },
            '&' => .product,
            '*' => .product,
            '|' => .sum,
            '+' => .sum,
            '^' => .xor,
            '~' => .complement,
            '=' => t: {
                if (chi + 1 < equation.len and equation[chi + 1] == '=') {
                    chi += 1;
                    break :t .equals;
                } else break :t .invalid;
            },
            '!' => t: {
                if (chi + 1 < equation.len and equation[chi + 1] == '=') {
                    chi += 1;
                    break :t .not_equals;
                } else break :t .complement;
            },
            '(' => .begin_subexpr,
            ')' => .end_subexpr,
            '{' => .begin_concat,
            '}' => .end_concat,
            '[' => .begin_extract,
            ']' => .end_extract,
            ':' => .range,
            '>' => .big_endian,
            '<' => .little_endian,
            else => .invalid,
        };
        try data.append(gpa, .{ .what = token, .where = chi });
        chi += 1;
    }

    try data.append(gpa, .{ .what = .eof, .where = chi });

    const tokens = try gpa.dupe(Token, data.items(.what));
    errdefer gpa.free(tokens);

    const offsets = try gpa.dupe(u32, data.items(.where));
    errdefer gpa.free(offsets);

    return .{ tokens, offsets };
}

pub fn token_span(equation: []const u8, start: u32) []const u8 {
    if (start >= equation.len) return "";

    var end = start + 1;

    switch (equation[start]) {
        0...' ' => {
            // whitespace
            while (end < equation.len and equation[end] <= ' ') end += 1;
        },
        ';' => {
            // comment
            while (end < equation.len and equation[end] != '\n') end += 1;
            if (end < equation.len) end += 1; // skip final \n
        },
        '0' ... '9', '\'', '-', '#' => {
            // literal
            while (end < equation.len and is_literal_char(equation[end])) end += 1;
        },
        'a' ... 'z', 'A' ... 'Z', '_' => {
            // identifier
            while (end < equation.len and is_identifier_char(equation[end])) end += 1;
        },
        '=' => {
            if (start + 1 < equation.len and equation[start + 1] == '=') end += 1;
        },
        '!' => {
            if (start + 1 < equation.len and equation[start + 1] == '=') end += 1;
        },
        else => {},
    }

    return equation[start..end];
}

inline fn is_literal_char(ch: u8) bool {
    return switch (ch) {
        '0' ... '9' => true,
        '\'' => true,
        '_' => true,
        '-' => true,
        'a' ... 'z' => true,
        'A' ... 'Z' => true,
        else => false,
    };
}

inline fn is_identifier_char(ch: u8) bool {
    return switch (ch) {
        '0' ... '9' => true,
        '_' => true,
        'a' ... 'z' => true,
        'A' ... 'Z' => true,
        else => false,
    };
}

pub const Literal = struct {
    value: u64,
    bits: u6,

    pub fn parse(text: []const u8) !Literal {
        var signed_value: i64 = undefined;
        var bits: u6 = 0;

        const value_text = if (std.mem.indexOfScalar(u8, text, '\'')) |sigil| t: {
            if (sigil > 0) {
                const base, const remaining = parse_base(text[0..sigil]);
                bits = try std.fmt.parseUnsigned(u6, remaining, base);
            }
            break :t text[sigil + 1 ..];
        } else text;

        const base, const remaining = parse_base(value_text);
        if (bits == 0) {
            const bits_per_digit: u6 = switch (base) {
                16 => 4,
                8 => 3,
                4 => 2,
                2 => 1,
                else => 0,
            };
            if (bits_per_digit > 0) {
                var num_digits: u6 = 0;
                for (remaining) |ch| {
                    if (ch != '_') num_digits += 1;
                }
                bits = num_digits * bits_per_digit;
            }
        }

        signed_value = try std.fmt.parseInt(i64, remaining, base);
        var unsigned_value: u64 = @bitCast(signed_value);

        if (bits == 0) {
            bits = @intCast(64 - @clz(unsigned_value));
            if (bits == 0) bits = 1;
        } else {
            const mask = @as(u64, std.math.maxInt(u64)) >> @intCast(@as(u7, 64) - bits);
            var masked_value = unsigned_value & mask;
            if (signed_value < 0) masked_value |= ~mask;
            if (masked_value != unsigned_value) return error.Overflow;
            unsigned_value &= mask;
        }

        return .{
            .value = unsigned_value,
            .bits = bits,
        };
    }

    fn parse_base(text: []const u8) struct { u8, []const u8 } {
        const text_without_leading_zero = if (text.len > 1 and text[0] == '0') text[1..] else text;
        if (text_without_leading_zero.len == 0) return .{ 10, "" };
        return switch (text_without_leading_zero[0]) {
            'H', 'h', 'X', 'x', '#' => .{ 16, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
            'D', 'd' => .{ 10, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
            'O', 'o' => .{ 8, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
            'B', 'b' => .{ 2, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
            else => .{ 10, std.mem.trim(u8, text_without_leading_zero, "_") },
        };
    }
};

pub const Node_Kind = enum (u8) {
    literal,
    bit_range,
    signal,
    bus_ref,

    // Unary
    complement,
    unary_sum,
    unary_product,
    unary_xor,
    subexpr,

    // Binary
    equals,
    not_equals,
    binary_sum,
    binary_product,
    binary_xor,
    binary_concat_be,
    binary_concat_le,
    extract,
    extract_be,
    extract_le,

    // N-ary
    sum,
    product,
    xor,
    concat_be,
    concat_le,
    multi_extract, // first child is item being extracted from
    multi_extract_be, // first child is item being extracted from
    multi_extract_le, // first child is item being extracted from
};

const IR = IR_Data.IR;
pub const IR_Data = @import("logic_parser/IR_Data.zig");
const qmc = @import("logic_parser/qmc.zig");
const naming = @import("naming.zig");
const lc4k = @import("lc4k.zig");
const console = @import("console");
const std = @import("std");
