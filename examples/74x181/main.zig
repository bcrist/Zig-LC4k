// An implementation of the once-venerable 74x181 4-bit ALU

const Chip = lc4k.LC4032ZE_TQFP48;

pub fn main() !void {
    var chip = Chip {};

    const in = comptime .{
        .Cin = Chip.pins._2.pad(),
        .@"~A" = [_]Signal {
            Chip.pins._14.pad(),
            Chip.pins._15.pad(),
            Chip.pins._16.pad(),
            Chip.pins._17.pad(),
        },

        .@"~B" = [_]Signal {
            Chip.pins._38.pad(),
            Chip.pins._39.pad(),
            Chip.pins._40.pad(),
            Chip.pins._41.pad(),
        },

        .S = [_]Signal {
            Chip.pins._20.pad(),
            Chip.pins._21.pad(),
            Chip.pins._22.pad(),
            Chip.pins._23.pad(),
        },

        .M = Chip.pins._24.pad(),
    };

    const out = comptime .{
        .@"~F" = [_]Signal {
            Chip.pins._7.pad(),
            Chip.pins._8.pad(),
            Chip.pins._9.pad(),
            Chip.pins._10.pad(),
        },

        .Cout = Chip.pins._3.pad(),
        .@"~G" = Chip.pins._47.pad(),
        .@"~P" = Chip.pins._48.pad(),
        .@"A=B" = Chip.pins._31.pad(),
    };

    const buried = comptime .{
        .TA = [_]Signal {
            in.@"~A"[0].fb(),
            in.@"~A"[1].fb(),
            in.@"~A"[2].fb(),
            in.@"~A"[3].fb(),
        },

        .TB = [_]Signal {
            in.@"~B"[0].fb(),
            in.@"~B"[1].fb(),
            in.@"~B"[2].fb(),
            in.@"~B"[3].fb(),
        },

        .TX = [_]Signal {
            in.S[0].fb(),
            in.S[1].fb(),
            in.S[2].fb(),
            in.S[3].fb(),
        },

        .@".fb" = .{
            .@"~F" = [_]Signal {
                out.@"~F"[0].fb(),
                out.@"~F"[1].fb(),
                out.@"~F"[2].fb(),
                out.@"~F"[3].fb(),
            },
        },
    };

    var names = Chip.Names.init(gpa.allocator());
    names.fallback = null;
    try names.add_glb_name(0, "X");
    try names.add_glb_name(1, "Y");
    try names.add_names(in, .{});
    try names.add_names(out, .{});
    try names.add_names(buried, .{});

    inline for (in.@"~A", in.@"~B", buried.TA) |a, b, ta| {
        var mc = chip.mc(ta.mc());
        mc.logic = comptime .{ .sum_inverted = &.{
            a.when_high().pt()  .and_factor(b.when_high())  .and_factor(in.S[3].when_high()),
            a.when_high().pt()  .and_factor(b.when_low())   .and_factor(in.S[2].when_high()),
        }};
    }

    inline for (in.@"~A", in.@"~B", buried.TB) |a, b, tb| {
        var mc = chip.mc(tb.mc());
        mc.logic = comptime .{ .sum_inverted = &.{
            b.when_low().pt()   .and_factor(in.S[1].when_high()),
            b.when_high().pt()  .and_factor(in.S[0].when_high()),
            a.when_high().pt(),
        }};
    }

    {
        var mc = chip.mc(out.@"~P".mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_inverted = &.{
            buried.TA[3].when_high().pt()
                .and_factor(buried.TA[2].when_high())
                .and_factor(buried.TA[1].when_high())
                .and_factor(buried.TA[0].when_high()),
        }};
    }

    {
        var mc = chip.mc(out.@"~G".mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_inverted = &.{
            buried.TB[3].when_high().pt(),
            buried.TB[2].when_high().pt() .and_factor(buried.TA[3].when_high()),
            buried.TB[1].when_high().pt() .and_factor(buried.TA[3].when_high()) .and_factor(buried.TA[2].when_high()),
            buried.TB[0].when_high().pt() .and_factor(buried.TA[3].when_high()) .and_factor(buried.TA[2].when_high()) .and_factor(buried.TA[1].when_high()),
        }};
    }

    {
        var mc = chip.mc(out.Cout.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum = &.{
            buried.TB[3].when_high().pt(),
            buried.TB[2].when_high().pt() .and_factor(buried.TA[3].when_high()),
            buried.TB[1].when_high().pt() .and_factor(buried.TA[3].when_high()) .and_factor(buried.TA[2].when_high()),
            buried.TB[0].when_high().pt() .and_factor(buried.TA[3].when_high()) .and_factor(buried.TA[2].when_high()) .and_factor(buried.TA[1].when_high()),
            in.Cin.when_high().pt()       .and_factor(buried.TA[3].when_high()) .and_factor(buried.TA[2].when_high()) .and_factor(buried.TA[1].when_high()) .and_factor(buried.TA[0].when_high()),
        }};
    }

    inline for (buried.TA, buried.TB, buried.TX) |ta, tb, tx| {
        var mc = chip.mc(tx.mc());
        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{ ta.when_high().pt() },
            .pt0 = tb.when_high().pt()
        }};
    }

    {
        var mc = chip.mc(out.@"~F"[0].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                in.M.when_low().pt() .and_factor(in.Cin.when_high()),
            },
            .pt0 = buried.TX[0].when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(out.@"~F"[1].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                in.M.when_low().pt() .and_factor(buried.TA[0].when_high()) .and_factor(in.Cin.when_high()),
                in.M.when_low().pt() .and_factor(buried.TB[0].when_high()),
            },
            .pt0 = buried.TX[1].when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(out.@"~F"[2].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                in.M.when_low().pt() .and_factor(buried.TA[1].when_high()) .and_factor(buried.TA[0].when_high()) .and_factor(in.Cin.when_high()),
                in.M.when_low().pt() .and_factor(buried.TA[1].when_high()) .and_factor(buried.TB[0].when_high()),
                in.M.when_low().pt() .and_factor(buried.TB[1].when_high()),
            },
            .pt0 = buried.TX[2].when_low().pt(),
        }};
    }
    {
        var mc = chip.mc(out.@"~F"[3].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;

        mc.logic = comptime .{ .sum_xor_pt0 = .{
            .sum = &.{
                in.M.when_low().pt() .and_factor(buried.TA[2].when_high()) .and_factor(buried.TA[1].when_high()) .and_factor(buried.TA[0].when_high()) .and_factor(in.Cin.when_high()),
                in.M.when_low().pt() .and_factor(buried.TA[2].when_high()) .and_factor(buried.TA[1].when_high()) .and_factor(buried.TB[0].when_high()),
                in.M.when_low().pt() .and_factor(buried.TA[2].when_high()) .and_factor(buried.TB[1].when_high()),
                in.M.when_low().pt() .and_factor(buried.TB[2].when_high()),
            },
            .pt0 = buried.TX[3].when_low().pt(),
        }};
    }

    {
        var mc = chip.mc(out.@"A=B".mc());
        mc.output.oe = .output_only;
        mc.output.drive_type = .open_drain;

        mc.logic = comptime .{ .sum = &.{
            out.@"~F"[0].fb().when_high().pt()
                .and_factor(out.@"~F"[1].fb().when_high())
                .and_factor(out.@"~F"[2].fb().when_high())
                .and_factor(out.@"~F"[3].fb().when_high()),
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

const Signal = Chip.Signal;
const MC_Ref = lc4k.MC_Ref;

const lc4k = @import("lc4k");
const std = @import("std");
