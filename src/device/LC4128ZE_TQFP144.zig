//[[!! include('devices', 'LC4128ZE_TQFP144') !! 1081 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.Device_Type.LC4128ZE_TQFP144;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.TQFP144;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(740, 100);

pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_G15;
    pub const timer_reset = timer_out;
};

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

pub fn getOscTimerEnableRange() jedec.FuseRange {
    return jedec.FuseRange.between(
        jedec.Fuse.init(91, 98),
        jedec.Fuse.init(92, 98),
    );
}

pub fn getOscOutFuse() jedec.Fuse {
    return jedec.Fuse.init(93, 100);
}

pub fn getTimerOutFuse() jedec.Fuse {
    return jedec.Fuse.init(93, 99);
}

pub fn getTimerDivRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(92, 99)
    ).expandToContain(
        jedec.Fuse.init(92, 100)
    );
}

pub fn getInputPower_GuardFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(87, 98),
        .clk1 => jedec.Fuse.init(88, 98),
        .clk2 => jedec.Fuse.init(89, 98),
        .clk3 => jedec.Fuse.init(90, 98),
        else => unreachable,
    };
}

pub fn getInputBus_MaintenanceRange(input: GRP) jedec.FuseRange {
    return switch (input) {
        .clk0 => jedec.FuseRange.between(jedec.Fuse.init(85, 101), jedec.Fuse.init(86, 101)),
        .clk1 => jedec.FuseRange.between(jedec.Fuse.init(85, 100), jedec.Fuse.init(86, 100)),
        .clk2 => jedec.FuseRange.between(jedec.Fuse.init(85, 99), jedec.Fuse.init(86, 99)),
        .clk3 => jedec.FuseRange.between(jedec.Fuse.init(85, 98), jedec.Fuse.init(86, 98)),
        else => unreachable,
    };
}

pub fn getInput_ThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 98),
        .clk1 => jedec.Fuse.init(94, 99),
        .clk2 => jedec.Fuse.init(94, 100),
        .clk3 => jedec.Fuse.init(94, 101),
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
        .func = .{ .vcco = {} },
    };
    pub const _4 = lc4k.Pin_Info {
        .id = "4",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const _5 = lc4k.Pin_Info {
        .id = "5",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const _6 = lc4k.Pin_Info {
        .id = "6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const _7 = lc4k.Pin_Info {
        .id = "7",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const _8 = lc4k.Pin_Info {
        .id = "8",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const _9 = lc4k.Pin_Info {
        .id = "9",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const _10 = lc4k.Pin_Info {
        .id = "10",
        .func = .{ .gnd = {} },
    };
    pub const _11 = lc4k.Pin_Info {
        .id = "11",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const _12 = lc4k.Pin_Info {
        .id = "12",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const _13 = lc4k.Pin_Info {
        .id = "13",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const _14 = lc4k.Pin_Info {
        .id = "14",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const _15 = lc4k.Pin_Info {
        .id = "15",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const _16 = lc4k.Pin_Info {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const _17 = lc4k.Pin_Info {
        .id = "17",
        .func = .{ .no_connect = {} },
    };
    pub const _18 = lc4k.Pin_Info {
        .id = "18",
        .func = .{ .gnd = {} },
    };
    pub const _19 = lc4k.Pin_Info {
        .id = "19",
        .func = .{ .vcco = {} },
    };
    pub const _20 = lc4k.Pin_Info {
        .id = "20",
        .func = .{ .no_connect = {} },
    };
    pub const _21 = lc4k.Pin_Info {
        .id = "21",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const _22 = lc4k.Pin_Info {
        .id = "22",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C13),
    };
    pub const _23 = lc4k.Pin_Info {
        .id = "23",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const _24 = lc4k.Pin_Info {
        .id = "24",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const _25 = lc4k.Pin_Info {
        .id = "25",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C9),
    };
    pub const _26 = lc4k.Pin_Info {
        .id = "26",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const _27 = lc4k.Pin_Info {
        .id = "27",
        .func = .{ .gnd = {} },
    };
    pub const _28 = lc4k.Pin_Info {
        .id = "28",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const _29 = lc4k.Pin_Info {
        .id = "29",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C5),
    };
    pub const _30 = lc4k.Pin_Info {
        .id = "30",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const _31 = lc4k.Pin_Info {
        .id = "31",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const _32 = lc4k.Pin_Info {
        .id = "32",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C1),
    };
    pub const _33 = lc4k.Pin_Info {
        .id = "33",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const _34 = lc4k.Pin_Info {
        .id = "34",
        .func = .{ .vcco = {} },
    };
    pub const _35 = lc4k.Pin_Info {
        .id = "35",
        .func = .{ .tck = {} },
    };
    pub const _36 = lc4k.Pin_Info {
        .id = "36",
        .func = .{ .vcc_core = {} },
    };
    pub const _37 = lc4k.Pin_Info {
        .id = "37",
        .func = .{ .gnd = {} },
    };
    pub const _38 = lc4k.Pin_Info {
        .id = "38",
        .func = .{ .no_connect = {} },
    };
    pub const _39 = lc4k.Pin_Info {
        .id = "39",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const _40 = lc4k.Pin_Info {
        .id = "40",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D13),
    };
    pub const _41 = lc4k.Pin_Info {
        .id = "41",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const _42 = lc4k.Pin_Info {
        .id = "42",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const _43 = lc4k.Pin_Info {
        .id = "43",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D9),
    };
    pub const _44 = lc4k.Pin_Info {
        .id = "44",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const _45 = lc4k.Pin_Info {
        .id = "45",
        .func = .{ .no_connect = {} },
    };
    pub const _46 = lc4k.Pin_Info {
        .id = "46",
        .func = .{ .gnd = {} },
    };
    pub const _47 = lc4k.Pin_Info {
        .id = "47",
        .func = .{ .vcco = {} },
    };
    pub const _48 = lc4k.Pin_Info {
        .id = "48",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const _49 = lc4k.Pin_Info {
        .id = "49",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D5),
    };
    pub const _50 = lc4k.Pin_Info {
        .id = "50",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const _51 = lc4k.Pin_Info {
        .id = "51",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const _52 = lc4k.Pin_Info {
        .id = "52",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D1),
    };
    pub const _53 = lc4k.Pin_Info {
        .id = "53",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const _54 = lc4k.Pin_Info {
        .id = "54",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const _55 = lc4k.Pin_Info {
        .id = "55",
        .func = .{ .gnd = {} },
    };
    pub const _56 = lc4k.Pin_Info {
        .id = "56",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const _57 = lc4k.Pin_Info {
        .id = "57",
        .func = .{ .vcc_core = {} },
    };
    pub const _58 = lc4k.Pin_Info {
        .id = "58",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E0),
    };
    pub const _59 = lc4k.Pin_Info {
        .id = "59",
        .func = .{ .io = 1 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E1),
    };
    pub const _60 = lc4k.Pin_Info {
        .id = "60",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E2),
    };
    pub const _61 = lc4k.Pin_Info {
        .id = "61",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E4),
    };
    pub const _62 = lc4k.Pin_Info {
        .id = "62",
        .func = .{ .io = 5 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E5),
    };
    pub const _63 = lc4k.Pin_Info {
        .id = "63",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E6),
    };
    pub const _64 = lc4k.Pin_Info {
        .id = "64",
        .func = .{ .vcco = {} },
    };
    pub const _65 = lc4k.Pin_Info {
        .id = "65",
        .func = .{ .gnd = {} },
    };
    pub const _66 = lc4k.Pin_Info {
        .id = "66",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E8),
    };
    pub const _67 = lc4k.Pin_Info {
        .id = "67",
        .func = .{ .io = 9 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E9),
    };
    pub const _68 = lc4k.Pin_Info {
        .id = "68",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E10),
    };
    pub const _69 = lc4k.Pin_Info {
        .id = "69",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E12),
    };
    pub const _70 = lc4k.Pin_Info {
        .id = "70",
        .func = .{ .io = 13 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E13),
    };
    pub const _71 = lc4k.Pin_Info {
        .id = "71",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E14),
    };
    pub const _72 = lc4k.Pin_Info {
        .id = "72",
        .func = .{ .no_connect = {} },
    };
    pub const _73 = lc4k.Pin_Info {
        .id = "73",
        .func = .{ .gnd = {} },
    };
    pub const _74 = lc4k.Pin_Info {
        .id = "74",
        .func = .{ .tms = {} },
    };
    pub const _75 = lc4k.Pin_Info {
        .id = "75",
        .func = .{ .vcco = {} },
    };
    pub const _76 = lc4k.Pin_Info {
        .id = "76",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F0),
    };
    pub const _77 = lc4k.Pin_Info {
        .id = "77",
        .func = .{ .io = 1 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F1),
    };
    pub const _78 = lc4k.Pin_Info {
        .id = "78",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F2),
    };
    pub const _79 = lc4k.Pin_Info {
        .id = "79",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F4),
    };
    pub const _80 = lc4k.Pin_Info {
        .id = "80",
        .func = .{ .io = 5 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F5),
    };
    pub const _81 = lc4k.Pin_Info {
        .id = "81",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F6),
    };
    pub const _82 = lc4k.Pin_Info {
        .id = "82",
        .func = .{ .gnd = {} },
    };
    pub const _83 = lc4k.Pin_Info {
        .id = "83",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F8),
    };
    pub const _84 = lc4k.Pin_Info {
        .id = "84",
        .func = .{ .io = 9 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F9),
    };
    pub const _85 = lc4k.Pin_Info {
        .id = "85",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F10),
    };
    pub const _86 = lc4k.Pin_Info {
        .id = "86",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F12),
    };
    pub const _87 = lc4k.Pin_Info {
        .id = "87",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F13),
    };
    pub const _88 = lc4k.Pin_Info {
        .id = "88",
        .func = .{ .io = 14 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F14),
    };
    pub const _89 = lc4k.Pin_Info {
        .id = "89",
        .func = .{ .no_connect = {} },
    };
    pub const _90 = lc4k.Pin_Info {
        .id = "90",
        .func = .{ .gnd = {} },
    };
    pub const _91 = lc4k.Pin_Info {
        .id = "91",
        .func = .{ .vcco = {} },
    };
    pub const _92 = lc4k.Pin_Info {
        .id = "92",
        .func = .{ .no_connect = {} },
    };
    pub const _93 = lc4k.Pin_Info {
        .id = "93",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G14),
    };
    pub const _94 = lc4k.Pin_Info {
        .id = "94",
        .func = .{ .io = 13 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G13),
    };
    pub const _95 = lc4k.Pin_Info {
        .id = "95",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G12),
    };
    pub const _96 = lc4k.Pin_Info {
        .id = "96",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G10),
    };
    pub const _97 = lc4k.Pin_Info {
        .id = "97",
        .func = .{ .io = 9 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G9),
    };
    pub const _98 = lc4k.Pin_Info {
        .id = "98",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G8),
    };
    pub const _99 = lc4k.Pin_Info {
        .id = "99",
        .func = .{ .gnd = {} },
    };
    pub const _100 = lc4k.Pin_Info {
        .id = "100",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G6),
    };
    pub const _101 = lc4k.Pin_Info {
        .id = "101",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G5),
    };
    pub const _102 = lc4k.Pin_Info {
        .id = "102",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G4),
    };
    pub const _103 = lc4k.Pin_Info {
        .id = "103",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G2),
    };
    pub const _104 = lc4k.Pin_Info {
        .id = "104",
        .func = .{ .io = 1 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G1),
    };
    pub const _105 = lc4k.Pin_Info {
        .id = "105",
        .func = .{ .io = 0 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G0),
    };
    pub const _106 = lc4k.Pin_Info {
        .id = "106",
        .func = .{ .vcco = {} },
    };
    pub const _107 = lc4k.Pin_Info {
        .id = "107",
        .func = .{ .tdo = {} },
    };
    pub const _108 = lc4k.Pin_Info {
        .id = "108",
        .func = .{ .vcc_core = {} },
    };
    pub const _109 = lc4k.Pin_Info {
        .id = "109",
        .func = .{ .gnd = {} },
    };
    pub const _110 = lc4k.Pin_Info {
        .id = "110",
        .func = .{ .no_connect = {} },
    };
    pub const _111 = lc4k.Pin_Info {
        .id = "111",
        .func = .{ .io = 14 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H14),
    };
    pub const _112 = lc4k.Pin_Info {
        .id = "112",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H13),
    };
    pub const _113 = lc4k.Pin_Info {
        .id = "113",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H12),
    };
    pub const _114 = lc4k.Pin_Info {
        .id = "114",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H10),
    };
    pub const _115 = lc4k.Pin_Info {
        .id = "115",
        .func = .{ .io = 9 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H9),
    };
    pub const _116 = lc4k.Pin_Info {
        .id = "116",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H8),
    };
    pub const _117 = lc4k.Pin_Info {
        .id = "117",
        .func = .{ .no_connect = {} },
    };
    pub const _118 = lc4k.Pin_Info {
        .id = "118",
        .func = .{ .gnd = {} },
    };
    pub const _119 = lc4k.Pin_Info {
        .id = "119",
        .func = .{ .vcco = {} },
    };
    pub const _120 = lc4k.Pin_Info {
        .id = "120",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H6),
    };
    pub const _121 = lc4k.Pin_Info {
        .id = "121",
        .func = .{ .io = 5 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H5),
    };
    pub const _122 = lc4k.Pin_Info {
        .id = "122",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H4),
    };
    pub const _123 = lc4k.Pin_Info {
        .id = "123",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H2),
    };
    pub const _124 = lc4k.Pin_Info {
        .id = "124",
        .func = .{ .io = 1 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H1),
    };
    pub const _125 = lc4k.Pin_Info {
        .id = "125",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H0),
    };
    pub const _126 = lc4k.Pin_Info {
        .id = "126",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const _127 = lc4k.Pin_Info {
        .id = "127",
        .func = .{ .gnd = {} },
    };
    pub const _128 = lc4k.Pin_Info {
        .id = "128",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const _129 = lc4k.Pin_Info {
        .id = "129",
        .func = .{ .vcc_core = {} },
    };
    pub const _130 = lc4k.Pin_Info {
        .id = "130",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const _131 = lc4k.Pin_Info {
        .id = "131",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const _132 = lc4k.Pin_Info {
        .id = "132",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const _133 = lc4k.Pin_Info {
        .id = "133",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const _134 = lc4k.Pin_Info {
        .id = "134",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const _135 = lc4k.Pin_Info {
        .id = "135",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const _136 = lc4k.Pin_Info {
        .id = "136",
        .func = .{ .vcco = {} },
    };
    pub const _137 = lc4k.Pin_Info {
        .id = "137",
        .func = .{ .gnd = {} },
    };
    pub const _138 = lc4k.Pin_Info {
        .id = "138",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const _139 = lc4k.Pin_Info {
        .id = "139",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const _140 = lc4k.Pin_Info {
        .id = "140",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const _141 = lc4k.Pin_Info {
        .id = "141",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const _142 = lc4k.Pin_Info {
        .id = "142",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const _143 = lc4k.Pin_Info {
        .id = "143",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const _144 = lc4k.Pin_Info {
        .id = "144",
        .func = .{ .no_connect = {} },
    };
};

pub const clock_pins = [_]lc4k.Pin_Info {
    pins._128,
    pins._54,
    pins._56,
    pins._126,
};

pub const oe_pins = [_]lc4k.Pin_Info {
    pins._130,
    pins._125,
};

pub const input_pins = [_]lc4k.Pin_Info {
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
    pins._129,
    pins._130,
    pins._131,
    pins._132,
    pins._133,
    pins._134,
    pins._135,
    pins._136,
    pins._137,
    pins._138,
    pins._139,
    pins._140,
    pins._141,
    pins._142,
    pins._143,
    pins._144,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
