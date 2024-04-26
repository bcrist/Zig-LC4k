// Implements a 16-bit priority encoder (i.e. count trailing zeroes)

const std = @import("std");
const lc4k = @import("lc4k");

const Chip = lc4k.LC4032ZE_TQFP48;
const PTs = Chip.PTs;
const not = PTs.not;
const all = PTs.all;

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

    chip.mc(outputs[0]).logic = .{ .sum = &[_]Chip.PT {
        all(.{ inputs[1],  not(inputs[0]) }),
        all(.{ inputs[3],  not(inputs[0]), not(inputs[1]), not(inputs[2]) }),
        all(.{ inputs[5],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]) }),
        all(.{ inputs[7],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]) }),
        all(.{ inputs[9],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]) }),
        all(.{ inputs[11], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]) }),
        all(.{ inputs[13], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]) }),
        all(.{ inputs[15], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]), not(inputs[14]) }),
    }};

    chip.mc(outputs[1]).logic = .{ .sum = &[_]Chip.PT {
        all(.{ inputs[2],  not(inputs[0]), not(inputs[1]) }),
        all(.{ inputs[3],  not(inputs[0]), not(inputs[1]), not(inputs[2]) }),
        all(.{ inputs[6],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]) }),
        all(.{ inputs[7],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]) }),
        all(.{ inputs[10], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]) }),
        all(.{ inputs[11], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]) }),
        all(.{ inputs[14], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]) }),
        all(.{ inputs[15], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]), not(inputs[14]) }),
    }};

    chip.mc(outputs[2]).logic = .{ .sum = &[_]Chip.PT {
        all(.{ inputs[4],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]) }),
        all(.{ inputs[5],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]) }),
        all(.{ inputs[6],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]) }),
        all(.{ inputs[7],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]) }),
        all(.{ inputs[12], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]) }),
        all(.{ inputs[13], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]) }),
        all(.{ inputs[14], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]) }),
        all(.{ inputs[15], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]), not(inputs[14]) }),
    }};

    chip.mc(outputs[3]).logic = .{ .sum = &[_]Chip.PT {
        all(.{ inputs[8],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]) }),
        all(.{ inputs[9],  not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]) }),
        all(.{ inputs[10], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]) }),
        all(.{ inputs[11], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]) }),
        all(.{ inputs[12], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]) }),
        all(.{ inputs[13], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]) }),
        all(.{ inputs[14], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]) }),
        all(.{ inputs[15], not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]), not(inputs[14]) }),
    }};

    chip.mc(outputs[4]).logic = .{ .sum = &[_]Chip.PT {
        all(.{ not(inputs[0]), not(inputs[1]), not(inputs[2]), not(inputs[3]), not(inputs[4]), not(inputs[5]), not(inputs[6]), not(inputs[7]), not(inputs[8]), not(inputs[9]), not(inputs[10]), not(inputs[11]), not(inputs[12]), not(inputs[13]), not(inputs[14]), not(inputs[15]) }),
    }};

    inline for (outputs) |out| {
        chip.mc(out).output.oe = .output_only;
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("examples/priority_encoder.jed", .{});
    defer jed_file.close();
    try Chip.writeJED(arena.allocator(), results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("examples/priority_encoder.svf", .{});
    defer svf_file.close();
    try Chip.writeSVF(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("examples/priority_encoder.html", .{});
    defer report_file.close();
    try Chip.writeReport(results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}

fn full_adder(chip: *Chip,
    comptime in0: anytype,
    comptime in1: anytype,
    comptime in2: anytype,
    comptime out0: anytype,
    comptime out1: anytype,
) void {
    chip.mc(out0).logic = .{ .sum_xor_pt0 = .{
        .sum = comptime &[_]Chip.PT {
            PTs.all(.{ in0, PTs.not(in1) }),
            PTs.all(.{ in1, PTs.not(in0) }),
        },
        .pt0 = PTs.of(in2),
    }};

    chip.mc(out1).logic = .{ .sum = comptime &[_]Chip.PT {
        PTs.all(.{ in0, in1 }),
        PTs.all(.{ in0, in2 }),
        PTs.all(.{ in1, in2 }),
        PTs.all(.{ in0, in1, in2 }),
    }};
}

fn half_adder(chip: *Chip,
    comptime in0: anytype,
    comptime in1: anytype,
    comptime out0: anytype,
    comptime out1: anytype,
) void {
    chip.mc(out0).logic = .{ .sum_xor_pt0 = .{
        .sum = comptime &[_]Chip.PT { PTs.of(in0) },
        .pt0 = PTs.of(in1),
    }};

    chip.mc(out1).logic = .{ .sum = comptime &[_]Chip.PT {
        PTs.all(.{ in0, in1 }),
    }};
}
