//[[!! include('devices', 'LC4064x_TQFP44') !! 395 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4064x_TQFP44;

pub const family = common.DeviceFamily.low_power;
pub const package = common.DevicePackage.TQFP44;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 10;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(352, 95);

const grp_device = @import("LC4064x_TQFP48.zig");

pub const GRP = grp_device.GRP;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;
pub const getGlbRange = grp_device.getGlbRange;
pub const getGiRange = grp_device.getGiRange;
pub const getBClockRange = grp_device.getBClockRange;


pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(90, 351),
        1 => jedec.Fuse.init(91, 351),
        2 => jedec.Fuse.init(92, 351),
        3 => jedec.Fuse.init(93, 351),
        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(88, 351),
        1 => jedec.Fuse.init(89, 351),
        else => unreachable,
    };
}

pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 351)
    ).expandToContain(
        jedec.Fuse.init(86, 351)
    );
}
pub fn getExtraFloatInputFuses() []jedec.Fuse {
    return &.{
        jedec.Fuse.init(89, 40),
        jedec.Fuse.init(89, 216),
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 348),
        .clk2 => jedec.Fuse.init(94, 350),
        else => unreachable,
    };
}

pub fn getMacrocellRef(comptime which: anytype) common.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) common.GlbIndex {
    return internal.getGlbIndex(@This(), which);
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
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    pub const _3 = common.PinInfo {
        .id = "3",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    pub const _4 = common.PinInfo {
        .id = "4",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
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
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    pub const _8 = common.PinInfo {
        .id = "8",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    pub const _9 = common.PinInfo {
        .id = "9",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    pub const _10 = common.PinInfo {
        .id = "10",
        .func = .{ .tck = {} },
    };
    pub const _11 = common.PinInfo {
        .id = "11",
        .func = .{ .vcc_core = {} },
    };
    pub const _12 = common.PinInfo {
        .id = "12",
        .func = .{ .gnd = {} },
    };
    pub const _13 = common.PinInfo {
        .id = "13",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    pub const _14 = common.PinInfo {
        .id = "14",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    pub const _15 = common.PinInfo {
        .id = "15",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    pub const _16 = common.PinInfo {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    pub const _17 = common.PinInfo {
        .id = "17",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    pub const _18 = common.PinInfo {
        .id = "18",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    pub const _19 = common.PinInfo {
        .id = "19",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    pub const _20 = common.PinInfo {
        .id = "20",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    pub const _21 = common.PinInfo {
        .id = "21",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    pub const _22 = common.PinInfo {
        .id = "22",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    pub const _23 = common.PinInfo {
        .id = "23",
        .func = .{ .tms = {} },
    };
    pub const _24 = common.PinInfo {
        .id = "24",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    pub const _25 = common.PinInfo {
        .id = "25",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    pub const _26 = common.PinInfo {
        .id = "26",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
    };
    pub const _27 = common.PinInfo {
        .id = "27",
        .func = .{ .gnd = {} },
    };
    pub const _28 = common.PinInfo {
        .id = "28",
        .func = .{ .vcco = {} },
    };
    pub const _29 = common.PinInfo {
        .id = "29",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    pub const _30 = common.PinInfo {
        .id = "30",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    pub const _31 = common.PinInfo {
        .id = "31",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    pub const _32 = common.PinInfo {
        .id = "32",
        .func = .{ .tdo = {} },
    };
    pub const _33 = common.PinInfo {
        .id = "33",
        .func = .{ .vcc_core = {} },
    };
    pub const _34 = common.PinInfo {
        .id = "34",
        .func = .{ .gnd = {} },
    };
    pub const _35 = common.PinInfo {
        .id = "35",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    pub const _36 = common.PinInfo {
        .id = "36",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    pub const _37 = common.PinInfo {
        .id = "37",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    pub const _38 = common.PinInfo {
        .id = "38",
        .func = .{ .io_oe1 = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    pub const _39 = common.PinInfo {
        .id = "39",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    pub const _40 = common.PinInfo {
        .id = "40",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    pub const _41 = common.PinInfo {
        .id = "41",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    pub const _42 = common.PinInfo {
        .id = "42",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    pub const _43 = common.PinInfo {
        .id = "43",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    pub const _44 = common.PinInfo {
        .id = "44",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins._39,
    pins._17,
};

pub const oe_pins = [_]common.PinInfo {
    pins._40,
    pins._38,
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
