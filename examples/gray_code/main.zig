// This example outputs a 16-bit binary counter on GLB B, and
// the gray-code equivalent of the current counter value on GLB A.

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4064ZC_TQFP100;
    const PTs = Chip.PTs;

    var chip = Chip {};

    @setEvalBranchQuota(5000);

    const counter_bits = [_]Chip.GRP {
        .io_B0, .io_B1, .io_B2, .io_B3,
        .io_B4, .io_B5, .io_B6, .io_B7,
        .io_B8, .io_B9, .io_B10, .io_B11,
        .io_B12, .io_B13, .io_B14, .io_B15,
    };

    const gray_code_bits = [_]Chip.GRP {
        .io_A15, .io_A14, .io_A13, .io_A12,
        .io_A11, .io_A10, .io_A9, .io_A8,
        .io_A7, .io_A6, .io_A5, .io_A4,
        .io_A3, .io_A2, .io_A1, .io_A0,
    };

    chip.glb[0].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };
    chip.glb[1].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };
    chip.glb[2].shared_pt_clock = .{ .positive = PTs.of(Chip.pins._12) };

    inline for (counter_bits) |out, bit| {
        var mc = chip.mc(out);
        mc.func = .{ .t_ff = .{
            .clock = .{ .shared_pt_clock = {} },
        }};
        mc.output.oe = .output_only;

        mc.logic = .{ .sum = &[_]Chip.PT { comptime blk: {
            // Each bit of the counter should toggle when every lower bit is a 1
            var all_ones = PTs.always();
            var n = 0;
            while (n < bit) : (n += 1) {
                all_ones = PTs.all(.{ all_ones, counter_bits[n] });
            }
            break :blk all_ones;
        }}};
    }

    inline for (gray_code_bits) |out, bit| {
        var mc = chip.mc(out);
        mc.output.oe = .output_only;
        if (bit < gray_code_bits.len - 1) {
            mc.logic = .{ .sum_xor_pt0 = .{
                .sum = &.{ PTs.of(counter_bits[bit]) },
                .pt0 = PTs.of(counter_bits[bit + 1]),
            }};
        } else {
            mc.logic = .{ .sum = &[_]Chip.PT { PTs.of(counter_bits[bit]) }};
        }
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("examples/gray_code.jed", .{});
    defer jed_file.close();
    try Chip.writeJED(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("examples/gray_code.svf", .{});
    defer svf_file.close();
    try Chip.writeSVF(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("examples/gray_code.html", .{});
    defer report_file.close();
    try Chip.writeReport(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
