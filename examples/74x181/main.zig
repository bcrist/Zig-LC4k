// An implementation of the once-venerable 74x181 4-bit ALU

const Chip = lc4k.LC4032ZE_TQFP48;

pub fn main() !void {
    var chip = Chip {};

    // inputs:
    const carry_in = comptime GRP.mc_pad(Chip.pins._2.mc());

    const input_a: [4]GRP = comptime .{
        GRP.mc_pad(Chip.pins._14.mc()),
        GRP.mc_pad(Chip.pins._15.mc()),
        GRP.mc_pad(Chip.pins._16.mc()),
        GRP.mc_pad(Chip.pins._17.mc()),
    };

    const input_b: [4]GRP = comptime .{
        GRP.mc_pad(Chip.pins._38.mc()),
        GRP.mc_pad(Chip.pins._39.mc()),
        GRP.mc_pad(Chip.pins._40.mc()),
        GRP.mc_pad(Chip.pins._41.mc()),
    };

    const op_sel: [4]GRP = comptime .{
        GRP.mc_pad(Chip.pins._20.mc()),
        GRP.mc_pad(Chip.pins._21.mc()),
        GRP.mc_pad(Chip.pins._22.mc()),
        GRP.mc_pad(Chip.pins._23.mc()),
    };
    const op_mode = comptime GRP.mc_pad(Chip.pins._24.mc());


    // outputs:
    const result: [4]GRP = comptime .{
        GRP.mc_pad(Chip.pins._7.mc()),
        GRP.mc_pad(Chip.pins._8.mc()),
        GRP.mc_pad(Chip.pins._9.mc()),
        GRP.mc_pad(Chip.pins._10.mc()),
    };

    const carry_out = GRP.mc_pad(Chip.pins._3.mc());
    const carry_generate = GRP.mc_pad(Chip.pins._47.mc());
    const carry_propagate = GRP.mc_pad(Chip.pins._48.mc());
    const equal = GRP.mc_pad(Chip.pins._31.mc());

    // buried macrocells:
    const input_temp_a: [4]MC_Ref = comptime .{
        input_a[0].mc(),
        input_a[1].mc(),
        input_a[2].mc(),
        input_a[3].mc(),
    };

    const input_temp_b: [4]MC_Ref = comptime .{
        input_b[0].mc(),
        input_b[1].mc(),
        input_b[2].mc(),
        input_b[3].mc(),
    };

    const xor_temp: [4]MC_Ref = comptime .{
        op_sel[0].mc(),
        op_sel[1].mc(),
        op_sel[2].mc(),
        op_sel[3].mc(),
    };

    var names = Chip.Names.init(gpa.allocator());
    names.fallback = null;
    try names.add_glb_name(0, "X");
    try names.add_glb_name(1, "Y");
    try names.add_signal_name(carry_in, "Cin");
    try names.add_signal_name(input_a[0], "~A[0]");
    try names.add_signal_name(input_a[1], "~A[1]");
    try names.add_signal_name(input_a[2], "~A[2]");
    try names.add_signal_name(input_a[3], "~A[3]");
    try names.add_signal_name(input_b[0], "~B[0]");
    try names.add_signal_name(input_b[1], "~B[1]");
    try names.add_signal_name(input_b[2], "~B[2]");
    try names.add_signal_name(input_b[3], "~B[3]");
    try names.add_signal_name(op_sel[0], "S[0]");
    try names.add_signal_name(op_sel[1], "S[1]");
    try names.add_signal_name(op_sel[2], "S[2]");
    try names.add_signal_name(op_sel[3], "S[3]");
    try names.add_signal_name(op_mode, "M");
    try names.add_signal_name(result[0], "~F[0]");
    try names.add_signal_name(result[1], "~F[1]");
    try names.add_signal_name(result[2], "~F[2]");
    try names.add_signal_name(result[3], "~F[3]");
    try names.add_mc_name(result[0].mc(), "~F[0]");
    try names.add_mc_name(result[1].mc(), "~F[1]");
    try names.add_mc_name(result[2].mc(), "~F[2]");
    try names.add_mc_name(result[3].mc(), "~F[3]");
    try names.add_signal_name(GRP.mc_fb(result[0].mc()), "~F[0] fb");
    try names.add_signal_name(GRP.mc_fb(result[1].mc()), "~F[1] fb");
    try names.add_signal_name(GRP.mc_fb(result[2].mc()), "~F[2] fb");
    try names.add_signal_name(GRP.mc_fb(result[3].mc()), "~F[3] fb");
    try names.add_signal_name(carry_out, "Cout");
    try names.add_signal_name(equal, "A=B");
    try names.add_signal_name(carry_generate, "~G");
    try names.add_signal_name(carry_propagate, "~P");
    try names.add_signal_name(GRP.mc_fb(input_temp_a[0]), "TA[0]");
    try names.add_signal_name(GRP.mc_fb(input_temp_a[1]), "TA[1]");
    try names.add_signal_name(GRP.mc_fb(input_temp_a[2]), "TA[2]");
    try names.add_signal_name(GRP.mc_fb(input_temp_a[3]), "TA[3]");
    try names.add_signal_name(GRP.mc_fb(input_temp_b[0]), "TB[0]");
    try names.add_signal_name(GRP.mc_fb(input_temp_b[1]), "TB[1]");
    try names.add_signal_name(GRP.mc_fb(input_temp_b[2]), "TB[2]");
    try names.add_signal_name(GRP.mc_fb(input_temp_b[3]), "TB[3]");
    try names.add_signal_name(GRP.mc_fb(xor_temp[0]), "TX[0]");
    try names.add_signal_name(GRP.mc_fb(xor_temp[1]), "TX[1]");
    try names.add_signal_name(GRP.mc_fb(xor_temp[2]), "TX[2]");
    try names.add_signal_name(GRP.mc_fb(xor_temp[3]), "TX[3]");

    // configure TA macrocells
    inline for (input_a, input_b, input_temp_a) |a, b, mcref| {
        var mc = chip.mc(mcref);
        mc.logic = comptime .{ .sum_inverted = &.{
            a.when_high().pt()  .and_factor(b.when_high())  .and_factor(op_sel[3].when_high()),
            a.when_high().pt()  .and_factor(b.when_low())   .and_factor(op_sel[2].when_high()),
        }};
    }

    // configure TB macrocells
    inline for (input_a, input_b, input_temp_b) |a, b, mcref| {
        var mc = chip.mc(mcref);
        mc.logic = comptime .{ .sum_inverted = &.{
            b.when_low().pt()   .and_factor(op_sel[1].when_high()),
            b.when_high().pt()  .and_factor(op_sel[0].when_high()),
            a.when_high().pt(),
        }};
    }

    // configure ~P
    {
        var mc = chip.mc(carry_propagate.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_inverted = &.{
            GRP.mc_fb(input_temp_a[3]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[0]).when_high()),
        }};
    }

    // configure ~G
    {
        var mc = chip.mc(carry_generate.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_inverted = &.{
            GRP.mc_fb(input_temp_b[3]).when_high().pt(),
            GRP.mc_fb(input_temp_b[2]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()),
            GRP.mc_fb(input_temp_b[1]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()),
            GRP.mc_fb(input_temp_b[0]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()),
        }};
    }

    // configure Cout
    {
        var mc = chip.mc(carry_out.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum = &.{
            GRP.mc_fb(input_temp_b[3]).when_high().pt(),
            GRP.mc_fb(input_temp_b[2]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()),
            GRP.mc_fb(input_temp_b[1]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()),
            GRP.mc_fb(input_temp_b[0]).when_high().pt() .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()),
            carry_in.when_high().pt()                   .and_factor(GRP.mc_fb(input_temp_a[3]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[0]).when_high()),
        }};
    }

    // configure TX macrocells
    inline for (input_temp_a, input_temp_b, xor_temp) |a, b, mcref| {
        var mc = chip.mc(mcref);
        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{ GRP.mc_fb(a).when_high().pt() },
            .pt0 = GRP.mc_fb(b).when_high().pt()
        }};
    }

    // configure F
    {
        var mc = chip.mc(result[0].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                op_mode.when_low().pt() .and_factor(carry_in.when_high()),
            },
            .pt0 = GRP.mc_fb(xor_temp[0]).when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(result[1].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[0]).when_high()) .and_factor(carry_in.when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_b[0]).when_high()),
            },
            .pt0 = GRP.mc_fb(xor_temp[1]).when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(result[2].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[0]).when_high()) .and_factor(carry_in.when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_b[0]).when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_b[1]).when_high()),
            },
            .pt0 = GRP.mc_fb(xor_temp[2]).when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(result[3].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[0]).when_high()) .and_factor(carry_in.when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_a[1]).when_high()) .and_factor(GRP.mc_fb(input_temp_b[0]).when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_a[2]).when_high()) .and_factor(GRP.mc_fb(input_temp_b[1]).when_high()),
                op_mode.when_low().pt() .and_factor(GRP.mc_fb(input_temp_b[2]).when_high()),
            },
            .pt0 = GRP.mc_fb(xor_temp[3]).when_low().pt(),
        }};
    }

    // configure A=B
    {
        var mc = chip.mc(equal.mc());
        mc.output.oe = .output_only;
        mc.output.drive_type = .open_drain;

        mc.logic = comptime .{ .sum = &.{
            GRP.mc_fb(result[0].mc()).when_high().pt()
                .and_factor(GRP.mc_fb(result[1].mc()).when_high())
                .and_factor(GRP.mc_fb(result[2].mc()).when_high())
                .and_factor(GRP.mc_fb(result[3].mc()).when_high()),
        }};
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator());

    var jed_file = try std.fs.cwd().createFile("74x181.jed", .{});
    defer jed_file.close();
    try Chip.write_jed(results.jedec, jed_file.writer(), .{});

    var svf_file = try std.fs.cwd().createFile("74x181.svf", .{});
    defer svf_file.close();
    try Chip.write_svf(results.jedec, svf_file.writer(), .{});

    var report_file = try std.fs.cwd().createFile("74x181.html", .{});
    defer report_file.close();
    try Chip.write_report(5, results.jedec, report_file.writer(), .{
        .design_name = "74x181",
        .notes = "An implementation of the once-venerable 74x181 4-bit ALU",
        .assembly_errors = results.errors.items,
        .names = &names,
    });
}

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

const GRP = Chip.GRP;
const PT = Chip.PT;
const MC_Ref = lc4k.MC_Ref;

const lc4k = @import("lc4k");
const std = @import("std");
