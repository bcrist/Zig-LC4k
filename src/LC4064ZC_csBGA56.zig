//[[!! include('devices', 'LC4064ZC_csBGA56') !! 527 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.LC4064ZC_csBGA56;

pub const family = common.DeviceFamily.zero_power;
pub const package = common.DevicePackage.csBGA56;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 12;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(356, 100);

const grp_device = @import("LC4064x_TQFP100.zig");

pub const GRP = grp_device.GRP;
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

pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 355)
    ).expandToContain(
        jedec.Fuse.init(86, 355)
    );
}
pub fn getExtraFloatInputFuses() []jedec.Fuse {
    return &.{
        jedec.Fuse.init(92, 11),
        jedec.Fuse.init(92, 21),
        jedec.Fuse.init(92, 31),
        jedec.Fuse.init(92, 41),
        jedec.Fuse.init(92, 51),
        jedec.Fuse.init(92, 61),
        jedec.Fuse.init(92, 71),
        jedec.Fuse.init(92, 80),
        jedec.Fuse.init(92, 110),
        jedec.Fuse.init(92, 120),
        jedec.Fuse.init(92, 130),
        jedec.Fuse.init(92, 140),
        jedec.Fuse.init(92, 160),
        jedec.Fuse.init(92, 169),
        jedec.Fuse.init(92, 170),
        jedec.Fuse.init(92, 189),
        jedec.Fuse.init(92, 199),
        jedec.Fuse.init(92, 209),
        jedec.Fuse.init(92, 219),
        jedec.Fuse.init(92, 229),
        jedec.Fuse.init(92, 239),
        jedec.Fuse.init(92, 249),
        jedec.Fuse.init(92, 258),
        jedec.Fuse.init(92, 288),
        jedec.Fuse.init(92, 298),
        jedec.Fuse.init(92, 308),
        jedec.Fuse.init(92, 318),
        jedec.Fuse.init(92, 337),
        jedec.Fuse.init(92, 338),
        jedec.Fuse.init(92, 347),
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

pub fn getMacrocellRef(comptime which: anytype) common.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) common.GlbIndex {
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

pub fn getPin(comptime which: anytype) common.PinInfo {
    return internal.getPin(@This(), which);
}

pub const pins = struct {
    pub const A1 = common.PinInfo {
        .id = "A1",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A6),
    };
    pub const A2 = common.PinInfo {
        .id = "A2",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A4),
    };
    pub const A3 = common.PinInfo {
        .id = "A3",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A2),
    };
    pub const A4 = common.PinInfo {
        .id = "A4",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A1),
    };
    pub const A5 = common.PinInfo {
        .id = "A5",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.clk0),
    };
    pub const A6 = common.PinInfo {
        .id = "A6",
        .func = .{ .io_oe1 = 0 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D0),
    };
    pub const A7 = common.PinInfo {
        .id = "A7",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D6),
    };
    pub const A8 = common.PinInfo {
        .id = "A8",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in5),
    };
    pub const A9 = common.PinInfo {
        .id = "A9",
        .func = .{ .vcc_core = {} },
    };
    pub const A10 = common.PinInfo {
        .id = "A10",
        .func = .{ .tdo = {} },
    };
    pub const B1 = common.PinInfo {
        .id = "B1",
        .func = .{ .tdi = {} },
    };
    pub const B10 = common.PinInfo {
        .id = "B10",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in4),
    };
    pub const C1 = common.PinInfo {
        .id = "C1",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A10),
    };
    pub const C3 = common.PinInfo {
        .id = "C3",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A8),
    };
    pub const C4 = common.PinInfo {
        .id = "C4",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A0),
    };
    pub const C5 = common.PinInfo {
        .id = "C5",
        .func = .{ .clock = 3 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.clk3),
    };
    pub const C6 = common.PinInfo {
        .id = "C6",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D2),
    };
    pub const C7 = common.PinInfo {
        .id = "C7",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D4),
    };
    pub const C8 = common.PinInfo {
        .id = "C8",
        .func = .{ .gnd = {} },
    };
    pub const C10 = common.PinInfo {
        .id = "C10",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D8),
    };
    pub const D1 = common.PinInfo {
        .id = "D1",
        .func = .{ .io = 11 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A11),
    };
    pub const D3 = common.PinInfo {
        .id = "D3",
        .func = .{ .gnd = {} },
    };
    pub const D8 = common.PinInfo {
        .id = "D8",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D12),
    };
    pub const D10 = common.PinInfo {
        .id = "D10",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D10),
    };
    pub const E1 = common.PinInfo {
        .id = "E1",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in0),
    };
    pub const E3 = common.PinInfo {
        .id = "E3",
        .func = .{ .io = 15 },
        .glb = 0,
        .grp_ordinal = @enumToInt(GRP.io_A15),
    };
    pub const E8 = common.PinInfo {
        .id = "E8",
        .func = .{ .vcco = {} },
    };
    pub const E10 = common.PinInfo {
        .id = "E10",
        .func = .{ .io = 15 },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.io_D15),
    };
    pub const F1 = common.PinInfo {
        .id = "F1",
        .func = .{ .io = 15 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B15),
    };
    pub const F3 = common.PinInfo {
        .id = "F3",
        .func = .{ .vcco = {} },
    };
    pub const F8 = common.PinInfo {
        .id = "F8",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C12),
    };
    pub const F10 = common.PinInfo {
        .id = "F10",
        .func = .{ .input = {} },
        .glb = 3,
        .grp_ordinal = @enumToInt(GRP.in3),
    };
    pub const G1 = common.PinInfo {
        .id = "G1",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B10),
    };
    pub const G3 = common.PinInfo {
        .id = "G3",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B12),
    };
    pub const G8 = common.PinInfo {
        .id = "G8",
        .func = .{ .gnd = {} },
    };
    pub const G10 = common.PinInfo {
        .id = "G10",
        .func = .{ .io = 11 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C11),
    };
    pub const H1 = common.PinInfo {
        .id = "H1",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B8),
    };
    pub const H3 = common.PinInfo {
        .id = "H3",
        .func = .{ .gnd = {} },
    };
    pub const H4 = common.PinInfo {
        .id = "H4",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B4),
    };
    pub const H5 = common.PinInfo {
        .id = "H5",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B2),
    };
    pub const H6 = common.PinInfo {
        .id = "H6",
        .func = .{ .clock = 1 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.clk1),
    };
    pub const H7 = common.PinInfo {
        .id = "H7",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C0),
    };
    pub const H8 = common.PinInfo {
        .id = "H8",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C8),
    };
    pub const H10 = common.PinInfo {
        .id = "H10",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C10),
    };
    pub const J1 = common.PinInfo {
        .id = "J1",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in1),
    };
    pub const J10 = common.PinInfo {
        .id = "J10",
        .func = .{ .tms = {} },
    };
    pub const K1 = common.PinInfo {
        .id = "K1",
        .func = .{ .tck = {} },
    };
    pub const K2 = common.PinInfo {
        .id = "K2",
        .func = .{ .vcc_core = {} },
    };
    pub const K3 = common.PinInfo {
        .id = "K3",
        .func = .{ .input = {} },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.in2),
    };
    pub const K4 = common.PinInfo {
        .id = "K4",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B6),
    };
    pub const K5 = common.PinInfo {
        .id = "K5",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @enumToInt(GRP.io_B0),
    };
    pub const K6 = common.PinInfo {
        .id = "K6",
        .func = .{ .clock = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.clk2),
    };
    pub const K7 = common.PinInfo {
        .id = "K7",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C1),
    };
    pub const K8 = common.PinInfo {
        .id = "K8",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C2),
    };
    pub const K9 = common.PinInfo {
        .id = "K9",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C4),
    };
    pub const K10 = common.PinInfo {
        .id = "K10",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @enumToInt(GRP.io_C6),
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
    pins.E1,
    pins.J1,
    pins.K3,
    pins.F10,
    pins.B10,
    pins.A8,
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
