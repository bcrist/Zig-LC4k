const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("util", .{
        .root_source_file = b.path("util.zig"),
        .imports = &.{
            .{ .name = "lc4k", .module = b.dependency("lc4k", .{}).module("lc4k") },
        },
    });
}
