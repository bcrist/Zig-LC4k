//[[!! include('devices', 'LC4064x_TQFP48') !! 467 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4064x_TQFP48;

pub const family = common.DeviceFamily.low_power;
pub const package = common.DevicePackage.TQFP48;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 10;

pub const jedec_dimensions = jedec.FuseRange.init(352, 95);

pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
    io_A0,
    io_A2,
    io_A4,
    io_A6,
    io_A8,
    io_A10,
    io_A12,
    io_A14,
    io_B0,
    io_B2,
    io_B4,
    io_B6,
    io_B8,
    io_B10,
    io_B12,
    io_B14,
    io_C0,
    io_C2,
    io_C4,
    io_C6,
    io_C8,
    io_C10,
    io_C12,
    io_C14,
    io_D0,
    io_D2,
    io_D4,
    io_D6,
    io_D8,
    io_D10,
    io_D12,
    io_D14,
    mc_A0,
    mc_A2,
    mc_A4,
    mc_A6,
    mc_A8,
    mc_A10,
    mc_A12,
    mc_A14,
    mc_B0,
    mc_B2,
    mc_B4,
    mc_B6,
    mc_B8,
    mc_B10,
    mc_B12,
    mc_B14,
    mc_C0,
    mc_C2,
    mc_C4,
    mc_C6,
    mc_C8,
    mc_C10,
    mc_C12,
    mc_C14,
    mc_D0,
    mc_D2,
    mc_D4,
    mc_D6,
    mc_D8,
    mc_D10,
    mc_D12,
    mc_D14,
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .mc_B9, .mc_A6, .mc_A11, .mc_B1, .mc_A1, .mc_C8, .mc_C10, .mc_D12, .mc_C2, .mc_C0, },
    .{ .io_A8, .io_A4, .mc_B4, .mc_B13, .mc_B0, .mc_C8, .io_D4, .io_C2, .mc_D1, .io_C14, },
    .{ .mc_B9, .mc_A9, .mc_B12, .mc_B2, .mc_B15, .io_C8, .mc_D6, .mc_C4, .mc_D1, .mc_C14, },
    .{ .mc_B6, .io_B4, .mc_A11, .mc_A13, .io_B14, .mc_C9, .io_D10, .mc_C11, .mc_D1, .mc_C15, },
    .{ .mc_B6, .mc_B10, .mc_A3, .mc_A2, .mc_B15, .mc_D7, .io_D4, .mc_C12, .mc_D14, .io_D0, },
    .{ .io_A8, .mc_B5, .mc_A12, .clk0, .io_A0, .io_C6, .mc_D9, .mc_C4, .mc_D14, .mc_C15, },
    .{ .io_B8, .mc_A6, .mc_B11, .mc_B13, .mc_A0, .mc_C7, .io_C4, .mc_D11, .clk3, .mc_C14, },
    .{ .mc_B7, .io_B10, .io_B12, .mc_A13, .mc_A14, .mc_D8, .mc_D5, .mc_C4, .io_D12, .mc_C0, },
    .{ .mc_A7, .io_A10, .mc_A3, .mc_B1, .io_B14, .io_C8, .mc_D9, .mc_D3, .io_D12, .mc_C1, },
    .{ .io_B6, .mc_A5, .mc_A11, .mc_A2, .mc_B0, .io_D8, .io_C10, .mc_C4, .mc_D13, .mc_C1, },
    .{ .mc_B9, .mc_A10, .mc_B3, .mc_A13, .io_A0, .mc_C7, .io_D4, .mc_D4, .mc_D13, .mc_D0, },
    .{ .io_A6, .mc_A5, .io_B12, .mc_B13, .io_A0, .io_C8, .mc_D10, .mc_D12, .mc_C13, .mc_D15, },
    .{ .mc_B6, .mc_A10, .mc_B12, .mc_B14, .mc_A14, .io_D6, .mc_D9, .mc_D11, .mc_C2, .mc_D15, },
    .{ .mc_B8, .io_A10, .mc_A4, .mc_B2, .mc_A0, .mc_C8, .mc_D10, .mc_C12, .clk2, .mc_C15, },
    .{ .mc_A7, .mc_A9, .mc_B3, .mc_B14, .mc_A0, .mc_D8, .io_D10, .mc_D12, .io_D2, .io_D0, },
    .{ .io_B6, .mc_A9, .mc_B4, .mc_A13, .io_A14, .mc_D7, .mc_C10, .mc_D3, .mc_D2, .mc_D15, },
    .{ .mc_B8, .mc_A5, .io_B2, .mc_B1, .mc_A14, .mc_C7, .io_D10, .io_C12, .mc_D2, .io_C0, },
    .{ .mc_B6, .mc_A5, .mc_B4, .clk1, .io_B0, .mc_C6, .io_C4, .mc_D4, .io_D2, .io_D14, },
    .{ .mc_A7, .io_A4, .io_B2, .mc_A2, .mc_A1, .mc_C6, .mc_D5, .mc_D11, .mc_C13, .mc_C15, },
    .{ .mc_B7, .mc_A6, .io_B2, .io_A2, .mc_B15, .io_D6, .io_C10, .mc_D3, .clk2, .mc_D0, },
    .{ .mc_A7, .mc_B5, .mc_B11, .clk1, .mc_A14, .mc_D7, .mc_D10, .mc_C3, .mc_D1, .mc_D0, },
    .{ .mc_B7, .mc_B5, .mc_B12, .io_A12, .io_B14, .mc_C8, .mc_C5, .mc_D4, .mc_D2, .io_D0, },
    .{ .mc_A8, .mc_A10, .mc_A4, .mc_B1, .io_B0, .mc_D8, .io_C10, .mc_C12, .mc_C13, .mc_C14, },
    .{ .io_A6, .mc_A6, .mc_B4, .clk0, .mc_A15, .mc_D8, .mc_D6, .mc_C11, .mc_D13, .io_C0, },
    .{ .io_B8, .mc_B10, .mc_A4, .io_A2, .mc_B0, .io_C6, .mc_D6, .mc_D12, .mc_D2, .io_D14, },
    .{ .mc_A8, .io_B10, .mc_A3, .io_A12, .mc_A1, .mc_C7, .mc_D6, .mc_C3, .io_D2, .mc_D15, },
    .{ .mc_B8, .mc_A9, .mc_A12, .clk1, .mc_B0, .io_D6, .mc_C5, .mc_C11, .clk3, .mc_C0, },
    .{ .io_A8, .mc_B10, .io_B12, .mc_B14, .mc_A1, .mc_C9, .mc_C5, .mc_D3, .mc_D13, .mc_C14, },
    .{ .io_A6, .mc_B5, .mc_B3, .mc_A2, .io_A14, .mc_C9, .io_C4, .io_C2, .clk2, .mc_C0, },
    .{ .mc_A8, .io_A10, .mc_B11, .mc_B14, .io_A14, .io_D8, .mc_D5, .mc_C11, .mc_D14, .io_C14, },
    .{ .mc_A8, .mc_B10, .mc_B12, .clk0, .mc_A0, .mc_C6, .mc_C10, .io_C2, .io_D12, .mc_D0, },
    .{ .io_B6, .io_B4, .mc_B3, .mc_B2, .io_B0, .io_C6, .mc_D5, .mc_C3, .mc_C2, .io_C0, },
    .{ .io_B8, .io_A4, .mc_A12, .io_A12, .mc_B15, .mc_C9, .mc_D10, .io_C12, .mc_C2, .mc_C1, },
    .{ .mc_B7, .mc_A10, .mc_A3, .mc_B2, .mc_A15, .io_D8, .mc_C10, .io_C12, .clk3, .io_D14, },
    .{ .mc_B8, .io_B10, .mc_A11, .io_A2, .mc_A15, .mc_D7, .mc_D9, .mc_D4, .mc_C13, .io_C14, },
    .{ .mc_B9, .io_B4, .mc_A4, .mc_B13, .mc_A15, .mc_C6, .mc_C5, .mc_C3, .mc_D14, .mc_C1, },
};

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);


pub const pins = struct {
    const _1 = common.PinInfo {
        .id = "1",
        .func = .{ .tdi = {} },
    };
    const _2 = common.PinInfo {
        .id = "2",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    const _3 = common.PinInfo {
        .id = "3",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
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
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
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
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .tms = {} },
    };
    const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
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
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
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
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .io_oe1 = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .clock = 3 },
        .glb = 3,
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
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    const _46 = common.PinInfo {
        .id = "46",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    const _47 = common.PinInfo {
        .id = "47",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    const _48 = common.PinInfo {
        .id = "48",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
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
