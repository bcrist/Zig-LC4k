// This example outputs a 16-bit binary counter on GLB B, and
// the gray-code equivalent of the current counter value on GLB A.

const Chip = lc4k.LC4064ZC_TQFP100;

const signals = struct {
    pub const bin = [_]Chip.Signal {
        .io_B0, .io_B1, .io_B2, .io_B3,
        .io_B4, .io_B5, .io_B6, .io_B7,
        .io_B8, .io_B9, .io_B10, .io_B11,
        .io_B12, .io_B13, .io_B14, .io_B15,
    };

    pub const gray = [_]Chip.Signal {
        .io_A15, .io_A14, .io_A13, .io_A12,
        .io_A11, .io_A10, .io_A9, .io_A8,
        .io_A7, .io_A6, .io_A5, .io_A4,
        .io_A3, .io_A2, .io_A1, .io_A0,
    };
};

pub fn main() !void {
    var chip = Chip {};

    @setEvalBranchQuota(5000);

    var names: Chip.Names = .init(gpa.allocator());
    try names.add_names(signals, .{});
    defer names.deinit();

    var lp: Chip.Logic_Parser = .{
        .gpa = gpa.allocator(),
        .arena = .init(gpa.allocator()),
        .names = &names,
    };
    defer lp.arena.deinit();

    const clk = try lp.pt_with_polarity("pin_12", .{});

    chip.glb[0].shared_pt_clock = clk;
    chip.glb[1].shared_pt_clock = clk;
    chip.glb[2].shared_pt_clock = clk;

    inline for (signals.bin, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.func = .{ .t_ff = .{ .clock = .shared_pt_clock } };
        mc.output.oe = .output_only;

        mc.logic = comptime .{ .sum = .{
            .polarity = .positive,
            .sum = &.{ blk: {
                // Each bit of the counter should toggle when every lower bit is a 1
                var pt = Chip.PT.always();
                var n = 0;
                while (n < bit) : (n += 1) {
                    pt = pt.and_factor(signals.bin[n].when_high());
                }
                break :blk pt;
            }},
        }};
    }

    inline for (signals.gray, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.output.oe = .output_only;
        if (bit < signals.gray.len - 1) {
            mc.logic = try lp.logic("@fb bin[bit] ^ @fb bin[next_bit]", .{
                .bit = bit,
                .next_bit = bit + 1,
            });
        } else {
            mc.logic = try lp.logic("@fb bin[bit]", .{ .bit = bit });
        }
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator(), .{});

    var jed_file = try std.fs.cwd().createFile("gray_code.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("gray_code.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("gray_code.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .errors = results.errors.items,
    });
}

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

const lc4k = @import("lc4k");
const std = @import("std");
