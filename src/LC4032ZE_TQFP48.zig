//[[!! include('devices', 'LC4032ZE_TQFP48') !! 368 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4032ZE_TQFP48;

pub const family = common.DeviceFamily.zero_power_enhanced;
pub const package = common.DevicePackage.TQFP48;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;

pub const jedec_dimensions = jedec.FuseRange.init(172, 100);

pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_B15;
    pub const timer_reset = timer_out;
};

const grp_device = @import("LC4032x_TQFP48.zig");

pub const GRP = grp_device.GRP;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;


pub const pins = struct {
    const _1 = common.PinInfo {
        .id = "1",
        .func = .{ .tdi = {} },
    };
    const _2 = common.PinInfo {
        .id = "2",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    const _3 = common.PinInfo {
        .id = "3",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A7),
    };
    const _5 = common.PinInfo {
        .id = "5",
        .func = .{ .gnd = {} },
    };
    const _6 = common.PinInfo {
        .id = "6",
        .func = .{ .vcco = {} },
    };
    const _7 = common.PinInfo {
        .id = "7",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    const _11 = common.PinInfo {
        .id = "11",
        .func = .{ .tck = {} },
    };
    const _12 = common.PinInfo {
        .id = "12",
        .func = .{ .vcc_core = {} },
    };
    const _13 = common.PinInfo {
        .id = "13",
        .func = .{ .gnd = {} },
    };
    const _14 = common.PinInfo {
        .id = "14",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .clock = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B3),
    };
    const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .tms = {} },
    };
    const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B7),
    };
    const _29 = common.PinInfo {
        .id = "29",
        .func = .{ .gnd = {} },
    };
    const _30 = common.PinInfo {
        .id = "30",
        .func = .{ .vcco = {} },
    };
    const _31 = common.PinInfo {
        .id = "31",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B11),
    };
    const _35 = common.PinInfo {
        .id = "35",
        .func = .{ .tdo = {} },
    };
    const _36 = common.PinInfo {
        .id = "36",
        .func = .{ .vcc_core = {} },
    };
    const _37 = common.PinInfo {
        .id = "37",
        .func = .{ .gnd = {} },
    };
    const _38 = common.PinInfo {
        .id = "38",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .clock = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    const _43 = common.PinInfo {
        .id = "43",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    const _44 = common.PinInfo {
        .id = "44",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    const _45 = common.PinInfo {
        .id = "45",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    const _46 = common.PinInfo {
        .id = "46",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    const _47 = common.PinInfo {
        .id = "47",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A3),
    };
    const _48 = common.PinInfo {
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
