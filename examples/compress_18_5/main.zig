// Implements a 18 to 5 bit compressor (i.e. count number of set bits)

// This might look a little convoluted if you've never thought about implementing it before,
// but it makes more sense if you draw a block diagram of the connections between the adders.

// There are 6 "layers" of logic, where each one takes some "weighted" input signals, grouped by weight.
// The goal in each layer is to reduce the number of bits in the lower weight groups, and increase the number of bits
// in the higher weight groups, until there's only a single bit in each; that's our output number.
// It does this by combining 2 or 3 input signals with the same weight, using a half or full adder, to
// yield one signal at the same weight, and one signal at the next higher weight.

// In the first layer we start will all inputs having weight 1, and sum them in groups of three using full adders.
// That gives us 6 new bits with weight 1 and 6 bits with weight 2.

// In the second layer we sum the weight 2 and weight 1 groups separately, again in groups of 2 or 3 with half or full adders.
// Coming out of layer 2 we have:
//   * 2 bits with weight 4
//   * 4 bits with weight 2
//   * 2 bits with weight 1

// After layer 3 we have:
//   * 3 bits with weight 4
//   * 3 bits with weight 2
//   * 1 bit with weight 1 (the first output bit!)

// After layer 4:
//   * 1 bit with weight 8
//   * 2 bits with weight 4
//   * 1 bit with weight 2 (second output bit)

// Layer 5 is just a half adder on the weight 4 bits, yielding:
//   * 2 bits with weight 8
//   * 1 bit with weight 4 (third output bit)

// Layer 6 is again just a half adder on the weight 8 bits, yielding the fourth and fifth output bits.

// Since layer 5 and 6 are quite simple, we can merge them into the same layer and decrease propagation delay
// by embedding the layer 5 carry equation directly into layer 6's product terms.
// Total worst-case propagation delay on a `-5` speed class device should be a little over 20ns.

// This strategy can be extended to wider bit-widths, but 18:5 is the largest that will fit in a 32-macrocell device;
// you'd need to go up to a 64-macrocell device for a full 32 bit compressor (and eventually you need another layer).

const std = @import("std");
const lc4k = @import("lc4k");

const Chip = lc4k.LC4032ZE_TQFP48;

pub fn main() !void {

    var chip = Chip {};

    const inputs = [_]Chip.Signal {
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
        .io_B15,
        .io_B14,
    };

    const outputs = [_]Chip.Signal {
        .io_B0,
        .io_B1,
        .io_B2,
        .io_B3,
        .io_B4,
    };

    const layer1_i0_o0 = [_]Chip.Signal {
        .mc_A0,
        .mc_A1,
        .mc_A2,
        .mc_A3,
        .mc_A4,
        .mc_A5,
    };
    const layer1_i0_o1 = [_]Chip.Signal {
        .mc_A6,
        .mc_A7,
        .mc_A8,
        .mc_A9,
        .mc_A10,
        .mc_A11,
    };

    const layer2_i0_o0_0 = Chip.Signal.mc_A12;
    const layer2_i0_o0_1 = Chip.Signal.mc_A13;
    const layer2_i0_o1_0 = Chip.Signal.mc_A14;
    const layer2_i0_o1_1 = Chip.Signal.mc_A15;
    const layer2_i1_o1_0 = Chip.Signal.mc_B15;
    const layer2_i1_o1_1 = Chip.Signal.mc_B14;
    const layer2_i1_o2_0 = Chip.Signal.mc_B13;
    const layer2_i1_o2_1 = Chip.Signal.mc_B12;

    const layer3_i0_o1 = Chip.Signal.mc_B11;
    const layer3_i1_o1 = Chip.Signal.mc_B10;
    const layer3_i1_o2 = Chip.Signal.mc_B9;

    const layer4_i1_o2 = Chip.Signal.mc_B8;
    const layer4_i2_o2 = Chip.Signal.mc_B7;
    const layer4_i2_o3 = Chip.Signal.mc_B6;

    inline for (layer1_i0_o0, 0..) |_, n| {
        const base = n * 3;
        full_adder(&chip, inputs[base],    inputs[base+1],  inputs[base+2],  layer1_i0_o0[n], layer1_i0_o1[n]);
    }

    full_adder(&chip,     layer1_i0_o0[0], layer1_i0_o0[1], layer1_i0_o0[2], layer2_i0_o0_0,  layer2_i0_o1_0);
    full_adder(&chip,     layer1_i0_o0[3], layer1_i0_o0[4], layer1_i0_o0[5], layer2_i0_o0_1,  layer2_i0_o1_1);
    full_adder(&chip,     layer1_i0_o1[0], layer1_i0_o1[1], layer1_i0_o1[2], layer2_i1_o1_0,  layer2_i1_o2_0);
    full_adder(&chip,     layer1_i0_o1[3], layer1_i0_o1[4], layer1_i0_o1[5], layer2_i1_o1_1,  layer2_i1_o2_1);

    half_adder(&chip,     layer2_i0_o0_0,  layer2_i0_o0_1,                   outputs[0],      layer3_i0_o1);
    full_adder(&chip,     layer2_i0_o1_0,  layer2_i1_o1_0, layer2_i1_o1_1,   layer3_i1_o1,    layer3_i1_o2);

    full_adder(&chip,     layer3_i0_o1,    layer2_i0_o1_1, layer3_i1_o1,     outputs[1],      layer4_i1_o2);
    full_adder(&chip,     layer3_i1_o2,    layer2_i1_o2_0, layer2_i1_o2_1,   layer4_i2_o2,    layer4_i2_o3);

    chip.mc(outputs[2].mc()).logic = comptime .{ .sum_xor_pt0 = .{
        .sum = &.{ layer4_i1_o2.when_high().pt() },
        .pt0 = layer4_i2_o2.when_high().pt(),
    }};

    chip.mc(outputs[3].mc()).logic = comptime .{ .sum_xor_pt0 = .{
        .sum = &.{ layer4_i2_o2.when_high().pt().and_factor(layer4_i1_o2.when_high()) },
        .pt0 = layer4_i2_o3.when_high().pt(),
    }};

    chip.mc(outputs[4].mc()).logic = comptime .{ .sum = &.{
        layer4_i1_o2.when_high().pt().and_factor(layer4_i2_o2.when_high()).and_factor(layer4_i2_o3.when_high()),
    }};

    inline for (outputs) |out| {
        chip.mc(out.mc()).output.oe = .output_only;
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("compress_18_5.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("compress_18_5.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("compress_18_5.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .assembly_errors = results.errors.items,
    });
}

fn full_adder(chip: *Chip,
    comptime in0: Chip.Signal,
    comptime in1: Chip.Signal,
    comptime in2: Chip.Signal,
    comptime out0: Chip.Signal,
    comptime out1: Chip.Signal,
) void {
    chip.mc(out0.mc()).logic = comptime .{ .sum_xor_pt0 = .{
        .sum = &.{
            in0.when_high().pt().and_factor(in1.when_low()),
            in1.when_high().pt().and_factor(in0.when_low()),
        },
        .pt0 = in2.when_high().pt(),
    }};

    chip.mc(out1.mc()).logic = comptime .{ .sum = &.{
        in0.when_high().pt().and_factor(in1.when_high()),
        in0.when_high().pt().and_factor(in2.when_high()),
        in1.when_high().pt().and_factor(in2.when_high()),
        in0.when_high().pt().and_factor(in1.when_high()).and_factor(in2.when_high()),
    }};
}

fn half_adder(chip: *Chip,
    comptime in0: anytype,
    comptime in1: anytype,
    comptime out0: anytype,
    comptime out1: anytype,
) void {
    chip.mc(out0.mc()).logic = comptime .{ .sum_xor_pt0 = .{
        .sum = &.{ in0.when_high().pt() },
        .pt0 = in1.when_high().pt(),
    }};

    chip.mc(out1.mc()).logic = comptime .{ .sum = &.{
        in0.when_high().pt().and_factor(in1.when_high()),
    }};
}
