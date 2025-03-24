// This example naively implements a counter, using comptime logic
// to compute the necessary product terms to drive D flip-flops.
// Some bits require more than 5 product terms, so this example
// demonstrates the automatic cluster routing functionality.
//
// A much more efficient counter can be made using T flip-flops
// or clock-enable product terms; see `counter1.zig` for an
// implementation of that.

const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    @setEvalBranchQuota(5000);

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

    inline for (output_pins, 0..) |out_pin, bit| {
        var mc = chip.mc(out_pin.mc());
        const out = comptime Chip.Signal.mc_fb(out_pin.mc());

        mc.func = .{ .d_ff = .{ .clock = .bclock2 }};
        mc.output.oe = .goe0;

        mc.logic = comptime .{ .sum = .{
            .sum = blk: {
                // Each bit of the counter will be set on the next clock cycle when:
                //      a) it is currently 0 and every lower bit is a 1
                //      b) it is currently 1 but at least one lower bit is not 1
                //
                // Implementing a) requires only one product term for counters up to ~36 bits.
                // Implementing b) requires N product terms, where N is the bit index.
                var sum: []const Chip.PT = &.{};
                var pt = Chip.PT.always();
                var n = bit;
                while (n > 0) : (n -= 1) {
                    const out_n = Chip.Signal.mc_fb(output_pins[n - 1].mc());
                    pt = pt.and_factor(out_n.when_high());
                    sum = sum ++ [_]Chip.PT{ out.when_high().pt().and_factor(out_n.when_low()) };
                }
                pt = pt.and_factor(out.when_low());
                break :blk sum ++ [_]Chip.PT{ pt };
            },
            .polarity = .positive,
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("counter2.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("counter2.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("counter2.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .errors = results.errors.items,
    });
}
