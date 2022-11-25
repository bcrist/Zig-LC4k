//[[!! include('devices', 'LC4128ZC_csBGA132') !! 909 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4128ZC_csBGA132;

pub const family = common.DeviceFamily.zero_power;
pub const package = common.DevicePackage.csBGA132;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;

pub const jedec_dimensions = jedec.FuseRange.init(740, 100);

const grp_device = @import("LC4128V_TQFP144.zig");

pub const GRP = grp_device.GRP;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;


pub const pins = struct {
    const A1 = common.PinInfo {
        .id = "A1",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    const A2 = common.PinInfo {
        .id = "A2",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    const A3 = common.PinInfo {
        .id = "A3",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    const A4 = common.PinInfo {
        .id = "A4",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    const A5 = common.PinInfo {
        .id = "A5",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    const A6 = common.PinInfo {
        .id = "A6",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    const A7 = common.PinInfo {
        .id = "A7",
        .func = .{ .no_connect = {} },
    };
    const A8 = common.PinInfo {
        .id = "A8",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H0),
    };
    const A9 = common.PinInfo {
        .id = "A9",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H2),
    };
    const A10 = common.PinInfo {
        .id = "A10",
        .func = .{ .vcco = {} },
    };
    const A11 = common.PinInfo {
        .id = "A11",
        .func = .{ .io = 9 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H9),
    };
    const A12 = common.PinInfo {
        .id = "A12",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H13),
    };
    const A13 = common.PinInfo {
        .id = "A13",
        .func = .{ .gnd = {} },
    };
    const A14 = common.PinInfo {
        .id = "A14",
        .func = .{ .vcc_core = {} },
    };
    const B1 = common.PinInfo {
        .id = "B1",
        .func = .{ .gnd = {} },
    };
    const B2 = common.PinInfo {
        .id = "B2",
        .func = .{ .tdi = {} },
    };
    const B3 = common.PinInfo {
        .id = "B3",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    const B4 = common.PinInfo {
        .id = "B4",
        .func = .{ .gnd = {} },
    };
    const B5 = common.PinInfo {
        .id = "B5",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    const B6 = common.PinInfo {
        .id = "B6",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    const B7 = common.PinInfo {
        .id = "B7",
        .func = .{ .vcc_core = {} },
    };
    const B8 = common.PinInfo {
        .id = "B8",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    const B9 = common.PinInfo {
        .id = "B9",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H4),
    };
    const B10 = common.PinInfo {
        .id = "B10",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H6),
    };
    const B11 = common.PinInfo {
        .id = "B11",
        .func = .{ .gnd = {} },
    };
    const B12 = common.PinInfo {
        .id = "B12",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H10),
    };
    const B13 = common.PinInfo {
        .id = "B13",
        .func = .{ .io = 14 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H14),
    };
    const B14 = common.PinInfo {
        .id = "B14",
        .func = .{ .tdo = {} },
    };
    const C1 = common.PinInfo {
        .id = "C1",
        .func = .{ .vcco = {} },
    };
    const C2 = common.PinInfo {
        .id = "C2",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    const C3 = common.PinInfo {
        .id = "C3",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    const C4 = common.PinInfo {
        .id = "C4",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    const C5 = common.PinInfo {
        .id = "C5",
        .func = .{ .vcco = {} },
    };
    const C6 = common.PinInfo {
        .id = "C6",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    const C7 = common.PinInfo {
        .id = "C7",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    const C8 = common.PinInfo {
        .id = "C8",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    const C9 = common.PinInfo {
        .id = "C9",
        .func = .{ .io = 1 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H1),
    };
    const C10 = common.PinInfo {
        .id = "C10",
        .func = .{ .io = 5 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H5),
    };
    const C11 = common.PinInfo {
        .id = "C11",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H8),
    };
    const C12 = common.PinInfo {
        .id = "C12",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @enumToInt(GRP.io_H12),
    };
    const C13 = common.PinInfo {
        .id = "C13",
        .func = .{ .vcco = {} },
    };
    const C14 = common.PinInfo {
        .id = "C14",
        .func = .{ .io = 0 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G0),
    };
    const D1 = common.PinInfo {
        .id = "D1",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    const D2 = common.PinInfo {
        .id = "D2",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    const D3 = common.PinInfo {
        .id = "D3",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    const D12 = common.PinInfo {
        .id = "D12",
        .func = .{ .io = 1 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G1),
    };
    const D13 = common.PinInfo {
        .id = "D13",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G4),
    };
    const D14 = common.PinInfo {
        .id = "D14",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G2),
    };
    const E1 = common.PinInfo {
        .id = "E1",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    const E2 = common.PinInfo {
        .id = "E2",
        .func = .{ .gnd = {} },
    };
    const E3 = common.PinInfo {
        .id = "E3",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    const E12 = common.PinInfo {
        .id = "E12",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G5),
    };
    const E13 = common.PinInfo {
        .id = "E13",
        .func = .{ .gnd = {} },
    };
    const E14 = common.PinInfo {
        .id = "E14",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G6),
    };
    const F1 = common.PinInfo {
        .id = "F1",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    const F2 = common.PinInfo {
        .id = "F2",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    const F3 = common.PinInfo {
        .id = "F3",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    const F12 = common.PinInfo {
        .id = "F12",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G8),
    };
    const F13 = common.PinInfo {
        .id = "F13",
        .func = .{ .io = 9 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G9),
    };
    const F14 = common.PinInfo {
        .id = "F14",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G10),
    };
    const G1 = common.PinInfo {
        .id = "G1",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    const G2 = common.PinInfo {
        .id = "G2",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    const G3 = common.PinInfo {
        .id = "G3",
        .func = .{ .vcco = {} },
    };
    const G12 = common.PinInfo {
        .id = "G12",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G12),
    };
    const G13 = common.PinInfo {
        .id = "G13",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G14),
    };
    const G14 = common.PinInfo {
        .id = "G14",
        .func = .{ .io = 13 },
        .glb = 6,
        .grp_ordinal = @enumToInt(GRP.io_G13),
    };
    const H1 = common.PinInfo {
        .id = "H1",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C13),
    };
    const H2 = common.PinInfo {
        .id = "H2",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
    };
    const H3 = common.PinInfo {
        .id = "H3",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    const H12 = common.PinInfo {
        .id = "H12",
        .func = .{ .vcco = {} },
    };
    const H13 = common.PinInfo {
        .id = "H13",
        .func = .{ .io = 14 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F14),
    };
    const H14 = common.PinInfo {
        .id = "H14",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F13),
    };
    const J1 = common.PinInfo {
        .id = "J1",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    const J2 = common.PinInfo {
        .id = "J2",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C9),
    };
    const J3 = common.PinInfo {
        .id = "J3",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    const J12 = common.PinInfo {
        .id = "J12",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F12),
    };
    const J13 = common.PinInfo {
        .id = "J13",
        .func = .{ .io = 9 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F9),
    };
    const J14 = common.PinInfo {
        .id = "J14",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F10),
    };
    const K1 = common.PinInfo {
        .id = "K1",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    const K2 = common.PinInfo {
        .id = "K2",
        .func = .{ .gnd = {} },
    };
    const K3 = common.PinInfo {
        .id = "K3",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C5),
    };
    const K12 = common.PinInfo {
        .id = "K12",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F8),
    };
    const K13 = common.PinInfo {
        .id = "K13",
        .func = .{ .gnd = {} },
    };
    const K14 = common.PinInfo {
        .id = "K14",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F6),
    };
    const L1 = common.PinInfo {
        .id = "L1",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    const L2 = common.PinInfo {
        .id = "L2",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    const L3 = common.PinInfo {
        .id = "L3",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C1),
    };
    const L12 = common.PinInfo {
        .id = "L12",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F4),
    };
    const L13 = common.PinInfo {
        .id = "L13",
        .func = .{ .io = 5 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F5),
    };
    const L14 = common.PinInfo {
        .id = "L14",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F2),
    };
    const M1 = common.PinInfo {
        .id = "M1",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    const M2 = common.PinInfo {
        .id = "M2",
        .func = .{ .vcco = {} },
    };
    const M3 = common.PinInfo {
        .id = "M3",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    const M4 = common.PinInfo {
        .id = "M4",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    const M5 = common.PinInfo {
        .id = "M5",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D5),
    };
    const M6 = common.PinInfo {
        .id = "M6",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D1),
    };
    const M7 = common.PinInfo {
        .id = "M7",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    const M8 = common.PinInfo {
        .id = "M8",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E0),
    };
    const M9 = common.PinInfo {
        .id = "M9",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E4),
    };
    const M10 = common.PinInfo {
        .id = "M10",
        .func = .{ .vcco = {} },
    };
    const M11 = common.PinInfo {
        .id = "M11",
        .func = .{ .io = 9 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E9),
    };
    const M12 = common.PinInfo {
        .id = "M12",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F0),
    };
    const M13 = common.PinInfo {
        .id = "M13",
        .func = .{ .io = 1 },
        .glb = 5,
        .grp_ordinal = @enumToInt(GRP.io_F1),
    };
    const M14 = common.PinInfo {
        .id = "M14",
        .func = .{ .vcco = {} },
    };
    const N1 = common.PinInfo {
        .id = "N1",
        .func = .{ .tck = {} },
    };
    const N2 = common.PinInfo {
        .id = "N2",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    const N3 = common.PinInfo {
        .id = "N3",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    const N4 = common.PinInfo {
        .id = "N4",
        .func = .{ .gnd = {} },
    };
    const N5 = common.PinInfo {
        .id = "N5",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
    };
    const N6 = common.PinInfo {
        .id = "N6",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    const N7 = common.PinInfo {
        .id = "N7",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    const N8 = common.PinInfo {
        .id = "N8",
        .func = .{ .vcc_core = {} },
    };
    const N9 = common.PinInfo {
        .id = "N9",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E2),
    };
    const N10 = common.PinInfo {
        .id = "N10",
        .func = .{ .io = 5 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E5),
    };
    const N11 = common.PinInfo {
        .id = "N11",
        .func = .{ .gnd = {} },
    };
    const N12 = common.PinInfo {
        .id = "N12",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E12),
    };
    const N13 = common.PinInfo {
        .id = "N13",
        .func = .{ .tms = {} },
    };
    const N14 = common.PinInfo {
        .id = "N14",
        .func = .{ .gnd = {} },
    };
    const P1 = common.PinInfo {
        .id = "P1",
        .func = .{ .vcc_core = {} },
    };
    const P2 = common.PinInfo {
        .id = "P2",
        .func = .{ .gnd = {} },
    };
    const P3 = common.PinInfo {
        .id = "P3",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D13),
    };
    const P4 = common.PinInfo {
        .id = "P4",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D9),
    };
    const P5 = common.PinInfo {
        .id = "P5",
        .func = .{ .vcco = {} },
    };
    const P6 = common.PinInfo {
        .id = "P6",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    const P7 = common.PinInfo {
        .id = "P7",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    const P8 = common.PinInfo {
        .id = "P8",
        .func = .{ .no_connect = {} },
    };
    const P9 = common.PinInfo {
        .id = "P9",
        .func = .{ .io = 1 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E1),
    };
    const P10 = common.PinInfo {
        .id = "P10",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E6),
    };
    const P11 = common.PinInfo {
        .id = "P11",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E8),
    };
    const P12 = common.PinInfo {
        .id = "P12",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E10),
    };
    const P13 = common.PinInfo {
        .id = "P13",
        .func = .{ .io = 13 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E13),
    };
    const P14 = common.PinInfo {
        .id = "P14",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @enumToInt(GRP.io_E14),
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins.C8,
    pins.N7,
    pins.M7,
    pins.B8,
};

pub const oe_pins = [_]common.PinInfo {
    pins.C7,
    pins.A8,
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
