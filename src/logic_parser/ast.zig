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
    pad_signal,
    fb_signal,

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
    mux,

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

pub fn Ast(comptime Device: type) type {
    return struct {
        gpa: std.mem.Allocator,
        eqn: []const u8,
        nodes: std.MultiArrayList(Node) = .empty,
        extra_children: std.ArrayListUnmanaged(Node.ID) = .empty,
        root: Node.ID,

        const Self = @This();

        pub fn parse(gpa: std.mem.Allocator, names: *const Device.Names, equation: []const u8) Parse_Error!Self {
            const tokens, const token_offsets = try lexer.lex(gpa, equation);
            var parser: Parser = .{
                .gpa = gpa,
                .eqn = equation,
                .tokens = tokens,
                .token_offsets = token_offsets,
                .names = names,
            };
            defer parser.deinit();

            const root = (try parser.try_sum()) orelse {
                report_token_error(equation, token_offsets[parser.next_token], "Expected expression");
                return error.InvalidEquation;
            };
            if (!parser.try_token(.eof)) {
                report_token_error(equation, token_offsets[parser.next_token], "Expected end of equation");
                return error.InvalidEquation;
            }

            const nodes = parser.nodes;
            parser.nodes = .empty;

            const extra_children = parser.extra_children;
            parser.extra_children = .empty;

            return .{
                .gpa = gpa,
                .eqn = equation,
                .nodes = nodes,
                .extra_children = extra_children,
                .root = root,
            };
        }

        pub fn deinit(self: *Self) void {
            self.nodes.deinit(self.gpa);
            self.extra_children.deinit(self.gpa);
        }

        pub const Check_Bit_Widths_Options = struct {
            min_result_bits: u6 = 1,
            max_result_bits: u6 = std.math.maxInt(u6),
        };
        pub fn infer_and_check_max_bit(self: *Self, options: Check_Bit_Widths_Options) !u6 {
            const slice = self.nodes.slice();
            const max_bit = try self.infer_and_check_node_max_bit(slice, self.root);
            const width: usize = @as(usize, max_bit) + 1;
            if (width > options.max_result_bits) {
                if (options.max_result_bits == 1) {
                    report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn,
                        self.root, "Result has width of {} bits, but expected width of 1 bit", .{ width }
                    );
                } else {
                    report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn, 
                        self.root, "Result has width of {} bits, but expected width of {} bits or less", .{ width, options.max_result_bits }
                    );
                }
                return error.InvalidEquation;
            } else if (max_bit < options.min_result_bits - 1) {
                if (options.min_result_bits == 1) {
                    report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn,
                        self.root, "Result has width of {} bits, but expected width of at least 1 bit", .{ width }
                    );
                } else {
                    report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn, 
                        self.root, "Result has width of {} bits, but expected width of at least {} bits", .{ width, options.min_result_bits }
                    );
                }
                return error.InvalidEquation;
            }
            return max_bit;
        }
        fn infer_and_check_node_max_bit(self: *Self, slice: std.MultiArrayList(Node).Slice, node: Node.ID) !u6 {
            const node_index = @intFromEnum(node);
            const max_bits = slice.items(.max_bit);
            if (max_bits[node_index]) |max_bit| return max_bit;

            switch (slice.items(.kind)[node_index]) {
                .literal, .bit_range, .signal, .bus_ref => unreachable, // .width should have been set when the node was created

                .complement, .subexpr, .pad_signal, .fb_signal => {
                    const child_node = slice.items(.data)[node_index].unary;
                    const child_max_bit = try self.infer_and_check_node_max_bit(slice, child_node);
                    max_bits[node_index] = child_max_bit;
                    return child_max_bit;
                },

                .unary_sum, .unary_product, .unary_xor => {
                    const child_node = slice.items(.data)[node_index].unary;
                    _ = try self.infer_and_check_node_max_bit(slice, child_node);
                    max_bits[node_index] = 0;
                    return 0;
                },

                .equals, .not_equals => {
                    const data = slice.items(.data)[node_index].binary;
                    const lhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.lhs);
                    const rhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.rhs);
                    if (lhs_max_bit != rhs_max_bit) {
                        report_node_error_fmt_3(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Both sides of a comparison operator must have the same bit width", .{},
                            data.lhs, "Left side has width of {} bits", .{ @as(usize, lhs_max_bit) + 1 },
                            data.rhs, "Right side has width of {} bits", .{ @as(usize, rhs_max_bit) + 1 }
                        );
                        return error.InvalidEquation;
                    }

                    max_bits[node_index] = 0;
                    return 0;
                },

                .binary_sum, .binary_product, .binary_xor => {
                    const data = slice.items(.data)[node_index].binary;
                    const lhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.lhs);
                    const rhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.rhs);
                    if (lhs_max_bit != rhs_max_bit and lhs_max_bit != 0 and rhs_max_bit != 0) {
                        report_node_error_fmt_3(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Both sides of binary operator must have the same bit width, or one side must have a width of 1 bit", .{},
                            data.lhs, "Left side has width of {} bits", .{ @as(usize, lhs_max_bit) + 1 },
                            data.rhs, "Right side has width of {} bits", .{ @as(usize, rhs_max_bit) + 1 }
                        );
                        return error.InvalidEquation;
                    }

                    const max_bit = @max(lhs_max_bit, rhs_max_bit);
                    max_bits[node_index] = max_bit;
                    return max_bit;
                },

                .binary_concat_be, .binary_concat_le => {
                    const data = slice.items(.data)[node_index].binary;
                    const lhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.lhs);
                    const rhs_max_bit = try self.infer_and_check_node_max_bit(slice, data.rhs);

                    max_bits[node_index] = lhs_max_bit + rhs_max_bit + 1;
                    return lhs_max_bit + rhs_max_bit + 1;
                },

                .extract, .extract_be, .extract_le => {
                    const data = slice.items(.data)[node_index].binary;
                    const bus_max_bit = try self.infer_and_check_node_max_bit(slice, data.lhs);
                    const endianness: ?std.builtin.Endian = switch (slice.items(.kind)[node_index]) {
                        .extract => null,
                        .extract_be => .big,
                        .extract_le => .little,
                        else => unreachable,
                    };
                    const extracted_max_bit, _ = try self.validate_and_count_bit_indices(slice, data.rhs, data.lhs, bus_max_bit, null, endianness);

                    max_bits[node_index] = extracted_max_bit;
                    return extracted_max_bit;
                },

                .mux => {
                    const data = slice.items(.data)[node_index].binary;
                    const bus_max_bit = try self.infer_and_check_node_max_bit(slice, data.lhs);
                    const selector_max_bit = try self.infer_and_check_node_max_bit(slice, data.rhs);
                    if (selector_max_bit > 5) {
                        report_node_error_fmt_3(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Multiplexer selector width cannot be greater than 6 bits", .{},
                            data.lhs, "Bus has width of {} bits", .{ @as(usize, bus_max_bit) + 1 },
                            data.rhs, "Selector has width of {} bits", .{ @as(usize, selector_max_bit) + 1 }
                        );
                        return error.InvalidEquation;
                    }
                    const expected_bus_max_bit = (@as(u7, 1) << @intCast(selector_max_bit + 1)) - 1;
                    if (expected_bus_max_bit != bus_max_bit) {
                        report_node_error_fmt_3(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Multiplexer width mismatch", .{},
                            data.lhs, "Bus has width of {} bits (expected {} bits)", .{ @as(usize, bus_max_bit) + 1, @as(usize, expected_bus_max_bit) + 1 },
                            data.rhs, "Selector has width of {} bits", .{ @as(usize, selector_max_bit) + 1 }
                        );
                        return error.InvalidEquation;
                    }

                    max_bits[node_index] = 0;
                    return 0;
                },

                .sum, .product, .xor => {
                    const data = slice.items(.data)[node_index].nary;
                    const children = self.extra_children.items[data.offset..][0..data.len];

                    var bus_max_bit: ?u6 = null;
                    var bus_child: Node.ID = undefined;

                    for (children, 1..) |child, n| {
                        const child_max_bit = try self.infer_and_check_node_max_bit(slice, child);
                        if (child_max_bit != 0) {
                            if (bus_max_bit) |max_bit| {
                                if (max_bit != child_max_bit) {
                                    report_node_error_fmt_3(self.gpa, self.nodes.slice(), self.eqn, 
                                        node, "All items in compound operator must have the same bit width, or a width of 1 bit", .{},
                                        bus_child, "Expected width is {} bits", .{ @as(usize, max_bit) + 1 },
                                        child, "Item {} has width of {} bits", .{ n, @as(usize, child_max_bit) + 1 }
                                    );
                                    return error.InvalidEquation;
                                }
                            } else {
                                bus_max_bit = child_max_bit;
                                bus_child = child;
                            }
                        }
                    }

                    max_bits[node_index] = bus_max_bit orelse 0;
                    return bus_max_bit orelse 0;
                },

                .concat_be, .concat_le => {
                    const data = slice.items(.data)[node_index].nary;
                    const children = self.extra_children.items[data.offset..][0..data.len];
                    var width: u7 = 0;
                    for (children) |child| {
                        width += 1;
                        width += try self.infer_and_check_node_max_bit(slice, child);
                    }

                    const max_bit: u6 = @intCast(width - 1);
                    max_bits[node_index] = max_bit;
                    return max_bit;
                },

                .multi_extract, .multi_extract_be, .multi_extract_le => {
                    const data = slice.items(.data)[node_index].nary;
                    const children = self.extra_children.items[data.offset..][0..data.len];
                    const bus_max_bit = try self.infer_and_check_node_max_bit(slice, children[0]);
                    const endianness: ?std.builtin.Endian = switch (slice.items(.kind)[node_index]) {
                        .multi_extract => null,
                        .multi_extract_be => .big,
                        .multi_extract_le => .little,
                        else => unreachable,
                    };
                    var prev_index: ?u6 = null;
                    var extracted_bits: usize = 0;
                    for (children[1..]) |child| {
                        const child_max_bit, prev_index = try self.validate_and_count_bit_indices(slice, child, children[0], bus_max_bit, prev_index, endianness);
                        extracted_bits += child_max_bit + 1;
                    }

                    const max_bit: u6 = @intCast(extracted_bits - 1);
                    max_bits[node_index] = max_bit;
                    return max_bit;
                },
            }
        }

        fn validate_and_count_bit_indices(self: *Self, slice: std.MultiArrayList(Node).Slice, node: Node.ID, bus_node: Node.ID, bus_max_bit: u6, prev_index: ?u6, endianness: ?std.builtin.Endian) !struct { u6, u6 } {
            const bus_width = @as(usize, bus_max_bit) + 1;
            const node_index = @intFromEnum(node);
            switch (slice.items(.kind)[node_index]) {
                .literal => {
                    const value: u6 = @intCast(slice.items(.data)[node_index].literal); // range has already been checked at parse time
                    if (value > bus_max_bit) {
                        report_node_error_fmt_2(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Bit index out of range", .{},
                            bus_node, "Bus has width of {} bits", .{ bus_width }
                        );
                        return error.InvalidEquation;
                    }
                    if (prev_index) |prev| {
                        if (endianness == null and value > prev) {
                            report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn, 
                                node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{}
                            );
                            return error.InvalidEquation;
                        }
                    }
                    return .{ 0, value };
                },
                .bit_range => {
                    const range = slice.items(.data)[node_index].bit_range;

                    const first = range.first orelse if (endianness) |e| switch (e) {
                        .little => 0,
                        .big => bus_max_bit,
                    } else bus_max_bit;
                    if (first > bus_max_bit) {
                        report_node_error_fmt_2(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "First bit index out of range", .{},
                            bus_node, "Bus has width of {} bits", .{ bus_width }
                        );
                        return error.InvalidEquation;
                    }

                    const last = range.last orelse if (endianness) |e| switch (e) {
                        .little => bus_max_bit,
                        .big => 0,
                    } else 0;
                    if (last > bus_max_bit) {
                        report_node_error_fmt_2(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Last bit index out of range", .{},
                            bus_node, "Bus has width of {} bits", .{ bus_width }
                        );
                        return error.InvalidEquation;
                    }

                    if (prev_index) |prev| {
                        if (endianness == null and first > prev) {
                            report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn, 
                                node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{}
                            );
                            return error.InvalidEquation;
                        }
                    }

                    if (endianness == null and last > first) {
                        report_node_error_fmt(self.gpa, self.nodes.slice(), self.eqn, 
                            node, "Ambiguous extraction; big-endian interpretation would result in extracting bits out of order.  Use '>' or '<' to request big or little endian mode explicitly.", .{}
                        );
                        return error.InvalidEquation;
                    }

                    return .{ @intCast(@abs(@as(i32, last) - first)), last };
                },
                else => unreachable,
            }
        }

        pub fn build_ir(self: *Self, irdata: *IR_Data, bit_index: u6) !IR.ID {
            const slice = self.nodes.slice();
            return try self.build_node_ir(irdata, slice, self.root, bit_index);
        }
        fn build_node_ir(self: *Self, irdata: *IR_Data, slice: std.MultiArrayList(Node).Slice, node: Node.ID, unchecked_bit_index: u6) !IR.ID {
            const node_index = @intFromEnum(node);
            const data = slice.items(.data)[node_index];
            const max_bits: []?u6 = slice.items(.max_bit);
            const bit_index = if (unchecked_bit_index > max_bits[node_index].?) 0 else unchecked_bit_index;

            switch (slice.items(.kind)[node_index]) {
                .literal => {
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
                    const bus = data.bus_ref[0 .. @as(usize, max_bits[node_index].?) + 1];
                    return try irdata.make_signal(@intFromEnum(bus[bit_index]));
                },

                .complement => {
                    const inner = try self.build_node_ir(irdata, slice, data.unary, bit_index);
                    return try irdata.make_complement(inner);
                },

                .unary_sum => {
                    std.debug.assert(bit_index == 0);
                    var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                    for (1 .. @as(usize, max_bits[@intFromEnum(data.unary)].?) + 1) |inner_bit_index| {
                        const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                        result = try irdata.make_binary(.sum, result, inner);
                    }
                    return result;
                },

                .unary_product => {
                    std.debug.assert(bit_index == 0);
                    var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                    for (1 .. @as(usize, max_bits[@intFromEnum(data.unary)].?) + 1) |inner_bit_index| {
                        const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                        result = try irdata.make_binary(.product, result, inner);
                    }
                    return result;
                },
                .unary_xor => {
                    std.debug.assert(bit_index == 0);
                    var result = try self.build_node_ir(irdata, slice, data.unary, 0);
                    for (1 .. @as(usize, max_bits[@intFromEnum(data.unary)].?) + 1) |inner_bit_index| {
                        const inner = try self.build_node_ir(irdata, slice, data.unary, @intCast(inner_bit_index));
                        result = try irdata.make_binary(.xor, result, inner);
                    }
                    return result;
                },
                .subexpr => {
                    return try self.build_node_ir(irdata, slice, data.unary, bit_index);
                },
                .pad_signal => {
                    const ir = try self.build_node_ir(irdata, slice, data.unary, bit_index);
                    return try convert_to_pad_signals(irdata, ir);
                },
                .fb_signal => {
                    const ir = try self.build_node_ir(irdata, slice, data.unary, bit_index);
                    return try convert_to_fb_signals(irdata, ir);
                },

                .equals => {
                    std.debug.assert(bit_index == 0);
                    const lhs0 = try self.build_node_ir(irdata, slice, data.binary.lhs, 0);
                    const rhs0 = try self.build_node_ir(irdata, slice, data.binary.rhs, 0);
                    var result = try irdata.make_binary(.xor, lhs0, rhs0);
                    result = try irdata.make_complement(result);
                    for (1 .. @as(usize, max_bits[@intFromEnum(data.binary.lhs)].?) + 1) |inner_bit_index| {
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
                    for (1 .. @as(usize, max_bits[@intFromEnum(data.binary.lhs)].?) + 1) |inner_bit_index| {
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
                    const rhs_max_bit = max_bits[@intFromEnum(data.binary.rhs)].?;
                    if (bit_index > rhs_max_bit) {
                        return try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index - rhs_max_bit - 1);
                    } else {
                        return try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index);
                    }
                },

                .binary_concat_le => {
                    const lhs_max_bit = max_bits[@intFromEnum(data.binary.lhs)].?;
                    if (bit_index > lhs_max_bit) {
                        return try self.build_node_ir(irdata, slice, data.binary.rhs, bit_index - lhs_max_bit - 1);
                    } else {
                        return try self.build_node_ir(irdata, slice, data.binary.lhs, bit_index);
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
                            const lhs_max_bit = max_bits[@intFromEnum(data.binary.lhs)].?;
                            var first_bit = range.first orelse switch (endianness) {
                                .big => lhs_max_bit,
                                .little => 0,
                            };
                            var last_bit = range.last orelse switch (endianness) {
                                .big => 0,
                                .little => lhs_max_bit,
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

                .mux => {
                    const bus = data.binary.lhs;
                    const selector = data.binary.rhs;
                    const selector_max_bit = max_bits[@intFromEnum(selector)].?;

                    var selector_ir: [6]IR.ID = undefined;
                    var inverted_selector_ir: [6]IR.ID = undefined;
                    for (0 .. @as(usize, selector_max_bit) + 1) |bit| {
                        selector_ir[bit] = try self.build_node_ir(irdata, slice, selector, @intCast(bit));
                        inverted_selector_ir[bit] = try irdata.make_complement(selector_ir[bit]);
                    }

                    var result: ?IR.ID = null;

                    for (0 .. @as(usize, 1) << (selector_max_bit + 1)) |permutation| {
                        var product = try self.build_node_ir(irdata, slice, bus, @intCast(permutation));
                        const permutation_bits: std.StaticBitSet(32) = .{ .mask = @intCast(permutation) };
                        for (0 .. @as(usize, selector_max_bit) + 1) |bit| {
                            const bit_ir = if (permutation_bits.isSet(bit)) selector_ir[bit] else inverted_selector_ir[bit];
                            product = try irdata.make_binary(.product, product, bit_ir);
                        }

                        result = if (result) |lhs| try irdata.make_binary(.sum, lhs, product) else product;
                    }

                    return result.?;
                },

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
                        const child_max_bit = max_bits[@intFromEnum(child)].?;
                        if (remaining_bit_index > child_max_bit) {
                            remaining_bit_index -= child_max_bit;
                            remaining_bit_index -= 1;
                        } else {
                            return try self.build_node_ir(irdata, slice, child, remaining_bit_index);
                        }
                    }
                    unreachable; // if we reach here bit_index was out of range
                },
                .concat_le => {
                    const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];
                    var remaining_bit_index = bit_index;
                    for (children) |child| {
                        const child_max_bit = max_bits[@intFromEnum(child)].?;
                        if (remaining_bit_index > child_max_bit) {
                            remaining_bit_index -= child_max_bit;
                            remaining_bit_index -= 1;
                        } else {
                            return try self.build_node_ir(irdata, slice, child, remaining_bit_index);
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
                                const lhs_max_bit = max_bits[@intFromEnum(children[0])].?;
                                const first_bit = range.first orelse 0;
                                const last_bit = range.last orelse lhs_max_bit;
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
                                const lhs_max_bit = max_bits[@intFromEnum(children[0])].?;
                                const first_bit = range.first orelse lhs_max_bit;
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

        fn convert_to_pad_signals(irdata: *IR_Data, id: IR.ID) !IR.ID {
            switch (irdata.get(id)) {
                .zero, .one => return id,
                .complement => |inner| {
                    const converted = try convert_to_pad_signals(irdata, inner);
                    return if (converted != inner) try irdata.make_complement(converted) else id;
                },
                .signal => |ordinal| {
                    const signal: Device.Signal = @enumFromInt(ordinal);
                    const pad_signal = signal.maybe_pad() orelse signal;
                    return if (pad_signal != signal) try irdata.make_signal(@intFromEnum(pad_signal)) else id;
                },
                .product => |bin| {
                    const lhs = try convert_to_pad_signals(irdata, bin.lhs);
                    const rhs = try convert_to_pad_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.product, lhs, rhs) else id;
                },
                .sum => |bin| {
                    const lhs = try convert_to_pad_signals(irdata, bin.lhs);
                    const rhs = try convert_to_pad_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.sum, lhs, rhs) else id;
                },
                .xor => |bin| {
                    const lhs = try convert_to_pad_signals(irdata, bin.lhs);
                    const rhs = try convert_to_pad_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.xor, lhs, rhs) else id;
                },
            }
        }

        fn convert_to_fb_signals(irdata: *IR_Data, id: IR.ID) !IR.ID {
            switch (irdata.get(id)) {
                .zero, .one => return id,
                .complement => |inner| {
                    const converted = try convert_to_fb_signals(irdata, inner);
                    return if (converted != inner) try irdata.make_complement(converted) else id;
                },
                .signal => |ordinal| {
                    const signal: Device.Signal = @enumFromInt(ordinal);
                    const fb_signal = signal.maybe_fb() orelse signal;
                    return if (fb_signal != signal) try irdata.make_signal(@intFromEnum(fb_signal)) else id;
                },
                .product => |bin| {
                    const lhs = try convert_to_fb_signals(irdata, bin.lhs);
                    const rhs = try convert_to_fb_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.product, lhs, rhs) else id;
                },
                .sum => |bin| {
                    const lhs = try convert_to_fb_signals(irdata, bin.lhs);
                    const rhs = try convert_to_fb_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.sum, lhs, rhs) else id;
                },
                .xor => |bin| {
                    const lhs = try convert_to_fb_signals(irdata, bin.lhs);
                    const rhs = try convert_to_fb_signals(irdata, bin.rhs);
                    return if (lhs != bin.lhs or rhs != bin.rhs) try irdata.make_binary(.xor, lhs, rhs) else id;
                },
            }
        }

        pub fn debug(self: *Self, w: *std.io.Writer) !void {
            const slice = self.nodes.slice();
            try self.debug_node(slice, self.root, 0, w);
        }
        fn debug_node(self: *Self, slice: std.MultiArrayList(Node).Slice, maybe_node: ?Node.ID, indent: usize, w: *std.io.Writer) !void {
            if (maybe_node) |node| {
                const node_index = @intFromEnum(node);
                const kind = slice.items(.kind)[node_index];
                const start_offset = slice.items(.begin_token_offset)[node_index];
                const end_token_offset = slice.items(.end_token_offset)[node_index];
                const end_offset = end_token_offset + token_span(self.eqn, end_token_offset).len;

                try w.print("{d}-{d} {s}", .{ start_offset, end_offset, @tagName(kind) });

                const max_bits = slice.items(.max_bit)[node_index];
                if (max_bits) |bits| {
                    try w.print(" ({d}b)", .{ @as(usize, bits) + 1 });
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
                        if (max_bits) |max_bit| {
                            try w.writeAll(" <");
                            for (data.bus_ref[0 .. @as(usize, max_bit) + 1]) |signal| {
                                try w.print(" {s}", .{ @tagName(signal) });
                            }
                            try w.writeByte('\n');
                        } else {
                            try w.print(" #{X:0>16}\n", .{ @intFromPtr(data.bus_ref) });
                        }
                    },
                    .complement, .unary_sum, .unary_product, .unary_xor, .subexpr, .pad_signal, .fb_signal => {
                        try w.writeAll(": ");
                        try self.debug_node(slice, data.unary, indent, w);
                    },
                    .equals, .not_equals, .binary_sum, .binary_product, .binary_xor, .binary_concat_be, .binary_concat_le, .extract, .extract_be, .extract_le, .mux => {
                        try w.writeAll(":\n");
                        const new_indent = indent + 1;

                        try w.splatByteAll(' ', new_indent * 3);
                        try w.writeAll("[0] ");
                        try self.debug_node(slice, data.binary.lhs, new_indent, w);

                        try w.splatByteAll(' ', new_indent * 3);
                        try w.writeAll("[1] ");
                        try self.debug_node(slice, data.binary.rhs, new_indent, w);
                    },
                    .sum, .product, .xor, .concat_be, .concat_le, .multi_extract, .multi_extract_be, .multi_extract_le => {
                        try w.writeAll(":\n");
                        const new_indent = indent + 1;
                        const children = self.extra_children.items[data.nary.offset..][0..data.nary.len];

                        for (children, 0..) |child, i| {
                            try w.splatByteAll(' ', new_indent * 3);
                            try w.print("[{d}] ", .{ i });
                            try self.debug_node(slice, child, new_indent, w);
                        }
                    },
                }
            } else {
                try w.writeAll("null\n");
            }
        }

        pub const Node = struct {
            begin_token_offset: u32,
            end_token_offset: u32,

            kind: Node_Kind,
            max_bit: ?u6 = null,

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

        pub const Parser = struct {
            gpa: std.mem.Allocator,
            eqn: []const u8,
            tokens: []const Token,
            token_offsets: []const u32,
            next_token: u32 = 0,
            names: *const Device.Names,
            nodes: std.MultiArrayList(Node) = .empty,
            extra_children: std.ArrayListUnmanaged(Node.ID) = .empty,
            temp_nodes: std.ArrayListUnmanaged(Node.ID) = .empty,

            pub fn deinit(self: *Parser) void {
                self.gpa.free(self.tokens);
                self.gpa.free(self.token_offsets);
                self.nodes.deinit(self.gpa);
                self.extra_children.deinit(self.gpa);
                self.temp_nodes.deinit(self.gpa);
            }

            // product
            // product | product ...
            // product + product ...
            // product ^ product ...
            fn try_sum(self: *Parser) Parse_Error!?Node.ID {
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
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected product expression",
                                    self.token_offsets[operator_token], "for OR operator here"
                                );
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
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected product expression",
                                    self.token_offsets[operator_token], "for XOR operator here"
                                );
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
            fn try_product(self: *Parser) Parse_Error!?Node.ID {
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
                            report_token_error_2(self.eqn,
                                self.token_offsets[self.next_token], "Expected comparison expression",
                                self.token_offsets[operator_token], "for AND operator here"
                            );
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
            fn try_equality(self: *Parser) Parse_Error!?Node.ID {
                var result: ?Node.ID = null;
                if (try self.try_unary()) |lhs| {
                    result = lhs;

                    while (true) {
                        const operator_token = self.next_token;
                        if (self.try_token(.equals)) {
                            if (try self.try_unary()) |rhs| {
                                result = try self.create_binary_node(result.?, rhs, .equals, .{});
                            } else {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected unary expression",
                                    self.token_offsets[operator_token], "for equality operator here"
                                );
                                return error.InvalidEquation;
                            }
                            continue;
                        } else if (self.try_token(.not_equals)) {
                            if (try self.try_unary()) |rhs| {
                                result = try self.create_binary_node(result.?, rhs, .not_equals, .{});
                            } else {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected unary expression",
                                    self.token_offsets[operator_token], "for inequality operator here"
                                );
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
            // @pad unary
            // @fb unary
            fn try_unary(self: *Parser) Parse_Error!?Node.ID {
                const operator_token = self.next_token;
                switch (self.peek_token()) {
                    .sum => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            report_token_error_2(self.eqn,
                                self.token_offsets[self.next_token], "Expected unary expression",
                                offset, "for reduction OR here"
                            );
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_sum, .{ .token_offset = offset });
                    },
                    .xor => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            report_token_error_2(self.eqn,
                                self.token_offsets[self.next_token], "Expected unary expression",
                                offset, "for reduction XOR here"
                            );
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_xor, .{ .token_offset = offset });
                    },
                    .product => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            report_token_error_2(self.eqn,
                                self.token_offsets[self.next_token], "Expected unary expression",
                                offset, "for reduction AND here"
                            );
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .unary_product, .{ .token_offset = offset });
                    },
                    .complement => {
                        const offset = self.token_offsets[operator_token];
                        self.consume_token();
                        const inner = (try self.try_unary()) orelse {
                            report_token_error_2(self.eqn,
                                self.token_offsets[self.next_token], "Expected unary expression",
                                offset, "for complement here"
                            );
                            return error.InvalidEquation;
                        };
                        return try self.create_unary_node(inner, .complement, .{ .token_offset = offset });
                    },
                    .builtin => {
                        const token_offset = self.token_offsets[operator_token];
                        const builtin = token_span(self.eqn, token_offset);
                        self.consume_token();
                        if (std.mem.eql(u8, builtin, "@pad")) {
                            const inner = (try self.try_unary()) orelse {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected unary expression",
                                    token_offset, "for builtin here"
                                );
                                return error.InvalidEquation;
                            };
                            return try self.create_unary_node(inner, .pad_signal, .{ .token_offset = token_offset });
                        } else if (std.mem.eql(u8, builtin, "@fb")) {
                            const inner = (try self.try_unary()) orelse {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected unary expression",
                                    token_offset, "for builtin here"
                                );
                                return error.InvalidEquation;
                            };
                            return try self.create_unary_node(inner, .fb_signal, .{ .token_offset = token_offset });
                        } else {
                            report_token_error(self.eqn, token_offset, "Unrecognized builtin; did you mean @pad or @fb?");
                            return error.InvalidEquation;
                        }
                    },
                    else => return try self.try_extraction(),
                }
            }

            // atom
            // atom extract
            fn try_extraction(self: *Parser) Parse_Error!?Node.ID {
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
            // lhs [ sum ]
            fn try_extract(self: *Parser, lhs: Node.ID) Parse_Error!?Node.ID {
                const begin_token = self.next_token;
                if (!self.try_token(.begin_extract)) return null;

                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

                try self.temp_nodes.append(self.gpa, lhs);

                var maybe_endianness: ?std.builtin.Endian = null;
                var first_endianness_token: u32 = 0;
                var is_mux_definition = false;

                while (!self.try_token(.end_extract)) {
                    if (is_mux_definition) {
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token], "Expected closing ']'",
                            self.token_offsets[begin_token], "for mux definition beginning here"
                        );
                        return error.InvalidEquation;
                    }
                    if (try self.try_bit_range()) |node| {
                        try self.temp_nodes.append(self.gpa, node);
                    } else if (self.try_token(.little_endian)) {
                        if (maybe_endianness) |endianness| {
                            if (endianness == .big) {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token - 1], "Can't select little-endian mode here",
                                    self.token_offsets[first_endianness_token], "big-endian was previously requested here"
                                );
                                return error.InvalidEquation;
                            }
                        } else {
                            maybe_endianness = .little;
                            first_endianness_token = self.next_token - 1;
                        }
                    } else if (self.try_token(.big_endian)) {
                        if (maybe_endianness) |endianness| {
                            if (endianness == .little) {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token - 1], "Can't select big-endian mode here",
                                    self.token_offsets[first_endianness_token], "little-endian was previously requested here"
                                );
                                return error.InvalidEquation;
                            }
                        } else {
                            maybe_endianness = .big;
                            first_endianness_token = self.next_token - 1;
                        }
                    } else if (self.temp_nodes.items.len > initial_temp_nodes_len + 1) {
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token], "Expected bit literal or range, or closing ']'",
                            self.token_offsets[begin_token], "for extraction beginning here"
                        );
                        return error.InvalidEquation;
                    } else if (try self.try_sum()) |selector| {
                        try self.temp_nodes.append(self.gpa, selector);
                        is_mux_definition = true;
                    } else {
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token], "Expected bit literal, range, or expression",
                            self.token_offsets[begin_token], "for extraction/mux beginning here"
                        );
                        return error.InvalidEquation;
                    }
                }

                const create_options: Create_Node_Options = .{
                    .end_token_offset = self.token_offsets[self.next_token - 1],
                };

                const children = self.temp_nodes.items[initial_temp_nodes_len..];
                if (children.len < 2) {
                    report_token_error_2(self.eqn,
                        self.token_offsets[self.next_token - 1], "Expected at least one bit literal, range, or expression",
                        self.token_offsets[begin_token], "for extraction/mux beginning here"
                    );
                    return error.InvalidEquation;
                }
                const new_node = if (is_mux_definition)
                    try self.create_binary_node(children[0], children[1], .mux, create_options)
                else if (maybe_endianness) |e| switch (e) {
                    .big => try self.create_binary_or_nary_node(children, .extract_be, .multi_extract_be, create_options),
                    .little => try self.create_binary_or_nary_node(children, .extract_le, .multi_extract_le, create_options),
                } else try self.create_binary_or_nary_node(children, .extract, .multi_extract, create_options);
                self.temp_nodes.items.len = initial_temp_nodes_len;
                return new_node;
            }

            fn try_bit_range(self: *Parser) Parse_Error!?Node.ID {
                const token_offset = self.token_offsets[self.next_token];
                if (try self.try_bit_index()) |first_bit_index| {
                    if (self.try_token(.range)) {
                        if (try self.try_bit_index()) |last_bit_index| {
                            return try self.create_bit_range_node(first_bit_index, last_bit_index, token_offset, self.token_offsets[self.next_token - 1]);
                        } else {
                            return try self.create_bit_range_node(first_bit_index, null, token_offset, self.token_offsets[self.next_token - 1]);
                        }
                    } else {
                        return try self.create_literal_node(.{ .value = first_bit_index, .max_bit_index = 5 }, token_offset);
                    }
                } else if (self.try_token(.range)) {
                    if (try self.try_bit_index()) |last_bit_index| {
                        return try self.create_bit_range_node(null, last_bit_index, token_offset, self.token_offsets[self.next_token - 1]);
                    } else {
                        return try self.create_bit_range_node(null, null, token_offset, self.token_offsets[self.next_token - 1]);
                    }
                }
                return null;
            }

            fn try_bit_index(self: *Parser) Parse_Error!?u6 {
                const begin_token = self.next_token;
                const token_offset = self.token_offsets[self.next_token];
                var maybe_literal = try self.try_raw_literal();

                if (maybe_literal == null and self.try_token(.id)) {
                    const text = token_span(self.eqn, token_offset);
                    if (self.names.lookup_constant(text)) |lit| {
                        maybe_literal = lit;
                    } else {
                        self.next_token = begin_token;
                    }
                }

                if (maybe_literal) |literal| {
                    return std.math.cast(u6, literal.value) orelse {
                        report_token_error(self.eqn, token_offset, "Bit index is too large");
                        return error.InvalidEquation;
                    };
                }

                return null;
            }

            // ref
            // literal
            // paren_expr
            // concat
            fn try_atom(self: *Parser) Parse_Error!?Node.ID {
                return switch (self.peek_token()) {
                    .id => try self.try_ref(),
                    .literal => try self.try_literal(),
                    .begin_subexpr => try self.try_paren_expr(),
                    .begin_concat => try self.try_concat(),
                    else => null,
                };
            }

            fn try_ref(self: *Parser) Parse_Error!?Node.ID {
                const token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.id)) {
                    const text = token_span(self.eqn, token_offset);
                    if (self.names.lookup_constant(text)) |literal| {
                        return try self.create_literal_node(literal, token_offset);
                    } else if (self.names.lookup_bus(text)) |bus| {
                        return try self.create_bus_ref_node(bus, token_offset);
                    } else if (self.names.lookup_signal(text)) |signal| {
                        return try self.create_signal_node(signal, token_offset);
                    } else {
                        report_token_error(self.eqn, token_offset, "Undefined signal/bus/constant");
                        return error.InvalidEquation;
                    }
                }
                return null;
            }

            fn try_literal(self: *Parser) Parse_Error!?Node.ID {
                return if (try self.try_raw_literal()) |lit| try self.create_literal_node(lit, self.token_offsets[self.next_token - 1]) else null;
            }

            fn try_raw_literal(self: *Parser) Parse_Error!?Literal {
                const token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.literal)) {
                    const text = token_span(self.eqn, token_offset);
                    const lit = Literal.parse(text) catch |err| {
                        switch (err) {
                            error.Overflow => report_token_error(self.eqn, token_offset, "Literal value overflows bit width"),
                            error.InvalidCharacter => report_token_error(self.eqn, token_offset, "Invalid literal"),
                        }
                        return error.InvalidEquation;
                    };
                    return lit;
                }
                return null;
            }

            // ( sum )
            fn try_paren_expr(self: *Parser) Parse_Error!?Node.ID {
                const begin_token_offset = self.token_offsets[self.next_token];
                if (self.try_token(.begin_subexpr)) {
                    const inner = (try self.try_sum()) orelse {
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token], "Expected sum expression",
                            begin_token_offset, "for parenthesis here"
                        );
                        return error.InvalidEquation;
                    };
                    const end_token_offset = self.token_offsets[self.next_token];
                    if (!self.try_token(.end_subexpr)) {
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token], "Expected ')'",
                            begin_token_offset, "for parenthesized subexpression starting here"
                        );
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
            fn try_concat(self: *Parser) Parse_Error!?Node.ID {
                const initial_temp_nodes_len = self.temp_nodes.items.len;
                defer std.debug.assert(self.temp_nodes.items.len == initial_temp_nodes_len);
                errdefer self.temp_nodes.items.len = initial_temp_nodes_len;

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
                                    report_token_error_2(self.eqn,
                                        self.token_offsets[self.next_token - 1], "Can't select little-endian mode here",
                                        self.token_offsets[first_endianness_token], "big-endian was previously requested here"
                                    );
                                    return error.InvalidEquation;
                                }
                            } else {
                                maybe_endianness = .little;
                                first_endianness_token = self.next_token - 1;
                            }
                        } else if (self.try_token(.big_endian)) {
                            if (maybe_endianness) |endianness| {
                                if (endianness == .little) {
                                    report_token_error_2(self.eqn,
                                        self.token_offsets[self.next_token - 1], "Can't select big-endian mode here",
                                        self.token_offsets[first_endianness_token], "little-endian was previously requested here"
                                    );
                                    return error.InvalidEquation;
                                }
                            } else {
                                maybe_endianness = .big;
                                first_endianness_token = self.next_token - 1;
                            }
                        } else {
                            if (self.temp_nodes.items.len > initial_temp_nodes_len + 1) {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected sum expression or closing '}'",
                                    begin_token_offset, "for concatenation beginning here"
                                );
                            } else {
                                report_token_error_2(self.eqn,
                                    self.token_offsets[self.next_token], "Expected sum expression",
                                    begin_token_offset, "for concatenation beginning here"
                                );
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
                        report_token_error_2(self.eqn,
                            self.token_offsets[self.next_token - 1], "Expected at least two items to concatenate",
                            begin_token_offset, "for concatenation beginning here"
                        );
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

            fn peek_token(self: *Parser) Token {
                return self.tokens[self.next_token];
            }
            fn consume_token(self: *Parser) void {
                self.next_token += 1;
            }
            fn try_token(self: *Parser, expected: Token) bool {
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

            fn create_binary_or_nary_node(self: *Parser, children: []const Node.ID, binary_type: Node_Kind, nary_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
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

            fn create_binary_node(self: *Parser, lhs: Node.ID, rhs: Node.ID, node_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
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

            fn create_unary_node(self: *Parser, inner: Node.ID, node_type: Node_Kind, options: Create_Node_Options) std.mem.Allocator.Error!Node.ID {
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

            fn create_literal_node(self: *Parser, literal: Literal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .literal,
                    .data = .{ .literal = literal.value },
                    .max_bit = literal.max_bit_index,
                });
                return id;
            }

            fn create_bit_range_node(self: *Parser, first_bit: ?u6, last_bit: ?u6, begin_token_offset: u32, end_token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = begin_token_offset,
                    .end_token_offset = end_token_offset,
                    .kind = .bit_range,
                    .data = .{ .bit_range = .{
                        .first = first_bit,
                        .last = last_bit,
                    }},
                    .max_bit = 5,
                });
                return id;
            }

            fn create_signal_node(self: *Parser, signal: Device.Signal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .signal,
                    .data = .{ .signal = signal },
                    .max_bit = 0,
                });
                return id;
            }

            fn create_bus_ref_node(self: *Parser, bus: []const Device.Signal, token_offset: u32) std.mem.Allocator.Error!Node.ID {
                const id: Node.ID = @enumFromInt(self.nodes.len);
                try self.nodes.append(self.gpa, .{
                    .begin_token_offset = token_offset,
                    .end_token_offset = token_offset,
                    .kind = .bus_ref,
                    .data = .{ .bus_ref = bus.ptr },
                    .max_bit = @intCast(bus.len - 1),
                });
                return id;
            }
        };


        pub fn report_node_error_fmt(gpa: std.mem.Allocator, slice: std.MultiArrayList(Node).Slice, eqn: []const u8, node: Node.ID, comptime format: []const u8, args: anytype) void {
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            w.interface.writeAll(" \n") catch {};

            const node_index = @intFromEnum(node);
            const offset = slice.items(.begin_token_offset)[node_index];
            const end_token_offset = slice.items(.end_token_offset)[node_index];
            const len = end_token_offset - offset + token_span(eqn, end_token_offset).len;
            const msg = std.fmt.allocPrint(gpa, format, args) catch return;
            defer gpa.free(msg);
            console.print_context(eqn, &.{
                .{ .offset = offset, .len = len, .note = msg },
            }, &w.interface, 160, .{}) catch {};
            w.interface.flush() catch {};
        }

        pub fn report_node_error_fmt_2(gpa: std.mem.Allocator, slice: std.MultiArrayList(Node).Slice, eqn: []const u8,
            node: Node.ID, comptime format: []const u8, args: anytype,
            node2: Node.ID, comptime format2: []const u8, args2: anytype,
        ) void {
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            w.interface.writeAll(" \n") catch {};

            const node_index = @intFromEnum(node);
            const offset = slice.items(.begin_token_offset)[node_index];
            const end_token_offset = slice.items(.end_token_offset)[node_index];
            const len = end_token_offset - offset + token_span(eqn, end_token_offset).len;
            const msg = std.fmt.allocPrint(gpa, format, args) catch return;
            defer gpa.free(msg);

            const node_index2 = @intFromEnum(node2);
            const offset2 = slice.items(.begin_token_offset)[node_index2];
            const end_token_offset2 = slice.items(.end_token_offset)[node_index2];
            const len2 = end_token_offset2 - offset2 + token_span(eqn, end_token_offset2).len;
            const msg2 = std.fmt.allocPrint(gpa, format2, args2) catch return;
            defer gpa.free(msg2);

            console.print_context(eqn, &.{
                .{ .offset = offset, .len = len, .note = msg },
                .{ .offset = offset2, .len = len2, .note = msg2, .style = .{ .fg = .yellow }, .note_style = .{ .fg = .yellow } },
            }, &w.interface, 160, .{}) catch {};
            w.interface.flush() catch {};
        }

        pub fn report_node_error_fmt_3(gpa: std.mem.Allocator, slice: std.MultiArrayList(Node).Slice, eqn: []const u8,
            node: Node.ID, comptime format: []const u8, args: anytype,
            node2: Node.ID, comptime format2: []const u8, args2: anytype,
            node3: Node.ID, comptime format3: []const u8, args3: anytype,
        ) void {
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            w.interface.writeAll(" \n") catch {};

            const node_index = @intFromEnum(node);
            const offset = slice.items(.begin_token_offset)[node_index];
            const end_token_offset = slice.items(.end_token_offset)[node_index];
            const len = end_token_offset - offset + token_span(eqn, end_token_offset).len;
            const msg = std.fmt.allocPrint(gpa, format, args) catch return;
            defer gpa.free(msg);

            const node_index2 = @intFromEnum(node2);
            const offset2 = slice.items(.begin_token_offset)[node_index2];
            const end_token_offset2 = slice.items(.end_token_offset)[node_index2];
            const len2 = end_token_offset2 - offset2 + token_span(eqn, end_token_offset2).len;
            const msg2 = std.fmt.allocPrint(gpa, format2, args2) catch return;
            defer gpa.free(msg2);

            const node_index3 = @intFromEnum(node3);
            const offset3 = slice.items(.begin_token_offset)[node_index3];
            const end_token_offset3 = slice.items(.end_token_offset)[node_index3];
            const len3 = end_token_offset3 - offset3 + token_span(eqn, end_token_offset3).len;
            const msg3 = std.fmt.allocPrint(gpa, format3, args3) catch return;
            defer gpa.free(msg3);

            console.print_context(eqn, &.{
                .{ .offset = offset, .len = len, .note = msg, .style = .{ .fg = .yellow }, .note_style = .{ .fg = .yellow } },
                .{ .offset = offset2, .len = len2, .note = msg2 },
                .{ .offset = offset3, .len = len3, .note = msg3 },
            }, &w.interface, 160, .{}) catch {};
            w.interface.flush() catch {};
        }

        pub fn report_token_error(eqn: []const u8, token_offset: u32, msg: []const u8) void {
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            w.interface.writeAll(" \n") catch {};
            console.print_context(eqn, &.{
                .{
                    .offset = token_offset,
                    .len = token_span(eqn, token_offset).len,
                    .note = msg,
                },
            }, &w.interface, 160, .{}) catch {};
            w.interface.flush() catch {};
        }

        pub fn report_token_error_2(eqn: []const u8, token_offset: u32, msg: []const u8, note_token_offset: u32, note: []const u8) void {
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            w.interface.writeAll(" \n") catch {};
            console.print_context(eqn, &.{
                .{
                    .offset = token_offset,
                    .len = token_span(eqn, token_offset).len,
                    .note = msg,
                },
                .{
                    .offset = note_token_offset,
                    .len = token_span(eqn, note_token_offset).len,
                    .note = note,
                    .style = .{ .fg = .yellow },
                    .note_style = .{ .fg = .yellow },
                },
            }, &w.interface, 160, .{}) catch {};
            w.interface.flush() catch {};
        }
    };
}

pub const Parse_Error = error {
    InvalidEquation,
} || std.mem.Allocator.Error;

const IR = IR_Data.IR;
const IR_Data = @import("IR_Data.zig");

const Token = lexer.Token;
const token_span = lexer.token_span;
const lexer = @import("lexer.zig");

const Literal = @import("Literal.zig");

const console = @import("console");
const std = @import("std");
