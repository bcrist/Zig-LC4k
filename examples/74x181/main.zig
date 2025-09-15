// An implementation of the once-venerable 74x181 4-bit ALU

const Chip = lc4k.LC4032ZE_TQFP48;

const in = struct {
    pub const Cin = Chip.pins._2.pad();
    pub const _A = [_]Signal {
        Chip.pins._14.pad(),
        Chip.pins._15.pad(),
        Chip.pins._16.pad(),
        Chip.pins._17.pad(),
    };

    pub const _B = [_]Signal {
        Chip.pins._38.pad(),
        Chip.pins._39.pad(),
        Chip.pins._40.pad(),
        Chip.pins._41.pad(),
    };

    pub const S = [_]Signal {
        Chip.pins._20.pad(),
        Chip.pins._21.pad(),
        Chip.pins._22.pad(),
        Chip.pins._23.pad(),
    };

    pub const M = Chip.pins._24.pad();
};

const out = struct {
    pub const _F = [_]Signal {
        Chip.pins._7.pad(),
        Chip.pins._8.pad(),
        Chip.pins._9.pad(),
        Chip.pins._10.pad(),
    };

    pub const Cout = Chip.pins._3.pad();
    pub const _G = Chip.pins._47.pad();
    pub const _P = Chip.pins._48.pad();
    pub const A_eq_B = Chip.pins._31.pad();
};

const buried = struct {
    pub const TA = [_]Signal {
        in._A[0].fb(),
        in._A[1].fb(),
        in._A[2].fb(),
        in._A[3].fb(),
    };

    pub const TB = [_]Signal {
        in._B[0].fb(),
        in._B[1].fb(),
        in._B[2].fb(),
        in._B[3].fb(),
    };

    pub const TX = [_]Signal {
        in.S[0].fb(),
        in.S[1].fb(),
        in.S[2].fb(),
        in.S[3].fb(),
    };

    pub const @".fb" = .{
        ._F = [_]Signal {
            out._F[0].fb(),
            out._F[1].fb(),
            out._F[2].fb(),
            out._F[3].fb(),
        },
    };
};

pub fn main() !void {
    var chip = Chip {};

    var names = Chip.Names.init(gpa.allocator());
    names.fallback = null;
    try names.add_glb_name(0, "X");
    try names.add_glb_name(1, "Y");
    try names.add_names(in, .{});
    try names.add_names(out, .{});
    try names.add_names(buried, .{});

    var lp: Chip.Logic_Parser = .{
        .gpa = gpa.allocator(),
        .arena = .init(gpa.allocator()),
        .names = &names,
    };
    defer lp.arena.deinit();

    try lp.assign_logic(&chip, &buried.TA, "~(_A & _B & S[3] | _A & ~_B & S[2])", .{ .optimize = true });
    try lp.assign_logic(&chip, &buried.TB, "~(~_B & S[1] | _B & S[0] | _A)", .{ .optimize = true });
    try lp.assign_logic(&chip, &buried.TX, "TA ^ TB", .{});

    {
        var mc = chip.mc(out._P.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~&TA", .{});
    }

    {
        var mc = chip.mc(out._G.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~(TB[3] | TB[2] & TA[3] | TB[1] & TA[3] & TA[2] | TB[0] & TA[3] & TA[2] * TA[1])", .{ .optimize = true });
    }

    {
        var mc = chip.mc(out.Cout.mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("TB[3] | TB[2] & TA[3] | TB[1] & &TA[:2] | TB[0] & &TA[:1] | Cin & &TA", .{ .optimize = true });
    }

    {
        var mc = chip.mc(out._F[0].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~TX[0] ^ ~M & Cin", .{ .optimize = true });
    }
    {
        var mc = chip.mc(out._F[1].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~TX[1] ^ ~M & (TA[0] & Cin | TB[0])", .{ .optimize = true });
    }
    {
        var mc = chip.mc(out._F[2].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~TX[2] ^ ~M & (&TA[1:] & Cin | TA[1] & TB[0] | TB[1])", .{ .optimize = true });
    }
    {
        var mc = chip.mc(out._F[3].mc());
        mc.output.oe = .output_only;
        mc.output.slew_rate = .fast;
        mc.logic = try lp.logic("~TX[3] ^ ~M & (&TA[2:] & Cin | &TA[2:1] & TB[0] | TA[2] & TB[1] | TB[2])", .{ .optimize = true });
    }

    {
        var mc = chip.mc(out.A_eq_B.mc());
        mc.output.oe = .output_only;
        mc.output.drive_type = .open_drain;
        mc.logic = try lp.logic("& @fb _F", .{});
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const results = try chip.assemble(arena.allocator(), .{});

    const design_name = "74x181";
    try Chip.write_jed_file(results.jedec, design_name ++ ".jed", .{});
    try Chip.write_svf_file(results.jedec, design_name ++ ".svf", .{});
    try Chip.write_report_file(5, results.jedec, design_name ++ ".html", .{
        .design_name = design_name,
        .notes = "An implementation of the once-venerable 74x181 4-bit ALU",
        .errors = results.errors.items,
        .names = &names,
    });
}

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

const Signal = Chip.Signal;

const lc4k = @import("lc4k");
const std = @import("std");
