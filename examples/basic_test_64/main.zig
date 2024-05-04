const std = @import("std");
const lc4k = @import("lc4k");

const Chip = lc4k.LC4064ZC_csBGA132;

pub fn main() !void {
    const PT = Chip.PT;

    var chip = Chip {};

    chip.usercode = 0x123456;
    chip.security = true;

    var mc1 = chip.mc(Chip.Signal.mc_A0.mc());
    mc1.output.oe = .output_only;
    mc1.logic = .{ .sum = &.{ PT.always() } };

    var mc2 = chip.mc(Chip.Signal.mc_B3.mc());
    mc2.output.oe = .output_only;
    mc2.logic = .{ .sum = &.{ PT.never() } };

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("basic_test_64.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("basic_test_64.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("basic_test_64.html", .{});
    defer report_file.close();
    try Chip.write_report(5, results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
