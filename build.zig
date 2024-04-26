const std = @import("std");

pub fn build(b: *std.Build) void {
    const lc4k = b.addModule("lc4k", .{
        .root_source_file = .{ .path = "src/lc4k.zig" },
    });

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "test/tests.zig" },
        .optimize = b.standardOptimizeOption(.{}),
        .target = b.standardTargetOptions(.{}),
    });
    tests.root_module.addImport("lc4k", lc4k);
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_tests.step);

    // const limp = b.dependency("limp", .{}).artifact("limp");
    // const run_limp = b.addRunArtifact(limp);
    // run_limp.addDirectoryArg(.{ .path = "src/device" });
    // run_limp.addArgs(&.{ "--set", "re4k" });
    // run_limp.addDirectoryArg(b.dependency("re4k", .{}).path("."));
    // const limp_step = b.step("codegen", "Run LIMP codegen");
    // limp_step.dependOn(&run_limp.step);
}
