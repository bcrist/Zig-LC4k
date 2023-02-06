const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {
    @setEvalBranchQuota(5000);

    const Chip = lc4k.LC4032ZE_TQFP48;
    const PTs = Chip.PTs;

    var chip = Chip {};

    chip.glb[0].shared_pt_enable = PTs.of(Chip.pins._20);
    chip.glb[0].shared_pt_enable_to_oe_bus[0] = true;
    chip.goe0.polarity = .active_high;

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
        mc.func = .d_ff;
        mc.clock = .{ .bclock = 2 };
        mc.output.oe = .goe0;

        mc.sum = comptime blk: {
            var sum: []const Chip.PT = &.{};
            var all_ones = PTs.always();
            var n = bit;
            while (n > 0) : (n -= 1) {
                const out_n = output_pins[n - 1];
                all_ones = PTs.all(.{ all_ones, out_n });
                sum = sum ++ &[_]Chip.PT {
                    PTs.all(.{
                        out,
                        PTs.not(out_n),
                    }),
                };
            }
            all_ones = PTs.all(.{ all_ones, PTs.not(out) });
            break :blk sum ++ &[_]Chip.PT { all_ones };
        };
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("examples/counter.jed", .{});
    defer jed_file.close();
    try Chip.writeJED(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("examples/counter.svf", .{});
    defer svf_file.close();
    try Chip.writeSVF(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("examples/counter.html", .{});
    defer report_file.close();
    try Chip.writeReport(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
