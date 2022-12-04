//[[!! include('devices', 'LC4032x_TQFP48') !! 542 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4032x_TQFP48;

pub const family = common.DeviceFamily.low_power;
pub const package = common.DevicePackage.TQFP48;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;
pub const oe_bus_size = 2;

pub const jedec_dimensions = jedec.FuseRange.init(172, 100);

pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
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
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .io_B0, .io_B6, .mc_B6, .io_A0, .mc_B15, .mc_A5, },
    .{ .io_A12, .mc_A15, .mc_A11, .io_B11, .io_A7, .mc_A3, },
    .{ .clk2, .mc_A13, .mc_A9, .io_A1, .mc_A2, .mc_B12, },
    .{ .io_A12, .io_B7, .mc_A12, .io_A0, .io_B8, .mc_B12, },
    .{ .io_B4, .mc_A15, .mc_B7, .io_A0, .io_B9, .mc_A7, },
    .{ .clk1, .mc_A14, .mc_B3, .io_B12, .io_A7, .mc_A4, },
    .{ .io_B2, .io_A9, .mc_B7, .io_B14, .io_A7, .mc_B10, },
    .{ .io_A11, .mc_B1, .mc_B4, .io_A1, .mc_B13, .mc_A6, },
    .{ .io_B0, .mc_B0, .mc_A8, .io_A1, .io_B10, .mc_A3, },
    .{ .io_A15, .io_A10, .mc_A9, .io_A3, .mc_B15, .mc_B11, },
    .{ .io_B3, .io_B5, .mc_B3, .clk0, .mc_A2, .mc_B11, },
    .{ .io_B1, .io_B7, .mc_A11, .io_A3, .io_A6, .mc_A5, },
    .{ .io_A14, .io_B6, .mc_B7, .io_A3, .io_B8, .mc_A3, },
    .{ .io_A12, .io_A10, .mc_A10, .io_B13, .io_A5, .mc_A5, },
    .{ .io_A11, .io_A9, .mc_A8, .clk0, .mc_A0, .mc_B9, },
    .{ .clk2, .mc_B0, .mc_B5, .io_B13, .mc_B14, .mc_B8, },
    .{ .clk1, .mc_B2, .mc_A10, .io_B11, .mc_B15, .mc_A7, },
    .{ .io_A13, .io_B6, .mc_A11, .io_B14, .mc_A1, .mc_B9, },
    .{ .io_A15, .mc_A13, .mc_B5, .io_B12, .io_A6, .mc_A6, },
    .{ .clk2, .io_A8, .mc_A8, .io_B15, .io_A5, .mc_A4, },
    .{ .clk1, .io_B7, .mc_B5, .io_A2, .mc_A0, .mc_B10, },
    .{ .io_B2, .io_A8, .mc_B3, .clk3, .mc_B14, .mc_B9, },
    .{ .io_A11, .mc_A13, .mc_A12, .io_B15, .io_B9, .mc_B8, },
    .{ .io_A14, .mc_B0, .mc_B6, .io_A4, .io_A5, .mc_B11, },
    .{ .io_B4, .mc_B2, .mc_B4, .io_B14, .io_A6, .mc_A4, },
    .{ .io_B1, .mc_B2, .mc_B6, .clk3, .mc_A1, .mc_A6, },
    .{ .io_A15, .io_B5, .mc_A12, .clk3, .mc_A0, .mc_A7, },
    .{ .io_B0, .mc_B1, .mc_A10, .io_B12, .io_B8, .mc_B11, },
    .{ .io_B3, .mc_A14, .mc_B7, .io_A2, .io_B10, .mc_B12, },
    .{ .io_B3, .io_A8, .mc_B4, .io_A4, .mc_A1, .mc_B10, },
    .{ .io_B2, .io_A10, .mc_B5, .io_A4, .io_B9, .mc_A4, },
    .{ .io_A13, .mc_B1, .mc_B6, .io_B13, .mc_A2, .mc_A7, },
    .{ .io_B4, .io_B5, .mc_A8, .io_B11, .mc_B14, .mc_B12, },
    .{ .io_B1, .mc_A14, .mc_A10, .io_B15, .mc_B13, .mc_B10, },
    .{ .io_A13, .io_A9, .mc_A9, .io_A2, .mc_B13, .mc_A3, },
    .{ .io_A14, .mc_A15, .mc_A9, .clk0, .io_B10, .mc_B8, },
};

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);

pub fn getGlbRange(glb: usize) jedec.FuseRange {
    const index = num_glbs - glb - 1;
    return jedec_dimensions.subColumns(86 * index + 3, 83);
}

pub fn getGiRange(glb: usize, gi: usize) jedec.FuseRange {
    return getGlbRange(glb).expandColumns(-3).subColumns(0, 3).subRows(gi * 2, 2);
}

pub fn getBClockRange(glb: usize) jedec.FuseRange {
    return getGlbRange(glb).subRows(79, 4).subColumns(0, 1);
}

pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(88, 171),
        1 => jedec.Fuse.init(89, 171),
        2 => jedec.Fuse.init(90, 171),
        3 => jedec.Fuse.init(91, 171),
        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        else => unreachable,
    };
}

pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 171)
    ).expandToContain(
        jedec.Fuse.init(86, 171)
    );
}
pub fn getExtraFloatInputFuses() []jedec.Fuse {
    return &.{
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(95, 168),
        .clk1 => jedec.Fuse.init(95, 169),
        .clk2 => jedec.Fuse.init(95, 170),
        .clk3 => jedec.Fuse.init(95, 171),
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
        .func = .{ .tdi = {} },
    };
    pub const _2 = common.PinInfo {
        .id = "2",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    pub const _3 = common.PinInfo {
        .id = "3",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    pub const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A7),
    };
    pub const _5 = common.PinInfo {
        .id = "5",
        .func = .{ .gnd = {} },
    };
    pub const _6 = common.PinInfo {
        .id = "6",
        .func = .{ .vcco = {} },
    };
    pub const _7 = common.PinInfo {
        .id = "7",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    pub const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    pub const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    pub const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    pub const _11 = common.PinInfo {
        .id = "11",
        .func = .{ .tck = {} },
    };
    pub const _12 = common.PinInfo {
        .id = "12",
        .func = .{ .vcc_core = {} },
    };
    pub const _13 = common.PinInfo {
        .id = "13",
        .func = .{ .gnd = {} },
    };
    pub const _14 = common.PinInfo {
        .id = "14",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    pub const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    pub const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    pub const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    pub const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .clock = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    pub const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    pub const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    pub const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    pub const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    pub const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B3),
    };
    pub const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    pub const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .tms = {} },
    };
    pub const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    pub const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    pub const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B7),
    };
    pub const _29 = common.PinInfo {
        .id = "29",
        .func = .{ .gnd = {} },
    };
    pub const _30 = common.PinInfo {
        .id = "30",
        .func = .{ .vcco = {} },
    };
    pub const _31 = common.PinInfo {
        .id = "31",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    pub const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    pub const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    pub const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B11),
    };
    pub const _35 = common.PinInfo {
        .id = "35",
        .func = .{ .tdo = {} },
    };
    pub const _36 = common.PinInfo {
        .id = "36",
        .func = .{ .vcc_core = {} },
    };
    pub const _37 = common.PinInfo {
        .id = "37",
        .func = .{ .gnd = {} },
    };
    pub const _38 = common.PinInfo {
        .id = "38",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    pub const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    pub const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    pub const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    pub const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .clock = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    pub const _43 = common.PinInfo {
        .id = "43",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    pub const _44 = common.PinInfo {
        .id = "44",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    pub const _45 = common.PinInfo {
        .id = "45",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    pub const _46 = common.PinInfo {
        .id = "46",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    pub const _47 = common.PinInfo {
        .id = "47",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A3),
    };
    pub const _48 = common.PinInfo {
        .id = "48",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins._43,
    pins._18,
    pins._19,
    pins._42,
};

pub const oe_pins = [_]common.PinInfo {
    pins._44,
    pins._41,
};

pub const input_pins = [_]common.PinInfo {
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
