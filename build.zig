const std = @import("std");

pub fn build(b: *std.Build) void {
    const lc4k = b.addModule("lc4k", .{
        .root_source_file = b.path("src/lc4k.zig"),
        .imports = &.{
            .{
                .name = "console",
                .module = b.dependency("console_helper", .{}).module("console"),
            },
        },
    });

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("test/tests.zig"),
            .optimize = b.standardOptimizeOption(.{}),
            .target = b.standardTargetOptions(.{}),
            .imports = &.{
                .{ .name = "lc4k", .module = lc4k },
            },
        }),
    });
    b.step("test", "Run all tests").dependOn(&b.addRunArtifact(tests).step);

    if (b.option(bool, "codegen", "regenerate device source files") orelse false) {
        const re4k_path = if (b.lazyDependency("re4k", .{})) |dep| dep.path("") else b.path("");
        if (b.lazyDependency("limp", .{ .optimize = .ReleaseSafe })) |dep| {
            const limp = dep.artifact("limp");
            const run_limp = b.addRunArtifact(limp);
            run_limp.addArgs(&.{ "-R", "--set", "re4k" });
            run_limp.addDirectoryArg(re4k_path);
            run_limp.addDirectoryArg(b.path("src"));
            b.getInstallStep().dependOn(&run_limp.step);
        }
    }
}
