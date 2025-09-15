// This example implements a counter, using T flip-flops.

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    const Chip = lc4k.LC4032ZE_TQFP48;

    var chip = Chip {};

    chip.glb[0].shared_pt_enable = comptime Chip.pins._20.when_high().pt();
    chip.goe0.source = .{ .glb_shared_pt_enable = 0 };
    chip.goe0.polarity = .positive;

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
        mc.func = .{ .t_ff = .{ .clock = .bclock2 }};
        mc.output.oe = .goe0;

        mc.logic = comptime .{ .sum = .{
            .sum = &.{ blk: {
                // Each bit of the counter should toggle when every lower bit is a 1
                var pt = Chip.PT.always();
                var n = 0;
                while (n < bit) : (n += 1) {
                    pt = pt.and_factor(Chip.Signal.mc_fb(output_pins[n].mc()).when_high());
                }
                break :blk pt;
            }},
            .polarity = .positive,
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator(), .{});

    const design_name = "counter1";
    try Chip.write_jed_file(results.jedec, design_name ++ ".jed", .{});
    try Chip.write_svf_file(results.jedec, design_name ++ ".svf", .{});
    try Chip.write_report_file(5, results.jedec, design_name ++ ".html", .{
        .design_name = design_name,
        .errors = results.errors.items,
    });
}
