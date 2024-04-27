//[[!! include('devices', 'LC4032ZC_csBGA56') !! 414 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
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

pub const F = lc4k.Factor(GRP);
pub const PT = lc4k.Product_Term(GRP);
pub const Pin = lc4k.Pin(GRP);

pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
    io_A0,
    io_A1,
    io_A2,
    io_A3,
    io_A4,
    io_A5,
    io_A6,
    io_A7,
    io_A8,
    io_A9,
    io_A10,
    io_A11,
    io_A12,
    io_A13,
    io_A14,
    io_A15,
    io_B0,
    io_B1,
    io_B2,
    io_B3,
    io_B4,
    io_B5,
    io_B6,
    io_B7,
    io_B8,
    io_B9,
    io_B10,
    io_B11,
    io_B12,
    io_B13,
    io_B14,
    io_B15,
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

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_B15) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_B15) => .mc,
        };
    }

    pub inline fn maybe_mc(self: GRP) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_A15) => .{ .glb = 0, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_A0) },
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_A15) => .{ .glb = 0, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_A0) },
            @intFromEnum(GRP.io_B0)...@intFromEnum(GRP.io_B15) => .{ .glb = 1, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_B0) },
            @intFromEnum(GRP.mc_B0)...@intFromEnum(GRP.mc_B15) => .{ .glb = 1, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_B0) },
            else => null,
        };
    }
    pub inline fn mc(self: GRP) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: GRP) ?Pin {
        return switch (self) {
            .clk0 => pins._43,
            .clk1 => pins._18,
            .clk2 => pins._19,
            .clk3 => pins._42,
            .io_A0 => pins._44,
            .io_A1 => pins._45,
            .io_A2 => pins._46,
            .io_A3 => pins._47,
            .io_A4 => pins._48,
            .io_A5 => pins._2,
            .io_A6 => pins._3,
            .io_A7 => pins._4,
            .io_A8 => pins._7,
            .io_A9 => pins._8,
            .io_A10 => pins._9,
            .io_A11 => pins._10,
            .io_A12 => pins._14,
            .io_A13 => pins._15,
            .io_A14 => pins._16,
            .io_A15 => pins._17,
            .io_B0 => pins._20,
            .io_B1 => pins._21,
            .io_B2 => pins._22,
            .io_B3 => pins._23,
            .io_B4 => pins._24,
            .io_B5 => pins._26,
            .io_B6 => pins._27,
            .io_B7 => pins._28,
            .io_B8 => pins._31,
            .io_B9 => pins._32,
            .io_B10 => pins._33,
            .io_B11 => pins._34,
            .io_B12 => pins._38,
            .io_B13 => pins._39,
            .io_B14 => pins._40,
            .io_B15 => pins._41,
            else => null,
        };
    }
    pub inline fn pin(self: GRP) Pin {
        return self.maybe_pin() orelse unreachable;
    }

    pub inline fn when_high(self: GRP) F {
        return .{ .when_high = self };
    }

    pub inline fn when_low(self: GRP) F {
        return .{ .when_low = self };
    }

    pub inline fn mc_fb(mcref: lc4k.MC_Ref) GRP {
        return mc_feedback_signals[mcref.glb][mcref.mc];
    }

    pub inline fn maybe_mc_pad(mcref: lc4k.MC_Ref) ?GRP {
        return mc_io_signals[mcref.glb][mcref.mc];
    }

    pub inline fn mc_pad(mcref: lc4k.MC_Ref) GRP {
        return mc_io_signals[mcref.glb][mcref.mc].?;
    }
};

pub const mc_feedback_signals = [num_glbs][num_mcs_per_glb]GRP {
    .{ .mc_A0, .mc_A1, .mc_A2, .mc_A3, .mc_A4, .mc_A5, .mc_A6, .mc_A7, .mc_A8, .mc_A9, .mc_A10, .mc_A11, .mc_A12, .mc_A13, .mc_A14, .mc_A15, },
    .{ .mc_B0, .mc_B1, .mc_B2, .mc_B3, .mc_B4, .mc_B5, .mc_B6, .mc_B7, .mc_B8, .mc_B9, .mc_B10, .mc_B11, .mc_B12, .mc_B13, .mc_B14, .mc_B15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?GRP {
    .{ .io_A0, .io_A1, .io_A2, .io_A3, .io_A4, .io_A5, .io_A6, .io_A7, .io_A8, .io_A9, .io_A10, .io_A11, .io_A12, .io_A13, .io_A14, .io_A15, },
    .{ .io_B0, .io_B1, .io_B2, .io_B3, .io_B4, .io_B5, .io_B6, .io_B7, .io_B8, .io_B9, .io_B10, .io_B11, .io_B12, .io_B13, .io_B14, .io_B15, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .io_B0, .io_B6, .mc_B6, .io_A0, .mc_B15, .mc_A5, },
    .{ .io_A12, .mc_A15, .mc_A11, .io_B11, .io_A7, .mc_A3, },
    .{ .clk2, .mc_A13, .mc_A9, .io_A1, .mc_A2, .mc_B12, },
    .{ .io_A12, .io_B7, .mc_A12, .io_A0, .io_B8, .mc_B12, },
    .{ .io_B4, .mc_A15, .mc_B7, .io_A0, .io_B9, .mc_A7, },
    .{ .clk1, .mc_A14, .mc_B3, .io_B12, .io_A7, .mc_A4, },
    .{ .io_B2, .io_A9, .mc_B7, .io_B14, .io_A7, .mc_B10, },
    .{ .io_A11, .mc_B1, .mc_B4, .io_A1, .mc_B13, .mc_A6, },
    .{ .io_B0, .mc_B0, .mc_A8, .io_A1, .io_B10, .mc_A3, },
    .{ .io_A15, .io_A10, .mc_A9, .io_A3, .mc_B15, .mc_B11, },
    .{ .io_B3, .io_B5, .mc_B3, .clk0, .mc_A2, .mc_B11, },
    .{ .io_B1, .io_B7, .mc_A11, .io_A3, .io_A6, .mc_A5, },
    .{ .io_A14, .io_B6, .mc_B7, .io_A3, .io_B8, .mc_A3, },
    .{ .io_A12, .io_A10, .mc_A10, .io_B13, .io_A5, .mc_A5, },
    .{ .io_A11, .io_A9, .mc_A8, .clk0, .mc_A0, .mc_B9, },
    .{ .clk2, .mc_B0, .mc_B5, .io_B13, .mc_B14, .mc_B8, },
    .{ .clk1, .mc_B2, .mc_A10, .io_B11, .mc_B15, .mc_A7, },
    .{ .io_A13, .io_B6, .mc_A11, .io_B14, .mc_A1, .mc_B9, },
    .{ .io_A15, .mc_A13, .mc_B5, .io_B12, .io_A6, .mc_A6, },
    .{ .clk2, .io_A8, .mc_A8, .io_B15, .io_A5, .mc_A4, },
    .{ .clk1, .io_B7, .mc_B5, .io_A2, .mc_A0, .mc_B10, },
    .{ .io_B2, .io_A8, .mc_B3, .clk3, .mc_B14, .mc_B9, },
    .{ .io_A11, .mc_A13, .mc_A12, .io_B15, .io_B9, .mc_B8, },
    .{ .io_A14, .mc_B0, .mc_B6, .io_A4, .io_A5, .mc_B11, },
    .{ .io_B4, .mc_B2, .mc_B4, .io_B14, .io_A6, .mc_A4, },
    .{ .io_B1, .mc_B2, .mc_B6, .clk3, .mc_A1, .mc_A6, },
    .{ .io_A15, .io_B5, .mc_A12, .clk3, .mc_A0, .mc_A7, },
    .{ .io_B0, .mc_B1, .mc_A10, .io_B12, .io_B8, .mc_B11, },
    .{ .io_B3, .mc_A14, .mc_B7, .io_A2, .io_B10, .mc_B12, },
    .{ .io_B3, .io_A8, .mc_B4, .io_A4, .mc_A1, .mc_B10, },
    .{ .io_B2, .io_A10, .mc_B5, .io_A4, .io_B9, .mc_A4, },
    .{ .io_A13, .mc_B1, .mc_B6, .io_B13, .mc_A2, .mc_A7, },
    .{ .io_B4, .io_B5, .mc_A8, .io_B11, .mc_B14, .mc_B12, },
    .{ .io_B1, .mc_A14, .mc_A10, .io_B15, .mc_B13, .mc_B10, },
    .{ .io_A13, .io_A9, .mc_A9, .io_A2, .mc_B13, .mc_A3, },
    .{ .io_A14, .mc_A15, .mc_A9, .clk0, .io_B10, .mc_B8, },
};

pub const gi_options_by_grp = lc4k.invert_gi_mapping(GRP, gi_mux_size, &gi_options);

const base = @import("LC4032x_TQFP48.zig");
pub const getGlbRange = base.getGlbRange;
pub const getGiRange = base.getGiRange;
pub const getBClockRange = base.getBClockRange;

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

pub const pins = struct {
    pub const A1 = Pin.init_io("A1", .io_A4);
    pub const A2 = Pin.init_io("A2", .io_A3);
    pub const A3 = Pin.init_io("A3", .io_A2);
    pub const A4 = Pin.init_io("A4", .io_A1);
    pub const A5 = Pin.init_clk("A5", .clk0, 0, 0);
    pub const A6 = Pin.init_oe("A6", .io_B15, 1);
    pub const A7 = Pin.init_io("A7", .io_B12);
    pub const A8 = Pin.init_misc("A8", .no_connect);
    pub const A9 = Pin.init_misc("A9", .vcc_core);
    pub const A10 = Pin.init_misc("A10", .tdo);
    pub const B1 = Pin.init_misc("B1", .tdi);
    pub const B10 = Pin.init_misc("B10", .no_connect);
    pub const C1 = Pin.init_io("C1", .io_A6);
    pub const C3 = Pin.init_io("C3", .io_A5);
    pub const C4 = Pin.init_oe("C4", .io_A0, 0);
    pub const C5 = Pin.init_clk("C5", .clk3, 3, 1);
    pub const C6 = Pin.init_io("C6", .io_B14);
    pub const C7 = Pin.init_io("C7", .io_B13);
    pub const C8 = Pin.init_misc("C8", .gnd);
    pub const C10 = Pin.init_io("C10", .io_B11);
    pub const D1 = Pin.init_io("D1", .io_A7);
    pub const D3 = Pin.init_misc("D3", .gnd);
    pub const D8 = Pin.init_io("D8", .io_B9);
    pub const D10 = Pin.init_io("D10", .io_B10);
    pub const E1 = Pin.init_misc("E1", .no_connect);
    pub const E3 = Pin.init_misc("E3", .no_connect);
    pub const E8 = Pin.init_misc("E8", .vcco);
    pub const E10 = Pin.init_io("E10", .io_B8);
    pub const F1 = Pin.init_io("F1", .io_A8);
    pub const F3 = Pin.init_misc("F3", .vcco);
    pub const F8 = Pin.init_misc("F8", .no_connect);
    pub const F10 = Pin.init_misc("F10", .no_connect);
    pub const G1 = Pin.init_io("G1", .io_A10);
    pub const G3 = Pin.init_io("G3", .io_A9);
    pub const G8 = Pin.init_misc("G8", .gnd);
    pub const G10 = Pin.init_io("G10", .io_B7);
    pub const H1 = Pin.init_io("H1", .io_A11);
    pub const H3 = Pin.init_misc("H3", .gnd);
    pub const H4 = Pin.init_io("H4", .io_A13);
    pub const H5 = Pin.init_io("H5", .io_A14);
    pub const H6 = Pin.init_clk("H6", .clk1, 1, 0);
    pub const H7 = Pin.init_io("H7", .io_B0);
    pub const H8 = Pin.init_io("H8", .io_B5);
    pub const H10 = Pin.init_io("H10", .io_B6);
    pub const J1 = Pin.init_misc("J1", .no_connect);
    pub const J10 = Pin.init_misc("J10", .tms);
    pub const K1 = Pin.init_misc("K1", .tck);
    pub const K2 = Pin.init_misc("K2", .vcc_core);
    pub const K3 = Pin.init_misc("K3", .no_connect);
    pub const K4 = Pin.init_io("K4", .io_A12);
    pub const K5 = Pin.init_io("K5", .io_A15);
    pub const K6 = Pin.init_clk("K6", .clk2, 2, 1);
    pub const K7 = Pin.init_io("K7", .io_B1);
    pub const K8 = Pin.init_io("K8", .io_B2);
    pub const K9 = Pin.init_io("K9", .io_B3);
    pub const K10 = Pin.init_io("K10", .io_B4);
};

pub const clock_pins = [_]Pin {
    pins.A5,
    pins.H6,
    pins.K6,
    pins.C5,
};

pub const oe_pins = [_]Pin {
    pins.C4,
    pins.A6,
};

pub const input_pins = [_]Pin {
};

pub const all_pins = [_]Pin {
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
