const lc4k = @import("lc4k");
const std = @import("std");

pub fn main() void {
    std.testing.refAllDecls(lc4k);

    var chip: lc4k.LC4032ZE_TQFP48 = .{};

    _ = &chip;

    const factor: lc4k.LC4032ZE_TQFP48.F = .always;

    const pt = factor.pt_indirect();

    _ = pt;

}
