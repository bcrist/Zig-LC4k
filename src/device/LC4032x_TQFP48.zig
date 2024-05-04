//[[!! include('devices', 'LC4032x_TQFP48') !! 438 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4032x_TQFP48;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP48;

pub const num_glbs = 2;
pub const num_mcs = 32;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 6;
pub const oe_bus_size = 2;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(172, 100);

pub const F = lc4k.Factor(Signal);
pub const PT = lc4k.Product_Term(Signal);
pub const Pin = lc4k.Pin(Signal);
pub const Names = naming.Names(@This());

var name_buf: [8192]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator());
    return &default_names.?;
}


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
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
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
        return mc_pad(mcref);
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

pub const gi_options_by_grp = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

pub fn get_glb_range(glb: usize) Fuse_Range {
    std.debug.assert(glb < num_glbs);
    const index = num_glbs - glb - 1;
    return jedec_dimensions.sub_columns(86 * index + 3, 83);

}

pub fn get_gi_range(glb: usize, gi: usize) Fuse_Range {
    std.debug.assert(gi < num_gis_per_glb);
    return get_glb_range(glb).expand_columns(-3).sub_columns(0, 3).sub_rows(gi * 2, 2);
}

pub fn get_bclock_range(glb: usize) Fuse_Range {
    return get_glb_range(glb).sub_rows(79, 4).sub_columns(0, 1);
}

pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 171),
        1 => Fuse.init(89, 171),
        2 => Fuse.init(90, 171),
        3 => Fuse.init(91, 171),
        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) Fuse {
    return switch (goe) {
        else => unreachable,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 171);
}


pub fn get_global_bus_maintenance_range() Fuse_Range {
    return Fuse.init(85, 171).range().expand_to_contain(Fuse.init(86, 171));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{
    };
}

pub fn get_input_threshold_fuse(input: Signal) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(95, 168),
        .clk1 => Fuse.init(95, 169),
        .clk2 => Fuse.init(95, 170),
        .clk3 => Fuse.init(95, 171),
        else => unreachable,
    };
}

pub const pins = struct {
    pub const _1 = Pin.init_misc("1", .tdi);
    pub const _2 = Pin.init_io("2", .io_A5);
    pub const _3 = Pin.init_io("3", .io_A6);
    pub const _4 = Pin.init_io("4", .io_A7);
    pub const _5 = Pin.init_misc("5", .gnd);
    pub const _6 = Pin.init_misc("6", .vcco);
    pub const _7 = Pin.init_io("7", .io_A8);
    pub const _8 = Pin.init_io("8", .io_A9);
    pub const _9 = Pin.init_io("9", .io_A10);
    pub const _10 = Pin.init_io("10", .io_A11);
    pub const _11 = Pin.init_misc("11", .tck);
    pub const _12 = Pin.init_misc("12", .vcc_core);
    pub const _13 = Pin.init_misc("13", .gnd);
    pub const _14 = Pin.init_io("14", .io_A12);
    pub const _15 = Pin.init_io("15", .io_A13);
    pub const _16 = Pin.init_io("16", .io_A14);
    pub const _17 = Pin.init_io("17", .io_A15);
    pub const _18 = Pin.init_clk("18", .clk1, 1, 0);
    pub const _19 = Pin.init_clk("19", .clk2, 2, 1);
    pub const _20 = Pin.init_io("20", .io_B0);
    pub const _21 = Pin.init_io("21", .io_B1);
    pub const _22 = Pin.init_io("22", .io_B2);
    pub const _23 = Pin.init_io("23", .io_B3);
    pub const _24 = Pin.init_io("24", .io_B4);
    pub const _25 = Pin.init_misc("25", .tms);
    pub const _26 = Pin.init_io("26", .io_B5);
    pub const _27 = Pin.init_io("27", .io_B6);
    pub const _28 = Pin.init_io("28", .io_B7);
    pub const _29 = Pin.init_misc("29", .gnd);
    pub const _30 = Pin.init_misc("30", .vcco);
    pub const _31 = Pin.init_io("31", .io_B8);
    pub const _32 = Pin.init_io("32", .io_B9);
    pub const _33 = Pin.init_io("33", .io_B10);
    pub const _34 = Pin.init_io("34", .io_B11);
    pub const _35 = Pin.init_misc("35", .tdo);
    pub const _36 = Pin.init_misc("36", .vcc_core);
    pub const _37 = Pin.init_misc("37", .gnd);
    pub const _38 = Pin.init_io("38", .io_B12);
    pub const _39 = Pin.init_io("39", .io_B13);
    pub const _40 = Pin.init_io("40", .io_B14);
    pub const _41 = Pin.init_oe("41", .io_B15, 1);
    pub const _42 = Pin.init_clk("42", .clk3, 3, 1);
    pub const _43 = Pin.init_clk("43", .clk0, 0, 0);
    pub const _44 = Pin.init_oe("44", .io_A0, 0);
    pub const _45 = Pin.init_io("45", .io_A1);
    pub const _46 = Pin.init_io("46", .io_A2);
    pub const _47 = Pin.init_io("47", .io_A3);
    pub const _48 = Pin.init_io("48", .io_A4);
};

pub const clock_pins = [_]Pin {
    pins._43,
    pins._18,
    pins._19,
    pins._42,
};

pub const oe_pins = [_]Pin {
    pins._44,
    pins._41,
};

pub const input_pins = [_]Pin {
};

pub const all_pins = [_]Pin {
    pins._1,
    pins._2,
    pins._3,
    pins._4,
    pins._5,
    pins._6,
    pins._7,
    pins._8,
    pins._9,
    pins._10,
    pins._11,
    pins._12,
    pins._13,
    pins._14,
    pins._15,
    pins._16,
    pins._17,
    pins._18,
    pins._19,
    pins._20,
    pins._21,
    pins._22,
    pins._23,
    pins._24,
    pins._25,
    pins._26,
    pins._27,
    pins._28,
    pins._29,
    pins._30,
    pins._31,
    pins._32,
    pins._33,
    pins._34,
    pins._35,
    pins._36,
    pins._37,
    pins._38,
    pins._39,
    pins._40,
    pins._41,
    pins._42,
    pins._43,
    pins._44,
    pins._45,
    pins._46,
    pins._47,
    pins._48,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
