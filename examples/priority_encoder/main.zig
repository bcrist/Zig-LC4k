// Implements a 16-bit priority encoder (i.e. count trailing zeroes)

const std = @import("std");
const lc4k = @import("lc4k");

const Chip = lc4k.LC4032ZE_TQFP48;

pub fn main() !void {

    var chip = Chip {};

    const inputs = [_]Chip.GRP {
        .io_A0,
        .io_A1,
        .io_A2,
        .io_A3,
        .io_A4,
        .io_A5,
        .io_A6,
        .io_A7,
        .io_A8,
        .io_A9,
        .io_A10,
        .io_A11,
        .io_A12,
        .io_A13,
        .io_A14,
        .io_A15,
    };

    const outputs = [_]Chip.GRP {
        .io_B0,
        .io_B2,
        .io_B4,
        .io_B6,
        .io_B8,
    };

    @setEvalBranchQuota(10000);

    chip.mc(outputs[0].mc()).logic = comptime .{ .sum = &.{
        inputs[1].when_high().pt()  .and_factor(inputs[0].when_low()),
        inputs[3].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()),
        inputs[5].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()),
        inputs[7].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()),
        inputs[9].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()),
        inputs[11].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()),
        inputs[13].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()),
        inputs[15].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()).and_factor(inputs[14].when_low()),
    }};

    chip.mc(outputs[1].mc()).logic = comptime .{ .sum = &.{
        inputs[2].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()),
        inputs[3].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()),
        inputs[6].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()),
        inputs[7].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()),
        inputs[10].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()),
        inputs[11].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()),
        inputs[14].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()),
        inputs[15].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()).and_factor(inputs[14].when_low()),
    }};

    chip.mc(outputs[2].mc()).logic = comptime .{ .sum = &.{
        inputs[4].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()),
        inputs[5].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()),
        inputs[6].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()),
        inputs[7].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()),
        inputs[12].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()),
        inputs[13].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()),
        inputs[14].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()),
        inputs[15].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()).and_factor(inputs[14].when_low()),
    }};

    chip.mc(outputs[3].mc()).logic = comptime .{ .sum = &.{
        inputs[8].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()),
        inputs[9].when_high().pt()  .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()),
        inputs[10].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()),
        inputs[11].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()),
        inputs[12].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()),
        inputs[13].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()),
        inputs[14].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()),
        inputs[15].when_high().pt() .and_factor(inputs[0].when_low()).and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()).and_factor(inputs[14].when_low()),
    }};

    chip.mc(outputs[4].mc()).logic = comptime .{ .sum = &.{
        inputs[0].when_low().pt().and_factor(inputs[1].when_low()).and_factor(inputs[2].when_low()).and_factor(inputs[3].when_low()).and_factor(inputs[4].when_low()).and_factor(inputs[5].when_low()).and_factor(inputs[6].when_low()).and_factor(inputs[7].when_low()).and_factor(inputs[8].when_low()).and_factor(inputs[9].when_low()).and_factor(inputs[10].when_low()).and_factor(inputs[11].when_low()).and_factor(inputs[12].when_low()).and_factor(inputs[13].when_low()).and_factor(inputs[14].when_low()).and_factor(inputs[15].when_low()),
    }};

    inline for (outputs) |out| {
        chip.mc(out.mc()).output.oe = .output_only;
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("priority_encoder.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("priority_encoder.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("priority_encoder.html", .{});
    defer report_file.close();
    try Chip.write_report(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}
