//[[!! include('devices', 'LC4032ZE_csBGA64') !! 521 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4032ZE_csBGA64;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.csBGA64;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;
pub const oe_bus_size = 2;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(172, 100);

pub const Logic_Parser = @import("../logic_parser.zig").Logic_Parser(@This());
pub const F = lc4k.Factor(Signal);
pub const PT = lc4k.Product_Term(Signal);
pub const Pin = lc4k.Pin(Signal);
pub const Names = naming.Names(@This());

var name_buf: [16384]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator(), pins);
    return &default_names.?;
}

pub const osctimer = struct {
    pub const osc_out = Signal.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = Signal.mc_B15;
    pub const timer_reset = timer_out;
};

pub const Signal = enum (u16) {
    clk0 = 0,
    clk1 = 1,
    clk2 = 2,
    clk3 = 3,
    io_A0 = 4,
    io_A1 = 5,
    io_A2 = 6,
    io_A3 = 7,
    io_A4 = 8,
    io_A5 = 9,
    io_A6 = 10,
    io_A7 = 11,
    io_A8 = 12,
    io_A9 = 13,
    io_A10 = 14,
    io_A11 = 15,
    io_A12 = 16,
    io_A13 = 17,
    io_A14 = 18,
    io_A15 = 19,
    io_B0 = 20,
    io_B1 = 21,
    io_B2 = 22,
    io_B3 = 23,
    io_B4 = 24,
    io_B5 = 25,
    io_B6 = 26,
    io_B7 = 27,
    io_B8 = 28,
    io_B9 = 29,
    io_B10 = 30,
    io_B11 = 31,
    io_B12 = 32,
    io_B13 = 33,
    io_B14 = 34,
    io_B15 = 35,
    mc_A0 = 36,
    mc_A1 = 37,
    mc_A2 = 38,
    mc_A3 = 39,
    mc_A4 = 40,
    mc_A5 = 41,
    mc_A6 = 42,
    mc_A7 = 43,
    mc_A8 = 44,
    mc_A9 = 45,
    mc_A10 = 46,
    mc_A11 = 47,
    mc_A12 = 48,
    mc_A13 = 49,
    mc_A14 = 50,
    mc_A15 = 51,
    mc_B0 = 52,
    mc_B1 = 53,
    mc_B2 = 54,
    mc_B3 = 55,
    mc_B4 = 56,
    mc_B5 = 57,
    mc_B6 = 58,
    mc_B7 = 59,
    mc_B8 = 60,
    mc_B9 = 61,
    mc_B10 = 62,
    mc_B11 = 63,
    mc_B12 = 64,
    mc_B13 = 65,
    mc_B14 = 66,
    mc_B15 = 67,

    pub inline fn kind(self: Signal) lc4k.Signal_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.clk0)...@intFromEnum(Signal.clk3) => .clk,
            @intFromEnum(Signal.io_A0)...@intFromEnum(Signal.io_B15) => .io,
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_B15) => .mc,
            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: Signal) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.io_A0)...@intFromEnum(Signal.io_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_A0)) },
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_A0)) },
            @intFromEnum(Signal.io_B0)...@intFromEnum(Signal.io_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_B0)) },
            @intFromEnum(Signal.mc_B0)...@intFromEnum(Signal.mc_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_B0)) },
            else => null,
        };
    }
    pub inline fn mc(self: Signal) lc4k.MC_Ref {
        return self.maybe_mc() orelse lc4k.panic("Signal {t} is not associated with a macrocell", .{ self });
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
        return switch (self) {
            .clk0 => pins.C4,
            .clk1 => pins.G4,
            .clk2 => pins.H5,
            .clk3 => pins.A4,
            .io_A0 => pins.B4,
            .io_A1 => pins.B3,
            .io_A2 => pins.A3,
            .io_A3 => pins.A2,
            .io_A4 => pins.A1,
            .io_A5 => pins.B1,
            .io_A6 => pins.C2,
            .io_A7 => pins.C1,
            .io_A8 => pins.D1,
            .io_A9 => pins.E1,
            .io_A10 => pins.D3,
            .io_A11 => pins.F1,
            .io_A12 => pins.G2,
            .io_A13 => pins.H3,
            .io_A14 => pins.G3,
            .io_A15 => pins.H4,
            .io_B0 => pins.F5,
            .io_B1 => pins.G5,
            .io_B2 => pins.G6,
            .io_B3 => pins.H6,
            .io_B4 => pins.F6,
            .io_B5 => pins.G7,
            .io_B6 => pins.F7,
            .io_B7 => pins.G8,
            .io_B8 => pins.E8,
            .io_B9 => pins.E6,
            .io_B10 => pins.D7,
            .io_B11 => pins.C7,
            .io_B12 => pins.A8,
            .io_B13 => pins.A6,
            .io_B14 => pins.B6,
            .io_B15 => pins.B5,
            else => null,
        };
    }
    pub inline fn pin(self: Signal) Pin {
        return self.maybe_pin() orelse unreachable;
    }

    pub inline fn when_high(self: Signal) F {
        return .{ .when_high = self };
    }

    pub inline fn when_low(self: Signal) F {
        return .{ .when_low = self };
    }

    pub inline fn maybe_fb(self: Signal) ?Signal {
        const mcref = self.maybe_mc() orelse return null;
        return mc_fb(mcref);
    }

    pub inline fn fb(self: Signal) Signal {
        return mc_fb(self.mc());
    }

    pub inline fn maybe_pad(self: Signal) ?Signal {
        const mcref = self.maybe_mc() orelse return null;
        return maybe_mc_pad(mcref);
    }

    pub inline fn pad(self: Signal) Signal {
        return mc_pad(self.mc());
    }

    pub inline fn mc_fb(mcref: lc4k.MC_Ref) Signal {
        return mc_feedback_signals[mcref.glb][mcref.mc];
    }

    pub inline fn maybe_mc_pad(mcref: lc4k.MC_Ref) ?Signal {
        return mc_io_signals[mcref.glb][mcref.mc];
    }

    pub inline fn mc_pad(mcref: lc4k.MC_Ref) Signal {
        return mc_io_signals[mcref.glb][mcref.mc].?;
    }
};

pub const mc_feedback_signals = [num_glbs][num_mcs_per_glb]Signal {
    .{ .mc_A0, .mc_A1, .mc_A2, .mc_A3, .mc_A4, .mc_A5, .mc_A6, .mc_A7, .mc_A8, .mc_A9, .mc_A10, .mc_A11, .mc_A12, .mc_A13, .mc_A14, .mc_A15, },
    .{ .mc_B0, .mc_B1, .mc_B2, .mc_B3, .mc_B4, .mc_B5, .mc_B6, .mc_B7, .mc_B8, .mc_B9, .mc_B10, .mc_B11, .mc_B12, .mc_B13, .mc_B14, .mc_B15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?Signal {
    .{ .io_A0, .io_A1, .io_A2, .io_A3, .io_A4, .io_A5, .io_A6, .io_A7, .io_A8, .io_A9, .io_A10, .io_A11, .io_A12, .io_A13, .io_A14, .io_A15, },
    .{ .io_B0, .io_B1, .io_B2, .io_B3, .io_B4, .io_B5, .io_B6, .io_B7, .io_B8, .io_B9, .io_B10, .io_B11, .io_B12, .io_B13, .io_B14, .io_B15, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]Signal {
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

pub const gi_options_by_signal = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

const base = @import("LC4032x_TQFP48.zig");
pub const get_glb_range = base.get_glb_range;
pub const get_gi_range = base.get_gi_range;
pub const get_bclock_range = base.get_bclock_range;

pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 171),
        1 => Fuse.init(89, 171),
        2 => Fuse.init(90, 171),
        3 => Fuse.init(91, 171),
        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) ?Fuse {
    return switch (goe) {
        else => null,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 171);
}

pub fn get_osctimer_enable_range() Fuse_Range {
    return Fuse_Range.between(
        Fuse.init(91, 168),
        Fuse.init(92, 168),
    );
}

pub fn get_osc_out_fuse() Fuse {
    return Fuse.init(93, 170);
}

pub fn get_timer_out_fuse() Fuse {
    return Fuse.init(93, 169);
}

pub fn get_timer_div_range() Fuse_Range {
    return Fuse.init(92, 169)
        .range().expand_to_contain(Fuse.init(92, 170));
}

pub fn get_input_power_guard_fuse(input: Signal) ?Fuse {
    return switch (input) {
        .clk0 => Fuse.init(87, 168),
        .clk1 => Fuse.init(88, 168),
        .clk2 => Fuse.init(89, 168),
        .clk3 => Fuse.init(90, 168),
        else => null,
    };
}

pub fn get_input_bus_maintenance_range(input: Signal) ?Fuse_Range {
    return switch (input) {
        .clk0 => Fuse_Range.between(Fuse.init(85, 171), Fuse.init(86, 171)),
        .clk1 => Fuse_Range.between(Fuse.init(85, 170), Fuse.init(86, 170)),
        .clk2 => Fuse_Range.between(Fuse.init(85, 169), Fuse.init(86, 169)),
        .clk3 => Fuse_Range.between(Fuse.init(85, 168), Fuse.init(86, 168)),
        else => null,
    };
}

pub fn get_input_threshold_fuse(input: Signal) ?Fuse {
    return switch (input) {
        .clk0 => Fuse.init(95, 168),
        .clk1 => Fuse.init(95, 169),
        .clk2 => Fuse.init(95, 170),
        .clk3 => Fuse.init(95, 171),
        else => null,
    };
}

pub const pins = struct {
    pub const A1 = Pin.init_io(0, "A1", 0, .io_A4);
    pub const A2 = Pin.init_io(1, "A2", 0, .io_A3);
    pub const A3 = Pin.init_io(2, "A3", 0, .io_A2);
    pub const A4 = Pin.init_clk(3, "A4", 1, .clk3, 3, 1);
    pub const A5 = Pin.init_misc(4, "A5", null, .no_connect);
    pub const A6 = Pin.init_io(5, "A6", 1, .io_B13);
    pub const A7 = Pin.init_misc(6, "A7", null, .no_connect);
    pub const A8 = Pin.init_io(7, "A8", 1, .io_B12);
    pub const B1 = Pin.init_io(8, "B1", 0, .io_A5);
    pub const B2 = Pin.init_misc(9, "B2", null, .tdi);
    pub const B3 = Pin.init_io(10, "B3", 0, .io_A1);
    pub const B4 = Pin.init_oe(11, "B4", 0, .io_A0, 0);
    pub const B5 = Pin.init_oe(12, "B5", 1, .io_B15, 1);
    pub const B6 = Pin.init_io(13, "B6", 1, .io_B14);
    pub const B7 = Pin.init_misc(14, "B7", null, .no_connect);
    pub const B8 = Pin.init_misc(15, "B8", null, .tdo);
    pub const C1 = Pin.init_io(16, "C1", 0, .io_A7);
    pub const C2 = Pin.init_io(17, "C2", 0, .io_A6);
    pub const C3 = Pin.init_misc(18, "C3", null, .no_connect);
    pub const C4 = Pin.init_clk(19, "C4", 0, .clk0, 0, 0);
    pub const C5 = Pin.init_misc(20, "C5", null, .no_connect);
    pub const C6 = Pin.init_misc(21, "C6", null, .no_connect);
    pub const C7 = Pin.init_io(22, "C7", 1, .io_B11);
    pub const C8 = Pin.init_misc(23, "C8", null, .no_connect);
    pub const D1 = Pin.init_io(24, "D1", 0, .io_A8);
    pub const D2 = Pin.init_misc(25, "D2", null, .no_connect);
    pub const D3 = Pin.init_io(26, "D3", 0, .io_A10);
    pub const D4 = Pin.init_misc(27, "D4", null, .gnd);
    pub const D5 = Pin.init_misc(28, "D5", null, .vcc_core);
    pub const D6 = Pin.init_misc(29, "D6", 1, .vcco);
    pub const D7 = Pin.init_io(30, "D7", 1, .io_B10);
    pub const D8 = Pin.init_misc(31, "D8", null, .no_connect);
    pub const E1 = Pin.init_io(32, "E1", 0, .io_A9);
    pub const E2 = Pin.init_misc(33, "E2", null, .no_connect);
    pub const E3 = Pin.init_misc(34, "E3", 0, .vcco);
    pub const E4 = Pin.init_misc(35, "E4", null, .vcc_core);
    pub const E5 = Pin.init_misc(36, "E5", null, .gnd);
    pub const E6 = Pin.init_io(37, "E6", 1, .io_B9);
    pub const E7 = Pin.init_misc(38, "E7", null, .no_connect);
    pub const E8 = Pin.init_io(39, "E8", 1, .io_B8);
    pub const F1 = Pin.init_io(40, "F1", 0, .io_A11);
    pub const F2 = Pin.init_misc(41, "F2", null, .no_connect);
    pub const F3 = Pin.init_misc(42, "F3", null, .no_connect);
    pub const F4 = Pin.init_misc(43, "F4", null, .no_connect);
    pub const F5 = Pin.init_io(44, "F5", 1, .io_B0);
    pub const F6 = Pin.init_io(45, "F6", 1, .io_B4);
    pub const F7 = Pin.init_io(46, "F7", 1, .io_B6);
    pub const F8 = Pin.init_misc(47, "F8", null, .no_connect);
    pub const G1 = Pin.init_misc(48, "G1", null, .no_connect);
    pub const G2 = Pin.init_io(49, "G2", 0, .io_A12);
    pub const G3 = Pin.init_io(50, "G3", 0, .io_A14);
    pub const G4 = Pin.init_clk(51, "G4", 0, .clk1, 1, 0);
    pub const G5 = Pin.init_io(52, "G5", 1, .io_B1);
    pub const G6 = Pin.init_io(53, "G6", 1, .io_B2);
    pub const G7 = Pin.init_io(54, "G7", 1, .io_B5);
    pub const G8 = Pin.init_io(55, "G8", 1, .io_B7);
    pub const H1 = Pin.init_misc(56, "H1", null, .tck);
    pub const H2 = Pin.init_misc(57, "H2", null, .no_connect);
    pub const H3 = Pin.init_io(58, "H3", 0, .io_A13);
    pub const H4 = Pin.init_io(59, "H4", 0, .io_A15);
    pub const H5 = Pin.init_clk(60, "H5", 1, .clk2, 2, 1);
    pub const H6 = Pin.init_io(61, "H6", 1, .io_B3);
    pub const H7 = Pin.init_misc(62, "H7", null, .no_connect);
    pub const H8 = Pin.init_misc(63, "H8", null, .tms);
};

pub const clock_pins = [_]Pin {
    pins.C4,
    pins.G4,
    pins.H5,
    pins.A4,
};

pub const oe_pins = [_]Pin {
    pins.B4,
    pins.B5,
};

pub const input_pins = [_]Pin {
};

pub const vcc_pins = [_]Pin {
    pins.D5,
    pins.E4,
};

pub const gnd_pins = [_]Pin {
    pins.D4,
    pins.E5,
};

pub const vcco_bank0_pins = [_]Pin {
    pins.E3,
};

pub const gnd_bank0_pins = [_]Pin {
};

pub const vcco_bank1_pins = [_]Pin {
    pins.D6,
};

pub const gnd_bank1_pins = [_]Pin {
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
