// This example implements a larson scanner "moving lights" effect.

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4064ZC_TQFP100;
    const PTs = Chip.PTs;
    const not = PTs.not;
    const all = PTs.all;

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

    chip.glb[0].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };
    chip.glb[1].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };
    chip.glb[2].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };

    var dir_mc = chip.mc(dir_signal);
    dir_mc.func = .{ .t_ff = .{
        .init_state = 1,
        .clock = .{ .shared_pt_clock = {} },

    }};
    dir_mc.output.oe = .output_only;
    dir_mc.logic = .{ .sum = &.{ PTs.of(none_signal) } };

    var none_mc = chip.mc(none_signal);
    none_mc.output.oe = .output_only;
    none_mc.logic = .{ .sum = &.{ all(.{
        not(outputs[0]),
        not(outputs[3]),
        not(outputs[6]),
        not(outputs[9]),
        not(outputs[12]),
        not(outputs[15]),
        not(outputs[16]),
        not(outputs[19]),
        not(outputs[22]),
        not(outputs[25]),
        not(outputs[28]),
        not(outputs[31]),
    }) } };

    inline for (outputs) |out, bit| {
        var mc = chip.mc(out);
        mc.func = .{ .d_ff = .{
            .clock = .{ .shared_pt_clock = {} },
        }};
        mc.output.oe = .output_only;
        mc.logic = .{ .sum = switch (bit) {
            0 => &[_]Chip.PT {
                all(.{ dir_signal, outputs[bit + 1] }),
                all(.{ dir_signal, none_signal }),
                all(.{ not(dir_signal), outputs[0],
                    not(outputs[3]), not(outputs[6]), not(outputs[9]), not(outputs[12]), not(outputs[15]),
                    not(outputs[16]), not(outputs[19]), not(outputs[22]), not(outputs[25]), not(outputs[28]), not(outputs[31]),
                }),
            },
            31 => &[_]Chip.PT {
                all(.{ not(dir_signal), outputs[bit - 1] }),
                all(.{ not(dir_signal), none_signal }),
                all(.{ dir_signal, outputs[31],
                    not(outputs[0]), not(outputs[3]), not(outputs[6]), not(outputs[9]), not(outputs[12]), not(outputs[15]),
                    not(outputs[16]), not(outputs[19]), not(outputs[22]), not(outputs[25]), not(outputs[28]),
                }),
            },
            else => &[_]Chip.PT {
                all(.{ not(dir_signal), outputs[bit - 1] }),
                all(.{     dir_signal,  outputs[bit + 1] }),
            },
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("examples/larson_scanner.jed", .{});
    defer jed_file.close();
    try Chip.writeJED(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("examples/larson_scanner.svf", .{});
    defer svf_file.close();
    try Chip.writeSVF(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("examples/larson_scanner.html", .{});
    defer report_file.close();
    try Chip.writeReport(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
