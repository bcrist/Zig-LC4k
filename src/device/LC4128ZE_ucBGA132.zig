//[[!! include('devices', 'LC4128ZE_ucBGA132') !! 1021 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.Device_Type.LC4128ZE_ucBGA132;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.ucBGA132;

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
    pub const A1 = lc4k.Pin_Info {
        .id = "A1",
        .func = .{ .tdi = {} },
    };
    pub const A2 = lc4k.Pin_Info {
        .id = "A2",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const A3 = lc4k.Pin_Info {
        .id = "A3",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const A4 = lc4k.Pin_Info {
        .id = "A4",
        .func = .{ .vcco = {} },
    };
    pub const A5 = lc4k.Pin_Info {
        .id = "A5",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const A6 = lc4k.Pin_Info {
        .id = "A6",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const A7 = lc4k.Pin_Info {
        .id = "A7",
        .func = .{ .io = 1 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H1),
    };
    pub const A8 = lc4k.Pin_Info {
        .id = "A8",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H2),
    };
    pub const A9 = lc4k.Pin_Info {
        .id = "A9",
        .func = .{ .gnd = {} },
    };
    pub const A10 = lc4k.Pin_Info {
        .id = "A10",
        .func = .{ .io = 14 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H14),
    };
    pub const A11 = lc4k.Pin_Info {
        .id = "A11",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H13),
    };
    pub const A12 = lc4k.Pin_Info {
        .id = "A12",
        .func = .{ .vcc_core = {} },
    };
    pub const B1 = lc4k.Pin_Info {
        .id = "B1",
        .func = .{ .vcco = {} },
    };
    pub const B2 = lc4k.Pin_Info {
        .id = "B2",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const B3 = lc4k.Pin_Info {
        .id = "B3",
        .func = .{ .gnd = {} },
    };
    pub const B4 = lc4k.Pin_Info {
        .id = "B4",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const B5 = lc4k.Pin_Info {
        .id = "B5",
        .func = .{ .vcc_core = {} },
    };
    pub const B6 = lc4k.Pin_Info {
        .id = "B6",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H0),
    };
    pub const B7 = lc4k.Pin_Info {
        .id = "B7",
        .func = .{ .gnd = {} },
    };
    pub const B8 = lc4k.Pin_Info {
        .id = "B8",
        .func = .{ .io = 5 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H5),
    };
    pub const B9 = lc4k.Pin_Info {
        .id = "B9",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H6),
    };
    pub const B10 = lc4k.Pin_Info {
        .id = "B10",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H12),
    };
    pub const B11 = lc4k.Pin_Info {
        .id = "B11",
        .func = .{ .io = 0 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G0),
    };
    pub const B12 = lc4k.Pin_Info {
        .id = "B12",
        .func = .{ .tdo = {} },
    };
    pub const C1 = lc4k.Pin_Info {
        .id = "C1",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const C2 = lc4k.Pin_Info {
        .id = "C2",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const C3 = lc4k.Pin_Info {
        .id = "C3",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const C4 = lc4k.Pin_Info {
        .id = "C4",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const C5 = lc4k.Pin_Info {
        .id = "C5",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const C6 = lc4k.Pin_Info {
        .id = "C6",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const C7 = lc4k.Pin_Info {
        .id = "C7",
        .func = .{ .vcco = {} },
    };
    pub const C8 = lc4k.Pin_Info {
        .id = "C8",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H8),
    };
    pub const C9 = lc4k.Pin_Info {
        .id = "C9",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H10),
    };
    pub const C10 = lc4k.Pin_Info {
        .id = "C10",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G2),
    };
    pub const C11 = lc4k.Pin_Info {
        .id = "C11",
        .func = .{ .io = 1 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G1),
    };
    pub const C12 = lc4k.Pin_Info {
        .id = "C12",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G4),
    };
    pub const D1 = lc4k.Pin_Info {
        .id = "D1",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const D2 = lc4k.Pin_Info {
        .id = "D2",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const D3 = lc4k.Pin_Info {
        .id = "D3",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const D4 = lc4k.Pin_Info {
        .id = "D4",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const D5 = lc4k.Pin_Info {
        .id = "D5",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const D6 = lc4k.Pin_Info {
        .id = "D6",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const D7 = lc4k.Pin_Info {
        .id = "D7",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H4),
    };
    pub const D8 = lc4k.Pin_Info {
        .id = "D8",
        .func = .{ .io = 9 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H9),
    };
    pub const D9 = lc4k.Pin_Info {
        .id = "D9",
        .func = .{ .vcco = {} },
    };
    pub const D10 = lc4k.Pin_Info {
        .id = "D10",
        .func = .{ .io = 9 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G9),
    };
    pub const D11 = lc4k.Pin_Info {
        .id = "D11",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G5),
    };
    pub const D12 = lc4k.Pin_Info {
        .id = "D12",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G6),
    };
    pub const E1 = lc4k.Pin_Info {
        .id = "E1",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const E2 = lc4k.Pin_Info {
        .id = "E2",
        .func = .{ .gnd = {} },
    };
    pub const E3 = lc4k.Pin_Info {
        .id = "E3",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const E4 = lc4k.Pin_Info {
        .id = "E4",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const E5 = lc4k.Pin_Info {
        .id = "E5",
        .func = .{ .gnd = {} },
    };
    pub const E8 = lc4k.Pin_Info {
        .id = "E8",
        .func = .{ .gnd = {} },
    };
    pub const E9 = lc4k.Pin_Info {
        .id = "E9",
        .func = .{ .gnd = {} },
    };
    pub const E10 = lc4k.Pin_Info {
        .id = "E10",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G10),
    };
    pub const E11 = lc4k.Pin_Info {
        .id = "E11",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G12),
    };
    pub const E12 = lc4k.Pin_Info {
        .id = "E12",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G8),
    };
    pub const F1 = lc4k.Pin_Info {
        .id = "F1",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const F2 = lc4k.Pin_Info {
        .id = "F2",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const F3 = lc4k.Pin_Info {
        .id = "F3",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const F4 = lc4k.Pin_Info {
        .id = "F4",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const F9 = lc4k.Pin_Info {
        .id = "F9",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F10),
    };
    pub const F10 = lc4k.Pin_Info {
        .id = "F10",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G14),
    };
    pub const F11 = lc4k.Pin_Info {
        .id = "F11",
        .func = .{ .io = 13 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G13),
    };
    pub const F12 = lc4k.Pin_Info {
        .id = "F12",
        .func = .{ .vcco = {} },
    };
    pub const G1 = lc4k.Pin_Info {
        .id = "G1",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const G2 = lc4k.Pin_Info {
        .id = "G2",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C13),
    };
    pub const G3 = lc4k.Pin_Info {
        .id = "G3",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const G4 = lc4k.Pin_Info {
        .id = "G4",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const G9 = lc4k.Pin_Info {
        .id = "G9",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F8),
    };
    pub const G10 = lc4k.Pin_Info {
        .id = "G10",
        .func = .{ .io = 14 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F14),
    };
    pub const G11 = lc4k.Pin_Info {
        .id = "G11",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F13),
    };
    pub const G12 = lc4k.Pin_Info {
        .id = "G12",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F12),
    };
    pub const H1 = lc4k.Pin_Info {
        .id = "H1",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const H2 = lc4k.Pin_Info {
        .id = "H2",
        .func = .{ .gnd = {} },
    };
    pub const H3 = lc4k.Pin_Info {
        .id = "H3",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const H4 = lc4k.Pin_Info {
        .id = "H4",
        .func = .{ .vcco = {} },
    };
    pub const H5 = lc4k.Pin_Info {
        .id = "H5",
        .func = .{ .gnd = {} },
    };
    pub const H8 = lc4k.Pin_Info {
        .id = "H8",
        .func = .{ .gnd = {} },
    };
    pub const H9 = lc4k.Pin_Info {
        .id = "H9",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F2),
    };
    pub const H10 = lc4k.Pin_Info {
        .id = "H10",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F6),
    };
    pub const H11 = lc4k.Pin_Info {
        .id = "H11",
        .func = .{ .io = 9 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F9),
    };
    pub const H12 = lc4k.Pin_Info {
        .id = "H12",
        .func = .{ .gnd = {} },
    };
    pub const J1 = lc4k.Pin_Info {
        .id = "J1",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C5),
    };
    pub const J2 = lc4k.Pin_Info {
        .id = "J2",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const J3 = lc4k.Pin_Info {
        .id = "J3",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const J4 = lc4k.Pin_Info {
        .id = "J4",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C9),
    };
    pub const J5 = lc4k.Pin_Info {
        .id = "J5",
        .func = .{ .vcco = {} },
    };
    pub const J6 = lc4k.Pin_Info {
        .id = "J6",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const J7 = lc4k.Pin_Info {
        .id = "J7",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const J8 = lc4k.Pin_Info {
        .id = "J8",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E4),
    };
    pub const J9 = lc4k.Pin_Info {
        .id = "J9",
        .func = .{ .gnd = {} },
    };
    pub const J10 = lc4k.Pin_Info {
        .id = "J10",
        .func = .{ .io = 1 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F1),
    };
    pub const J11 = lc4k.Pin_Info {
        .id = "J11",
        .func = .{ .io = 5 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F5),
    };
    pub const J12 = lc4k.Pin_Info {
        .id = "J12",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F4),
    };
    pub const K1 = lc4k.Pin_Info {
        .id = "K1",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const K2 = lc4k.Pin_Info {
        .id = "K2",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C1),
    };
    pub const K3 = lc4k.Pin_Info {
        .id = "K3",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const K4 = lc4k.Pin_Info {
        .id = "K4",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const K5 = lc4k.Pin_Info {
        .id = "K5",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D9),
    };
    pub const K6 = lc4k.Pin_Info {
        .id = "K6",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const K7 = lc4k.Pin_Info {
        .id = "K7",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const K8 = lc4k.Pin_Info {
        .id = "K8",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E0),
    };
    pub const K9 = lc4k.Pin_Info {
        .id = "K9",
        .func = .{ .vcco = {} },
    };
    pub const K10 = lc4k.Pin_Info {
        .id = "K10",
        .func = .{ .io = 9 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E9),
    };
    pub const K11 = lc4k.Pin_Info {
        .id = "K11",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F0),
    };
    pub const K12 = lc4k.Pin_Info {
        .id = "K12",
        .func = .{ .io = 13 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E13),
    };
    pub const L1 = lc4k.Pin_Info {
        .id = "L1",
        .func = .{ .tck = {} },
    };
    pub const L2 = lc4k.Pin_Info {
        .id = "L2",
        .func = .{ .vcco = {} },
    };
    pub const L3 = lc4k.Pin_Info {
        .id = "L3",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const L4 = lc4k.Pin_Info {
        .id = "L4",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const L5 = lc4k.Pin_Info {
        .id = "L5",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const L6 = lc4k.Pin_Info {
        .id = "L6",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D1),
    };
    pub const L7 = lc4k.Pin_Info {
        .id = "L7",
        .func = .{ .gnd = {} },
    };
    pub const L8 = lc4k.Pin_Info {
        .id = "L8",
        .func = .{ .io = 1 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E1),
    };
    pub const L9 = lc4k.Pin_Info {
        .id = "L9",
        .func = .{ .io = 5 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E5),
    };
    pub const L10 = lc4k.Pin_Info {
        .id = "L10",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E8),
    };
    pub const L11 = lc4k.Pin_Info {
        .id = "L11",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E12),
    };
    pub const L12 = lc4k.Pin_Info {
        .id = "L12",
        .func = .{ .vcco = {} },
    };
    pub const M1 = lc4k.Pin_Info {
        .id = "M1",
        .func = .{ .vcc_core = {} },
    };
    pub const M2 = lc4k.Pin_Info {
        .id = "M2",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D13),
    };
    pub const M3 = lc4k.Pin_Info {
        .id = "M3",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const M4 = lc4k.Pin_Info {
        .id = "M4",
        .func = .{ .gnd = {} },
    };
    pub const M5 = lc4k.Pin_Info {
        .id = "M5",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D5),
    };
    pub const M6 = lc4k.Pin_Info {
        .id = "M6",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const M7 = lc4k.Pin_Info {
        .id = "M7",
        .func = .{ .vcc_core = {} },
    };
    pub const M8 = lc4k.Pin_Info {
        .id = "M8",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E2),
    };
    pub const M9 = lc4k.Pin_Info {
        .id = "M9",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E6),
    };
    pub const M10 = lc4k.Pin_Info {
        .id = "M10",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E10),
    };
    pub const M11 = lc4k.Pin_Info {
        .id = "M11",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E14),
    };
    pub const M12 = lc4k.Pin_Info {
        .id = "M12",
        .func = .{ .tms = {} },
    };
};

pub const clock_pins = [_]lc4k.Pin_Info {
    pins.D6,
    pins.K7,
    pins.J7,
    pins.C6,
};

pub const oe_pins = [_]lc4k.Pin_Info {
    pins.A6,
    pins.B6,
};

pub const input_pins = [_]lc4k.Pin_Info {
};

pub const all_pins = [_]lc4k.Pin_Info {
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
    pins.D1,
    pins.D2,
    pins.D3,
    pins.D4,
    pins.D5,
    pins.D6,
    pins.D7,
    pins.D8,
    pins.D9,
    pins.D10,
    pins.D11,
    pins.D12,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E4,
    pins.E5,
    pins.E8,
    pins.E9,
    pins.E10,
    pins.E11,
    pins.E12,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F4,
    pins.F9,
    pins.F10,
    pins.F11,
    pins.F12,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G4,
    pins.G9,
    pins.G10,
    pins.G11,
    pins.G12,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H4,
    pins.H5,
    pins.H8,
    pins.H9,
    pins.H10,
    pins.H11,
    pins.H12,
    pins.J1,
    pins.J2,
    pins.J3,
    pins.J4,
    pins.J5,
    pins.J6,
    pins.J7,
    pins.J8,
    pins.J9,
    pins.J10,
    pins.J11,
    pins.J12,
    pins.K1,
    pins.K2,
    pins.K3,
    pins.K4,
    pins.K5,
    pins.K6,
    pins.K7,
    pins.K8,
    pins.K9,
    pins.K10,
    pins.K11,
    pins.K12,
    pins.L1,
    pins.L2,
    pins.L3,
    pins.L4,
    pins.L5,
    pins.L6,
    pins.L7,
    pins.L8,
    pins.L9,
    pins.L10,
    pins.L11,
    pins.L12,
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
