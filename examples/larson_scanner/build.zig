const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "larson_scanner",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = b.standardTargetOptions(.{}),
            .optimize = b.standardOptimizeOption(.{}),
            .imports = &.{
                .{ .name = "lc4k", .module = b.dependency("lc4k", .{}).module("lc4k") },
            },
        }),
    });
    var run = b.addRunArtifact(exe);
    run.step.dependOn(&b.addInstallArtifact(exe, .{}).step);
    b.getInstallStep().dependOn(&run.step);
}
