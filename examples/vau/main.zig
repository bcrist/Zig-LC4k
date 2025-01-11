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
    var chip = Chip {};
    var names = Chip.Names.init(gpa.allocator());
    try names.add_names(@This(), .{});

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

    chip.mc(use_dr.mc()).logic = comptime .{ .sum = &.{
        Chip.PT.when_eql(&vao, 0x20),
        Chip.PT.when_eql(&vao, 0x21),
        Chip.PT.when_eql(&vao, 0x22),
    }};

    chip.mc(offset[0].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[0].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[0].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[8].when_high()),
    }};
    chip.mc(offset[1].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[1].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[1].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[9].when_high()),
    }};
    chip.mc(offset[2].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[2].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[2].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[10].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[8].when_high()),
    }};
    chip.mc(offset[3].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[3].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[3].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[11].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[9].when_high()),
    }};
    chip.mc(offset[4].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[4].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[4].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[12].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[10].when_high()),
    }};
    chip.mc(offset[5].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[5].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[5].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[13].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[11].when_high()),
    }};
    chip.mc(offset[6].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[5].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[6].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[13].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[11].when_high()),
    }};
    chip.mc(offset[7].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[5].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[7].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[14].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[12].when_high()),
    }};
    chip.mc(offset[8].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[5].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[8].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[13].when_high()),
    }};
    chip.mc(offset[9].mc()).logic = comptime .{ .sum = &.{
        use_dr.when_low().pt().and_factor(vao[5].when_high()),
        Chip.PT.when_eql(&vao, 0x20).and_factor(dr[9].when_high()),
        Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
        Chip.PT.when_eql(&vao, 0x22).and_factor(dr[14].when_high()),
    }};
    inline for (10..16) |bit| {
        chip.mc(offset[bit].mc()).logic = comptime .{ .sum = &.{
            use_dr.when_low().pt().and_factor(vao[5].when_high()),
            Chip.PT.when_eql(&vao, 0x20).and_factor(dr[bit].when_high()),
            Chip.PT.when_eql(&vao, 0x21).and_factor(dr[15].when_high()),
            Chip.PT.when_eql(&vao, 0x22).and_factor(dr[15].when_high()),
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

        chip.mc(result.mc()).logic = comptime .{ .sum = &.{
            sign.when_low().pt().and_factor(carry16.when_low()).and_factor(base.when_high()),
            sign.when_high().pt().and_factor(carry16.when_high()).and_factor(base.when_high()),
            increment_pt,
            decrement_pt,
        }};
    }

    comptime var increment_overflow_pt = sign.when_low().pt().and_factor(carry16.when_high());
    comptime var decrement_overflow_pt = sign.when_high().pt().and_factor(carry16.when_low());
    inline for (vab[17..32]) |base| {
        increment_overflow_pt = increment_overflow_pt.and_factor(base.when_high());
        decrement_overflow_pt = decrement_overflow_pt.and_factor(base.when_low());
    }
    chip.mc(addr_overflow_fault.mc()).logic = comptime .{ .sum = &.{
        increment_overflow_pt,
        decrement_overflow_pt,
    }};

    // Carry lookahead logic:
    chip.mc(carry4.mc()).logic = comptime .{ .sum = &.{
        g4.when_high().pt(),
        p4.when_high().pt().and_factor(carry2.when_high()),
    }};
    chip.mc(carry6.mc()).logic = comptime .{ .sum = &.{
        g6.when_high().pt(),
        p6.when_high().pt().and_factor(g4.when_high()),
        p6.when_high().pt().and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};
    chip.mc(carry8.mc()).logic = comptime .{ .sum = &.{
        g8.when_high().pt(),
        p8.when_high().pt().and_factor(g6.when_high()),
        p8.when_high().pt().and_factor(p6.when_high()).and_factor(g4.when_high()),
        p8.when_high().pt().and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};
    chip.mc(carry10.mc()).logic = comptime .{ .sum = &.{
        g10.when_high().pt(),
        p10.when_high().pt().and_factor(g8.when_high()),
        p10.when_high().pt().and_factor(p8.when_high()).and_factor(g6.when_high()),
        p10.when_high().pt().and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
        p10.when_high().pt().and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};
    chip.mc(carry12.mc()).logic = comptime .{ .sum = &.{
        g12.when_high().pt(),
        p12.when_high().pt().and_factor(g10.when_high()),
        p12.when_high().pt().and_factor(p10.when_high()).and_factor(g8.when_high()),
        p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
        p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
        p12.when_high().pt().and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};
    chip.mc(carry14.mc()).logic = comptime .{ .sum = &.{
        g14.when_high().pt(),
        p14.when_high().pt().and_factor(g12.when_high()),
        p14.when_high().pt().and_factor(p12.when_high()).and_factor(g10.when_high()),
        p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(g8.when_high()),
        p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
        p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
        p14.when_high().pt().and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};
    chip.mc(carry16.mc()).logic = comptime .{ .sum = &.{
        g16.when_high().pt(),
        p16.when_high().pt().and_factor(g14.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(g12.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(g10.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(g8.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(g6.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(g4.when_high()),
        p16.when_high().pt().and_factor(p14.when_high()).and_factor(p12.when_high()).and_factor(p10.when_high()).and_factor(p8.when_high()).and_factor(p6.when_high()).and_factor(p4.when_high()).and_factor(carry2.when_high()),
    }};

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("vau.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("vau.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("vau.html", .{});
    defer report_file.close();
    try Chip.write_report(7, results.jedec, report_file.writer(), .{
        .design_name = "vau",
        .notes = "Virtual Address Unit for the Vera homebrew CPU.  Mainly consists of a 32b (unsigned) + 16b (signed) adder, with an overflow output and some preprocessing on the 16b input to allow it to be sourced from microcode or one of 3 locations within the instruction word.",
        .assembly_errors = results.errors.items,
        .names = &names,
    });
}

const Add1_Options = struct {
    a: Chip.Signal,
    b: Chip.Signal,
    ci: ?Chip.Signal = null,
    sum: Chip.Signal,
    co: ?Chip.Signal = null,
    p: ?Chip.Signal = null,
    g: ?Chip.Signal = null,
    k: ?Chip.Signal = null,
};
/// 1-bit full adder with optional carry signals (any combination of in, out, generate, propagate, kill)
/// Minimally uses 1 macrocell and 1 PT cluster
/// carry out/propagate/generate/kill outputs add +1 MC, +1 PTC for each used
/// 
fn add1(chip: *Chip, comptime options: Add1_Options) void {
    const a = options.a;
    const b = options.b;

    if (options.ci) |ci| {
        chip.mc(options.sum.mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{
                    ci.when_high().pt().and_factor(b.when_low()),
                    ci.when_low().pt().and_factor(b.when_high()),
                },
                .pt0 = a.when_high().pt(),
            },
        };
        if (options.co) |co| {
            chip.mc(co.mc()).logic = comptime .{ .sum = &.{
                a.when_high().pt().and_factor(b.when_high()),
                a.when_high().pt().and_factor(ci.when_high()),
                b.when_high().pt().and_factor(ci.when_high()),
            }};
        }
    } else {
        chip.mc(options.sum.mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{ b.when_high().pt() },
                .pt0 = a.when_high().pt(),
            },
        };
        if (options.co) |co| {
            chip.mc(co.mc()).logic = comptime .{ .sum = &.{
                a.when_high().pt().and_factor(b.when_high()),
            }};
        }
    }

    if (options.g) |g| {
        chip.mc(g.mc()).logic = comptime .{ .sum = &.{
            a.when_high().pt().and_factor(b.when_high()),
        }};
    }

    if (options.p) |p| {
        chip.mc(p.mc()).logic = comptime .{ .sum = &.{
            a.when_high().pt(),
            b.when_high().pt(),
        }};
    }

    if (options.k) |k| {
        chip.mc(k.mc()).logic = comptime .{ .sum = &.{
            a.when_low().pt().and_factor(b.when_low()),
        }};
    }
}

const Add2_Options = struct {
    a: *const [2]Chip.Signal,
    b: *const [2]Chip.Signal,
    ci: ?Chip.Signal = null,
    sum: *const [2]Chip.Signal,
    co: ?Chip.Signal = null,
    p: ?Chip.Signal = null,
    g: ?Chip.Signal = null,
    k: ?Chip.Signal = null,
};
/// 2-bit adder with optional carry signals (any combination of in, out, generate, propagate, kill)
/// This level of flattening represents a good balance between PT cluster/MC usage and propagation delay.
/// Without carry in, uses 2 macrocells and 2 PT clusters (+1 MC, +1 PTC if carry out is used)
/// With carry in, uses 2 macrocells and 3 PT clusters (+1 MC, +2 PTC if carry out is used)
/// propagate/generate/kill outputs always add +1 MC, +1 PTC for each used (not affected by carry in/out)
/// So for a typical CLA usage (using ci/p/g, but not co/k) usage is 4 MCs and 5 PTCs
fn add2(chip: *Chip, comptime options: Add2_Options) void {
    const a = options.a;
    const b = options.b;

    if (options.ci) |ci| {
        chip.mc(options.sum[0].mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{
                    ci.when_high().pt().and_factor(b[0].when_low()),
                    ci.when_low().pt().and_factor(b[0].when_high()),
                },
                .pt0 = a[0].when_high().pt(),
            },
        };
        // carry0 = a[0] & b[0]
        //        | a[0] & ci
        //        | b[0] & ci
        chip.mc(options.sum[1].mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{ // b[1] xor carry0
                    b[1].when_high().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
                    b[1].when_high().pt().and_factor(a[0].when_low()).and_factor(ci.when_low()),
                    b[1].when_high().pt().and_factor(b[0].when_low()).and_factor(ci.when_low()),
                    b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                    b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                    b[1].when_low().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
                },
                .pt0 = a[1].when_high().pt(),
            },
        };
        if (options.co) |co| {
            chip.mc(co.mc()).logic = comptime .{ .sum = &.{
                a[1].when_high().pt().and_factor(b[1].when_high()),
                a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                a[1].when_high().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
                b[1].when_high().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
            }};
        }
    } else {
        chip.mc(options.sum[0].mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{ b[0].when_high().pt() },
                .pt0 = a[0].when_high().pt(),
            },
        };
        // carry0 = a[0] & b[0]
        chip.mc(options.sum[1].mc()).logic = comptime .{
            .sum_xor_pt0 = .{
                .sum = &.{ // b[1] xor carry0
                    b[1].when_high().pt().and_factor(a[0].when_low()),
                    b[1].when_high().pt().and_factor(b[0].when_low()),
                    b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                },
                .pt0 = a[1].when_high().pt(),
            },
        };
        if (options.co) |co| {
            chip.mc(co.mc()).logic = comptime .{ .sum = &.{
                a[1].when_high().pt().and_factor(b[1].when_high()),
                a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
            }};
        }
    }

    // p[i] = a[i] | b[i]
    // g[i] = a[i] & b[i]
    // k[i] = ~a[i] & ~b[i]

    if (options.g) |g| {
        // g = g[1] | p[1] & g[0]
        chip.mc(g.mc()).logic = comptime .{ .sum = &.{
            a[1].when_high().pt().and_factor(b[1].when_high()),
            a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
            b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
        }};
    }

    if (options.p) |p| {
        // p = p[1] & p[0]
        chip.mc(p.mc()).logic = comptime .{ .sum = &.{
            a[1].when_high().pt().and_factor(a[0].when_high()),
            a[1].when_high().pt().and_factor(b[0].when_high()),
            b[1].when_high().pt().and_factor(a[0].when_high()),
            b[1].when_high().pt().and_factor(b[0].when_high()),
        }};
    }

    if (options.k) |k| {
        // k = k[1] | ~g[1] & k[0]
        chip.mc(k.mc()).logic = comptime .{ .sum = &.{
            a[1].when_low().pt().and_factor(b[1].when_low()),
            a[1].when_low().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
            b[1].when_low().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
        }};
    }
}

const Add3_Options = struct {
    a: *const [3]Chip.Signal,
    b: *const [3]Chip.Signal,
    sum: *const [3]Chip.Signal,
    co: ?Chip.Signal = null,
};
/// 3-bit adder without carry in and with optional carry out.
/// Useful as the LSB adder when overall cin is always going to be 0.
/// Note there's no point in P/G/K outputs in this case since the final carry out can be calculated just as quickly.
/// Uses 3 macrocells and 4 PT clusters (without carry out)
/// Uses 4 macrocells and 6 PT clusters (with carry out)
fn add3(chip: *Chip, comptime options: Add3_Options) void {
    const a = options.a;
    const b = options.b;
    
    chip.mc(options.sum[0].mc()).logic = comptime .{
        .sum_xor_pt0 = .{
            .sum = &.{ b[0].when_high().pt() },
            .pt0 = a[0].when_high().pt(),
        },
    };
    // carry0 = a[0] & b[0]
    chip.mc(options.sum[1].mc()).logic = comptime .{
        .sum_xor_pt0 = .{
            .sum = &.{ // b[1] xor carry0
                b[1].when_high().pt().and_factor(a[0].when_low()),
                b[1].when_high().pt().and_factor(b[0].when_low()),
                b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
            },
            .pt0 = a[1].when_high().pt(),
        },
    };
    // carry1 = a[1] & b[1] | a[1] & a[0] & b[0] | b[1] & a[0] & b[0]
    // ~carry1 = ~a[1] & ~b[1] | ~a[1] & ~a[0] | ~a[1] & ~b[0] | ~b[1] & ~a[0] | ~b[1] & ~b[0]
    chip.mc(options.sum[2].mc()).logic = comptime .{
        .sum_xor_pt0 = .{
            .sum = &.{ // b[2] xor carry1
                b[2].when_low().pt().and_factor(a[1].when_high()).and_factor(b[1].when_high()),
                b[2].when_low().pt().and_factor(a[1].when_high()).and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                b[2].when_low().pt().and_factor(b[1].when_high()).and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(b[1].when_low()),
                b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(a[0].when_low()),
                b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(b[0].when_low()),
                b[2].when_high().pt().and_factor(b[1].when_low()).and_factor(a[0].when_low()),
                b[2].when_high().pt().and_factor(b[1].when_low()).and_factor(b[0].when_low()),
            },
            .pt0 = a[2].when_high().pt(),
        },
    };

    if (options.co) |co| {
        chip.mc(co.mc()).logic = comptime .{ .sum = &.{
            a[2].when_high().pt().and_factor(b[2].when_high()),
            a[1].when_high().pt().and_factor(b[1].when_high()).and_factor(a[2].when_high()),
            a[1].when_high().pt().and_factor(b[1].when_high()).and_factor(b[2].when_high()),
            a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(a[1].when_high()).and_factor(a[2].when_high()),
            a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(a[1].when_high()).and_factor(b[2].when_high()),
            a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(b[1].when_high()).and_factor(a[2].when_high()),
            a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(b[1].when_high()).and_factor(b[2].when_high()),
        }};
    }
}

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

const Signal = Chip.Signal;
const MC_Ref = lc4k.MC_Ref;

const lc4k = @import("lc4k");
const std = @import("std");
