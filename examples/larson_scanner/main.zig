// This example implements a larson scanner "moving lights" effect.

const Chip = lc4k.LC4064ZC_TQFP100;

const signals = struct {
    pub const out = [_]Chip.Signal {
        .io_A0, .io_A1, .io_A2, .io_A3,
        .io_A4, .io_A5, .io_A6, .io_A7,
        .io_A8, .io_A9, .io_A10, .io_A11,
        .io_A12, .io_A13, .io_A14, .io_A15,
        .io_B15, .io_B14, .io_B13, .io_B12,
        .io_B11, .io_B10, .io_B9, .io_B8,
        .io_B7, .io_B6, .io_B5, .io_B4,
        .io_B3, .io_B2, .io_B1, .io_B0,
    };

    pub const @".fb" = struct {
        pub const out = [_]Chip.Signal {
            signals.out[0].fb(), signals.out[1].fb(), signals.out[2].fb(), signals.out[3].fb(),
            signals.out[4].fb(), signals.out[5].fb(), signals.out[6].fb(), signals.out[7].fb(),
            signals.out[8].fb(), signals.out[9].fb(), signals.out[10].fb(), signals.out[11].fb(),
            signals.out[12].fb(), signals.out[13].fb(), signals.out[14].fb(), signals.out[15].fb(),
            signals.out[16].fb(), signals.out[17].fb(), signals.out[18].fb(), signals.out[19].fb(),
            signals.out[20].fb(), signals.out[21].fb(), signals.out[22].fb(), signals.out[23].fb(),
            signals.out[24].fb(), signals.out[25].fb(), signals.out[26].fb(), signals.out[27].fb(),
            signals.out[28].fb(), signals.out[29].fb(), signals.out[30].fb(), signals.out[31].fb(),
        };
    };

    pub const dir = Chip.Signal.mc_C0;
    pub const none = Chip.Signal.mc_C15;
};

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    var names = Chip.Names.init(gpa);
    @setEvalBranchQuota(10000);
    try names.add_names(signals, .{});
    defer names.deinit();

    var lp: Chip.Logic_Parser = .{
        .gpa = gpa,
        .arena = arena.allocator(),
        .names = &names,
    };

    var chip = Chip {};

    const clk = try lp.pt_with_polarity("pin_12", .{});

    chip.glb[0].shared_pt_clock = clk;
    chip.glb[1].shared_pt_clock = clk;
    chip.glb[2].shared_pt_clock = clk;

    var dir_mc = chip.mc(signals.dir.mc());
    dir_mc.func = .{ .t_ff = .{
        .init_state = 1,
        .clock = .shared_pt_clock,
    }};
    dir_mc.output.oe = .output_only;
    dir_mc.logic = try lp.logic("none", .{});

    var none_mc = chip.mc(signals.none.mc());
    none_mc.output.oe = .output_only;
    none_mc.logic = try lp.logic("@fb &~out[31 28 25 22 19 16 15 12 9 6 3 0]", .{});

    @setEvalBranchQuota(10000);

    inline for (signals.out, 0..) |out, bit| {
        var mc = chip.mc(out.mc());
        mc.func = .{ .d_ff = .{ .clock = .shared_pt_clock }};
        mc.output.oe = .output_only;

        const extra = .{
            .next_bit = bit + 1,
            .prev_bit = bit -| 1,
        };

        mc.logic = try lp.logic(switch (bit) {
            0  => " dir & @fb out[next_bit] |  dir & none | ~dir & @fb &{out[0]  ~out[<  3 6 9 12 15 16 19 22 25 28 31]}",
            31 => "~dir & @fb out[prev_bit] | ~dir & none |  dir & @fb &{out[31] ~out[<0 3 6 9 12 15 16 19 22 25 28   ]}",
            else => "@fb out[next_bit prev_bit][dir]",
        }, extra);
    }

    const results = try chip.assemble(arena.allocator(), .{});

    const design_name = "larson_scanner";
    try Chip.write_jed_file(results.jedec, design_name ++ ".jed", .{});
    try Chip.write_svf_file(results.jedec, design_name ++ ".svf", .{});
    try Chip.write_report_file(5, results.jedec, design_name ++ ".html", .{
        .design_name = design_name,
        .errors = results.errors.items,
        .names = &names,
    });
}

const gpa = std.heap.smp_allocator;

const lc4k = @import("lc4k");
const std = @import("std");
