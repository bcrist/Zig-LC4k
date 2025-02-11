const std = @import("std");

pub fn build(b: *std.Build) void {
    const module = b.addModule("util", .{
        .root_source_file = b.path("util.zig"),
    });
    module.addImport("lc4k", b.dependency("lc4k", .{}).module("lc4k"));
}
