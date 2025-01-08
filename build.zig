const std = @import("std");

pub fn build(b: *std.Build) void {
    const lc4k = b.addModule("lc4k", .{
        .root_source_file = b.path("src/lc4k.zig"),
    });

    const tests = b.addTest(.{
        .root_source_file = b.path("test/tests.zig"),
        .optimize = b.standardOptimizeOption(.{}),
        .target = b.standardTargetOptions(.{}),
    });
    tests.root_module.addImport("lc4k", lc4k);
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_tests.step);

    // const no_limp = b.option(bool, "no_limp", "skip regenerating device files (avoids dependency loop when RE4k depends on this for code sharing)") orelse false;

    // if (!no_limp) {
    //     const re4k_path = if (b.lazyDependency("RE4k", .{ .no_build = true })) |dep| dep.path("") else b.path("");
    //     if (b.lazyDependency("LIMP", .{ .optimize = .ReleaseSafe })) |dep| {
    //         const limp = dep.artifact("limp");
    //         const run_limp = b.addRunArtifact(limp);
    //         run_limp.addArgs(&.{ "-R", "--set", "re4k" });
    //         run_limp.addDirectoryArg(re4k_path);
    //         run_limp.addDirectoryArg(b.path("src"));
    //         const limp_step = b.step("codegen", "Run LIMP codegen");
    //         limp_step.dependOn(&run_limp.step);
    //     }
    // }
}
