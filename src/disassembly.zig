const std = @import("std");
const lc4k = @import("lc4k.zig");
const jedec = @import("jedec.zig");

pub fn disassemble(comptime Device: type, allocator: std.mem.Allocator, file: jedec.JedecFile) !lc4k.LC4k(Device.device_type) {
    _ = allocator;
    _ = file;
    unreachable;
}