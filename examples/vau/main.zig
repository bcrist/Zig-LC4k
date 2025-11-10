// Virtual Address Unit for the Vera homebrew CPU

const Chip = lc4k.LC4128ZC_csBGA132;

pub const clk = Signal.clk0;

pub const vab: [32]Signal = .{
    .io_A0,
    .io_A1,
    .io_A2,
    .io_A4,
    .io_A5,
    .io_A6,
    .io_A8,
    .io_A9,
    .io_A10,
    .io_A12,
    .io_A13,
    .io_A14,
    .io_B0,
    .io_B1,
    .io_B2,
    .io_B4,
    .io_B5,
    .io_B6,
    .io_B8,
    .io_B9,
    .io_B10,
    .io_B12,
    .io_B13,
    .io_B14,
    .io_C0,
    .io_C1,
    .io_C2,
    .io_C4,
    .io_C5,
    .io_C6,
    .io_C8,
    .io_C9,
};

pub const vao: [6]Signal = .{
    .io_C10,
    .io_C12,
    .io_C13,
    .io_C14,
    .io_D0,
    .io_D1,
};

pub const dr: [16]Signal = .{ // exclusing 8 LSBs and 8 MSBs
    .io_D2,
    .io_D4,
    .io_D5,
    .io_D6,
    .io_D8,
    .io_D9,
    .io_D10,
    .io_D12,
    .io_D13,
    .io_D14,
    .io_E0,
    .io_E1,
    .io_E2,
    .io_E4,
    .io_E5,
    .io_E6,
};

pub const offset: [16]Signal = blk: {
    var tmp: [16]Signal = undefined;
    for (&tmp, dr) |*out, in| {
        out.* = in.fb();
    }
    break :blk tmp;
};

pub const page: [20]Signal = .{
    .io_G2,
    .io_G4,
    .io_G5,
    .io_G6,
    .io_G8,
    .io_G9,
    .io_G10,
    .io_G12,
    .io_G13,
    .io_G14,
    .io_H0,
    .io_H1,
    .io_H2,
    .io_H4,
    .io_H5,
    .io_H6,
    .io_H8,
    .io_H9,
    .io_H10,
    .io_H12,
};

pub const page_offset: [12]Signal = .{
    .io_F0,
    .io_F1,
    .io_F2,
    .io_F4,
    .io_F5,
    .io_F6,
    .io_F8,
    .io_F10,
    .io_F12,
    .io_F13,
    .io_F14,
    .io_G0,
};

pub const addr_overflow_fault = Signal.io_H14;

pub const use_dr = Signal.mc_C10;

pub const carry2 = Signal.mc_B14;
pub const carry4 = Signal.mc_A1;
pub const carry6 = Signal.mc_A2;
pub const carry8 = Signal.mc_A4;
pub const carry10 = Signal.mc_A0;
pub const carry12 = Signal.mc_A6;
pub const carry14 = Signal.mc_A8;
pub const carry16 = Signal.mc_A9;

pub const p4 = Signal.mc_A11;
pub const p6 = Signal.mc_A12;
pub const p8 = Signal.mc_A13;
pub const p10 = Signal.mc_A14;
pub const p12 = Signal.mc_B0;
pub const p14 = Signal.mc_B1;
pub const p16 = Signal.mc_B2;

pub const g4 = Signal.mc_B5;
pub const g6 = Signal.mc_B6;
pub const g8 = Signal.mc_B8;
pub const g10 = Signal.mc_B9;
pub const g12 = Signal.mc_B10;
pub const g14 = Signal.mc_B12;
pub const g16 = Signal.mc_B13;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var names = Chip.Names.init(gpa);
    @setEvalBranchQuota(10000);
    try names.add_names(@This(), .{});

    var chip = Chip {};

    std.debug.assert(clk == Signal.clk0);
    for (&chip.glb) |*glb| {
        glb.bclock0 = .clk0_pos;
    }

    for (page) |p| {
        const mc = chip.mc(p.mc());
        mc.func = .{ .d_ff = .{ .clock = .bclock0 }};
        mc.output = .{ .oe = .output_only };
    }
    for (page_offset) |po| {
        const mc = chip.mc(po.mc());
        mc.func = .{ .d_ff = .{ .clock = .bclock0 }};
        mc.output = .{ .oe = .output_only };
    }
    chip.mc(addr_overflow_fault.mc()).func = .{ .d_ff = .{ .clock = .bclock0 }};
    chip.mc(addr_overflow_fault.mc()).output = .{ .oe = .output_only };

    @setEvalBranchQuota(10000);

    chip.mc(use_dr.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            Chip.PT.when_eql(&vao, 0x20),
            Chip.PT.when_eql(&vao, 0x21),
            Chip.PT.when_eql(&vao, 0x22),
        },
        .polarity = .positive,
    }};

    chip.mc(offset[0].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[0].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[0].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[8].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[1].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[1].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[1].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[9].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[2].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[2].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[2].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[10].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[8].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[3].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[3].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[3].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[11].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[9].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[4].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[4].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[4].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[12].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[10].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[5].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[5].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[13].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[11].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[6].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[6].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[13].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[11].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[7].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[7].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[14].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[12].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[8].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[8].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[13].when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(offset[9].mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[9].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[14].when_high()),
        },
        .polarity = .positive,
    }};
    inline for (10..16) |bit| {
        chip.mc(offset[bit].mc()).logic = comptime .{ .sum = .{
            .sum = &.{
                use_dr.when_low().pt().and_factor(vao[5].when_high()),
                Chip.PT.when_eql(&vao, 0x20).and_factor(dr[bit].when_high()),
                Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
                Chip.PT.when_eql(&vao, 0x22).and_factor(dr[15].when_high()),
            },
            .polarity = .positive,
        }};
    }

    add3(&chip, .{ .a = vab[0..3], .b = offset[0..3], .sum = page_offset[0..3], .co = carry2 });
    add2(&chip, .{ .a = vab[3..5], .b = offset[3..5], .sum = page_offset[3..5], .ci = carry2, .p = p4, .g = g4 });
    add2(&chip, .{ .a = vab[5..7], .b = offset[5..7], .sum = page_offset[5..7], .ci = carry4, .p = p6, .g = g6 });
    add2(&chip, .{ .a = vab[7..9], .b = offset[7..9], .sum = page_offset[7..9], .ci = carry6, .p = p8, .g = g8 });
    add2(&chip, .{ .a = vab[9..11], .b = offset[9..11], .sum = page_offset[9..11], .ci = carry8, .p = p10, .g = g10 });
    add2(&chip, .{ .a = vab[11..13], .b = offset[11..13], .sum = &.{ page_offset[11], page[0] }, .ci = carry10, .p = p12, .g = g12 });
    add2(&chip, .{ .a = vab[13..15], .b = offset[13..15], .sum = page[1..3], .ci = carry12, .p = p14, .g = g14 });
    add2(&chip, .{ .a = vab[15..17], .b = &(.{ offset[15] } ** 2), .sum = page[3..5], .ci = carry14, .p = p16, .g = g16 });

    const sign = offset[15];
    inline for (17..32, vab[17..], page[5..]) |bit, base, result| {
        comptime var increment_pt = sign.when_low().pt().and_factor(carry16.when_high()).and_factor(base.when_low());
        comptime var decrement_pt = sign.when_high().pt().and_factor(carry16.when_low()).and_factor(base.when_low());

        inline for (vab[17..bit]) |prev_base| {
            increment_pt = increment_pt.and_factor(prev_base.when_high());
            decrement_pt = decrement_pt.and_factor(prev_base.when_low());
        }

        chip.mc(result.mc()).logic = comptime .{ .sum = .{
            .sum = &.{
                sign.when_low().pt().and_factor(carry16.when_low()).and_factor(base.when_high()),
                sign.when_high().pt().and_factor(carry16.when_high()).and_factor(base.when_high()),
                increment_pt,
                decrement_pt,
            },
            .polarity = .positive,
        }};
    }

    comptime var increment_overflow_pt = sign.when_low().pt().and_factor(carry16.when_high());
    comptime var decrement_overflow_pt = sign.when_high().pt().and_factor(carry16.when_low());
    inline for (vab[17..32]) |base| {
        increment_overflow_pt = increment_overflow_pt.and_factor(base.when_high());
        decrement_overflow_pt = decrement_overflow_pt.and_factor(base.when_low());
    }
    chip.mc(addr_overflow_fault.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            increment_overflow_pt,
            decrement_overflow_pt,
        },
        .polarity = .positive,
    }};

    // Carry lookahead logic:
    chip.mc(carry4.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g4.when_high().pt(),
            p4.when_high().pt().and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry6.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g6.when_high().pt(),
            p6.when_high().pt().and_factor(g4.when_high()),
            p6.when_high().pt().and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry8.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g8.when_high().pt(),
            p8.when_high().pt().and_factor(g6.when_high()),
            p8.when_high().pt().and_factor(p6.when_high()).and_factor(g4.when_high()),
            p8.when_high().pt().and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry10.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g10.when_high().pt(),
            p10.when_high().pt().and_factor(g8.when_high()),
            p10.when_high().pt().and_factor(p8.when_high()).and_factor(g6.when_high()),
            p10.when_high().pt().and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
            p10.when_high().pt().and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry12.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g12.when_high().pt(),
            p12.when_high().pt().and_factor(g10.when_high()),
            p12.when_high().pt().and_factor(p10.when_high()).and_factor(g8.when_high()),
            p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
            p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
            p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry14.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g14.when_high().pt(),
            p14.when_high().pt().and_factor(g12.when_high()),
            p14.when_high().pt().and_factor(p12.when_high()).and_factor(g10.when_high()),
            p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(g8.when_high()),
            p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
            p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
            p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};
    chip.mc(carry16.mc()).logic = comptime .{ .sum = .{
        .sum = &.{
            g16.when_high().pt(),
            p16.when_high().pt().and_factor(g14.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(g12.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(g10.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(g8.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
            p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
        },
        .polarity = .positive,
    }};

    const results = try chip.assemble(arena.allocator(), .{});

    const design_name = "vau";
    try Chip.write_jed_file(results.jedec, design_name ++ ".jed", .{});
    try Chip.write_svf_file(results.jedec, design_name ++ ".svf", .{});
    try Chip.write_report_file(7, results.jedec, design_name ++ ".html", .{
        .design_name = design_name,
        .notes = "Virtual Address Unit for the Vera homebrew CPU.  Mainly consists of a 32b (unsigned) + 16b (signed) adder, with an overflow output and some preprocessing on the 16b input to allow it to be sourced from microcode or one of 3 locations within the instruction word.",
        .errors = results.errors.items,
        .names = &names,
    });
}

const gpa = std.heap.smp_allocator;

const add1 = Chip_Util.add1;
const add2 = Chip_Util.add2;
const add3 = Chip_Util.add3;

const Signal = Chip.Signal;

const Chip_Util = util.Chip_Util(Chip);
const util = @import("util");
const lc4k = @import("lc4k");
const std = @import("std");
