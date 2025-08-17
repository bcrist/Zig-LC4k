// A 3:8 demultiplexer, with active-low outputs

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4032ZE_TQFP48;
    const Signal = Chip.Signal;

    var chip = Chip {};

    chip.glb[0].shared_pt_enable = comptime Chip.pins._19.when_high().pt();
    chip.goe0.source = .{ .glb_shared_pt_enable = 0 };
    chip.goe0.polarity = .positive;

    const inputs = [_]Signal {
        Chip.pins._22.pad(),
        Chip.pins._21.pad(),
        Chip.pins._20.pad(),
    };

    const outputs = [_]Signal {
        Chip.pins._23.pad(),
        Chip.pins._24.pad(),
        Chip.pins._26.pad(),
        Chip.pins._27.pad(),
        Chip.pins._28.pad(),
        Chip.pins._31.pad(),
        Chip.pins._32.pad(),
        Chip.pins._33.pad(),
    };

    inline for (outputs, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.output.oe = .goe0;
        mc.logic = comptime .{ .sum = .{
            .sum = &.{
                Chip.PT.when_eql(&.{
                    inputs[0],
                    inputs[1],
                    inputs[2],
                }, bit),
            },
            .polarity = .negative,
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator(), .{});

    var jed_file = try std.fs.cwd().createFile("demux.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("demux.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("demux.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .errors = results.errors.items,
    });
}
