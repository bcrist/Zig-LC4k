// A 3:8 demultiplexer, with active-low outputs

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4032ZE_TQFP48;

    var chip = Chip {};

    chip.glb[0].shared_pt_enable = comptime Chip.pins._19.when_high().pt();
    chip.goe0.source = .{ .glb_shared_pt_enable = 0 };
    chip.goe0.polarity = .active_high;

    const input_pins = [_]Chip.Pin {
        Chip.pins._22,
        Chip.pins._21,
        Chip.pins._20,
    };

    const output_pins = [_]Chip.Pin {
        Chip.pins._23,
        Chip.pins._24,
        Chip.pins._26,
        Chip.pins._27,
        Chip.pins._28,
        Chip.pins._31,
        Chip.pins._32,
        Chip.pins._33,
    };

    inline for (output_pins, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.output.oe = .goe0;
        mc.logic = comptime .{ .sum_inverted = &.{
            Chip.PT.when_eql(&.{
                input_pins[0].signal(),
                input_pins[1].signal(),
                input_pins[2].signal(),
            }, bit),
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("demux.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("demux.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("demux.html", .{});
    defer report_file.close();
    try Chip.write_report(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
