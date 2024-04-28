// This example implements a larson scanner "moving lights" effect.

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4064ZC_TQFP100;

    var chip = Chip {};

    const outputs = [_]Chip.GRP {
        .io_A0, .io_A1, .io_A2, .io_A3,
        .io_A4, .io_A5, .io_A6, .io_A7,
        .io_A8, .io_A9, .io_A10, .io_A11,
        .io_A12, .io_A13, .io_A14, .io_A15,
        .io_B15, .io_B14, .io_B13, .io_B12,
        .io_B11, .io_B10, .io_B9, .io_B8,
        .io_B7, .io_B6, .io_B5, .io_B4,
        .io_B3, .io_B2, .io_B1, .io_B0,
    };

    const dir_signal = Chip.GRP.mc_C0;
    const none_signal = Chip.GRP.mc_C15;

    chip.glb[0].shared_pt_clock = comptime .{ .positive = Chip.pins._12.when_high().pt() };
    chip.glb[1].shared_pt_clock = comptime .{ .positive = Chip.pins._12.when_high().pt() };
    chip.glb[2].shared_pt_clock = comptime .{ .positive = Chip.pins._12.when_high().pt() };

    var dir_mc = chip.mc(dir_signal.mc());
    dir_mc.func = .{ .t_ff = .{
        .init_state = 1,
        .clock = .shared_pt_clock,
    }};
    dir_mc.output.oe = .output_only;
    dir_mc.logic = comptime .{ .sum = &.{ none_signal.when_high().pt() } };

    var none_mc = chip.mc(none_signal.mc());
    none_mc.output.oe = .output_only;
    none_mc.logic = comptime .{ .sum = &.{ outputs[0].when_low().pt()
        .and_factor(outputs[3].when_low())
        .and_factor(outputs[6].when_low())
        .and_factor(outputs[9].when_low())
        .and_factor(outputs[12].when_low())
        .and_factor(outputs[15].when_low())
        .and_factor(outputs[16].when_low())
        .and_factor(outputs[19].when_low())
        .and_factor(outputs[22].when_low())
        .and_factor(outputs[25].when_low())
        .and_factor(outputs[28].when_low())
        .and_factor(outputs[31].when_low())
    }};

    inline for (outputs, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.func = .{ .d_ff = .{ .clock = .shared_pt_clock }};
        mc.output.oe = .output_only;
        mc.logic = comptime .{ .sum = switch (bit) {
            0 => &.{
                dir_signal.when_high().pt().and_factor(outputs[bit + 1].when_high()),
                dir_signal.when_high().pt().and_factor(none_signal.when_high()),
                dir_signal.when_low().pt()
                    .and_factor(outputs[0].when_high())
                    .and_factor(outputs[3].when_low())
                    .and_factor(outputs[6].when_low())
                    .and_factor(outputs[9].when_low())
                    .and_factor(outputs[12].when_low())
                    .and_factor(outputs[15].when_low())
                    .and_factor(outputs[16].when_low())
                    .and_factor(outputs[19].when_low())
                    .and_factor(outputs[22].when_low())
                    .and_factor(outputs[25].when_low())
                    .and_factor(outputs[28].when_low())
                    .and_factor(outputs[31].when_low())
            },
            31 => &.{
                dir_signal.when_low().pt().and_factor(outputs[bit - 1].when_high()),
                dir_signal.when_low().pt().and_factor(none_signal.when_high()),
                dir_signal.when_high().pt()
                    .and_factor(outputs[0].when_low())
                    .and_factor(outputs[3].when_low())
                    .and_factor(outputs[6].when_low())
                    .and_factor(outputs[9].when_low())
                    .and_factor(outputs[12].when_low())
                    .and_factor(outputs[15].when_low())
                    .and_factor(outputs[16].when_low())
                    .and_factor(outputs[19].when_low())
                    .and_factor(outputs[22].when_low())
                    .and_factor(outputs[25].when_low())
                    .and_factor(outputs[28].when_low())
                    .and_factor(outputs[31].when_high())
            },
            else => &.{
                dir_signal.when_low().pt().and_factor(outputs[bit - 1].when_high()),
                dir_signal.when_high().pt().and_factor(outputs[bit + 1].when_high()),
            },
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("larson_scanner.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("larson_scanner.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("larson_scanner.html", .{});
    defer report_file.close();
    try Chip.write_report(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
