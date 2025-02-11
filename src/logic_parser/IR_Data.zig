gpa: std.mem.Allocator,
lookup: std.AutoArrayHashMapUnmanaged(IR, void),
merge_temp: std.ArrayListUnmanaged(IR.ID),
normalize_temp: std.AutoArrayHashMapUnmanaged(IR.ID, void),

pub fn init(gpa: std.mem.Allocator) !IR_Data {
    var self: IR_Data = .{
        .gpa = gpa,
        .lookup = .empty,
        .merge_temp = .empty,
        .normalize_temp = .empty,
    };
    try self.lookup.put(gpa, .zero, {});
    try self.lookup.put(gpa, .one, {});
    std.debug.assert(.zero == try self.intern(.zero));
    std.debug.assert(.one == try self.intern(.one));
    return self;
}

pub fn deinit(self: *IR_Data) void {
    self.normalize_temp.deinit(self.gpa);
    self.merge_temp.deinit(self.gpa);
    self.lookup.deinit(self.gpa);
}

pub fn intern(self: *IR_Data, ir: IR) std.mem.Allocator.Error!IR.ID {
    const result = try self.lookup.getOrPut(self.gpa, ir);
    const id = IR.ID.init(@intCast(result.index));
    if (!result.found_existing) {
        result.key_ptr.* = ir;
    }
    return id;
}

pub fn get(self: IR_Data, id: IR.ID) IR {
    return self.lookup.keys()[id.raw()];
}

pub fn debug(self: IR_Data, id: IR.ID, indent: usize, include_ids: bool, w: std.io.AnyWriter) anyerror!void {
    const ir = self.get(id);
    if (include_ids) {
        try w.print("${} {s}", .{ @intFromEnum(id), @tagName(ir) });
    } else {
        try w.writeAll(@tagName(ir));
    }

    switch (ir) {
        .zero, .one => {
            try w.writeByte('\n');
        },
        .signal => |ordinal| {
            try w.print(" {}\n", .{ ordinal });
        },
        .complement => |inner_id| {
            try w.writeAll(": ");
            try self.debug(inner_id, indent, include_ids, w);
        },
        .product, .sum, .xor => |bin| {
            try w.writeAll(":\n");
            var i: usize = 0;
            i = try self.debug_binary(ir, i, bin.lhs, indent + 1, include_ids, w);
            _ = try self.debug_binary(ir, i, bin.rhs, indent + 1, include_ids, w);
        },
    }
}

fn debug_binary(self: IR_Data, kind: IR.Tag, first_index: usize, id: IR.ID, indent: usize, include_ids: bool, w: std.io.AnyWriter) anyerror!usize {
    const ir = self.get(id);
    if (ir == kind) {
        const bin = switch (ir) {
            .product, .sum, .xor => |bin| bin,
            else => unreachable,
        };
        var index = first_index;
        index = try self.debug_binary(kind, index, bin.lhs, indent, include_ids, w);
        index = try self.debug_binary(kind, index, bin.rhs, indent, include_ids, w);
        return index;
    } else {
        try w.writeByteNTimes(' ', indent * 3);
        try w.print("[{}] ", .{ first_index });
        try self.debug(id, indent, include_ids, w);
        return first_index + 1;
    }
}

pub const Normalize_Options = struct {
    max_depth: u16 = 0xFFFF,
    max_xor_depth: u16 = 1,
    demorgan: bool = true,
    distribute: bool = true,
};
pub fn normalize(self: *IR_Data, id: IR.ID, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    if (options.max_depth == 0) return id;

    var options_less_depth = options;
    options_less_depth.max_depth -= 1;
    var options_less_xor = options_less_depth;
    options_less_xor.max_xor_depth -|= 1;

    var last_result: IR.ID = .zero; // If `id` also happens to be .zero, the while loop won't run even once, but by definition .zero is already as simplified as possible
    var result = id;
    while (result != last_result) {
        last_result = result;
        result = switch (self.get(result)) {
            // these are maximally simplified by definition, so we can just return if we reach one:
            .zero, .one, .signal => return result,

            .complement => |inner_id| try self.normalize_complement(result, inner_id, options_less_depth),
            .product => |bin| try self.normalize_product(result, bin, options_less_xor),
            .sum => |bin| try self.normalize_sum(result, bin, options_less_xor),
            .xor => |bin| try self.normalize_xor(result, bin, options_less_depth),
        };
    }
    return result;
}
fn normalize_complement(self: *IR_Data, complement_id: IR.ID, inner_id: IR.ID, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    switch (self.get(inner_id)) {
        // ~~x => x
        .complement => |double_complemented_id| return double_complemented_id,
        
        // ~0 => 1
        .zero => return .one,

        // ~1 => 0
        .one => return .zero,

        // ~(x^y) => x ^ ~y
        .xor => |xor_bin| {
            const not_rhs = try self.make_complement(xor_bin.rhs);
            return try self.make_binary(.xor, xor_bin.lhs, not_rhs);
        },

        // ~(x|y) => ~x & ~y
        .sum => |sum_bin| if (options.demorgan) {
            const not_lhs = try self.make_complement(sum_bin.lhs);
            const not_rhs = try self.make_complement(sum_bin.rhs);
            return try self.make_binary(.product, not_lhs, not_rhs);
        },

        // ~(x&y) => ~x | ~y
        .product => |product_bin| if (options.demorgan) {
            const not_lhs = try self.make_complement(product_bin.lhs);
            const not_rhs = try self.make_complement(product_bin.rhs);
            return try self.make_binary(.sum, not_lhs, not_rhs);
        },

        else => {},
    }

    const inner_normal = try self.normalize(inner_id, options);
    if (inner_id != inner_normal) {
        return try self.make_complement(inner_normal);
    }

    return complement_id;
}
fn normalize_product(self: *IR_Data, product_id: IR.ID, bin: IR.Binary, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    std.debug.assert(self.normalize_temp.count() == 0);
    defer self.normalize_temp.clearRetainingCapacity();

    var rebuild_product = false;
    var sum_factor: ?IR.ID = null;
    var iter = self.iterator(.product, product_id);
    while (iter.next()) |factor| {
        const factor_ir = self.get(factor);
        switch (factor_ir) {
            .zero => return .zero, // 0 & x => 0
            .one => rebuild_product = true,  // 1 & x => x
            else => {
                const complement = try self.make_complement(factor);
                if (self.normalize_temp.contains(complement)) {
                    return .zero; // ~x & x => 0
                }

                const gop = try self.normalize_temp.getOrPut(self.gpa, factor);
                if (gop.found_existing) {
                    rebuild_product = true; // x & x => x
                } else {
                    gop.key_ptr.* = factor;
                }

                if (factor_ir == .sum) sum_factor = factor;
            },
        }
    }

    // (x|y) & x => x
    check_absorbtion: for (0.., self.normalize_temp.keys()) |f1, factor1| {
        for (self.normalize_temp.keys()[f1 + 1 ..]) |factor2| {
            const factor1_or_factor2 = try self.make_binary(.sum, factor1, factor2);
            if (factor1_or_factor2 == factor1) {
                _ = self.normalize_temp.swapRemove(factor1);
                rebuild_product = true;
                break :check_absorbtion;
            }
            if (factor1_or_factor2 == factor2) {
                _ = self.normalize_temp.swapRemove(factor2);
                rebuild_product = true;
                break :check_absorbtion;
            }
        }
    }

    if (rebuild_product) {
        return try self.make_binary_chain_rev(.product, self.normalize_temp.keys());
    }

    if (options.distribute and self.normalize_temp.count() > 1) if (sum_factor) |sum| {
        // (y|z) & x => x&y | x&z
        var product_without_sum: ?IR.ID = null;
        for (self.normalize_temp.keys()) |factor| {
            if (factor == sum) continue;
            product_without_sum = if (product_without_sum) |lhs| try self.make_binary(.product, lhs, factor) else factor;
        }

        var result: ?IR.ID = null;
        var sum_iter = self.iterator(.sum, sum);
        while (sum_iter.next()) |term| {
            const product = try self.make_binary(.product, product_without_sum.?, term);
            result = if (result) |lhs| try self.make_binary(.sum, lhs, product) else product;
        }

        return result.?;
    };

    self.normalize_temp.clearRetainingCapacity();
    return try self.normalize_recursive(.product, product_id, bin, options);
}
fn normalize_sum(self: *IR_Data, sum_id: IR.ID, bin: IR.Binary, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    std.debug.assert(self.normalize_temp.count() == 0);
    defer self.normalize_temp.clearRetainingCapacity();

    var rebuild_sum = false;
    var iter = self.iterator(.sum, sum_id);
    while (iter.next()) |term| {
        const term_ir = self.get(term);
        switch (term_ir) {
            .zero => rebuild_sum = true, // 0 | x => x
            .one => return .one,  // 1 | x => 1
            else => {
                const complement = try self.make_complement(term);
                if (self.normalize_temp.contains(complement)) {
                    return .one; // ~x | x => 1
                }

                const gop = try self.normalize_temp.getOrPut(self.gpa, term);
                if (gop.found_existing) {
                    rebuild_sum = true; // x | x => x
                } else {
                    gop.key_ptr.* = term;
                }
            },
        }
    }

    // x&y | x => x
    check_absorbtion: for (0.., self.normalize_temp.keys()) |t1, term1| {
        for (self.normalize_temp.keys()[t1 + 1 ..]) |term2| {
            const term1_and_term2 = try self.make_binary(.product, term1, term2);
            if (term1_and_term2 == term1) {
                _ = self.normalize_temp.swapRemove(term1);
                rebuild_sum = true;
                break :check_absorbtion;
            }
            if (term1_and_term2 == term2) {
                _ = self.normalize_temp.swapRemove(term2);
                rebuild_sum = true;
                break :check_absorbtion;
            }
        }
    }

    if (rebuild_sum) {
        return try self.make_binary_chain_rev(.sum, self.normalize_temp.keys());
    }

    self.normalize_temp.clearRetainingCapacity();
    return try self.normalize_recursive(.sum, sum_id, bin, options);
}
fn normalize_xor(self: *IR_Data, xor_id: IR.ID, bin: IR.Binary, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    std.debug.assert(self.normalize_temp.count() == 0);
    defer self.normalize_temp.clearRetainingCapacity();

    var rebuild_xor = false;
    var complement_last = false;
    var iter = self.iterator(.xor, xor_id);
    while (iter.next()) |term| {
        const term_ir = self.get(term);
        switch (term_ir) {
            .zero => {
                rebuild_xor = true; // 0 ^ x => x
            },
            .one => {
                complement_last = !complement_last;
                rebuild_xor = true; // 1 ^ x => ~x
            },
            else => {
                if (self.normalize_temp.swapRemove(term)) {
                    rebuild_xor = true; // x ^ x => 0
                } else if (self.normalize_temp.swapRemove(try self.make_complement(term))) {
                    complement_last = !complement_last;
                    rebuild_xor = true; // ~x ^ x => 1
                } else {
                    try self.normalize_temp.put(self.gpa, term, {});
                }
            },
        }
    }

    if (complement_last) std.debug.assert(rebuild_xor);
    if (rebuild_xor) {
        const xor = try self.make_binary_chain_rev(.xor, self.normalize_temp.keys());
        return if (complement_last) try self.make_complement(xor) else xor;
    }

    var options_less_xor = options;
    options_less_xor.max_xor_depth -|= 1;

    self.normalize_temp.clearRetainingCapacity();
    const xor_childnorm = try self.normalize_recursive(.xor, xor_id, bin, options_less_xor);
    if (xor_childnorm != xor_id) return xor_childnorm;

    return try self.normalize_xor_removal(xor_id, bin, options);
}
fn normalize_xor_removal(self: *IR_Data, xor_id: IR.ID, bin: IR.Binary, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    if (options.max_xor_depth == 0) {
        const not_lhs = try self.make_complement(bin.lhs);
        const not_rhs = try self.make_complement(bin.rhs);
        const new_lhs = try self.make_binary(.product, bin.lhs, not_rhs);
        const new_rhs = try self.make_binary(.product, not_lhs, bin.rhs);
        return try self.make_binary(.sum, new_lhs, new_rhs);
    }

    switch (self.get(bin.lhs)) {
        .xor => |inner_bin| {
            var options_less_xor = options;
            options_less_xor.max_xor_depth -|= 1;
            const new_lhs = try self.normalize_xor_removal(bin.lhs, inner_bin, options_less_xor);
            if (new_lhs != bin.lhs) {
                return try self.make_binary(.xor, new_lhs, bin.rhs);
            }
        },
        else => {},
    }

    return xor_id;
}
fn normalize_recursive(self: *IR_Data, comptime kind: IR.Tag, id: IR.ID, bin: IR.Binary, options: Normalize_Options) std.mem.Allocator.Error!IR.ID {
    const lhs = self.get(bin.lhs);
    const lhs_normal = if (lhs == kind) try self.normalize_recursive(kind, bin.lhs, switch (lhs) {
        .xor, .sum, .product => |lhs_bin| lhs_bin,
        else => unreachable,
    }, options) else try self.normalize(bin.lhs, options);

    const rhs_normal = try self.normalize(bin.rhs, options);

    if (bin.lhs != lhs_normal or bin.rhs != rhs_normal) {
        return try self.make_binary(kind, lhs_normal, rhs_normal);
    }

    return id;
}

pub fn evaluate(self: *IR_Data, id: IR.ID, signal_states: std.DynamicBitSetUnmanaged) u1 {
    return switch (self.get(id)) {
        .zero => 0,
        .one => 1,
        .signal => |ordinal| if (ordinal < signal_states.capacity()) @intFromBool(signal_states.isSet(ordinal)) else 0,
        .complement => |inner| 1 ^ self.evaluate(inner, signal_states),
        .product => |bin| self.evaluate(bin.lhs, signal_states) & self.evaluate(bin.rhs, signal_states),
        .sum => |bin| self.evaluate(bin.lhs, signal_states) | self.evaluate(bin.rhs, signal_states),
        .xor => |bin| self.evaluate(bin.lhs, signal_states) ^ self.evaluate(bin.rhs, signal_states),
    };
}

pub fn count_pts(self: IR_Data, id: IR.ID) usize {
    // N.B. assumes expression is already in a normalized sum-of-products form!
    return switch (self.get(id)) {
        .sum => |bin| self.count_pts(bin.lhs) + self.count_pts(bin.rhs),
        .zero, .one, .signal, .complement, .product => 1,
        .xor => unreachable,
    };
}

pub fn count_factors(self: IR_Data, id: IR.ID) usize {
    // N.B. assumes expression is a valid product term!
    return switch (self.get(id)) {
        .product => |bin| self.count_factors(bin.lhs) + self.count_factors(bin.rhs),
        .zero => 1, // This corresponds to lc4k.Factor.never; on device such a PT actually has at least 2 factors.
        .one => 0, // We do not use lc4k.Factor.always; just an empty PT.
        .signal, .complement => 1, // Assumes that complement's inner expression will be a signal.
        .xor, .sum => unreachable,
    };
}

pub fn get_pt(self: *IR_Data, comptime Signal: type, allocator: std.mem.Allocator, id: IR.ID, pt_index: usize) !lc4k.Product_Term(Signal) {
    // N.B. assumes expression is already in a normalized sum-of-products form!
    const pt_id = self.get_pt_id(id, pt_index).id;
    const num_factors = self.count_factors(pt_id);
    if (num_factors == 0) return .always();
    const factors = try allocator.alloc(lc4k.Factor(Signal), num_factors);
    errdefer allocator.free(factors);

    var factor_iter = self.iterator(.product, pt_id);
    for (0..num_factors) |factor_index| {
        const factor_id = factor_iter.next().?;
        factors[factor_index] = switch (self.get(factor_id)) {
            .zero => .never,
            .one => .always,
            .signal => |ordinal| .{ .when_high = @enumFromInt(ordinal) },
            .complement => |signal_id| .{ .when_low = @enumFromInt(self.get(signal_id).signal) },
            .product, .sum, .xor => unreachable,
        };
    }
    return .{ .factors = factors };
}

const Get_ID_Result = union (enum) {
    id: IR.ID,
    new_index: usize,
};
fn get_pt_id(self: IR_Data, root_id: IR.ID, pt_index: usize) Get_ID_Result {
    // N.B. assumes expression is already in a normalized sum-of-products form!
    switch (self.get(root_id)) {
        .sum => |bin| {
            var result = self.get_pt_id(bin.lhs, pt_index);
            if (result == .new_index) result = self.get_pt_id(bin.rhs, result.new_index);
            return result;
        },
        .zero, .one, .signal, .complement, .product => {
            return if (pt_index == 0) .{ .id = root_id } else .{ .new_index = pt_index - 1 };
        },
        .xor => unreachable,
    }
}

pub fn make_signal(self: *IR_Data, ordinal: u16) !IR.ID {
    return try self.intern(.{ .signal = ordinal });
}

pub fn make_complement(self: *IR_Data, inner: IR.ID) std.mem.Allocator.Error!IR.ID {
    return try self.intern(.{ .complement = inner });
}

pub fn make_binary_chain(self: *IR_Data, comptime kind: IR.Tag, items: []const IR.ID) !IR.ID {
    std.debug.assert(items.len > 0);
    if (items.len == 1) return items[0];

    var id = try self.make_binary(kind, items[0], items[1]);
    for (items[2..]) |item| {
        id = try self.make_binary(kind, id, item);
    }
    return id;
}

pub fn make_binary_chain_rev(self: *IR_Data, comptime kind: IR.Tag, items: []const IR.ID) !IR.ID {
    std.debug.assert(items.len > 0);
    if (items.len == 1) return items[0];

    var id = try self.make_binary(kind, items[items.len - 1], items[items.len - 2]);
    for (3 .. items.len + 1) |i| {
        id = try self.make_binary(kind, id, items[items.len - i]);
    }
    return id;
}

/// When combining/merging two or more binary operations of the same kind, this will ensure that
/// there is a single canonical IR ID for all the permutations of associatively-equivalent expressions.
/// e.g. if `A|B|C` already exists, and then you try to create `A|C|B` this will return the existing ID for `A|B|C`.
pub fn make_binary(self: *IR_Data, comptime kind: IR.Tag, lhs_id: IR.ID, rhs_id: IR.ID) !IR.ID {
    if (lhs_id == rhs_id) return switch (kind) {
        .xor => .zero,
        .sum, .product => lhs_id,
        else => unreachable,
    };

    const lhs = self.get(lhs_id);
    const rhs = self.get(rhs_id);
    if (lhs == kind and rhs == kind) {
        std.debug.assert(self.merge_temp.items.len == 0);
        defer self.merge_temp.clearRetainingCapacity();
        try self.add_to_merge_pool(lhs);
        try self.add_to_merge_pool(rhs);
        std.sort.pdq(IR.ID, self.merge_temp.items, {}, IR.ID.less_than);

        var result = self.merge_temp.items[0];
        var last_item = result;
        for (self.merge_temp.items[1..]) |item| {
            // For AND and OR, we will remove duplicate subexpressions here, according to the logical equivalences:
            //   x & x => x
            //   x | x => x
            // But not for XOR, since `x ^ x => x` is not valid, but simplify() will apply `x ^ x => 0` instead.
            if (kind == .xor or item != last_item) {
                result = try self.intern(@unionInit(IR, @tagName(kind), .{ .lhs = result, .rhs = item }));
                last_item = item;
            }
        }
        return result;
    } else if (lhs == kind or rhs == kind) {
        const tree_id = if (lhs == kind) lhs_id else rhs_id;
        const leaf_id = if (lhs == kind) rhs_id else lhs_id;

        const tree_bin = switch (if (lhs == kind) lhs else rhs) {
            .product, .sum, .xor => |bin| bin,
            else => unreachable,
        };

        if (kind != .xor and tree_bin.rhs.raw() == leaf_id.raw()) {
            // leaf_id is already in the expression, and adding it again would be redundant
            return tree_id;
        } else if (tree_bin.rhs.raw() < leaf_id.raw()) {
            // no need to modify the existing tree; just add a new root with the new leaf
            return try self.intern(@unionInit(IR, @tagName(kind), .{ .lhs = tree_id, .rhs = leaf_id }));
        } else {
            // leaf < tree_bin.rhs, so we need to do one or more tree rotations:
            const new_tree_id = try self.make_binary(kind, tree_bin.lhs, leaf_id);
            return try self.intern(@unionInit(IR, @tagName(kind), .{ .lhs = new_tree_id, .rhs = tree_bin.rhs }));
        }
    } else {
        const bin: IR.Binary = if (lhs_id.raw() <= rhs_id.raw()) .{
            .lhs = lhs_id,
            .rhs = rhs_id,
        } else .{
            .lhs = rhs_id,
            .rhs = lhs_id,
        };
        return try self.intern(@unionInit(IR, @tagName(kind), bin));
    }
}

fn add_to_merge_pool(self: *IR_Data, ir: IR) !void {
    switch (ir) {
        .product, .sum, .xor => |bin| {
            const lhs = self.get(bin.lhs);
            if (lhs == @as(IR.Tag, ir)) {
                try self.add_to_merge_pool(lhs);
            } else {
                try self.merge_temp.append(self.gpa, bin.lhs);
            }

            const rhs = self.get(bin.rhs);
            if (rhs == @as(IR.Tag, ir)) {
                try self.add_to_merge_pool(rhs);
            } else {
                try self.merge_temp.append(self.gpa, bin.rhs);
            }
        },
        else => unreachable,
    }
}

pub fn iterator(self: *const IR_Data, kind: IR.Tag, root: IR.ID) Iterator {
    switch (kind) {
        .sum, .product, .xor => {},
        else => unreachable,
    }
    return .{
        .data = self,
        .kind = kind,
        .root = root,
    };
}
pub const Iterator = struct {
    data: *const IR_Data,
    kind: IR.Tag,
    root: ?IR.ID,

    pub fn next(self: *Iterator) ?IR.ID {
        if (self.root) |root| {
            const ir = self.data.get(root);
            if (ir == self.kind) {
                const bin = switch (ir) {
                    .sum, .product, .xor => |bin| bin,
                    else => unreachable,
                };
                self.root = bin.lhs;
                return bin.rhs;
            } else {
                self.root = null;
                return root;
            }
        } else {
            return null;
        }
    }
};

pub const IR = union (enum) {
    zero,
    one,
    signal: u16,
    complement: ID,
    product: Binary,
    sum: Binary,
    xor: Binary,

    pub const Tag = std.meta.Tag(IR);
    pub const ID = enum (u32) {
        zero = 0,
        one = 1,
        _,

        pub fn init(index: u32) ID {
            return @enumFromInt(index);
        }

        pub fn raw(self: ID) u32 {
            return @intFromEnum(self);
        }

        pub fn less_than(_: void, a: ID, b: ID) bool {
            return a.raw() < b.raw();
        }
    };

    pub const Binary = struct {
        lhs: ID,
        rhs: ID,
    };
};

const IR_Data = @This();

const lc4k = @import("../lc4k.zig");
const std = @import("std");
