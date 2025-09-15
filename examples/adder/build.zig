const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "adder",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "lc4k", .module = b.dependency("lc4k", .{}).module("lc4k") },
                .{ .name = "util", .module = b.dependency("example_utils", .{}).module("util") },
            },
        }),
    });
    var run = b.addRunArtifact(exe);
    run.step.dependOn(&b.addInstallArtifact(exe, .{}).step);
    b.getInstallStep().dependOn(&run.step);

    const test_exe = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "lc4k", .module = b.dependency("lc4k", .{}).module("lc4k") },
                .{ .name = "util", .module = b.dependency("example_utils", .{}).module("util") },
            },
        }),
    });
    b.step("test", "Run tests").dependOn(&b.addRunArtifact(test_exe).step);
}
