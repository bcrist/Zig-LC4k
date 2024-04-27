//[[!! include('devices', 'LC4128x_TQFP100') !! 810 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.Device_Type.LC4128x_TQFP100;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP100;

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


pub fn getGOE_PolarityFuse(goe: usize) jedec.Fuse {
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


pub fn getGlobalBus_MaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 101)
    ).expandToContain(
        jedec.Fuse.init(86, 101)
    );
}
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
    return &.{
        jedec.Fuse.init(92, 24),
        jedec.Fuse.init(92, 44),
        jedec.Fuse.init(92, 64),
        jedec.Fuse.init(92, 107),
        jedec.Fuse.init(92, 147),
        jedec.Fuse.init(92, 167),
        jedec.Fuse.init(92, 209),
        jedec.Fuse.init(92, 229),
        jedec.Fuse.init(92, 249),
        jedec.Fuse.init(92, 269),
        jedec.Fuse.init(92, 292),
        jedec.Fuse.init(92, 312),
        jedec.Fuse.init(92, 332),
        jedec.Fuse.init(92, 394),
        jedec.Fuse.init(92, 414),
        jedec.Fuse.init(92, 434),
        jedec.Fuse.init(92, 477),
        jedec.Fuse.init(92, 517),
        jedec.Fuse.init(92, 537),
        jedec.Fuse.init(92, 579),
        jedec.Fuse.init(92, 599),
        jedec.Fuse.init(92, 619),
        jedec.Fuse.init(92, 639),
        jedec.Fuse.init(92, 662),
        jedec.Fuse.init(92, 682),
        jedec.Fuse.init(92, 702),
    };
}

pub fn getInput_ThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 98),
        .clk1 => jedec.Fuse.init(94, 99),
        .clk2 => jedec.Fuse.init(94, 100),
        .clk3 => jedec.Fuse.init(94, 101),
        .io_B14 => jedec.Fuse.init(99, 731),
        .io_C0 => jedec.Fuse.init(99, 476),
        .io_D14 => jedec.Fuse.init(99, 463),
        .io_F14 => jedec.Fuse.init(99, 361),
        .io_G0 => jedec.Fuse.init(99, 106),
        .io_H14 => jedec.Fuse.init(99, 93),
        else => unreachable,
    };
}

pub fn getMC_Ref(comptime which: anytype) lc4k.MC_Ref {
    return internal.getMC_Ref(GRP, which);
}

pub fn getGLB_Index(comptime which: anytype) lc4k.GLB_Index {
    return internal.getGLB_Index(@This(), which);
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

pub fn getPin(comptime which: anytype) lc4k.Pin_Info {
    return internal.getPin(@This(), which);
}

pub const pins = struct {
    pub const _1 = lc4k.Pin_Info {
        .id = "1",
        .func = .{ .gnd = {} },
    };
    pub const _2 = lc4k.Pin_Info {
        .id = "2",
        .func = .{ .tdi = {} },
    };
    pub const _3 = lc4k.Pin_Info {
        .id = "3",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const _4 = lc4k.Pin_Info {
        .id = "4",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const _5 = lc4k.Pin_Info {
        .id = "5",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const _6 = lc4k.Pin_Info {
        .id = "6",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const _7 = lc4k.Pin_Info {
        .id = "7",
        .func = .{ .gnd = {} },
    };
    pub const _8 = lc4k.Pin_Info {
        .id = "8",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const _9 = lc4k.Pin_Info {
        .id = "9",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const _10 = lc4k.Pin_Info {
        .id = "10",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const _11 = lc4k.Pin_Info {
        .id = "11",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const _12 = lc4k.Pin_Info {
        .id = "12",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const _13 = lc4k.Pin_Info {
        .id = "13",
        .func = .{ .vcco = {} },
    };
    pub const _14 = lc4k.Pin_Info {
        .id = "14",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const _15 = lc4k.Pin_Info {
        .id = "15",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const _16 = lc4k.Pin_Info {
        .id = "16",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const _17 = lc4k.Pin_Info {
        .id = "17",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const _18 = lc4k.Pin_Info {
        .id = "18",
        .func = .{ .gnd = {} },
    };
    pub const _19 = lc4k.Pin_Info {
        .id = "19",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const _20 = lc4k.Pin_Info {
        .id = "20",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C5),
    };
    pub const _21 = lc4k.Pin_Info {
        .id = "21",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const _22 = lc4k.Pin_Info {
        .id = "22",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const _23 = lc4k.Pin_Info {
        .id = "23",
        .func = .{ .input = {} },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const _24 = lc4k.Pin_Info {
        .id = "24",
        .func = .{ .tck = {} },
    };
    pub const _25 = lc4k.Pin_Info {
        .id = "25",
        .func = .{ .vcc_core = {} },
    };
    pub const _26 = lc4k.Pin_Info {
        .id = "26",
        .func = .{ .gnd = {} },
    };
    pub const _27 = lc4k.Pin_Info {
        .id = "27",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const _28 = lc4k.Pin_Info {
        .id = "28",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D13),
    };
    pub const _29 = lc4k.Pin_Info {
        .id = "29",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const _30 = lc4k.Pin_Info {
        .id = "30",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const _31 = lc4k.Pin_Info {
        .id = "31",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const _32 = lc4k.Pin_Info {
        .id = "32",
        .func = .{ .gnd = {} },
    };
    pub const _33 = lc4k.Pin_Info {
        .id = "33",
        .func = .{ .vcco = {} },
    };
    pub const _34 = lc4k.Pin_Info {
        .id = "34",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const _35 = lc4k.Pin_Info {
        .id = "35",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const _36 = lc4k.Pin_Info {
        .id = "36",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const _37 = lc4k.Pin_Info {
        .id = "37",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const _38 = lc4k.Pin_Info {
        .id = "38",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const _39 = lc4k.Pin_Info {
        .id = "39",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const _40 = lc4k.Pin_Info {
        .id = "40",
        .func = .{ .vcc_core = {} },
    };
    pub const _41 = lc4k.Pin_Info {
        .id = "41",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E0),
    };
    pub const _42 = lc4k.Pin_Info {
        .id = "42",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E2),
    };
    pub const _43 = lc4k.Pin_Info {
        .id = "43",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E4),
    };
    pub const _44 = lc4k.Pin_Info {
        .id = "44",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E6),
    };
    pub const _45 = lc4k.Pin_Info {
        .id = "45",
        .func = .{ .vcco = {} },
    };
    pub const _46 = lc4k.Pin_Info {
        .id = "46",
        .func = .{ .gnd = {} },
    };
    pub const _47 = lc4k.Pin_Info {
        .id = "47",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E8),
    };
    pub const _48 = lc4k.Pin_Info {
        .id = "48",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E10),
    };
    pub const _49 = lc4k.Pin_Info {
        .id = "49",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E12),
    };
    pub const _50 = lc4k.Pin_Info {
        .id = "50",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E14),
    };
    pub const _51 = lc4k.Pin_Info {
        .id = "51",
        .func = .{ .gnd = {} },
    };
    pub const _52 = lc4k.Pin_Info {
        .id = "52",
        .func = .{ .tms = {} },
    };
    pub const _53 = lc4k.Pin_Info {
        .id = "53",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F0),
    };
    pub const _54 = lc4k.Pin_Info {
        .id = "54",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F2),
    };
    pub const _55 = lc4k.Pin_Info {
        .id = "55",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F4),
    };
    pub const _56 = lc4k.Pin_Info {
        .id = "56",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F6),
    };
    pub const _57 = lc4k.Pin_Info {
        .id = "57",
        .func = .{ .gnd = {} },
    };
    pub const _58 = lc4k.Pin_Info {
        .id = "58",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F8),
    };
    pub const _59 = lc4k.Pin_Info {
        .id = "59",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F10),
    };
    pub const _60 = lc4k.Pin_Info {
        .id = "60",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F12),
    };
    pub const _61 = lc4k.Pin_Info {
        .id = "61",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F13),
    };
    pub const _62 = lc4k.Pin_Info {
        .id = "62",
        .func = .{ .input = {} },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F14),
    };
    pub const _63 = lc4k.Pin_Info {
        .id = "63",
        .func = .{ .vcco = {} },
    };
    pub const _64 = lc4k.Pin_Info {
        .id = "64",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G14),
    };
    pub const _65 = lc4k.Pin_Info {
        .id = "65",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G12),
    };
    pub const _66 = lc4k.Pin_Info {
        .id = "66",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G10),
    };
    pub const _67 = lc4k.Pin_Info {
        .id = "67",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G8),
    };
    pub const _68 = lc4k.Pin_Info {
        .id = "68",
        .func = .{ .gnd = {} },
    };
    pub const _69 = lc4k.Pin_Info {
        .id = "69",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G6),
    };
    pub const _70 = lc4k.Pin_Info {
        .id = "70",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G5),
    };
    pub const _71 = lc4k.Pin_Info {
        .id = "71",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G4),
    };
    pub const _72 = lc4k.Pin_Info {
        .id = "72",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G2),
    };
    pub const _73 = lc4k.Pin_Info {
        .id = "73",
        .func = .{ .input = {} },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G0),
    };
    pub const _74 = lc4k.Pin_Info {
        .id = "74",
        .func = .{ .tdo = {} },
    };
    pub const _75 = lc4k.Pin_Info {
        .id = "75",
        .func = .{ .vcc_core = {} },
    };
    pub const _76 = lc4k.Pin_Info {
        .id = "76",
        .func = .{ .gnd = {} },
    };
    pub const _77 = lc4k.Pin_Info {
        .id = "77",
        .func = .{ .input = {} },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H14),
    };
    pub const _78 = lc4k.Pin_Info {
        .id = "78",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H13),
    };
    pub const _79 = lc4k.Pin_Info {
        .id = "79",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H12),
    };
    pub const _80 = lc4k.Pin_Info {
        .id = "80",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H10),
    };
    pub const _81 = lc4k.Pin_Info {
        .id = "81",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H8),
    };
    pub const _82 = lc4k.Pin_Info {
        .id = "82",
        .func = .{ .gnd = {} },
    };
    pub const _83 = lc4k.Pin_Info {
        .id = "83",
        .func = .{ .vcco = {} },
    };
    pub const _84 = lc4k.Pin_Info {
        .id = "84",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H6),
    };
    pub const _85 = lc4k.Pin_Info {
        .id = "85",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H4),
    };
    pub const _86 = lc4k.Pin_Info {
        .id = "86",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H2),
    };
    pub const _87 = lc4k.Pin_Info {
        .id = "87",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H0),
    };
    pub const _88 = lc4k.Pin_Info {
        .id = "88",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const _89 = lc4k.Pin_Info {
        .id = "89",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const _90 = lc4k.Pin_Info {
        .id = "90",
        .func = .{ .vcc_core = {} },
    };
    pub const _91 = lc4k.Pin_Info {
        .id = "91",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const _92 = lc4k.Pin_Info {
        .id = "92",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const _93 = lc4k.Pin_Info {
        .id = "93",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const _94 = lc4k.Pin_Info {
        .id = "94",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const _95 = lc4k.Pin_Info {
        .id = "95",
        .func = .{ .vcco = {} },
    };
    pub const _96 = lc4k.Pin_Info {
        .id = "96",
        .func = .{ .gnd = {} },
    };
    pub const _97 = lc4k.Pin_Info {
        .id = "97",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const _98 = lc4k.Pin_Info {
        .id = "98",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const _99 = lc4k.Pin_Info {
        .id = "99",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const _100 = lc4k.Pin_Info {
        .id = "100",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
};

pub const clock_pins = [_]lc4k.Pin_Info {
    pins._89,
    pins._38,
    pins._39,
    pins._88,
};

pub const oe_pins = [_]lc4k.Pin_Info {
    pins._91,
    pins._87,
};

pub const input_pins = [_]lc4k.Pin_Info {
    pins._12,
    pins._23,
    pins._27,
    pins._62,
    pins._73,
    pins._77,
};

pub const all_pins = [_]lc4k.Pin_Info {
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
