//[[!! include('devices', 'LC4032ZC_csBGA56') !! 401 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4032ZC_csBGA56;

pub const family = common.DeviceFamily.zero_power;
pub const package = common.DevicePackage.csBGA56;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;

pub const jedec_dimensions = jedec.FuseRange.init(172, 100);

const grp_device = @import("LC4032x_TQFP48.zig");

pub const GRP = grp_device.GRP;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;


pub const pins = struct {
    const A1 = common.PinInfo {
        .id = "A1",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    const A2 = common.PinInfo {
        .id = "A2",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A3),
    };
    const A3 = common.PinInfo {
        .id = "A3",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    const A4 = common.PinInfo {
        .id = "A4",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    const A5 = common.PinInfo {
        .id = "A5",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    const A6 = common.PinInfo {
        .id = "A6",
        .func = .{ .io_oe1 = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    const A7 = common.PinInfo {
        .id = "A7",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    const A8 = common.PinInfo {
        .id = "A8",
        .func = .{ .no_connect = {} },
    };
    const A9 = common.PinInfo {
        .id = "A9",
        .func = .{ .vcc_core = {} },
    };
    const A10 = common.PinInfo {
        .id = "A10",
        .func = .{ .tdo = {} },
    };
    const B1 = common.PinInfo {
        .id = "B1",
        .func = .{ .tdi = {} },
    };
    const B10 = common.PinInfo {
        .id = "B10",
        .func = .{ .no_connect = {} },
    };
    const C1 = common.PinInfo {
        .id = "C1",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    const C3 = common.PinInfo {
        .id = "C3",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    const C4 = common.PinInfo {
        .id = "C4",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    const C5 = common.PinInfo {
        .id = "C5",
        .func = .{ .clock = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    const C6 = common.PinInfo {
        .id = "C6",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    const C7 = common.PinInfo {
        .id = "C7",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    const C8 = common.PinInfo {
        .id = "C8",
        .func = .{ .gnd = {} },
    };
    const C10 = common.PinInfo {
        .id = "C10",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B11),
    };
    const D1 = common.PinInfo {
        .id = "D1",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A7),
    };
    const D3 = common.PinInfo {
        .id = "D3",
        .func = .{ .gnd = {} },
    };
    const D8 = common.PinInfo {
        .id = "D8",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    const D10 = common.PinInfo {
        .id = "D10",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    const E1 = common.PinInfo {
        .id = "E1",
        .func = .{ .no_connect = {} },
    };
    const E3 = common.PinInfo {
        .id = "E3",
        .func = .{ .no_connect = {} },
    };
    const E8 = common.PinInfo {
        .id = "E8",
        .func = .{ .vcco = {} },
    };
    const E10 = common.PinInfo {
        .id = "E10",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    const F1 = common.PinInfo {
        .id = "F1",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    const F3 = common.PinInfo {
        .id = "F3",
        .func = .{ .vcco = {} },
    };
    const F8 = common.PinInfo {
        .id = "F8",
        .func = .{ .no_connect = {} },
    };
    const F10 = common.PinInfo {
        .id = "F10",
        .func = .{ .no_connect = {} },
    };
    const G1 = common.PinInfo {
        .id = "G1",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    const G3 = common.PinInfo {
        .id = "G3",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    const G8 = common.PinInfo {
        .id = "G8",
        .func = .{ .gnd = {} },
    };
    const G10 = common.PinInfo {
        .id = "G10",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B7),
    };
    const H1 = common.PinInfo {
        .id = "H1",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    const H3 = common.PinInfo {
        .id = "H3",
        .func = .{ .gnd = {} },
    };
    const H4 = common.PinInfo {
        .id = "H4",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    const H5 = common.PinInfo {
        .id = "H5",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    const H6 = common.PinInfo {
        .id = "H6",
        .func = .{ .clock = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    const H7 = common.PinInfo {
        .id = "H7",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    const H8 = common.PinInfo {
        .id = "H8",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    const H10 = common.PinInfo {
        .id = "H10",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    const J1 = common.PinInfo {
        .id = "J1",
        .func = .{ .no_connect = {} },
    };
    const J10 = common.PinInfo {
        .id = "J10",
        .func = .{ .tms = {} },
    };
    const K1 = common.PinInfo {
        .id = "K1",
        .func = .{ .tck = {} },
    };
    const K2 = common.PinInfo {
        .id = "K2",
        .func = .{ .vcc_core = {} },
    };
    const K3 = common.PinInfo {
        .id = "K3",
        .func = .{ .no_connect = {} },
    };
    const K4 = common.PinInfo {
        .id = "K4",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    const K5 = common.PinInfo {
        .id = "K5",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    const K6 = common.PinInfo {
        .id = "K6",
        .func = .{ .clock = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    const K7 = common.PinInfo {
        .id = "K7",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    const K8 = common.PinInfo {
        .id = "K8",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    const K9 = common.PinInfo {
        .id = "K9",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B3),
    };
    const K10 = common.PinInfo {
        .id = "K10",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins.A5,
    pins.H6,
    pins.K6,
    pins.C5,
};

pub const oe_pins = [_]common.PinInfo {
    pins.C4,
    pins.A6,
};

pub const input_pins = [_]common.PinInfo {
};

pub const all_pins = [_]common.PinInfo {
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
