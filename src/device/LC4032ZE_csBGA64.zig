//[[!! include('devices', 'LC4032ZE_csBGA64') !! 551 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.DeviceType.LC4032ZE_csBGA64;

pub const family = lc4k.DeviceFamily.zero_power_enhanced;
pub const package = lc4k.DevicePackage.csBGA64;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;
pub const oe_bus_size = 2;

pub const jedec_dimensions = jedec.FuseRange.init(172, 100);

pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_B15;
    pub const timer_reset = timer_out;
};

const grp_device = @import("LC4032x_TQFP48.zig");

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

pub fn getOscTimerEnableRange() jedec.FuseRange {
    return jedec.FuseRange.between(
        jedec.Fuse.init(91, 168),
        jedec.Fuse.init(92, 168),
    );
}

pub fn getOscOutFuse() jedec.Fuse {
    return jedec.Fuse.init(93, 170);
}

pub fn getTimerOutFuse() jedec.Fuse {
    return jedec.Fuse.init(93, 169);
}

pub fn getTimerDivRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(92, 169)
    ).expandToContain(
        jedec.Fuse.init(92, 170)
    );
}

pub fn getInputPowerGuardFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(87, 168),
        .clk1 => jedec.Fuse.init(88, 168),
        .clk2 => jedec.Fuse.init(89, 168),
        .clk3 => jedec.Fuse.init(90, 168),
        else => unreachable,
    };
}

pub fn getInputBusMaintenanceRange(input: GRP) jedec.FuseRange {
    return switch (input) {
        .clk0 => jedec.FuseRange.between(jedec.Fuse.init(85, 171), jedec.Fuse.init(86, 171)),
        .clk1 => jedec.FuseRange.between(jedec.Fuse.init(85, 170), jedec.Fuse.init(86, 170)),
        .clk2 => jedec.FuseRange.between(jedec.Fuse.init(85, 169), jedec.Fuse.init(86, 169)),
        .clk3 => jedec.FuseRange.between(jedec.Fuse.init(85, 168), jedec.Fuse.init(86, 168)),
        else => unreachable,
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(95, 168),
        .clk1 => jedec.Fuse.init(95, 169),
        .clk2 => jedec.Fuse.init(95, 170),
        .clk3 => jedec.Fuse.init(95, 171),
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
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const A2 = lc4k.PinInfo {
        .id = "A2",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A3),
    };
    pub const A3 = lc4k.PinInfo {
        .id = "A3",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const A4 = lc4k.PinInfo {
        .id = "A4",
        .func = .{ .clock = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const A5 = lc4k.PinInfo {
        .id = "A5",
        .func = .{ .no_connect = {} },
    };
    pub const A6 = lc4k.PinInfo {
        .id = "A6",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const A7 = lc4k.PinInfo {
        .id = "A7",
        .func = .{ .no_connect = {} },
    };
    pub const A8 = lc4k.PinInfo {
        .id = "A8",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const B1 = lc4k.PinInfo {
        .id = "B1",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const B2 = lc4k.PinInfo {
        .id = "B2",
        .func = .{ .tdi = {} },
    };
    pub const B3 = lc4k.PinInfo {
        .id = "B3",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const B4 = lc4k.PinInfo {
        .id = "B4",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const B5 = lc4k.PinInfo {
        .id = "B5",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B15),
    };
    pub const B6 = lc4k.PinInfo {
        .id = "B6",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const B7 = lc4k.PinInfo {
        .id = "B7",
        .func = .{ .no_connect = {} },
    };
    pub const B8 = lc4k.PinInfo {
        .id = "B8",
        .func = .{ .tdo = {} },
    };
    pub const C1 = lc4k.PinInfo {
        .id = "C1",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A7),
    };
    pub const C2 = lc4k.PinInfo {
        .id = "C2",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const C3 = lc4k.PinInfo {
        .id = "C3",
        .func = .{ .no_connect = {} },
    };
    pub const C4 = lc4k.PinInfo {
        .id = "C4",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const C5 = lc4k.PinInfo {
        .id = "C5",
        .func = .{ .no_connect = {} },
    };
    pub const C6 = lc4k.PinInfo {
        .id = "C6",
        .func = .{ .no_connect = {} },
    };
    pub const C7 = lc4k.PinInfo {
        .id = "C7",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B11),
    };
    pub const C8 = lc4k.PinInfo {
        .id = "C8",
        .func = .{ .no_connect = {} },
    };
    pub const D1 = lc4k.PinInfo {
        .id = "D1",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const D2 = lc4k.PinInfo {
        .id = "D2",
        .func = .{ .no_connect = {} },
    };
    pub const D3 = lc4k.PinInfo {
        .id = "D3",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const D4 = lc4k.PinInfo {
        .id = "D4",
        .func = .{ .gnd = {} },
    };
    pub const D5 = lc4k.PinInfo {
        .id = "D5",
        .func = .{ .vcc_core = {} },
    };
    pub const D6 = lc4k.PinInfo {
        .id = "D6",
        .func = .{ .vcco = {} },
    };
    pub const D7 = lc4k.PinInfo {
        .id = "D7",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const D8 = lc4k.PinInfo {
        .id = "D8",
        .func = .{ .no_connect = {} },
    };
    pub const E1 = lc4k.PinInfo {
        .id = "E1",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const E2 = lc4k.PinInfo {
        .id = "E2",
        .func = .{ .no_connect = {} },
    };
    pub const E3 = lc4k.PinInfo {
        .id = "E3",
        .func = .{ .vcco = {} },
    };
    pub const E4 = lc4k.PinInfo {
        .id = "E4",
        .func = .{ .vcc_core = {} },
    };
    pub const E5 = lc4k.PinInfo {
        .id = "E5",
        .func = .{ .gnd = {} },
    };
    pub const E6 = lc4k.PinInfo {
        .id = "E6",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const E7 = lc4k.PinInfo {
        .id = "E7",
        .func = .{ .no_connect = {} },
    };
    pub const E8 = lc4k.PinInfo {
        .id = "E8",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const F1 = lc4k.PinInfo {
        .id = "F1",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A11),
    };
    pub const F2 = lc4k.PinInfo {
        .id = "F2",
        .func = .{ .no_connect = {} },
    };
    pub const F3 = lc4k.PinInfo {
        .id = "F3",
        .func = .{ .no_connect = {} },
    };
    pub const F4 = lc4k.PinInfo {
        .id = "F4",
        .func = .{ .no_connect = {} },
    };
    pub const F5 = lc4k.PinInfo {
        .id = "F5",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const F6 = lc4k.PinInfo {
        .id = "F6",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const F7 = lc4k.PinInfo {
        .id = "F7",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const F8 = lc4k.PinInfo {
        .id = "F8",
        .func = .{ .no_connect = {} },
    };
    pub const G1 = lc4k.PinInfo {
        .id = "G1",
        .func = .{ .no_connect = {} },
    };
    pub const G2 = lc4k.PinInfo {
        .id = "G2",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const G3 = lc4k.PinInfo {
        .id = "G3",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const G4 = lc4k.PinInfo {
        .id = "G4",
        .func = .{ .clock = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const G5 = lc4k.PinInfo {
        .id = "G5",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const G6 = lc4k.PinInfo {
        .id = "G6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const G7 = lc4k.PinInfo {
        .id = "G7",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const G8 = lc4k.PinInfo {
        .id = "G8",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B7),
    };
    pub const H1 = lc4k.PinInfo {
        .id = "H1",
        .func = .{ .tck = {} },
    };
    pub const H2 = lc4k.PinInfo {
        .id = "H2",
        .func = .{ .no_connect = {} },
    };
    pub const H3 = lc4k.PinInfo {
        .id = "H3",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const H4 = lc4k.PinInfo {
        .id = "H4",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A15),
    };
    pub const H5 = lc4k.PinInfo {
        .id = "H5",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const H6 = lc4k.PinInfo {
        .id = "H6",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B3),
    };
    pub const H7 = lc4k.PinInfo {
        .id = "H7",
        .func = .{ .no_connect = {} },
    };
    pub const H8 = lc4k.PinInfo {
        .id = "H8",
        .func = .{ .tms = {} },
    };
};

pub const clock_pins = [_]lc4k.PinInfo {
    pins.C4,
    pins.G4,
    pins.H5,
    pins.A4,
};

pub const oe_pins = [_]lc4k.PinInfo {
    pins.B4,
    pins.B5,
};

pub const input_pins = [_]lc4k.PinInfo {
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
    pins.B1,
    pins.B2,
    pins.B3,
    pins.B4,
    pins.B5,
    pins.B6,
    pins.B7,
    pins.B8,
    pins.C1,
    pins.C2,
    pins.C3,
    pins.C4,
    pins.C5,
    pins.C6,
    pins.C7,
    pins.C8,
    pins.D1,
    pins.D2,
    pins.D3,
    pins.D4,
    pins.D5,
    pins.D6,
    pins.D7,
    pins.D8,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E4,
    pins.E5,
    pins.E6,
    pins.E7,
    pins.E8,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F4,
    pins.F5,
    pins.F6,
    pins.F7,
    pins.F8,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G4,
    pins.G5,
    pins.G6,
    pins.G7,
    pins.G8,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H4,
    pins.H5,
    pins.H6,
    pins.H7,
    pins.H8,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
