const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "adder",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("lc4k", b.dependency("lc4k", .{}).module("lc4k"));
    exe.root_module.addImport("util", b.dependency("example_utils", .{}).module("util"));

    var run = b.addRunArtifact(exe);
    run.step.dependOn(&b.addInstallArtifact(exe, .{}).step);
    b.getInstallStep().dependOn(&run.step);


    const test_exe = b.addTest(.{
        .root_source_file = b.path("main.zig"),
        .optimize = optimize,
    });
    test_exe.root_module.addImport("lc4k", b.dependency("lc4k", .{}).module("lc4k"));
    test_exe.root_module.addImport("util", b.dependency("example_utils", .{}).module("util"));

    var run_test = b.addRunArtifact(test_exe);
    b.step("test", "Run tests").dependOn(&run_test.step);
}
