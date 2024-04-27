//[[!! include('devices', 'LC4032ZC_csBGA56') !! 474 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.Device_Type.LC4032ZC_csBGA56;

pub const family = lc4k.Device_Family.zero_power;
pub const package = lc4k.Device_Package.csBGA56;

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
    };
}

pub fn getInput_ThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(95, 168),
        .clk1 => jedec.Fuse.init(95, 169),
        .clk2 => jedec.Fuse.init(95, 170),
        .clk3 => jedec.Fuse.init(95, 171),
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
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const A2 = lc4k.Pin_Info {
        .id = "A2",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A3),
    };
    pub const A3 = lc4k.Pin_Info {
        .id = "A3",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const A4 = lc4k.Pin_Info {
        .id = "A4",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const A5 = lc4k.Pin_Info {
        .id = "A5",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const A6 = lc4k.Pin_Info {
        .id = "A6",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B15),
    };
    pub const A7 = lc4k.Pin_Info {
        .id = "A7",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const A8 = lc4k.Pin_Info {
        .id = "A8",
        .func = .{ .no_connect = {} },
    };
    pub const A9 = lc4k.Pin_Info {
        .id = "A9",
        .func = .{ .vcc_core = {} },
    };
    pub const A10 = lc4k.Pin_Info {
        .id = "A10",
        .func = .{ .tdo = {} },
    };
    pub const B1 = lc4k.Pin_Info {
        .id = "B1",
        .func = .{ .tdi = {} },
    };
    pub const B10 = lc4k.Pin_Info {
        .id = "B10",
        .func = .{ .no_connect = {} },
    };
    pub const C1 = lc4k.Pin_Info {
        .id = "C1",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const C3 = lc4k.Pin_Info {
        .id = "C3",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const C4 = lc4k.Pin_Info {
        .id = "C4",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const C5 = lc4k.Pin_Info {
        .id = "C5",
        .func = .{ .clock = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const C6 = lc4k.Pin_Info {
        .id = "C6",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const C7 = lc4k.Pin_Info {
        .id = "C7",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const C8 = lc4k.Pin_Info {
        .id = "C8",
        .func = .{ .gnd = {} },
    };
    pub const C10 = lc4k.Pin_Info {
        .id = "C10",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B11),
    };
    pub const D1 = lc4k.Pin_Info {
        .id = "D1",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A7),
    };
    pub const D3 = lc4k.Pin_Info {
        .id = "D3",
        .func = .{ .gnd = {} },
    };
    pub const D8 = lc4k.Pin_Info {
        .id = "D8",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const D10 = lc4k.Pin_Info {
        .id = "D10",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const E1 = lc4k.Pin_Info {
        .id = "E1",
        .func = .{ .no_connect = {} },
    };
    pub const E3 = lc4k.Pin_Info {
        .id = "E3",
        .func = .{ .no_connect = {} },
    };
    pub const E8 = lc4k.Pin_Info {
        .id = "E8",
        .func = .{ .vcco = {} },
    };
    pub const E10 = lc4k.Pin_Info {
        .id = "E10",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const F1 = lc4k.Pin_Info {
        .id = "F1",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const F3 = lc4k.Pin_Info {
        .id = "F3",
        .func = .{ .vcco = {} },
    };
    pub const F8 = lc4k.Pin_Info {
        .id = "F8",
        .func = .{ .no_connect = {} },
    };
    pub const F10 = lc4k.Pin_Info {
        .id = "F10",
        .func = .{ .no_connect = {} },
    };
    pub const G1 = lc4k.Pin_Info {
        .id = "G1",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const G3 = lc4k.Pin_Info {
        .id = "G3",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const G8 = lc4k.Pin_Info {
        .id = "G8",
        .func = .{ .gnd = {} },
    };
    pub const G10 = lc4k.Pin_Info {
        .id = "G10",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B7),
    };
    pub const H1 = lc4k.Pin_Info {
        .id = "H1",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A11),
    };
    pub const H3 = lc4k.Pin_Info {
        .id = "H3",
        .func = .{ .gnd = {} },
    };
    pub const H4 = lc4k.Pin_Info {
        .id = "H4",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const H5 = lc4k.Pin_Info {
        .id = "H5",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const H6 = lc4k.Pin_Info {
        .id = "H6",
        .func = .{ .clock = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const H7 = lc4k.Pin_Info {
        .id = "H7",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const H8 = lc4k.Pin_Info {
        .id = "H8",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const H10 = lc4k.Pin_Info {
        .id = "H10",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const J1 = lc4k.Pin_Info {
        .id = "J1",
        .func = .{ .no_connect = {} },
    };
    pub const J10 = lc4k.Pin_Info {
        .id = "J10",
        .func = .{ .tms = {} },
    };
    pub const K1 = lc4k.Pin_Info {
        .id = "K1",
        .func = .{ .tck = {} },
    };
    pub const K2 = lc4k.Pin_Info {
        .id = "K2",
        .func = .{ .vcc_core = {} },
    };
    pub const K3 = lc4k.Pin_Info {
        .id = "K3",
        .func = .{ .no_connect = {} },
    };
    pub const K4 = lc4k.Pin_Info {
        .id = "K4",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const K5 = lc4k.Pin_Info {
        .id = "K5",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A15),
    };
    pub const K6 = lc4k.Pin_Info {
        .id = "K6",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const K7 = lc4k.Pin_Info {
        .id = "K7",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const K8 = lc4k.Pin_Info {
        .id = "K8",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const K9 = lc4k.Pin_Info {
        .id = "K9",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B3),
    };
    pub const K10 = lc4k.Pin_Info {
        .id = "K10",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
};

pub const clock_pins = [_]lc4k.Pin_Info {
    pins.A5,
    pins.H6,
    pins.K6,
    pins.C5,
};

pub const oe_pins = [_]lc4k.Pin_Info {
    pins.C4,
    pins.A6,
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
    pins.B1,
    pins.B10,
    pins.C1,
    pins.C3,
    pins.C4,
    pins.C5,
    pins.C6,
    pins.C7,
    pins.C8,
    pins.C10,
    pins.D1,
    pins.D3,
    pins.D8,
    pins.D10,
    pins.E1,
    pins.E3,
    pins.E8,
    pins.E10,
    pins.F1,
    pins.F3,
    pins.F8,
    pins.F10,
    pins.G1,
    pins.G3,
    pins.G8,
    pins.G10,
    pins.H1,
    pins.H3,
    pins.H4,
    pins.H5,
    pins.H6,
    pins.H7,
    pins.H8,
    pins.H10,
    pins.J1,
    pins.J10,
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
