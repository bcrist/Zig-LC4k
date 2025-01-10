const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "basic_test_128",
        .root_source_file = b.path("main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    exe.root_module.addImport("lc4k", b.dependency("lc4k", .{}).module("lc4k"));

    var run = b.addRunArtifact(exe);
    run.step.dependOn(&b.addInstallArtifact(exe, .{}).step);
    b.getInstallStep().dependOn(&run.step);
}
