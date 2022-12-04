const std = @import("std");
const jedec = @import("jedec.zig");

pub const WriteOptions = struct {
    notes: []const u8 = "",
};

pub fn write(comptime Device: type, data: jedec.JedecFile, writer: anytype, options: WriteOptions) !void {
    _ = Device;
    _ = data;
    _ = writer;
    _ = options;
}
