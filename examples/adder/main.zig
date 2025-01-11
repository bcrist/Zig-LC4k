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

fn configure_chip() Chip {
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
    chip.mc(buried.C4.mc()).logic = comptime .{ .sum = &.{
        buried.G4.when_high().pt(),
        buried.P4.when_high().pt().and_factor(buried.C2.when_high()),
    }};
    chip.mc(buried.C6.mc()).logic = comptime .{ .sum = &.{
        buried.G6.when_high().pt(),
        buried.P6.when_high().pt().and_factor(buried.G4.when_high()),
        buried.P6.when_high().pt().and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};
    chip.mc(buried.C8.mc()).logic = comptime .{ .sum = &.{
        buried.G8.when_high().pt(),
        buried.P8.when_high().pt().and_factor(buried.G6.when_high()),
        buried.P8.when_high().pt().and_factor(buried.P6.when_high()).and_factor(buried.G4.when_high()),
        buried.P8.when_high().pt().and_factor(buried.P6.when_high()).and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};
    chip.mc(buried.C10.mc()).logic = comptime .{ .sum = &.{
        buried.G10.when_high().pt(),
        buried.P10.when_high().pt().and_factor(buried.G8.when_high()),
        buried.P10.when_high().pt().and_factor(buried.P8.when_high()).and_factor(buried.G6.when_high()),
        buried.P10.when_high().pt().and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.G4.when_high()),
        buried.P10.when_high().pt().and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};
    chip.mc(buried.C12.mc()).logic = comptime .{ .sum = &.{
        buried.G12.when_high().pt(),
        buried.P12.when_high().pt().and_factor(buried.G10.when_high()),
        buried.P12.when_high().pt().and_factor(buried.P10.when_high()).and_factor(buried.G8.when_high()),
        buried.P12.when_high().pt().and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.G6.when_high()),
        buried.P12.when_high().pt().and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.G4.when_high()),
        buried.P12.when_high().pt().and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};
    chip.mc(buried.C14.mc()).logic = comptime .{ .sum = &.{
        buried.G14.when_high().pt(),
        buried.P14.when_high().pt().and_factor(buried.G12.when_high()),
        buried.P14.when_high().pt().and_factor(buried.P12.when_high()).and_factor(buried.G10.when_high()),
        buried.P14.when_high().pt().and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.G8.when_high()),
        buried.P14.when_high().pt().and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.G6.when_high()),
        buried.P14.when_high().pt().and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.G4.when_high()),
        buried.P14.when_high().pt().and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};
    chip.mc(out.C.mc()).logic = comptime .{ .sum = &.{
        buried.G15.when_high().pt(),
        buried.P15.when_high().pt().and_factor(buried.G14.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.G12.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.P12.when_high()).and_factor(buried.G10.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.G8.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.G6.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.G4.when_high()),
        buried.P15.when_high().pt().and_factor(buried.P14.when_high()).and_factor(buried.P12.when_high()).and_factor(buried.P10.when_high()).and_factor(buried.P8.when_high()).and_factor(buried.P6.when_high()).and_factor(buried.P4.when_high()).and_factor(buried.C2.when_high()),
    }};

    return chip;
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

pub fn main() !void {
    var chip = configure_chip();
    var names = Chip.Names.init(gpa.allocator());
    try names.add_names(in, .{});
    try names.add_names(out, .{});
    try names.add_names(buried, .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

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
        .assembly_errors = results.errors.items,
        .names = &names,
    });
}

test configure_chip {
    const chip = configure_chip();
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

const Signal = Chip.Signal;
const MC_Ref = lc4k.MC_Ref;

const lc4k = @import("lc4k");
const std = @import("std");
