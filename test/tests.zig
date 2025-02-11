const lc4k = @import("lc4k");
const std = @import("std");

comptime {
    _ = @import("logic_parser.zig");
}

test "lc4k" {
    std.testing.refAllDecls(lc4k);

    var chip: lc4k.LC4032ZE_TQFP48 = .{};

    _ = &chip;

    var factor: lc4k.LC4032ZE_TQFP48.F = .always;

    const pt = factor.pt_indirect();

    _ = pt;
}
