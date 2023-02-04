const std = @import("std");
const lc4k = @import("lc4k");

pub fn main() !void {

    const Chip = lc4k.LC4032ZE_TQFP48;
    const PTs = Chip.PTs;

    var chip = Chip {};

    chip.usercode = 0x123456;
    chip.security = true;

    var mc1 = chip.mc(Chip.pins._23);
    mc1.output.oe = .output_only;
    mc1.sum = &.{ PTs.always() };

    var mc2 = chip.mc(Chip.pins._24);
    mc2.output.oe = .output_only;
    mc2.sum = &.{ PTs.never() };

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("examples/basic_test.jed", .{});
    defer jed_file.close();
    try Chip.writeJED(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("examples/basic_test.svf", .{});
    defer svf_file.close();
    try Chip.writeSVF(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("examples/basic_test.html", .{});
    defer report_file.close();
    try Chip.writeReport(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
