// A 16-bit carry lookahead adder

const Chip = lc4k.LC4064ZE_TQFP100;

const in = struct {
    pub const A: [16]Signal = .{
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

    pub const B: [16]Signal = .{
        .io_B0,
        .io_B2,
        .io_B4,
        .io_B6,
        .io_B8,
        .io_B10,
        .io_B12,
        .io_B14,
        .io_C0,
        .io_C2,
        .io_C4,
        .io_C6,
        .io_C8,
        .io_C10,
        .io_C12,
        .io_C14,
    };
};

const out = struct {
    pub const S: [16]Signal = .{
        .io_B1,
        .io_B3,
        .io_B5,
        .io_B7,
        .io_B9,
        .io_B11,
        .io_B13,
        .io_B15,
        .io_C1,
        .io_C3,
        .io_C5,
        .io_C7,
        .io_C9,
        .io_C11,
        .io_C13,
        .io_C15,
    };

    pub const C = Signal.io_D15;
};

const buried = struct {
    pub const C2 = Signal.mc_D1;
    pub const C4 = Signal.mc_D2;
    pub const C6 = Signal.mc_D3;
    pub const C8 = Signal.mc_D5;
    pub const C10 = Signal.mc_D7;
    pub const C12 = Signal.mc_D9;
    pub const C14 = Signal.mc_D11;

    pub const P4 = Signal.mc_A0;
    pub const P6 = Signal.mc_A1;
    pub const P8 = Signal.mc_A2;
    pub const P10 = Signal.mc_A3;
    pub const P12 = Signal.mc_A4;
    pub const P14 = Signal.mc_A5;
    pub const P15 = Signal.mc_A6;

    pub const G4 = Signal.mc_A7;
    pub const G6 = Signal.mc_A8;
    pub const G8 = Signal.mc_A9;
    pub const G10 = Signal.mc_A10;
    pub const G12 = Signal.mc_A11;
    pub const G14 = Signal.mc_A12;
    pub const G15 = Signal.mc_A13;
};

fn configure_chip(lp: *Chip.Logic_Parser) !Chip {
    var chip: Chip = .{};

    for (out.S) |s| {
        chip.mc(s.mc()).output = .{ .oe = .output_only };
    }
    chip.mc(out.C.mc()).output = .{ .oe = .output_only };

    add3(&chip, .{ .a = in.A[0..3], .b = in.B[0..3], .sum = out.S[0..3], .co = buried.C2 });
    add2(&chip, .{ .a = in.A[3..5], .b = in.B[3..5], .sum = out.S[3..5], .ci = buried.C2, .p = buried.P4, .g = buried.G4 });
    add2(&chip, .{ .a = in.A[5..7], .b = in.B[5..7], .sum = out.S[5..7], .ci = buried.C4, .p = buried.P6, .g = buried.G6 });
    add2(&chip, .{ .a = in.A[7..9], .b = in.B[7..9], .sum = out.S[7..9], .ci = buried.C6, .p = buried.P8, .g = buried.G8 });
    add2(&chip, .{ .a = in.A[9..11], .b = in.B[9..11], .sum = out.S[9..11], .ci = buried.C8, .p = buried.P10, .g = buried.G10 });
    add2(&chip, .{ .a = in.A[11..13], .b = in.B[11..13], .sum = out.S[11..13], .ci = buried.C10, .p = buried.P12, .g = buried.G12 });
    add2(&chip, .{ .a = in.A[13..15], .b = in.B[13..15], .sum = out.S[13..15], .ci = buried.C12, .p = buried.P14, .g = buried.G14 });
    add1(&chip, .{ .a = in.A[15], .b = in.B[15], .sum = out.S[15], .ci = buried.C14, .p = buried.P15, .g = buried.G15 });

    // Carry lookahead logic:

    chip.mc(buried.C4.mc()).logic = try lp.logic("G4 | P4 & C2", .{});
    chip.mc(buried.C6.mc()).logic = try lp.logic("G6 | P6 & G4 | &{P6 P4 C2}", .{});
    chip.mc(buried.C8.mc()).logic = try lp.logic("G8 | P8 & G6 | &{P8 P6 G4} | &{P8 P6 P4 C2}", .{});
    chip.mc(buried.C10.mc()).logic = try lp.logic("G10 | P10 & G8 | &{P10 P8 G6} | &{P10 P8 P6 G4} | &{P10 P8 P6 P4 C2}", .{});
    chip.mc(buried.C12.mc()).logic = try lp.logic("G12 | P12 & G10 | &{P12 P10 G8} | &{P12 P10 P8 G6} | &{P12 P10 P8 P6 G4} | &{P12 P10 P8 P6 P4 C2}", .{});
    chip.mc(buried.C14.mc()).logic = try lp.logic("G14 | P14 & G12 | &{P14 P12 G10} | &{P14 P12 P10 G8} | &{P14 P12 P10 P8 G6} | &{P14 P12 P10 P8 P6 G4} | &{P14 P12 P10 P8 P6 P4 C2}", .{});
    chip.mc(out.C.mc()).logic = try lp.logic("G15 | P15 & G14 | &{P15 P14 G12} | &{P15 P14 P12 G10} | &{P15 P14 P12 P10 G8} | &{P15 P14 P12 P10 P8 G6} | &{P15 P14 P12 P10 P8 P6 G4} | &{P15 P14 P12 P10 P8 P6 P4 C2}", .{});

    return chip;
}

pub fn main() !void {
    var names = Chip.Names.init(gpa.allocator());
    try names.add_names(in, .{});
    try names.add_names(out, .{});
    try names.add_names(buried, .{});
    var lp: Chip.Logic_Parser = .{
        .gpa = std.heap.page_allocator,
        .arena = .init(std.heap.page_allocator),
        .names = &names,
    };
    defer lp.arena.deinit();
    var chip = try configure_chip(&lp);

    const results = try chip.assemble(lp.arena.allocator(), .{});

    var jed_file = try std.fs.cwd().createFile("adder.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("adder.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("adder.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .design_name = "adder",
        .notes = "A 16-bit carry lookahead adder",
        .errors = results.errors.items,
        .names = &names,
    });
}

test configure_chip {
    var names = Chip.Names.init(gpa.allocator());
    try names.add_names(in, .{});
    try names.add_names(out, .{});
    try names.add_names(buried, .{});
    var lp: Chip.Logic_Parser = .{
        .gpa = std.heap.page_allocator,
        .arena = .init(std.heap.page_allocator),
        .names = &names,
    };
    defer lp.arena.deinit();
    const chip = try configure_chip(&lp);
    var sim = chip.simulator();

    _ = sim.simulate(.{});
    try sim.expect_oe_state(&out.S, 0xFFFF, null);
    try sim.expect_oe_state(&.{ out.C }, 1, null);

    try check_sum(&sim, 0, 0);
    try check_sum(&sim, 0x1234, 0x4321);
    try check_sum(&sim, 0xFFFF, 1);
    try check_sum(&sim, 0xFF00, 0x111);
    try check_sum(&sim, 0xFEED, 0xBABE);
    try check_sum(&sim, 0x62E1, 0xA84B);
    try check_sum(&sim, 0x7D8B, 0xC460);
    try check_sum(&sim, 0x4D8A, 0x1C03);

    var xornd = std.Random.Xoshiro256.init(std.crypto.random.int(u64));
    const rnd = xornd.random();
    for (0..10000) |_| {
        const v1 = rnd.int(u16);
        const v2 = rnd.int(u16);
        try check_sum(&sim, v1, v2);
        try check_sum(&sim, v2, v1);
    }
}

fn check_sum(sim: *lc4k.Simulator(Chip.Device), a: u16, b: u16) !void {
    errdefer std.debug.print("For A={X} + B={X}\n", .{ a, b });

    const actual_sum: u17 = @as(u17, a) + @as(u17, b);
    const truncated_sum: u16 = @truncate(actual_sum);
    const carry = actual_sum >> 16;

    sim.set_inputs(&in.A, a);
    sim.set_inputs(&in.B, b);
    
    _ = sim.simulate(.{});

    try sim.expect_signal_state(&out.S, truncated_sum, null);
    try sim.expect_signal_state(&.{ out.C }, carry, null);
}

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

const add1 = Chip_Util.add1;
const add2 = Chip_Util.add2;
const add3 = Chip_Util.add3;

const Signal = Chip.Signal;

const Chip_Util = util.Chip_Util(Chip);
const util = @import("util");
const lc4k = @import("lc4k");
const std = @import("std");
