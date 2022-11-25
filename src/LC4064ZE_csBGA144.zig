//[[!! include('devices', 'LC4064ZE_csBGA144') !! 930 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4064ZE_csBGA144;

pub const family = common.DeviceFamily.zero_power_enhanced;
pub const package = common.DevicePackage.csBGA144;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 12;

pub const jedec_dimensions = jedec.FuseRange.init(356, 100);

pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_D15;
    pub const timer_reset = timer_out;
};

const grp_device = @import("LC4064x_TQFP100.zig");

pub const GRP = grp_device.GRP;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;


pub const pins = struct {
    const A01 = common.PinInfo {
        .id = "A01",
        .func = .{ .tdi = {} },
    };
    const A2 = common.PinInfo {
        .id = "A2",
        .func = .{ .no_connect = {} },
    };
    const A3 = common.PinInfo {
        .id = "A3",
        .func = .{ .io = 7 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A7),
    };
    const A4 = common.PinInfo {
        .id = "A4",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    const A5 = common.PinInfo {
        .id = "A5",
        .func = .{ .no_connect = {} },
    };
    const A6 = common.PinInfo {
        .id = "A6",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    const A7 = common.PinInfo {
        .id = "A7",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    const A8 = common.PinInfo {
        .id = "A8",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    const A9 = common.PinInfo {
        .id = "A9",
        .func = .{ .no_connect = {} },
    };
    const A10 = common.PinInfo {
        .id = "A10",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    const A11 = common.PinInfo {
        .id = "A11",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in5),
    };
    const A12 = common.PinInfo {
        .id = "A12",
        .func = .{ .no_connect = {} },
    };
    const B1 = common.PinInfo {
        .id = "B1",
        .func = .{ .no_connect = {} },
    };
    const B2 = common.PinInfo {
        .id = "B2",
        .func = .{ .no_connect = {} },
    };
    const B3 = common.PinInfo {
        .id = "B3",
        .func = .{ .no_connect = {} },
    };
    const B4 = common.PinInfo {
        .id = "B4",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A5),
    };
    const B5 = common.PinInfo {
        .id = "B5",
        .func = .{ .no_connect = {} },
    };
    const B6 = common.PinInfo {
        .id = "B6",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    const B7 = common.PinInfo {
        .id = "B7",
        .func = .{ .io_oe1 = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    const B8 = common.PinInfo {
        .id = "B8",
        .func = .{ .no_connect = {} },
    };
    const B9 = common.PinInfo {
        .id = "B9",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
    };
    const B10 = common.PinInfo {
        .id = "B10",
        .func = .{ .no_connect = {} },
    };
    const B11 = common.PinInfo {
        .id = "B11",
        .func = .{ .tdo = {} },
    };
    const B12 = common.PinInfo {
        .id = "B12",
        .func = .{ .no_connect = {} },
    };
    const C1 = common.PinInfo {
        .id = "C1",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    const C2 = common.PinInfo {
        .id = "C2",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A9),
    };
    const C3 = common.PinInfo {
        .id = "C3",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    const C4 = common.PinInfo {
        .id = "C4",
        .func = .{ .no_connect = {} },
    };
    const C5 = common.PinInfo {
        .id = "C5",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    const C6 = common.PinInfo {
        .id = "C6",
        .func = .{ .io = 3 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A3),
    };
    const C7 = common.PinInfo {
        .id = "C7",
        .func = .{ .clock = 3 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    const C8 = common.PinInfo {
        .id = "C8",
        .func = .{ .io = 3 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D3),
    };
    const C9 = common.PinInfo {
        .id = "C9",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D5),
    };
    const C10 = common.PinInfo {
        .id = "C10",
        .func = .{ .no_connect = {} },
    };
    const C11 = common.PinInfo {
        .id = "C11",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in4),
    };
    const C12 = common.PinInfo {
        .id = "C12",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    const D1 = common.PinInfo {
        .id = "D1",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    const D2 = common.PinInfo {
        .id = "D2",
        .func = .{ .no_connect = {} },
    };
    const D3 = common.PinInfo {
        .id = "D3",
        .func = .{ .no_connect = {} },
    };
    const D4 = common.PinInfo {
        .id = "D4",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A14),
    };
    const D05 = common.PinInfo {
        .id = "D05",
        .func = .{ .vcco = {} },
    };
    const D6 = common.PinInfo {
        .id = "D6",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    const D7 = common.PinInfo {
        .id = "D7",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D1),
    };
    const D08 = common.PinInfo {
        .id = "D08",
        .func = .{ .vcco = {} },
    };
    const D9 = common.PinInfo {
        .id = "D9",
        .func = .{ .io = 7 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D7),
    };
    const D10 = common.PinInfo {
        .id = "D10",
        .func = .{ .no_connect = {} },
    };
    const D11 = common.PinInfo {
        .id = "D11",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    const D12 = common.PinInfo {
        .id = "D12",
        .func = .{ .no_connect = {} },
    };
    const E1 = common.PinInfo {
        .id = "E1",
        .func = .{ .no_connect = {} },
    };
    const E2 = common.PinInfo {
        .id = "E2",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A12),
    };
    const E3 = common.PinInfo {
        .id = "E3",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B14),
    };
    const E4 = common.PinInfo {
        .id = "E4",
        .func = .{ .no_connect = {} },
    };
    const E05 = common.PinInfo {
        .id = "E05",
        .func = .{ .vcc_core = {} },
    };
    const E6 = common.PinInfo {
        .id = "E6",
        .func = .{ .no_connect = {} },
    };
    const E07 = common.PinInfo {
        .id = "E07",
        .func = .{ .gnd = {} },
    };
    const E08 = common.PinInfo {
        .id = "E08",
        .func = .{ .vcc_core = {} },
    };
    const E9 = common.PinInfo {
        .id = "E9",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D9),
    };
    const E10 = common.PinInfo {
        .id = "E10",
        .func = .{ .io = 11 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D11),
    };
    const E11 = common.PinInfo {
        .id = "E11",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D13),
    };
    const E12 = common.PinInfo {
        .id = "E12",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    const F1 = common.PinInfo {
        .id = "F1",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    const F2 = common.PinInfo {
        .id = "F2",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A13),
    };
    const F3 = common.PinInfo {
        .id = "F3",
        .func = .{ .input = {} },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.in0),
    };
    const F04 = common.PinInfo {
        .id = "F04",
        .func = .{ .vcco = {} },
    };
    const F05 = common.PinInfo {
        .id = "F05",
        .func = .{ .gnd = {} },
    };
    const F06 = common.PinInfo {
        .id = "F06",
        .func = .{ .gnd = {} },
    };
    const F07 = common.PinInfo {
        .id = "F07",
        .func = .{ .gnd = {} },
    };
    const F08 = common.PinInfo {
        .id = "F08",
        .func = .{ .gnd = {} },
    };
    const F9 = common.PinInfo {
        .id = "F9",
        .func = .{ .no_connect = {} },
    };
    const F10 = common.PinInfo {
        .id = "F10",
        .func = .{ .no_connect = {} },
    };
    const F11 = common.PinInfo {
        .id = "F11",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D14),
    };
    const F12 = common.PinInfo {
        .id = "F12",
        .func = .{ .io = 15 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D15),
    };
    const G1 = common.PinInfo {
        .id = "G1",
        .func = .{ .io = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    const G2 = common.PinInfo {
        .id = "G2",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B13),
    };
    const G3 = common.PinInfo {
        .id = "G3",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    const G4 = common.PinInfo {
        .id = "G4",
        .func = .{ .no_connect = {} },
    };
    const G05 = common.PinInfo {
        .id = "G05",
        .func = .{ .gnd = {} },
    };
    const G06 = common.PinInfo {
        .id = "G06",
        .func = .{ .gnd = {} },
    };
    const G07 = common.PinInfo {
        .id = "G07",
        .func = .{ .gnd = {} },
    };
    const G08 = common.PinInfo {
        .id = "G08",
        .func = .{ .gnd = {} },
    };
    const G09 = common.PinInfo {
        .id = "G09",
        .func = .{ .vcco = {} },
    };
    const G10 = common.PinInfo {
        .id = "G10",
        .func = .{ .input = {} },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.in3),
    };
    const G11 = common.PinInfo {
        .id = "G11",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C13),
    };
    const G12 = common.PinInfo {
        .id = "G12",
        .func = .{ .io = 15 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C15),
    };
    const H1 = common.PinInfo {
        .id = "H1",
        .func = .{ .no_connect = {} },
    };
    const H2 = common.PinInfo {
        .id = "H2",
        .func = .{ .no_connect = {} },
    };
    const H3 = common.PinInfo {
        .id = "H3",
        .func = .{ .no_connect = {} },
    };
    const H04 = common.PinInfo {
        .id = "H04",
        .func = .{ .gnd = {} },
    };
    const H05 = common.PinInfo {
        .id = "H05",
        .func = .{ .vcc_core = {} },
    };
    const H06 = common.PinInfo {
        .id = "H06",
        .func = .{ .gnd = {} },
    };
    const H7 = common.PinInfo {
        .id = "H7",
        .func = .{ .no_connect = {} },
    };
    const H08 = common.PinInfo {
        .id = "H08",
        .func = .{ .vcc_core = {} },
    };
    const H9 = common.PinInfo {
        .id = "H9",
        .func = .{ .no_connect = {} },
    };
    const H10 = common.PinInfo {
        .id = "H10",
        .func = .{ .no_connect = {} },
    };
    const H11 = common.PinInfo {
        .id = "H11",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C14),
    };
    const H12 = common.PinInfo {
        .id = "H12",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    const J1 = common.PinInfo {
        .id = "J1",
        .func = .{ .io = 11 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B11),
    };
    const J2 = common.PinInfo {
        .id = "J2",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B9),
    };
    const J3 = common.PinInfo {
        .id = "J3",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    const J4 = common.PinInfo {
        .id = "J4",
        .func = .{ .io = 7 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B7),
    };
    const J05 = common.PinInfo {
        .id = "J05",
        .func = .{ .vcco = {} },
    };
    const J6 = common.PinInfo {
        .id = "J6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    const J7 = common.PinInfo {
        .id = "J7",
        .func = .{ .io = 3 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C3),
    };
    const J08 = common.PinInfo {
        .id = "J08",
        .func = .{ .vcco = {} },
    };
    const J09 = common.PinInfo {
        .id = "J09",
        .func = .{ .gnd = {} },
    };
    const J10 = common.PinInfo {
        .id = "J10",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    const J11 = common.PinInfo {
        .id = "J11",
        .func = .{ .no_connect = {} },
    };
    const J12 = common.PinInfo {
        .id = "J12",
        .func = .{ .no_connect = {} },
    };
    const K1 = common.PinInfo {
        .id = "K1",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    const K2 = common.PinInfo {
        .id = "K2",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in1),
    };
    const K3 = common.PinInfo {
        .id = "K3",
        .func = .{ .no_connect = {} },
    };
    const K4 = common.PinInfo {
        .id = "K4",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    const K5 = common.PinInfo {
        .id = "K5",
        .func = .{ .io = 3 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B3),
    };
    const K6 = common.PinInfo {
        .id = "K6",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    const K7 = common.PinInfo {
        .id = "K7",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    const K8 = common.PinInfo {
        .id = "K8",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
    };
    const K9 = common.PinInfo {
        .id = "K9",
        .func = .{ .no_connect = {} },
    };
    const K10 = common.PinInfo {
        .id = "K10",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    const K11 = common.PinInfo {
        .id = "K11",
        .func = .{ .io = 11 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C11),
    };
    const K12 = common.PinInfo {
        .id = "K12",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C9),
    };
    const L1 = common.PinInfo {
        .id = "L1",
        .func = .{ .no_connect = {} },
    };
    const L02 = common.PinInfo {
        .id = "L02",
        .func = .{ .tck = {} },
    };
    const L3 = common.PinInfo {
        .id = "L3",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in2),
    };
    const L4 = common.PinInfo {
        .id = "L4",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    const L5 = common.PinInfo {
        .id = "L5",
        .func = .{ .no_connect = {} },
    };
    const L6 = common.PinInfo {
        .id = "L6",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    const L7 = common.PinInfo {
        .id = "L7",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    const L8 = common.PinInfo {
        .id = "L8",
        .func = .{ .no_connect = {} },
    };
    const L9 = common.PinInfo {
        .id = "L9",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C5),
    };
    const L10 = common.PinInfo {
        .id = "L10",
        .func = .{ .no_connect = {} },
    };
    const L11 = common.PinInfo {
        .id = "L11",
        .func = .{ .no_connect = {} },
    };
    const L12 = common.PinInfo {
        .id = "L12",
        .func = .{ .no_connect = {} },
    };
    const M1 = common.PinInfo {
        .id = "M1",
        .func = .{ .no_connect = {} },
    };
    const M2 = common.PinInfo {
        .id = "M2",
        .func = .{ .no_connect = {} },
    };
    const M3 = common.PinInfo {
        .id = "M3",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B5),
    };
    const M4 = common.PinInfo {
        .id = "M4",
        .func = .{ .no_connect = {} },
    };
    const M5 = common.PinInfo {
        .id = "M5",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B1),
    };
    const M6 = common.PinInfo {
        .id = "M6",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    const M7 = common.PinInfo {
        .id = "M7",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C1),
    };
    const M8 = common.PinInfo {
        .id = "M8",
        .func = .{ .no_connect = {} },
    };
    const M9 = common.PinInfo {
        .id = "M9",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    const M10 = common.PinInfo {
        .id = "M10",
        .func = .{ .io = 7 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C7),
    };
    const M11 = common.PinInfo {
        .id = "M11",
        .func = .{ .no_connect = {} },
    };
    const M12 = common.PinInfo {
        .id = "M12",
        .func = .{ .tms = {} },
    };
};

pub const clock_pins = [_]common.PinInfo {
    pins.A7,
    pins.L6,
    pins.M6,
    pins.C7,
};

pub const oe_pins = [_]common.PinInfo {
    pins.D6,
    pins.B7,
};

pub const input_pins = [_]common.PinInfo {
    pins.F3,
    pins.K2,
    pins.L3,
    pins.G10,
    pins.C11,
    pins.A11,
};

pub const all_pins = [_]common.PinInfo {
    pins.A01,
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
    pins.D05,
    pins.D6,
    pins.D7,
    pins.D08,
    pins.D9,
    pins.D10,
    pins.D11,
    pins.D12,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E4,
    pins.E05,
    pins.E6,
    pins.E07,
    pins.E08,
    pins.E9,
    pins.E10,
    pins.E11,
    pins.E12,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F04,
    pins.F05,
    pins.F06,
    pins.F07,
    pins.F08,
    pins.F9,
    pins.F10,
    pins.F11,
    pins.F12,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G4,
    pins.G05,
    pins.G06,
    pins.G07,
    pins.G08,
    pins.G09,
    pins.G10,
    pins.G11,
    pins.G12,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H04,
    pins.H05,
    pins.H06,
    pins.H7,
    pins.H08,
    pins.H9,
    pins.H10,
    pins.H11,
    pins.H12,
    pins.J1,
    pins.J2,
    pins.J3,
    pins.J4,
    pins.J05,
    pins.J6,
    pins.J7,
    pins.J08,
    pins.J09,
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
    pins.L02,
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
