//[[!! include('devices', 'LC4032x_TQFP44') !! 404 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.Device_Type.LC4032x_TQFP44;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP44;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;
pub const oe_bus_size = 2;

pub const jedec_dimensions = jedec.FuseRange.init(172, 100);

const grp_device = @import("LC4032x_TQFP48.zig");

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

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(87, 171);
}


pub fn getGlobalBus_MaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 171)
    ).expandToContain(
        jedec.Fuse.init(86, 171)
    );
}
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
    return &.{
        jedec.Fuse.init(92, 58),
        jedec.Fuse.init(92, 144),
    };
}

pub fn getInput_ThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(95, 168),
        .clk2 => jedec.Fuse.init(95, 170),
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
        .func = .{ .tdi = {} },
    };
    pub const _2 = lc4k.Pin_Info {
        .id = "2",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const _3 = lc4k.Pin_Info {
        .id = "3",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const _4 = lc4k.Pin_Info {
        .id = "4",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A7),
    };
    pub const _5 = lc4k.Pin_Info {
        .id = "5",
        .func = .{ .gnd = {} },
    };
    pub const _6 = lc4k.Pin_Info {
        .id = "6",
        .func = .{ .vcco = {} },
    };
    pub const _7 = lc4k.Pin_Info {
        .id = "7",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const _8 = lc4k.Pin_Info {
        .id = "8",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const _9 = lc4k.Pin_Info {
        .id = "9",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const _10 = lc4k.Pin_Info {
        .id = "10",
        .func = .{ .tck = {} },
    };
    pub const _11 = lc4k.Pin_Info {
        .id = "11",
        .func = .{ .vcc_core = {} },
    };
    pub const _12 = lc4k.Pin_Info {
        .id = "12",
        .func = .{ .gnd = {} },
    };
    pub const _13 = lc4k.Pin_Info {
        .id = "13",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const _14 = lc4k.Pin_Info {
        .id = "14",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const _15 = lc4k.Pin_Info {
        .id = "15",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const _16 = lc4k.Pin_Info {
        .id = "16",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A15),
    };
    pub const _17 = lc4k.Pin_Info {
        .id = "17",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const _18 = lc4k.Pin_Info {
        .id = "18",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const _19 = lc4k.Pin_Info {
        .id = "19",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const _20 = lc4k.Pin_Info {
        .id = "20",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const _21 = lc4k.Pin_Info {
        .id = "21",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B3),
    };
    pub const _22 = lc4k.Pin_Info {
        .id = "22",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const _23 = lc4k.Pin_Info {
        .id = "23",
        .func = .{ .tms = {} },
    };
    pub const _24 = lc4k.Pin_Info {
        .id = "24",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const _25 = lc4k.Pin_Info {
        .id = "25",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const _26 = lc4k.Pin_Info {
        .id = "26",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B7),
    };
    pub const _27 = lc4k.Pin_Info {
        .id = "27",
        .func = .{ .gnd = {} },
    };
    pub const _28 = lc4k.Pin_Info {
        .id = "28",
        .func = .{ .vcco = {} },
    };
    pub const _29 = lc4k.Pin_Info {
        .id = "29",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const _30 = lc4k.Pin_Info {
        .id = "30",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const _31 = lc4k.Pin_Info {
        .id = "31",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const _32 = lc4k.Pin_Info {
        .id = "32",
        .func = .{ .tdo = {} },
    };
    pub const _33 = lc4k.Pin_Info {
        .id = "33",
        .func = .{ .vcc_core = {} },
    };
    pub const _34 = lc4k.Pin_Info {
        .id = "34",
        .func = .{ .gnd = {} },
    };
    pub const _35 = lc4k.Pin_Info {
        .id = "35",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const _36 = lc4k.Pin_Info {
        .id = "36",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const _37 = lc4k.Pin_Info {
        .id = "37",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const _38 = lc4k.Pin_Info {
        .id = "38",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B15),
    };
    pub const _39 = lc4k.Pin_Info {
        .id = "39",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const _40 = lc4k.Pin_Info {
        .id = "40",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const _41 = lc4k.Pin_Info {
        .id = "41",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const _42 = lc4k.Pin_Info {
        .id = "42",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const _43 = lc4k.Pin_Info {
        .id = "43",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A3),
    };
    pub const _44 = lc4k.Pin_Info {
        .id = "44",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
};

pub const clock_pins = [_]lc4k.Pin_Info {
    pins._39,
    pins._17,
};

pub const oe_pins = [_]lc4k.Pin_Info {
    pins._40,
    pins._38,
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
