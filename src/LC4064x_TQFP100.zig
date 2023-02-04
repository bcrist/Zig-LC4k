//[[!! include('devices', 'LC4064x_TQFP100') !! 983 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4064x_TQFP100;

pub const family = common.DeviceFamily.low_power;
pub const package = common.DevicePackage.TQFP100;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 12;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(356, 100);

pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
    in0,
    in1,
    in2,
    in3,
    in4,
    in5,
    io_A0,
    io_A1,
    io_A2,
    io_A3,
    io_A4,
    io_A5,
    io_A6,
    io_A7,
    io_A8,
    io_A9,
    io_A10,
    io_A11,
    io_A12,
    io_A13,
    io_A14,
    io_A15,
    io_B0,
    io_B1,
    io_B2,
    io_B3,
    io_B4,
    io_B5,
    io_B6,
    io_B7,
    io_B8,
    io_B9,
    io_B10,
    io_B11,
    io_B12,
    io_B13,
    io_B14,
    io_B15,
    io_C0,
    io_C1,
    io_C2,
    io_C3,
    io_C4,
    io_C5,
    io_C6,
    io_C7,
    io_C8,
    io_C9,
    io_C10,
    io_C11,
    io_C12,
    io_C13,
    io_C14,
    io_C15,
    io_D0,
    io_D1,
    io_D2,
    io_D3,
    io_D4,
    io_D5,
    io_D6,
    io_D7,
    io_D8,
    io_D9,
    io_D10,
    io_D11,
    io_D12,
    io_D13,
    io_D14,
    io_D15,
    mc_A0,
    mc_A1,
    mc_A2,
    mc_A3,
    mc_A4,
    mc_A5,
    mc_A6,
    mc_A7,
    mc_A8,
    mc_A9,
    mc_A10,
    mc_A11,
    mc_A12,
    mc_A13,
    mc_A14,
    mc_A15,
    mc_B0,
    mc_B1,
    mc_B2,
    mc_B3,
    mc_B4,
    mc_B5,
    mc_B6,
    mc_B7,
    mc_B8,
    mc_B9,
    mc_B10,
    mc_B11,
    mc_B12,
    mc_B13,
    mc_B14,
    mc_B15,
    mc_C0,
    mc_C1,
    mc_C2,
    mc_C3,
    mc_C4,
    mc_C5,
    mc_C6,
    mc_C7,
    mc_C8,
    mc_C9,
    mc_C10,
    mc_C11,
    mc_C12,
    mc_C13,
    mc_C14,
    mc_C15,
    mc_D0,
    mc_D1,
    mc_D2,
    mc_D3,
    mc_D4,
    mc_D5,
    mc_D6,
    mc_D7,
    mc_D8,
    mc_D9,
    mc_D10,
    mc_D11,
    mc_D12,
    mc_D13,
    mc_D14,
    mc_D15,
};

pub const mc_signals = [num_glbs][num_mcs_per_glb]GRP {
    .{ .mc_A0, .mc_A1, .mc_A2, .mc_A3, .mc_A4, .mc_A5, .mc_A6, .mc_A7, .mc_A8, .mc_A9, .mc_A10, .mc_A11, .mc_A12, .mc_A13, .mc_A14, .mc_A15, },
    .{ .mc_B0, .mc_B1, .mc_B2, .mc_B3, .mc_B4, .mc_B5, .mc_B6, .mc_B7, .mc_B8, .mc_B9, .mc_B10, .mc_B11, .mc_B12, .mc_B13, .mc_B14, .mc_B15, },
    .{ .mc_C0, .mc_C1, .mc_C2, .mc_C3, .mc_C4, .mc_C5, .mc_C6, .mc_C7, .mc_C8, .mc_C9, .mc_C10, .mc_C11, .mc_C12, .mc_C13, .mc_C14, .mc_C15, },
    .{ .mc_D0, .mc_D1, .mc_D2, .mc_D3, .mc_D4, .mc_D5, .mc_D6, .mc_D7, .mc_D8, .mc_D9, .mc_D10, .mc_D11, .mc_D12, .mc_D13, .mc_D14, .mc_D15, },
};

pub const mc_output_signals = [num_glbs][num_mcs_per_glb]?GRP {
    .{ .io_A0, .io_A1, .io_A2, .io_A3, .io_A4, .io_A5, .io_A6, .io_A7, .io_A8, .io_A9, .io_A10, .io_A11, .io_A12, .io_A13, .io_A14, .io_A15, },
    .{ .io_B0, .io_B1, .io_B2, .io_B3, .io_B4, .io_B5, .io_B6, .io_B7, .io_B8, .io_B9, .io_B10, .io_B11, .io_B12, .io_B13, .io_B14, .io_B15, },
    .{ .io_C0, .io_C1, .io_C2, .io_C3, .io_C4, .io_C5, .io_C6, .io_C7, .io_C8, .io_C9, .io_C10, .io_C11, .io_C12, .io_C13, .io_C14, .io_C15, },
    .{ .io_D0, .io_D1, .io_D2, .io_D3, .io_D4, .io_D5, .io_D6, .io_D7, .io_D8, .io_D9, .io_D10, .io_D11, .io_D12, .io_D13, .io_D14, .io_D15, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .io_A14, .io_B10, .io_B9, .mc_A5, .mc_A3, .io_A0, .mc_D13, .mc_D10, .mc_D8, .mc_C6, .io_C2, .clk3, },
    .{ .io_B13, .io_B11, .io_A8, .io_A4, .mc_A3, .mc_B2, .io_C14, .io_D10, .mc_C9, .io_D6, .mc_D4, .mc_C0, },
    .{ .mc_B14, .io_A12, .mc_A10, .mc_A7, .io_B2, .io_B0, .io_D14, .io_D12, .mc_C9, .mc_C6, .io_D3, .clk2, },
    .{ .io_A13, .mc_B10, .io_B8, .io_A5, .mc_A2, .clk0, .io_D13, .mc_D12, .mc_C8, .mc_D7, .io_D3, .io_D0, },
    .{ .mc_A14, .mc_B12, .in1, .mc_A7, .mc_B5, .io_A0, .mc_D15, .mc_D12, .io_C7, .mc_D6, .io_D2, .mc_C0, },
    .{ .io_A15, .mc_A12, .mc_A9, .mc_A6, .mc_B4, .mc_B1, .io_C13, .io_C12, .io_C7, .mc_D7, .io_C3, .mc_C1, },
    .{ .io_B14, .io_B12, .io_A9, .mc_A6, .mc_A4, .clk1, .mc_C14, .io_D10, .in5, .mc_C6, .io_D2, .io_C0, },
    .{ .io_B14, .mc_A11, .io_B8, .io_A4, .io_A2, .mc_A0, .mc_D15, .io_D12, .mc_D9, .mc_C5, .mc_C4, .io_C1, },
    .{ .mc_B13, .mc_B11, .io_A8, .mc_A7, .io_A3, .mc_A1, .mc_D13, .io_D11, .io_D9, .io_D5, .mc_C3, .mc_C1, },
    .{ .mc_A15, .io_A10, .io_B8, .io_A6, .mc_B4, .io_A1, .mc_C15, .io_D11, .io_C9, .io_D6, .io_C2, .mc_D1, },
    .{ .mc_B13, .io_B11, .io_A7, .io_B5, .mc_B3, .clk0, .mc_C14, .mc_C13, .mc_D9, .mc_C7, .io_C2, .clk2, },
    .{ .mc_B13, .io_A11, .in1, .io_B6, .io_B4, .io_B0, .io_C14, .mc_D11, .io_C9, .mc_C5, .mc_D3, .clk3, },
    .{ .mc_A14, .mc_B11, .io_A9, .mc_B7, .io_B2, .mc_B0, .mc_D14, .mc_D11, .in4, .mc_D5, .io_C2, .io_D0, },
    .{ .io_A14, .mc_B10, .mc_B8, .io_B6, .mc_B5, .mc_A1, .mc_C14, .mc_C12, .in4, .io_D7, .io_C3, .mc_D2, },
    .{ .in0, .io_B10, .mc_A10, .io_B6, .io_A3, .mc_B1, .mc_D14, .mc_C11, .io_C8, .mc_C7, .io_D2, .mc_D0, },
    .{ .in0, .mc_B12, .in2, .io_B5, .mc_A4, .mc_B2, .in3, .io_D11, .mc_D8, .mc_D7, .mc_D3, .mc_D2, },
    .{ .mc_B15, .mc_B12, .io_A7, .mc_B7, .io_B4, .mc_A1, .io_C13, .io_C10, .mc_C10, .io_D6, .io_D3, .mc_D0, },
    .{ .io_B14, .io_A12, .mc_B9, .mc_B6, .mc_B5, .mc_B2, .io_C13, .mc_D10, .mc_C8, .mc_C7, .io_C4, .mc_D1, },
    .{ .mc_B14, .io_B11, .mc_A9, .mc_B6, .io_B3, .io_A1, .mc_D15, .io_C11, .io_D9, .io_C6, .mc_D3, .io_C0, },
    .{ .io_B13, .mc_A12, .in1, .mc_B7, .io_B3, .clk0, .io_D15, .io_D12, .io_C8, .io_C5, .io_D4, .mc_D1, },
    .{ .mc_A15, .mc_A11, .io_B9, .mc_A6, .io_B3, .io_B1, .io_C14, .mc_C11, .mc_C10, .mc_D5, .mc_C3, .clk2, },
    .{ .io_B13, .io_B10, .mc_B8, .io_A6, .io_A2, .mc_B0, .io_D14, .mc_D12, .mc_C10, .io_D5, .mc_C2, .io_C0, },
    .{ .mc_B15, .mc_B10, .in2, .io_B7, .io_B2, .io_A0, .mc_C15, .mc_C11, .io_D8, .io_C6, .io_D4, .io_C1, },
    .{ .in0, .io_A11, .io_B9, .io_B7, .mc_A2, .io_A1, .io_C15, .io_C10, .mc_D9, .io_D5, .io_C3, .io_D1, },
    .{ .io_A15, .io_B12, .mc_B9, .io_B5, .io_A2, .io_A1, .io_D15, .mc_D11, .io_D8, .mc_D6, .mc_D4, .mc_D0, },
    .{ .io_A14, .io_A10, .mc_A8, .mc_B6, .mc_A4, .io_B1, .mc_D14, .mc_C13, .io_C7, .io_D5, .mc_D4, .io_C1, },
    .{ .mc_A15, .mc_B11, .mc_B8, .io_A4, .io_B4, .clk1, .io_D13, .io_C12, .mc_D8, .io_C6, .io_C4, .io_D1, },
    .{ .io_B15, .io_B12, .io_A8, .mc_A5, .mc_B5, .io_B1, .io_D14, .io_C10, .io_C9, .io_C5, .mc_C4, .io_D0, },
    .{ .mc_B15, .mc_A13, .io_A9, .io_A5, .mc_B4, .mc_A0, .mc_D13, .mc_C12, .io_C8, .mc_D6, .mc_C2, .io_D1, },
    .{ .mc_A14, .mc_A13, .mc_A8, .io_A6, .mc_A2, .mc_A1, .in3, .io_D10, .io_D8, .mc_C5, .io_C4, .clk2, },
    .{ .mc_B14, .mc_A12, .mc_A8, .io_B7, .mc_B3, .mc_B2, .io_D13, .mc_C12, .in5, .mc_D5, .mc_C4, .mc_D0, },
    .{ .io_A13, .mc_A11, .mc_B9, .mc_A5, .mc_B3, .io_B0, .mc_C15, .io_C12, .io_D9, .io_D7, .mc_C2, .mc_C0, },
    .{ .io_B15, .mc_A13, .io_A7, .mc_A7, .mc_A4, .mc_B1, .io_C15, .io_C11, .mc_C8, .mc_D5, .io_D4, .clk3, },
    .{ .io_B15, .io_A10, .mc_A9, .io_B7, .io_A3, .clk1, .io_D15, .mc_D10, .mc_C9, .mc_C5, .mc_C2, .mc_D2, },
    .{ .io_A13, .io_A12, .in2, .io_A6, .io_B4, .mc_A0, .io_C15, .mc_C13, .in4, .io_C5, .io_D2, .mc_C1, },
    .{ .io_A15, .io_A11, .mc_A10, .io_A5, .mc_A3, .mc_B0, .in3, .io_C11, .in5, .io_D7, .mc_C3, .mc_D1, },
};

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);

pub fn getGlbRange(glb: usize) jedec.FuseRange {
    std.debug.assert(glb < num_glbs);
    const index = num_glbs - glb - 1;
    return jedec_dimensions.subColumns(89 * index + 6, 83);
}

pub fn getGiRange(glb: usize, gi: usize) jedec.FuseRange {
    std.debug.assert(gi < num_gis_per_glb);
    return getGlbRange(glb).expandColumns(-6).subColumns(0, 6).subRows(gi * 2, 2);
}

pub fn getBClockRange(glb: usize) jedec.FuseRange {
    return getGlbRange(glb).subRows(79, 4).subColumns(0, 1);
}

pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(90, 355),
        1 => jedec.Fuse.init(91, 355),
        2 => jedec.Fuse.init(92, 355),
        3 => jedec.Fuse.init(93, 355),
        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(88, 355),
        1 => jedec.Fuse.init(89, 355),
        else => unreachable,
    };
}

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(87, 355);
}


pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 355)
    ).expandToContain(
        jedec.Fuse.init(86, 355)
    );
}
pub fn getExtraFloatInputFuses() []jedec.Fuse {
    return &.{
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 351),
        .clk1 => jedec.Fuse.init(94, 352),
        .clk2 => jedec.Fuse.init(94, 353),
        .clk3 => jedec.Fuse.init(94, 354),
        .in0 => jedec.Fuse.init(94, 355),
        .in1 => jedec.Fuse.init(95, 351),
        .in2 => jedec.Fuse.init(95, 352),
        .in3 => jedec.Fuse.init(95, 353),
        .in4 => jedec.Fuse.init(95, 354),
        .in5 => jedec.Fuse.init(95, 355),
        else => unreachable,
    };
}

pub fn getMacrocellRef(comptime which: anytype) common.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) common.GlbIndex {
    return internal.getGlbIndex(@This(), which);
}

pub fn getGrp(comptime which: anytype) GRP {
    return internal.getGrp(GRP, which);
}

pub fn getGrpInput(comptime which: anytype) GRP {
    return internal.getGrpInput(GRP, which);
}

pub fn getGrpFeedback(comptime which: anytype) GRP {
    return internal.getGrpFeedback(GRP, which);
}

pub fn getPin(comptime which: anytype) common.PinInfo {
    return internal.getPin(@This(), which);
}

pub const pins = struct {
    pub const _1 = common.PinInfo {
        .id = "1",
        .func = .{ .gnd = {} },
    };
    pub const _2 = common.PinInfo {
        .id = "2",
        .func = .{ .tdi = {} },
    };
    pub const _3 = common.PinInfo {
        .id = "3",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    pub const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    pub const _5 = common.PinInfo {
        .id = "5",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    pub const _6 = common.PinInfo {
        .id = "6",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    pub const _7 = common.PinInfo {
        .id = "7",
        .func = .{ .gnd = {} },
    };
    pub const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    pub const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    pub const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    pub const _11 = common.PinInfo {
        .id = "11",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    pub const _12 = common.PinInfo {
        .id = "12",
        .func = .{ .input = {} },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.in0),
    };
    pub const _13 = common.PinInfo {
        .id = "13",
        .func = .{ .vcco = {} },
    };
    pub const _14 = common.PinInfo {
        .id = "14",
        .func = .{ .io = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    pub const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    pub const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    pub const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    pub const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .gnd = {} },
    };
    pub const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B11),
    };
    pub const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    pub const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    pub const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    pub const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in1),
    };
    pub const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .tck = {} },
    };
    pub const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .vcc_core = {} },
    };
    pub const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .gnd = {} },
    };
    pub const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in2),
    };
    pub const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B7),
    };
    pub const _29 = common.PinInfo {
        .id = "29",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    pub const _30 = common.PinInfo {
        .id = "30",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    pub const _31 = common.PinInfo {
        .id = "31",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    pub const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .gnd = {} },
    };
    pub const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .vcco = {} },
    };
    pub const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B3),
    };
    pub const _35 = common.PinInfo {
        .id = "35",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    pub const _36 = common.PinInfo {
        .id = "36",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    pub const _37 = common.PinInfo {
        .id = "37",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    pub const _38 = common.PinInfo {
        .id = "38",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    pub const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    pub const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .vcc_core = {} },
    };
    pub const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    pub const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C1),
    };
    pub const _43 = common.PinInfo {
        .id = "43",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    pub const _44 = common.PinInfo {
        .id = "44",
        .func = .{ .io = 3 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C3),
    };
    pub const _45 = common.PinInfo {
        .id = "45",
        .func = .{ .vcco = {} },
    };
    pub const _46 = common.PinInfo {
        .id = "46",
        .func = .{ .gnd = {} },
    };
    pub const _47 = common.PinInfo {
        .id = "47",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    pub const _48 = common.PinInfo {
        .id = "48",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C5),
    };
    pub const _49 = common.PinInfo {
        .id = "49",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    pub const _50 = common.PinInfo {
        .id = "50",
        .func = .{ .io = 7 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C7),
    };
    pub const _51 = common.PinInfo {
        .id = "51",
        .func = .{ .gnd = {} },
    };
    pub const _52 = common.PinInfo {
        .id = "52",
        .func = .{ .tms = {} },
    };
    pub const _53 = common.PinInfo {
        .id = "53",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    pub const _54 = common.PinInfo {
        .id = "54",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C9),
    };
    pub const _55 = common.PinInfo {
        .id = "55",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    pub const _56 = common.PinInfo {
        .id = "56",
        .func = .{ .io = 11 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C11),
    };
    pub const _57 = common.PinInfo {
        .id = "57",
        .func = .{ .gnd = {} },
    };
    pub const _58 = common.PinInfo {
        .id = "58",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    pub const _59 = common.PinInfo {
        .id = "59",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C13),
    };
    pub const _60 = common.PinInfo {
        .id = "60",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
    };
    pub const _61 = common.PinInfo {
        .id = "61",
        .func = .{ .io = 15 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C15),
    };
    pub const _62 = common.PinInfo {
        .id = "62",
        .func = .{ .input = {} },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.in3),
    };
    pub const _63 = common.PinInfo {
        .id = "63",
        .func = .{ .vcco = {} },
    };
    pub const _64 = common.PinInfo {
        .id = "64",
        .func = .{ .io = 15 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D15),
    };
    pub const _65 = common.PinInfo {
        .id = "65",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    pub const _66 = common.PinInfo {
        .id = "66",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D13),
    };
    pub const _67 = common.PinInfo {
        .id = "67",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    pub const _68 = common.PinInfo {
        .id = "68",
        .func = .{ .gnd = {} },
    };
    pub const _69 = common.PinInfo {
        .id = "69",
        .func = .{ .io = 11 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D11),
    };
    pub const _70 = common.PinInfo {
        .id = "70",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    pub const _71 = common.PinInfo {
        .id = "71",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D9),
    };
    pub const _72 = common.PinInfo {
        .id = "72",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    pub const _73 = common.PinInfo {
        .id = "73",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in4),
    };
    pub const _74 = common.PinInfo {
        .id = "74",
        .func = .{ .tdo = {} },
    };
    pub const _75 = common.PinInfo {
        .id = "75",
        .func = .{ .vcc_core = {} },
    };
    pub const _76 = common.PinInfo {
        .id = "76",
        .func = .{ .gnd = {} },
    };
    pub const _77 = common.PinInfo {
        .id = "77",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in5),
    };
    pub const _78 = common.PinInfo {
        .id = "78",
        .func = .{ .io = 7 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D7),
    };
    pub const _79 = common.PinInfo {
        .id = "79",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
    };
    pub const _80 = common.PinInfo {
        .id = "80",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D5),
    };
    pub const _81 = common.PinInfo {
        .id = "81",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    pub const _82 = common.PinInfo {
        .id = "82",
        .func = .{ .gnd = {} },
    };
    pub const _83 = common.PinInfo {
        .id = "83",
        .func = .{ .vcco = {} },
    };
    pub const _84 = common.PinInfo {
        .id = "84",
        .func = .{ .io = 3 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D3),
    };
    pub const _85 = common.PinInfo {
        .id = "85",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    pub const _86 = common.PinInfo {
        .id = "86",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D1),
    };
    pub const _87 = common.PinInfo {
        .id = "87",
        .func = .{ .io_oe1 = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    pub const _88 = common.PinInfo {
        .id = "88",
        .func = .{ .clock = 3 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    pub const _89 = common.PinInfo {
        .id = "89",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    pub const _90 = common.PinInfo {
        .id = "90",
        .func = .{ .vcc_core = {} },
    };
    pub const _91 = common.PinInfo {
        .id = "91",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    pub const _92 = common.PinInfo {
        .id = "92",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    pub const _93 = common.PinInfo {
        .id = "93",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    pub const _94 = common.PinInfo {
        .id = "94",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A3),
    };
    pub const _95 = common.PinInfo {
        .id = "95",
        .func = .{ .vcco = {} },
    };
    pub const _96 = common.PinInfo {
        .id = "96",
        .func = .{ .gnd = {} },
    };
    pub const _97 = common.PinInfo {
        .id = "97",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    pub const _98 = common.PinInfo {
        .id = "98",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    pub const _99 = common.PinInfo {
        .id = "99",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    pub const _100 = common.PinInfo {
        .id = "100",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A7),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins._89,
    pins._38,
    pins._39,
    pins._88,
};

pub const oe_pins = [_]common.PinInfo {
    pins._91,
    pins._87,
};

pub const input_pins = [_]common.PinInfo {
    pins._12,
    pins._23,
    pins._27,
    pins._62,
    pins._73,
    pins._77,
};

pub const all_pins = [_]common.PinInfo {
    pins._1,
    pins._2,
    pins._3,
    pins._4,
    pins._5,
    pins._6,
    pins._7,
    pins._8,
    pins._9,
    pins._10,
    pins._11,
    pins._12,
    pins._13,
    pins._14,
    pins._15,
    pins._16,
    pins._17,
    pins._18,
    pins._19,
    pins._20,
    pins._21,
    pins._22,
    pins._23,
    pins._24,
    pins._25,
    pins._26,
    pins._27,
    pins._28,
    pins._29,
    pins._30,
    pins._31,
    pins._32,
    pins._33,
    pins._34,
    pins._35,
    pins._36,
    pins._37,
    pins._38,
    pins._39,
    pins._40,
    pins._41,
    pins._42,
    pins._43,
    pins._44,
    pins._45,
    pins._46,
    pins._47,
    pins._48,
    pins._49,
    pins._50,
    pins._51,
    pins._52,
    pins._53,
    pins._54,
    pins._55,
    pins._56,
    pins._57,
    pins._58,
    pins._59,
    pins._60,
    pins._61,
    pins._62,
    pins._63,
    pins._64,
    pins._65,
    pins._66,
    pins._67,
    pins._68,
    pins._69,
    pins._70,
    pins._71,
    pins._72,
    pins._73,
    pins._74,
    pins._75,
    pins._76,
    pins._77,
    pins._78,
    pins._79,
    pins._80,
    pins._81,
    pins._82,
    pins._83,
    pins._84,
    pins._85,
    pins._86,
    pins._87,
    pins._88,
    pins._89,
    pins._90,
    pins._91,
    pins._92,
    pins._93,
    pins._94,
    pins._95,
    pins._96,
    pins._97,
    pins._98,
    pins._99,
    pins._100,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
