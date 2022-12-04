const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    @setEvalBranchQuota(2000);

    const Chip = lc4k.LC4032ZE_TQFP48;
    const PTs = Chip.PTs;

    var chip = Chip {};

    chip.glb[0].shared_pt_enable = PTs.of(Chip.pins._20);
    chip.glb[0].shared_pt_enable_to_oe_bus[0] = true;
    chip.goe0.polarity = .active_high;

    chip.glb[1].shared_pt_init = .{ .active_low = PTs.of(Chip.pins._22) };

    const output_pins = [_]lc4k.PinInfo {
        Chip.pins._23,
        Chip.pins._24,
        Chip.pins._26,
        Chip.pins._27,
        Chip.pins._28,
        Chip.pins._31,
        Chip.pins._32,
        Chip.pins._33,
    };

    inline for (output_pins) |out, bit| {
        var mc = chip.mc(out);
        mc.clock = .{ .bclock = 2 };
        mc.output.oe = .goe0;

        comptime var sum: []const Chip.PT = &.{};
        comptime var all_ones = PTs.always();
        comptime var n = bit;
        inline while (n > 0) : (n -= 1) {
            const out_n = output_pins[n - 1];
            all_ones = comptime PTs.all(.{ all_ones, out_n });
            sum = sum ++ &[_]Chip.PT {
                comptime PTs.all(.{
                    out,
                    PTs.not(out_n),
                }),
            };
        }
        mc.sum = sum ++ &[_]Chip.PT { all_ones };
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());
    try lc4k.jed_file.write(results.jedec, arena.allocator(), std.io.getStdOut().writer(), .{ .one_char = '.' });
}
