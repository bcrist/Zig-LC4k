//[[!! include('devices', 'LC4128x_TQFP128') !! 960 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4128x_TQFP128;

pub const family = common.DeviceFamily.low_power;
pub const package = common.DevicePackage.TQFP128;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(740, 100);

const grp_device = @import("LC4128V_TQFP144.zig");

pub const GRP = grp_device.GRP;
pub const mc_signals = grp_device.mc_signals;
pub const mc_output_signals = grp_device.mc_output_signals;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;
pub const getGlbRange = grp_device.getGlbRange;
pub const getGiRange = grp_device.getGiRange;
pub const getBClockRange = grp_device.getBClockRange;


pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(90, 101),
        1 => jedec.Fuse.init(91, 101),
        2 => jedec.Fuse.init(92, 101),
        3 => jedec.Fuse.init(93, 101),
        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(88, 101),
        1 => jedec.Fuse.init(89, 101),
        else => unreachable,
    };
}

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(87, 101);
}


pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 101)
    ).expandToContain(
        jedec.Fuse.init(86, 101)
    );
}
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
    return &.{
        jedec.Fuse.init(92, 107),
        jedec.Fuse.init(92, 269),
        jedec.Fuse.init(92, 477),
        jedec.Fuse.init(92, 639),
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 98),
        .clk1 => jedec.Fuse.init(94, 99),
        .clk2 => jedec.Fuse.init(94, 100),
        .clk3 => jedec.Fuse.init(94, 101),
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
        .func = .{ .vcco = {} },
    };
    pub const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    pub const _5 = common.PinInfo {
        .id = "5",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    pub const _6 = common.PinInfo {
        .id = "6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    pub const _7 = common.PinInfo {
        .id = "7",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    pub const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    pub const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    pub const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .gnd = {} },
    };
    pub const _11 = common.PinInfo {
        .id = "11",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    pub const _12 = common.PinInfo {
        .id = "12",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    pub const _13 = common.PinInfo {
        .id = "13",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    pub const _14 = common.PinInfo {
        .id = "14",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    pub const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    pub const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    pub const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .vcco = {} },
    };
    pub const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
    };
    pub const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C13),
    };
    pub const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    pub const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    pub const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C9),
    };
    pub const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    pub const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .gnd = {} },
    };
    pub const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    pub const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C5),
    };
    pub const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    pub const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    pub const _29 = common.PinInfo {
        .id = "29",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    pub const _30 = common.PinInfo {
        .id = "30",
        .func = .{ .vcco = {} },
    };
    pub const _31 = common.PinInfo {
        .id = "31",
        .func = .{ .tck = {} },
    };
    pub const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .vcc_core = {} },
    };
    pub const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .gnd = {} },
    };
    pub const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    pub const _35 = common.PinInfo {
        .id = "35",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D13),
    };
    pub const _36 = common.PinInfo {
        .id = "36",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    pub const _37 = common.PinInfo {
        .id = "37",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    pub const _38 = common.PinInfo {
        .id = "38",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D9),
    };
    pub const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    pub const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .gnd = {} },
    };
    pub const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .vcco = {} },
    };
    pub const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
    };
    pub const _43 = common.PinInfo {
        .id = "43",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D5),
    };
    pub const _44 = common.PinInfo {
        .id = "44",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    pub const _45 = common.PinInfo {
        .id = "45",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    pub const _46 = common.PinInfo {
        .id = "46",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D1),
    };
    pub const _47 = common.PinInfo {
        .id = "47",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    pub const _48 = common.PinInfo {
        .id = "48",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    pub const _49 = common.PinInfo {
        .id = "49",
        .func = .{ .gnd = {} },
    };
    pub const _50 = common.PinInfo {
        .id = "50",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    pub const _51 = common.PinInfo {
        .id = "51",
        .func = .{ .vcc_core = {} },
    };
    pub const _52 = common.PinInfo {
        .id = "52",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E0),
    };
    pub const _53 = common.PinInfo {
        .id = "53",
        .func = .{ .io = 1 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E1),
    };
    pub const _54 = common.PinInfo {
        .id = "54",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E2),
    };
    pub const _55 = common.PinInfo {
        .id = "55",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E4),
    };
    pub const _56 = common.PinInfo {
        .id = "56",
        .func = .{ .io = 5 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E5),
    };
    pub const _57 = common.PinInfo {
        .id = "57",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E6),
    };
    pub const _58 = common.PinInfo {
        .id = "58",
        .func = .{ .vcco = {} },
    };
    pub const _59 = common.PinInfo {
        .id = "59",
        .func = .{ .gnd = {} },
    };
    pub const _60 = common.PinInfo {
        .id = "60",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E8),
    };
    pub const _61 = common.PinInfo {
        .id = "61",
        .func = .{ .io = 9 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E9),
    };
    pub const _62 = common.PinInfo {
        .id = "62",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E10),
    };
    pub const _63 = common.PinInfo {
        .id = "63",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E12),
    };
    pub const _64 = common.PinInfo {
        .id = "64",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E14),
    };
    pub const _65 = common.PinInfo {
        .id = "65",
        .func = .{ .gnd = {} },
    };
    pub const _66 = common.PinInfo {
        .id = "66",
        .func = .{ .tms = {} },
    };
    pub const _67 = common.PinInfo {
        .id = "67",
        .func = .{ .vcco = {} },
    };
    pub const _68 = common.PinInfo {
        .id = "68",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F0),
    };
    pub const _69 = common.PinInfo {
        .id = "69",
        .func = .{ .io = 1 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F1),
    };
    pub const _70 = common.PinInfo {
        .id = "70",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F2),
    };
    pub const _71 = common.PinInfo {
        .id = "71",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F4),
    };
    pub const _72 = common.PinInfo {
        .id = "72",
        .func = .{ .io = 5 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F5),
    };
    pub const _73 = common.PinInfo {
        .id = "73",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F6),
    };
    pub const _74 = common.PinInfo {
        .id = "74",
        .func = .{ .gnd = {} },
    };
    pub const _75 = common.PinInfo {
        .id = "75",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F8),
    };
    pub const _76 = common.PinInfo {
        .id = "76",
        .func = .{ .io = 9 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F9),
    };
    pub const _77 = common.PinInfo {
        .id = "77",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F10),
    };
    pub const _78 = common.PinInfo {
        .id = "78",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F12),
    };
    pub const _79 = common.PinInfo {
        .id = "79",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F13),
    };
    pub const _80 = common.PinInfo {
        .id = "80",
        .func = .{ .io = 14 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F14),
    };
    pub const _81 = common.PinInfo {
        .id = "81",
        .func = .{ .vcco = {} },
    };
    pub const _82 = common.PinInfo {
        .id = "82",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G14),
    };
    pub const _83 = common.PinInfo {
        .id = "83",
        .func = .{ .io = 13 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G13),
    };
    pub const _84 = common.PinInfo {
        .id = "84",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G12),
    };
    pub const _85 = common.PinInfo {
        .id = "85",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G10),
    };
    pub const _86 = common.PinInfo {
        .id = "86",
        .func = .{ .io = 9 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G9),
    };
    pub const _87 = common.PinInfo {
        .id = "87",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G8),
    };
    pub const _88 = common.PinInfo {
        .id = "88",
        .func = .{ .gnd = {} },
    };
    pub const _89 = common.PinInfo {
        .id = "89",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G6),
    };
    pub const _90 = common.PinInfo {
        .id = "90",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G5),
    };
    pub const _91 = common.PinInfo {
        .id = "91",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G4),
    };
    pub const _92 = common.PinInfo {
        .id = "92",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G2),
    };
    pub const _93 = common.PinInfo {
        .id = "93",
        .func = .{ .io = 0 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G0),
    };
    pub const _94 = common.PinInfo {
        .id = "94",
        .func = .{ .vcco = {} },
    };
    pub const _95 = common.PinInfo {
        .id = "95",
        .func = .{ .tdo = {} },
    };
    pub const _96 = common.PinInfo {
        .id = "96",
        .func = .{ .vcc_core = {} },
    };
    pub const _97 = common.PinInfo {
        .id = "97",
        .func = .{ .gnd = {} },
    };
    pub const _98 = common.PinInfo {
        .id = "98",
        .func = .{ .io = 14 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H14),
    };
    pub const _99 = common.PinInfo {
        .id = "99",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H13),
    };
    pub const _100 = common.PinInfo {
        .id = "100",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H12),
    };
    pub const _101 = common.PinInfo {
        .id = "101",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H10),
    };
    pub const _102 = common.PinInfo {
        .id = "102",
        .func = .{ .io = 9 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H9),
    };
    pub const _103 = common.PinInfo {
        .id = "103",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H8),
    };
    pub const _104 = common.PinInfo {
        .id = "104",
        .func = .{ .gnd = {} },
    };
    pub const _105 = common.PinInfo {
        .id = "105",
        .func = .{ .vcco = {} },
    };
    pub const _106 = common.PinInfo {
        .id = "106",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H6),
    };
    pub const _107 = common.PinInfo {
        .id = "107",
        .func = .{ .io = 5 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H5),
    };
    pub const _108 = common.PinInfo {
        .id = "108",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H4),
    };
    pub const _109 = common.PinInfo {
        .id = "109",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H2),
    };
    pub const _110 = common.PinInfo {
        .id = "110",
        .func = .{ .io = 1 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H1),
    };
    pub const _111 = common.PinInfo {
        .id = "111",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H0),
    };
    pub const _112 = common.PinInfo {
        .id = "112",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    pub const _113 = common.PinInfo {
        .id = "113",
        .func = .{ .gnd = {} },
    };
    pub const _114 = common.PinInfo {
        .id = "114",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    pub const _115 = common.PinInfo {
        .id = "115",
        .func = .{ .vcc_core = {} },
    };
    pub const _116 = common.PinInfo {
        .id = "116",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    pub const _117 = common.PinInfo {
        .id = "117",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    pub const _118 = common.PinInfo {
        .id = "118",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    pub const _119 = common.PinInfo {
        .id = "119",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    pub const _120 = common.PinInfo {
        .id = "120",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    pub const _121 = common.PinInfo {
        .id = "121",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    pub const _122 = common.PinInfo {
        .id = "122",
        .func = .{ .vcco = {} },
    };
    pub const _123 = common.PinInfo {
        .id = "123",
        .func = .{ .gnd = {} },
    };
    pub const _124 = common.PinInfo {
        .id = "124",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    pub const _125 = common.PinInfo {
        .id = "125",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    pub const _126 = common.PinInfo {
        .id = "126",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    pub const _127 = common.PinInfo {
        .id = "127",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    pub const _128 = common.PinInfo {
        .id = "128",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins._114,
    pins._48,
    pins._50,
    pins._112,
};

pub const oe_pins = [_]common.PinInfo {
    pins._116,
    pins._111,
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
    pins._101,
    pins._102,
    pins._103,
    pins._104,
    pins._105,
    pins._106,
    pins._107,
    pins._108,
    pins._109,
    pins._110,
    pins._111,
    pins._112,
    pins._113,
    pins._114,
    pins._115,
    pins._116,
    pins._117,
    pins._118,
    pins._119,
    pins._120,
    pins._121,
    pins._122,
    pins._123,
    pins._124,
    pins._125,
    pins._126,
    pins._127,
    pins._128,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
