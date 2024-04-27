//[[!! include('devices', 'LC4064ZC_csBGA132') !! 944 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.DeviceType.LC4064ZC_csBGA132;

pub const family = lc4k.DeviceFamily.zero_power;
pub const package = lc4k.DevicePackage.csBGA132;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 12;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(356, 100);

const grp_device = @import("LC4064x_TQFP100.zig");

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
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
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
    pub const A1 = lc4k.PinInfo {
        .id = "A1",
        .func = .{ .no_connect = {} },
    };
    pub const A2 = lc4k.PinInfo {
        .id = "A2",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A7),
    };
    pub const A3 = lc4k.PinInfo {
        .id = "A3",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const A4 = lc4k.PinInfo {
        .id = "A4",
        .func = .{ .no_connect = {} },
    };
    pub const A5 = lc4k.PinInfo {
        .id = "A5",
        .func = .{ .no_connect = {} },
    };
    pub const A6 = lc4k.PinInfo {
        .id = "A6",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const A7 = lc4k.PinInfo {
        .id = "A7",
        .func = .{ .no_connect = {} },
    };
    pub const A8 = lc4k.PinInfo {
        .id = "A8",
        .func = .{ .io_oe1 = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const A9 = lc4k.PinInfo {
        .id = "A9",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const A10 = lc4k.PinInfo {
        .id = "A10",
        .func = .{ .vcco = {} },
    };
    pub const A11 = lc4k.PinInfo {
        .id = "A11",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D5),
    };
    pub const A12 = lc4k.PinInfo {
        .id = "A12",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.in5),
    };
    pub const A13 = lc4k.PinInfo {
        .id = "A13",
        .func = .{ .gnd = {} },
    };
    pub const A14 = lc4k.PinInfo {
        .id = "A14",
        .func = .{ .vcc_core = {} },
    };
    pub const B1 = lc4k.PinInfo {
        .id = "B1",
        .func = .{ .gnd = {} },
    };
    pub const B2 = lc4k.PinInfo {
        .id = "B2",
        .func = .{ .tdi = {} },
    };
    pub const B3 = lc4k.PinInfo {
        .id = "B3",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const B4 = lc4k.PinInfo {
        .id = "B4",
        .func = .{ .gnd = {} },
    };
    pub const B5 = lc4k.PinInfo {
        .id = "B5",
        .func = .{ .no_connect = {} },
    };
    pub const B6 = lc4k.PinInfo {
        .id = "B6",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const B7 = lc4k.PinInfo {
        .id = "B7",
        .func = .{ .vcc_core = {} },
    };
    pub const B8 = lc4k.PinInfo {
        .id = "B8",
        .func = .{ .clock = 3 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const B9 = lc4k.PinInfo {
        .id = "B9",
        .func = .{ .io = 3 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D3),
    };
    pub const B10 = lc4k.PinInfo {
        .id = "B10",
        .func = .{ .no_connect = {} },
    };
    pub const B11 = lc4k.PinInfo {
        .id = "B11",
        .func = .{ .gnd = {} },
    };
    pub const B12 = lc4k.PinInfo {
        .id = "B12",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const B13 = lc4k.PinInfo {
        .id = "B13",
        .func = .{ .no_connect = {} },
    };
    pub const B14 = lc4k.PinInfo {
        .id = "B14",
        .func = .{ .tdo = {} },
    };
    pub const C1 = lc4k.PinInfo {
        .id = "C1",
        .func = .{ .no_connect = {} },
    };
    pub const C2 = lc4k.PinInfo {
        .id = "C2",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const C3 = lc4k.PinInfo {
        .id = "C3",
        .func = .{ .no_connect = {} },
    };
    pub const C4 = lc4k.PinInfo {
        .id = "C4",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const C5 = lc4k.PinInfo {
        .id = "C5",
        .func = .{ .vcco = {} },
    };
    pub const C6 = lc4k.PinInfo {
        .id = "C6",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A3),
    };
    pub const C7 = lc4k.PinInfo {
        .id = "C7",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const C8 = lc4k.PinInfo {
        .id = "C8",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const C9 = lc4k.PinInfo {
        .id = "C9",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D1),
    };
    pub const C10 = lc4k.PinInfo {
        .id = "C10",
        .func = .{ .no_connect = {} },
    };
    pub const C11 = lc4k.PinInfo {
        .id = "C11",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const C12 = lc4k.PinInfo {
        .id = "C12",
        .func = .{ .io = 7 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D7),
    };
    pub const C13 = lc4k.PinInfo {
        .id = "C13",
        .func = .{ .no_connect = {} },
    };
    pub const C14 = lc4k.PinInfo {
        .id = "C14",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.in4),
    };
    pub const D1 = lc4k.PinInfo {
        .id = "D1",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const D2 = lc4k.PinInfo {
        .id = "D2",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A11),
    };
    pub const D3 = lc4k.PinInfo {
        .id = "D3",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const D12 = lc4k.PinInfo {
        .id = "D12",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const D13 = lc4k.PinInfo {
        .id = "D13",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const D14 = lc4k.PinInfo {
        .id = "D14",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D9),
    };
    pub const E1 = lc4k.PinInfo {
        .id = "E1",
        .func = .{ .no_connect = {} },
    };
    pub const E2 = lc4k.PinInfo {
        .id = "E2",
        .func = .{ .gnd = {} },
    };
    pub const E3 = lc4k.PinInfo {
        .id = "E3",
        .func = .{ .no_connect = {} },
    };
    pub const E12 = lc4k.PinInfo {
        .id = "E12",
        .func = .{ .io = 11 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D11),
    };
    pub const E13 = lc4k.PinInfo {
        .id = "E13",
        .func = .{ .gnd = {} },
    };
    pub const E14 = lc4k.PinInfo {
        .id = "E14",
        .func = .{ .no_connect = {} },
    };
    pub const F1 = lc4k.PinInfo {
        .id = "F1",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const F2 = lc4k.PinInfo {
        .id = "F2",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const F3 = lc4k.PinInfo {
        .id = "F3",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const F12 = lc4k.PinInfo {
        .id = "F12",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const F13 = lc4k.PinInfo {
        .id = "F13",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D13),
    };
    pub const F14 = lc4k.PinInfo {
        .id = "F14",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const G1 = lc4k.PinInfo {
        .id = "G1",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A15),
    };
    pub const G2 = lc4k.PinInfo {
        .id = "G2",
        .func = .{ .input = {} },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.in0),
    };
    pub const G3 = lc4k.PinInfo {
        .id = "G3",
        .func = .{ .vcco = {} },
    };
    pub const G12 = lc4k.PinInfo {
        .id = "G12",
        .func = .{ .io = 15 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D15),
    };
    pub const G13 = lc4k.PinInfo {
        .id = "G13",
        .func = .{ .no_connect = {} },
    };
    pub const G14 = lc4k.PinInfo {
        .id = "G14",
        .func = .{ .no_connect = {} },
    };
    pub const H1 = lc4k.PinInfo {
        .id = "H1",
        .func = .{ .io = 15 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B15),
    };
    pub const H2 = lc4k.PinInfo {
        .id = "H2",
        .func = .{ .no_connect = {} },
    };
    pub const H3 = lc4k.PinInfo {
        .id = "H3",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const H12 = lc4k.PinInfo {
        .id = "H12",
        .func = .{ .vcco = {} },
    };
    pub const H13 = lc4k.PinInfo {
        .id = "H13",
        .func = .{ .input = {} },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.in3),
    };
    pub const H14 = lc4k.PinInfo {
        .id = "H14",
        .func = .{ .io = 15 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C15),
    };
    pub const J1 = lc4k.PinInfo {
        .id = "J1",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const J2 = lc4k.PinInfo {
        .id = "J2",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const J3 = lc4k.PinInfo {
        .id = "J3",
        .func = .{ .no_connect = {} },
    };
    pub const J12 = lc4k.PinInfo {
        .id = "J12",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const J13 = lc4k.PinInfo {
        .id = "J13",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const J14 = lc4k.PinInfo {
        .id = "J14",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C13),
    };
    pub const K1 = lc4k.PinInfo {
        .id = "K1",
        .func = .{ .no_connect = {} },
    };
    pub const K2 = lc4k.PinInfo {
        .id = "K2",
        .func = .{ .gnd = {} },
    };
    pub const K3 = lc4k.PinInfo {
        .id = "K3",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B11),
    };
    pub const K12 = lc4k.PinInfo {
        .id = "K12",
        .func = .{ .no_connect = {} },
    };
    pub const K13 = lc4k.PinInfo {
        .id = "K13",
        .func = .{ .gnd = {} },
    };
    pub const K14 = lc4k.PinInfo {
        .id = "K14",
        .func = .{ .no_connect = {} },
    };
    pub const L1 = lc4k.PinInfo {
        .id = "L1",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const L2 = lc4k.PinInfo {
        .id = "L2",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const L3 = lc4k.PinInfo {
        .id = "L3",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const L12 = lc4k.PinInfo {
        .id = "L12",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const L13 = lc4k.PinInfo {
        .id = "L13",
        .func = .{ .io = 11 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C11),
    };
    pub const L14 = lc4k.PinInfo {
        .id = "L14",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C9),
    };
    pub const M1 = lc4k.PinInfo {
        .id = "M1",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.in1),
    };
    pub const M2 = lc4k.PinInfo {
        .id = "M2",
        .func = .{ .no_connect = {} },
    };
    pub const M3 = lc4k.PinInfo {
        .id = "M3",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const M4 = lc4k.PinInfo {
        .id = "M4",
        .func = .{ .no_connect = {} },
    };
    pub const M5 = lc4k.PinInfo {
        .id = "M5",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B3),
    };
    pub const M6 = lc4k.PinInfo {
        .id = "M6",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const M7 = lc4k.PinInfo {
        .id = "M7",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const M8 = lc4k.PinInfo {
        .id = "M8",
        .func = .{ .no_connect = {} },
    };
    pub const M9 = lc4k.PinInfo {
        .id = "M9",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const M10 = lc4k.PinInfo {
        .id = "M10",
        .func = .{ .vcco = {} },
    };
    pub const M11 = lc4k.PinInfo {
        .id = "M11",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const M12 = lc4k.PinInfo {
        .id = "M12",
        .func = .{ .no_connect = {} },
    };
    pub const M13 = lc4k.PinInfo {
        .id = "M13",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const M14 = lc4k.PinInfo {
        .id = "M14",
        .func = .{ .no_connect = {} },
    };
    pub const N1 = lc4k.PinInfo {
        .id = "N1",
        .func = .{ .tck = {} },
    };
    pub const N2 = lc4k.PinInfo {
        .id = "N2",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.in2),
    };
    pub const N3 = lc4k.PinInfo {
        .id = "N3",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const N4 = lc4k.PinInfo {
        .id = "N4",
        .func = .{ .gnd = {} },
    };
    pub const N5 = lc4k.PinInfo {
        .id = "N5",
        .func = .{ .no_connect = {} },
    };
    pub const N6 = lc4k.PinInfo {
        .id = "N6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const N7 = lc4k.PinInfo {
        .id = "N7",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const N8 = lc4k.PinInfo {
        .id = "N8",
        .func = .{ .vcc_core = {} },
    };
    pub const N9 = lc4k.PinInfo {
        .id = "N9",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C1),
    };
    pub const N10 = lc4k.PinInfo {
        .id = "N10",
        .func = .{ .io = 3 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C3),
    };
    pub const N11 = lc4k.PinInfo {
        .id = "N11",
        .func = .{ .gnd = {} },
    };
    pub const N12 = lc4k.PinInfo {
        .id = "N12",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const N13 = lc4k.PinInfo {
        .id = "N13",
        .func = .{ .tms = {} },
    };
    pub const N14 = lc4k.PinInfo {
        .id = "N14",
        .func = .{ .gnd = {} },
    };
    pub const P1 = lc4k.PinInfo {
        .id = "P1",
        .func = .{ .vcc_core = {} },
    };
    pub const P2 = lc4k.PinInfo {
        .id = "P2",
        .func = .{ .gnd = {} },
    };
    pub const P3 = lc4k.PinInfo {
        .id = "P3",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B7),
    };
    pub const P4 = lc4k.PinInfo {
        .id = "P4",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const P5 = lc4k.PinInfo {
        .id = "P5",
        .func = .{ .vcco = {} },
    };
    pub const P6 = lc4k.PinInfo {
        .id = "P6",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const P7 = lc4k.PinInfo {
        .id = "P7",
        .func = .{ .no_connect = {} },
    };
    pub const P8 = lc4k.PinInfo {
        .id = "P8",
        .func = .{ .no_connect = {} },
    };
    pub const P9 = lc4k.PinInfo {
        .id = "P9",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const P10 = lc4k.PinInfo {
        .id = "P10",
        .func = .{ .no_connect = {} },
    };
    pub const P11 = lc4k.PinInfo {
        .id = "P11",
        .func = .{ .no_connect = {} },
    };
    pub const P12 = lc4k.PinInfo {
        .id = "P12",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C5),
    };
    pub const P13 = lc4k.PinInfo {
        .id = "P13",
        .func = .{ .io = 7 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C7),
    };
    pub const P14 = lc4k.PinInfo {
        .id = "P14",
        .func = .{ .no_connect = {} },
    };
};

pub const clock_pins = [_]lc4k.PinInfo {
    pins.C8,
    pins.N7,
    pins.M7,
    pins.B8,
};

pub const oe_pins = [_]lc4k.PinInfo {
    pins.C7,
    pins.A8,
};

pub const input_pins = [_]lc4k.PinInfo {
    pins.G2,
    pins.M1,
    pins.N2,
    pins.H13,
    pins.C14,
    pins.A12,
};

pub const all_pins = [_]lc4k.PinInfo {
    pins.A1,
    pins.A2,
    pins.A3,
    pins.A4,
    pins.A5,
    pins.A6,
    pins.A7,
    pins.A8,
    pins.A9,
    pins.A10,
    pins.A11,
    pins.A12,
    pins.A13,
    pins.A14,
    pins.B1,
    pins.B2,
    pins.B3,
    pins.B4,
    pins.B5,
    pins.B6,
    pins.B7,
    pins.B8,
    pins.B9,
    pins.B10,
    pins.B11,
    pins.B12,
    pins.B13,
    pins.B14,
    pins.C1,
    pins.C2,
    pins.C3,
    pins.C4,
    pins.C5,
    pins.C6,
    pins.C7,
    pins.C8,
    pins.C9,
    pins.C10,
    pins.C11,
    pins.C12,
    pins.C13,
    pins.C14,
    pins.D1,
    pins.D2,
    pins.D3,
    pins.D12,
    pins.D13,
    pins.D14,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E12,
    pins.E13,
    pins.E14,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F12,
    pins.F13,
    pins.F14,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G12,
    pins.G13,
    pins.G14,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H12,
    pins.H13,
    pins.H14,
    pins.J1,
    pins.J2,
    pins.J3,
    pins.J12,
    pins.J13,
    pins.J14,
    pins.K1,
    pins.K2,
    pins.K3,
    pins.K12,
    pins.K13,
    pins.K14,
    pins.L1,
    pins.L2,
    pins.L3,
    pins.L12,
    pins.L13,
    pins.L14,
    pins.M1,
    pins.M2,
    pins.M3,
    pins.M4,
    pins.M5,
    pins.M6,
    pins.M7,
    pins.M8,
    pins.M9,
    pins.M10,
    pins.M11,
    pins.M12,
    pins.M13,
    pins.M14,
    pins.N1,
    pins.N2,
    pins.N3,
    pins.N4,
    pins.N5,
    pins.N6,
    pins.N7,
    pins.N8,
    pins.N9,
    pins.N10,
    pins.N11,
    pins.N12,
    pins.N13,
    pins.N14,
    pins.P1,
    pins.P2,
    pins.P3,
    pins.P4,
    pins.P5,
    pins.P6,
    pins.P7,
    pins.P8,
    pins.P9,
    pins.P10,
    pins.P11,
    pins.P12,
    pins.P13,
    pins.P14,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
