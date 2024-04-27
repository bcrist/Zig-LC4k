//[[!! include('devices', 'LC4064x_TQFP48') !! 597 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.DeviceType.LC4064x_TQFP48;

pub const family = lc4k.DeviceFamily.low_power;
pub const package = lc4k.DevicePackage.TQFP48;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 10;
pub const oe_bus_size = 4;

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
    .{ .io_A0, null, .io_A2, null, .io_A4, null, .io_A6, null, .io_A8, null, .io_A10, null, .io_A12, null, .io_A14, null, },
    .{ .io_B0, null, .io_B2, null, .io_B4, null, .io_B6, null, .io_B8, null, .io_B10, null, .io_B12, null, .io_B14, null, },
    .{ .io_C0, null, .io_C2, null, .io_C4, null, .io_C6, null, .io_C8, null, .io_C10, null, .io_C12, null, .io_C14, null, },
    .{ .io_D0, null, .io_D2, null, .io_D4, null, .io_D6, null, .io_D8, null, .io_D10, null, .io_D12, null, .io_D14, null, },
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

pub fn getGlbRange(glb: usize) jedec.FuseRange {
    std.debug.assert(glb < num_glbs);
    const index = num_glbs - glb - 1;
    return jedec_dimensions.subColumns(88 * index + 5, 83);
}

pub fn getGiRange(glb: usize, gi: usize) jedec.FuseRange {
    std.debug.assert(gi < num_gis_per_glb);
    return getGlbRange(glb).expandColumns(-5).subColumns(0, 5).subRows(gi * 2, 2);
}

pub fn getBClockRange(glb: usize) jedec.FuseRange {
    return getGlbRange(glb).subRows(79, 4).subColumns(0, 1);
}

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

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(87, 351);
}


pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 351)
    ).expandToContain(
        jedec.Fuse.init(86, 351)
    );
}
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
    return &.{
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 348),
        .clk1 => jedec.Fuse.init(94, 349),
        .clk2 => jedec.Fuse.init(94, 350),
        .clk3 => jedec.Fuse.init(94, 351),
        else => unreachable,
    };
}

pub fn getMacrocellRef(comptime which: anytype) lc4k.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) lc4k.GlbIndex {
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

pub fn getPin(comptime which: anytype) lc4k.PinInfo {
    return internal.getPin(@This(), which);
}

pub const pins = struct {
    pub const _1 = lc4k.PinInfo {
        .id = "1",
        .func = .{ .tdi = {} },
    };
    pub const _2 = lc4k.PinInfo {
        .id = "2",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const _3 = lc4k.PinInfo {
        .id = "3",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const _4 = lc4k.PinInfo {
        .id = "4",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const _5 = lc4k.PinInfo {
        .id = "5",
        .func = .{ .gnd = {} },
    };
    pub const _6 = lc4k.PinInfo {
        .id = "6",
        .func = .{ .vcco = {} },
    };
    pub const _7 = lc4k.PinInfo {
        .id = "7",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const _8 = lc4k.PinInfo {
        .id = "8",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const _9 = lc4k.PinInfo {
        .id = "9",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const _10 = lc4k.PinInfo {
        .id = "10",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const _11 = lc4k.PinInfo {
        .id = "11",
        .func = .{ .tck = {} },
    };
    pub const _12 = lc4k.PinInfo {
        .id = "12",
        .func = .{ .vcc_core = {} },
    };
    pub const _13 = lc4k.PinInfo {
        .id = "13",
        .func = .{ .gnd = {} },
    };
    pub const _14 = lc4k.PinInfo {
        .id = "14",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const _15 = lc4k.PinInfo {
        .id = "15",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const _16 = lc4k.PinInfo {
        .id = "16",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const _17 = lc4k.PinInfo {
        .id = "17",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const _18 = lc4k.PinInfo {
        .id = "18",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const _19 = lc4k.PinInfo {
        .id = "19",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const _20 = lc4k.PinInfo {
        .id = "20",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const _21 = lc4k.PinInfo {
        .id = "21",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const _22 = lc4k.PinInfo {
        .id = "22",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const _23 = lc4k.PinInfo {
        .id = "23",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const _24 = lc4k.PinInfo {
        .id = "24",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const _25 = lc4k.PinInfo {
        .id = "25",
        .func = .{ .tms = {} },
    };
    pub const _26 = lc4k.PinInfo {
        .id = "26",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const _27 = lc4k.PinInfo {
        .id = "27",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const _28 = lc4k.PinInfo {
        .id = "28",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const _29 = lc4k.PinInfo {
        .id = "29",
        .func = .{ .gnd = {} },
    };
    pub const _30 = lc4k.PinInfo {
        .id = "30",
        .func = .{ .vcco = {} },
    };
    pub const _31 = lc4k.PinInfo {
        .id = "31",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const _32 = lc4k.PinInfo {
        .id = "32",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const _33 = lc4k.PinInfo {
        .id = "33",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const _34 = lc4k.PinInfo {
        .id = "34",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const _35 = lc4k.PinInfo {
        .id = "35",
        .func = .{ .tdo = {} },
    };
    pub const _36 = lc4k.PinInfo {
        .id = "36",
        .func = .{ .vcc_core = {} },
    };
    pub const _37 = lc4k.PinInfo {
        .id = "37",
        .func = .{ .gnd = {} },
    };
    pub const _38 = lc4k.PinInfo {
        .id = "38",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const _39 = lc4k.PinInfo {
        .id = "39",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const _40 = lc4k.PinInfo {
        .id = "40",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const _41 = lc4k.PinInfo {
        .id = "41",
        .func = .{ .io_oe1 = 14 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const _42 = lc4k.PinInfo {
        .id = "42",
        .func = .{ .clock = 3 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const _43 = lc4k.PinInfo {
        .id = "43",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const _44 = lc4k.PinInfo {
        .id = "44",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const _45 = lc4k.PinInfo {
        .id = "45",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const _46 = lc4k.PinInfo {
        .id = "46",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const _47 = lc4k.PinInfo {
        .id = "47",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const _48 = lc4k.PinInfo {
        .id = "48",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
};

pub const clock_pins = [_]lc4k.PinInfo {
    pins._43,
    pins._18,
    pins._19,
    pins._42,
};

pub const oe_pins = [_]lc4k.PinInfo {
    pins._44,
    pins._41,
};

pub const input_pins = [_]lc4k.PinInfo {
};

pub const all_pins = [_]lc4k.PinInfo {
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
