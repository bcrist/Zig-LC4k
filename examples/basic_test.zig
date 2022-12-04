const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {

    const Chip = lc4k.LC4032ZE_TQFP48;
    const PTs = Chip.PTs;

    var chip = Chip {};

    var mc1 = chip.mc(Chip.pins._23);
    mc1.output.oe = .output_only;
    mc1.sum = &.{ PTs.always() };

    var mc2 = chip.mc(Chip.pins._24);
    mc2.output.oe = .output_only;
    mc2.sum = &.{ PTs.never() };


    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());
    try lc4k.jed_file.write(results.jedec, arena.allocator(), std.io.getStdOut().writer(), .{ .one_char = '1' });
}
