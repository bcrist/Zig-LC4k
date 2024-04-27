const lc4k = @import("lc4k");
const std = @import("std");

pub fn main() void {
    std.testing.refAllDecls(lc4k);
}
