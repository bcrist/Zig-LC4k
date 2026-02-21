// Implements a 16-bit priority encoder (i.e. count trailing zeroes)

const Chip = lc4k.LC4032ZE_TQFP48;

const signals = struct {
    pub const in = [_]Chip.Signal {
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

    pub const out = [_]Chip.Signal {
        .io_B0,
        .io_B2,
        .io_B4,
        .io_B6,
        .io_B8,
    };
};

pub fn main(init: std.process.Init) !void {
    var names = Chip.Names.init(init.gpa);
    defer names.deinit();

    try names.add_names(signals, .{});

    var lp: Chip.Logic_Parser = .{
        .gpa = init.gpa,
        .arena = init.arena.allocator(),
        .names = &names,
    };

    var chip = Chip {};

    @setEvalBranchQuota(10000);

    chip.mc(signals.out[0].mc()).logic = try lp.logic(
        \\   &{in[1] ~in[0]}
        \\ | &{in[3] ~in[2:]}
        \\ | &{in[5] ~in[4:]}
        \\ | &{in[7] ~in[6:]}
        \\ | &{in[9] ~in[8:]}
        \\ | &{in[11] ~in[10:]}
        \\ | &{in[13] ~in[12:]}
        \\ | &{in[15] ~in[14:]}
        , .{});

    chip.mc(signals.out[1].mc()).logic = try lp.logic(
        \\   &{in[2] ~in[1:]}
        \\ | &{in[3] ~in[2:]}
        \\ | &{in[6] ~in[5:]}
        \\ | &{in[7] ~in[6:]}
        \\ | &{in[10] ~in[9:]}
        \\ | &{in[11] ~in[10:]}
        \\ | &{in[14] ~in[13:]}
        \\ | &{in[15] ~in[14:]}
        , .{});

    chip.mc(signals.out[2].mc()).logic = try lp.logic(
        \\   &{in[4] ~in[3:]}
        \\ | &{in[5] ~in[4:]}
        \\ | &{in[6] ~in[5:]}
        \\ | &{in[7] ~in[6:]}
        \\ | &{in[12] ~in[11:]}
        \\ | &{in[13] ~in[12:]}
        \\ | &{in[14] ~in[13:]}
        \\ | &{in[15] ~in[14:]}
        , .{});

    chip.mc(signals.out[3].mc()).logic = try lp.logic(
        \\   &{in[8] ~in[7:]}
        \\ | &{in[9] ~in[8:]}
        \\ | &{in[10] ~in[9:]}
        \\ | &{in[11] ~in[10:]}
        \\ | &{in[12] ~in[11:]}
        \\ | &{in[13] ~in[12:]}
        \\ | &{in[14] ~in[13:]}
        \\ | &{in[15] ~in[14:]}
        , .{});

    chip.mc(signals.out[4].mc()).logic = try lp.logic("in == 16'0", .{});

    inline for (signals.out) |out| {
        chip.mc(out.mc()).output.oe = .output_only;
    }

    const results = try chip.assemble(init.arena.allocator(), .{});

    const design_name = "priority_encoder";
    try Chip.write_jed_file(init.io, results.jedec, design_name ++ ".jed", .{});
    try Chip.write_svf_file(init.io, results.jedec, design_name ++ ".svf", .{});
    try Chip.write_report_file(init.io, results.jedec, design_name ++ ".html", .{
        .speed_grade = 5,
        .design_name = design_name,
        .errors = results.errors.items,
        .names = &names,
    });
}

const lc4k = @import("lc4k");
const std = @import("std");
