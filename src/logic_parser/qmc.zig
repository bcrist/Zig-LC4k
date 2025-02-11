pub const Minterm = struct {
    v: u32,
    dc: u32 = 0,

    pub fn format(self: Minterm, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;

        const v: std.StaticBitSet(32) = .{ .mask = self.v };
        const dc: std.StaticBitSet(32) = .{ .mask = self.dc };

        const num_bits = options.width orelse 32;
        for (0..num_bits) |i| {
            const bit = num_bits - i - 1;
            if (dc.isSet(bit)) {
                try writer.writeByte('-');
            } else {
                try writer.writeByte(if (v.isSet(bit)) '1' else '0');
            }
        }
    }
};

/// Optimizes a normalized sum-of-products using Quine-McCluskey and Petrick's method.
/// Note that this has exponential time and space complexity, and though this implementation
/// will theoretically work for expressions of up to 32 variables/signals, in practice a
/// lower limit should probably be used.
pub fn optimize(data: *IR_Data, sum: IR.ID, dc_sum: ?IR.ID, max_signals: u5) !IR.ID {
    // N.B. assumes expression is already in a normalized sum-of-products form!

    if (max_signals < 2) return sum;

    var signals: std.AutoArrayHashMap(u16, void) = .init(data.gpa);
    defer signals.deinit();

    // determine how many and which signals are used in the sum:
    var max_signal_ordinal: u16 = 0;
    var term_iter = data.iterator(.sum, sum);
    while (term_iter.next()) |term| {
        var factor_iter = data.iterator(.product, term);
        while (factor_iter.next()) |factor| {
            switch (data.get(factor)) {
                .signal => |ordinal| {
                    try signals.put(ordinal, {});
                    if (ordinal > max_signal_ordinal) {
                        max_signal_ordinal = ordinal;
                    }
                },
                .complement => |signal| {
                    const ordinal = data.get(signal).signal;
                    try signals.put(ordinal, {});
                    if (ordinal > max_signal_ordinal) {
                        max_signal_ordinal = ordinal;
                    }
                },
                else => unreachable,
            }
        }
    }

    if (signals.count() > max_signals or signals.count() < 2) {
        return sum;
    }

    // convert IR to minterms
    var minterms: std.ArrayList(Minterm) = .init(data.gpa);
    var dc_minterms: std.ArrayList(Minterm) = .init(data.gpa);
    defer minterms.deinit();
    defer dc_minterms.deinit();

    {
        var signal_states: std.DynamicBitSetUnmanaged = try .initEmpty(data.gpa, max_signal_ordinal + 1);
        defer signal_states.deinit(data.gpa);

        for (0..@as(usize, 1) << @intCast(signals.count())) |minterm_v_usize| {
            const minterm_v: u32 = @intCast(minterm_v_usize);
            const minterm_bits: std.bit_set.IntegerBitSet(32) = .{ .mask = minterm_v };
            for (0.., signals.keys()) |minterm_bit, signal_ordinal| {
                signal_states.setValue(signal_ordinal, minterm_bits.isSet(minterm_bit));
            }

            if (dc_sum) |dc| {
                if (data.evaluate(dc, signal_states) == 1) {
                    try dc_minterms.append(.{ .v = minterm_v });
                    continue;
                }
            }

            if (data.evaluate(sum, signal_states) == 1) {
                try minterms.append(.{ .v = minterm_v });
            }
        }
    }

    const num_minterms_excluding_dcs = minterms.items.len;
    try minterms.appendSlice(dc_minterms.items);
    dc_minterms.clearAndFree();

    const prime_implicants = try compute_prime_implicants(data.gpa, minterms.items);
    defer data.gpa.free(prime_implicants);

    const covering_implicants = try compute_covering_implicants(data.gpa, minterms.items[0..num_minterms_excluding_dcs], prime_implicants);
    defer data.gpa.free(covering_implicants);

    var optimized_sum: ?IR.ID = null;

    for (covering_implicants) |minterm| {
        const dc_bits: std.bit_set.IntegerBitSet(32) = .{ .mask = minterm.dc };
        const v_bits: std.bit_set.IntegerBitSet(32) = .{ .mask = minterm.v };

        var optimized_product: ?IR.ID = null;

        for (0.., signals.keys()) |minterm_bit, ordinal| {
            if (!dc_bits.isSet(minterm_bit)) {
                var signal_ir = try data.make_signal(ordinal);
                if (!v_bits.isSet(minterm_bit)) {
                    signal_ir = try data.make_complement(signal_ir);
                }

                optimized_product = if (optimized_product) |rhs| try data.make_binary(.product, rhs, signal_ir) else signal_ir;
            }
        }

        optimized_sum = if (optimized_sum) |rhs| try data.make_binary(.sum, rhs, optimized_product.?) else optimized_product;
    }
    
    return optimized_sum.?;
}


// N.B. all input minterms should have the same .dc value.  Don't care states should be handled by
// iterating all permutations of the don't care bits and providing them as separate minterms.
// Failure to do this may result in incorrect results.
pub fn compute_prime_implicants(gpa: std.mem.Allocator, minterms: []const Minterm) ![]Minterm {
    var prime_implicants: std.AutoArrayHashMap(Minterm, void) = .init(gpa);
    defer prime_implicants.deinit();

    var possible_prime_implicants: std.AutoArrayHashMap(Minterm, void) = .init(gpa);
    defer possible_prime_implicants.deinit();

    var remaining_minterms: std.ArrayList(Minterm) = try .initCapacity(gpa, minterms.len);
    remaining_minterms.appendSliceAssumeCapacity(minterms);
    defer remaining_minterms.deinit();

    var merged_minterms: std.DynamicBitSet = try .initEmpty(gpa, minterms.len);
    defer merged_minterms.deinit();

    while (remaining_minterms.items.len > 0) {
        for (0.., remaining_minterms.items) |ai, a| {
            for (ai + 1.., remaining_minterms.items[ai + 1..]) |bi, b| {
                if (a.dc == b.dc and @popCount(a.v ^ b.v) == 1) {
                    try possible_prime_implicants.put(.{
                        .dc = a.dc | (a.v ^ b.v),
                        .v = a.v & b.v,
                    }, {});
                    merged_minterms.set(ai);
                    merged_minterms.set(bi);
                }
            }
        }

        for (0..remaining_minterms.items.len) |i| {
            if (!merged_minterms.isSet(i)) {
                try prime_implicants.put(remaining_minterms.items[i], {});
            }
        }

        remaining_minterms.clearRetainingCapacity();
        try remaining_minterms.appendSlice(possible_prime_implicants.keys());
        possible_prime_implicants.clearRetainingCapacity();

        merged_minterms.toggleSet(merged_minterms); // clear all bits
        if (remaining_minterms.items.len > merged_minterms.capacity()) {
            try merged_minterms.resize(remaining_minterms.items.len, false);
        }
    }

    return try gpa.dupe(Minterm, prime_implicants.keys());
}

// N.B. any don't care minterms should not be provided.
pub fn compute_covering_implicants(gpa: std.mem.Allocator, minterms: []const Minterm, prime_implicants: []const Minterm) ![]Minterm {
    var covering_implicants: std.AutoArrayHashMap(Minterm, void) = .init(gpa);
    defer covering_implicants.deinit();

    var uncovered_minterms: std.AutoArrayHashMap(Minterm, std.DynamicBitSetUnmanaged) = .init(gpa);
    defer uncovered_minterms.deinit();
    defer for (uncovered_minterms.values()) |*coverage| {
        coverage.deinit(gpa);
    };

    var temp_coverage: std.DynamicBitSet = try .initEmpty(gpa, prime_implicants.len);
    defer temp_coverage.deinit();

    next_minterm: for (minterms) |minterm| {
        temp_coverage.toggleSet(temp_coverage);
        for (0.., prime_implicants) |pi, prime_implicant| {
            if (prime_implicant.v == (minterm.v & ~prime_implicant.dc)) {
                if (covering_implicants.contains(prime_implicant)) {
                    continue :next_minterm;
                } else {
                    temp_coverage.set(pi);
                }
            }
        }

        if (temp_coverage.count() == 0) {
            @panic("No prime implicant covers minterm");
        } else if (temp_coverage.count() == 1) {
            const prime_implicant = prime_implicants[temp_coverage.findFirstSet().?];
            try covering_implicants.put(prime_implicant, {});
        } else {
            try uncovered_minterms.put(minterm, (try temp_coverage.clone(gpa)).unmanaged);
        }
    }

    if (covering_implicants.count() > 0) {
        for (minterms) |minterm| {
            if (uncovered_minterms.getPtr(minterm)) |coverage| {
                var iter = coverage.iterator(.{});
                const already_covered = while (iter.next()) |pi| {
                    if (covering_implicants.contains(prime_implicants[pi])) {
                        break true;
                    }
                } else false;
                if (already_covered) {
                    coverage.deinit(gpa);
                    _ = uncovered_minterms.swapRemove(minterm);
                }
            }
        }
    }

    if (uncovered_minterms.count() > 0) {
        // essential prime implicants are insufficient; use Petrick's method to find the best covering set of remaining prime implicants

        var ird = try IR_Data.init(gpa);
        defer ird.deinit();

        var product: ?IR.ID = null;

        for (uncovered_minterms.values()) |coverage| {
            var iter = coverage.iterator(.{});
            var sum = try ird.make_signal(@intCast(iter.next().?));
            while (iter.next()) |pi| {
                sum = try ird.make_binary(.sum, sum, try ird.make_signal(@intCast(pi)));
            }
            product = if (product) |lhs| try ird.make_binary(.product, lhs, sum) else sum;
        }

        const normalized = try ird.normalize(product.?, .{});

        var best_term_factors: usize = std.math.maxInt(usize);

        var term_iter = ird.iterator(.sum, normalized);
        while (term_iter.next()) |term| {
            const num_factors = ird.count_factors(term);
            if (num_factors < best_term_factors) {
                best_term_factors = num_factors;
            }
        }

        var best_term: ?IR.ID = null;
        var best_term_literals: usize = 0;

        term_iter = ird.iterator(.sum, normalized);
        while (term_iter.next()) |term| {
            if (ird.count_factors(term) == best_term_factors) {
                var positive_literals: u32 = 0;
                var negative_literals: u32 = 0;
                var factor_iter = ird.iterator(.product, term);
                while (factor_iter.next()) |factor| {
                    const prime_implicant = prime_implicants[ird.get(factor).signal];
                    positive_literals |= prime_implicant.v & ~prime_implicant.dc;
                    negative_literals |= ~prime_implicant.v & ~prime_implicant.dc;
                }
                const total_literals = @popCount(positive_literals) + @popCount(negative_literals);
                if (best_term == null or total_literals < best_term_literals) {
                    best_term = term;
                    best_term_literals = total_literals;
                }
            }
        }

        var factor_iter = ird.iterator(.product, best_term.?);
        while (factor_iter.next()) |factor| {
            const prime_implicant = prime_implicants[ird.get(factor).signal];
            try covering_implicants.put(prime_implicant, {});
        }
    }

    return try gpa.dupe(Minterm, covering_implicants.keys());
}

const IR = IR_Data.IR;
const IR_Data = @import("IR_Data.zig");
const std = @import("std");
