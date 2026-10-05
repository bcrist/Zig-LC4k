const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lc4k_module = b.dependency("lc4k", .{}).module("lc4k");

    const util_module = b.createModule(.{
        .root_source_file = b.path("util.zig"),
        .imports = &.{
            .{ .name = "lc4k", .module = lc4k_module },
        },
    });

    const imports = [_]std.Build.Module.Import{
        .{ .name = "lc4k", .module = lc4k_module },
        .{ .name = "util", .module = util_module },
    };

    const install = b.getInstallStep();

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "74x181",
        .root_module = b.createModule(.{
            .root_source_file = b.path("74x181.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "adder",
        .root_module = b.createModule(.{
            .root_source_file = b.path("adder.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "compress_18_5",
        .root_module = b.createModule(.{
            .root_source_file = b.path("compress_18_5.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "counter1",
        .root_module = b.createModule(.{
            .root_source_file = b.path("counter1.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "counter2",
        .root_module = b.createModule(.{
            .root_source_file = b.path("counter2.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "demux",
        .root_module = b.createModule(.{
            .root_source_file = b.path("demux.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "gray_code",
        .root_module = b.createModule(.{
            .root_source_file = b.path("gray_code.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "larson_scanner",
        .root_module = b.createModule(.{
            .root_source_file = b.path("larson_scanner.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "priority_encoder",
        .root_module = b.createModule(.{
            .root_source_file = b.path("priority_encoder.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    install.dependOn(&b.addRunArtifact(b.addExecutable(.{
        .name = "vau",
        .root_module = b.createModule(.{
            .root_source_file = b.path("vau.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);

    b.step("test", "Run tests").dependOn(&b.addRunArtifact(b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    })).step);
}
