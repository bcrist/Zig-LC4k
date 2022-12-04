const std = @import("std");
const Pkg = std.build.Pkg;

const sx = Pkg {
    .name = "sx",
    .source = .{ .path = "../sx/sx.zig" },
};

const lc4k = Pkg {
    .name = "lc4k",
    .source = .{ .path = "src/lc4k.zig" },
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const tests = b.addTest("test/tests.zig");
    tests.addPackage(lc4k);
    tests.addPackage(sx);
    tests.setTarget(target);
    tests.setBuildMode(mode);

    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&tests.step);

    const Example = enum {
        all,
        counter,
        basic_test,
    };
    if (b.option(Example, "example", "Build example program")) |example| switch (example) {
        .all => inline for (comptime std.enums.values(Example)) |eg| {
            if (eg != .all) buildExample(b, @tagName(eg), target, mode);
        },
        inline else => |eg| buildExample(b, @tagName(eg), target, mode),
    };
}

fn buildExample(b: *std.build.Builder, comptime name: []const u8, target: std.zig.CrossTarget, mode: std.builtin.Mode) void {
    const exe = b.addExecutable(name, "examples/" ++ name ++ ".zig");
    exe.addPackage(lc4k);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();
    _ = makeRunStep(b, exe, name, "run " ++ name);
}

fn makeRunStep(b: *std.build.Builder, exe: *std.build.LibExeObjStep, name: []const u8, desc: []const u8) *std.build.RunStep {
    var run = exe.run();
    run.step.dependOn(b.getInstallStep());
    b.step(name, desc).dependOn(&run.step);
    return run;
}
