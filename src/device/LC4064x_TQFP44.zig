//[[!! include('devices', 'LC4064x_TQFP44') !! 437 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4064x_TQFP44;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP44;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 10;
pub const oe_bus_size = 4;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(352, 95);

pub const F = lc4k.Factor(GRP);
pub const PT = lc4k.Product_Term(GRP);
pub const Pin = lc4k.Pin(GRP);
pub const Names = naming.Names(@This());

var name_buf: [16384]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator());
    return &default_names.?;
}


pub const GRP = enum (u16) {
    clk0 = 0,
    clk1 = 1,
    clk2 = 2,
    clk3 = 3,
    io_A0 = 4,
    io_A2 = 5,
    io_A4 = 6,
    io_A6 = 7,
    io_A8 = 8,
    io_A10 = 9,
    io_A12 = 10,
    io_A14 = 11,
    io_B0 = 12,
    io_B2 = 13,
    io_B4 = 14,
    io_B6 = 15,
    io_B8 = 16,
    io_B10 = 17,
    io_B12 = 18,
    io_B14 = 19,
    io_C0 = 20,
    io_C2 = 21,
    io_C4 = 22,
    io_C6 = 23,
    io_C8 = 24,
    io_C10 = 25,
    io_C12 = 26,
    io_C14 = 27,
    io_D0 = 28,
    io_D2 = 29,
    io_D4 = 30,
    io_D6 = 31,
    io_D8 = 32,
    io_D10 = 33,
    io_D12 = 34,
    io_D14 = 35,
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
    mc_C0 = 68,
    mc_C1 = 69,
    mc_C2 = 70,
    mc_C3 = 71,
    mc_C4 = 72,
    mc_C5 = 73,
    mc_C6 = 74,
    mc_C7 = 75,
    mc_C8 = 76,
    mc_C9 = 77,
    mc_C10 = 78,
    mc_C11 = 79,
    mc_C12 = 80,
    mc_C13 = 81,
    mc_C14 = 82,
    mc_C15 = 83,
    mc_D0 = 84,
    mc_D1 = 85,
    mc_D2 = 86,
    mc_D3 = 87,
    mc_D4 = 88,
    mc_D5 = 89,
    mc_D6 = 90,
    mc_D7 = 91,
    mc_D8 = 92,
    mc_D9 = 93,
    mc_D10 = 94,
    mc_D11 = 95,
    mc_D12 = 96,
    mc_D13 = 97,
    mc_D14 = 98,
    mc_D15 = 99,

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_D14) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_D15) => .mc,
            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: GRP) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_A14) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_A0)) },
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_A0)) },
            @intFromEnum(GRP.io_B0)...@intFromEnum(GRP.io_B14) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_B0)) },
            @intFromEnum(GRP.mc_B0)...@intFromEnum(GRP.mc_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_B0)) },
            @intFromEnum(GRP.io_C0)...@intFromEnum(GRP.io_C14) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_C0)) },
            @intFromEnum(GRP.mc_C0)...@intFromEnum(GRP.mc_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_C0)) },
            @intFromEnum(GRP.io_D0)...@intFromEnum(GRP.io_D14) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_D0)) },
            @intFromEnum(GRP.mc_D0)...@intFromEnum(GRP.mc_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_D0)) },
            else => null,
        };
    }
    pub inline fn mc(self: GRP) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: GRP) ?Pin {
        return switch (self) {
            .clk0 => pins._39,
            .clk2 => pins._17,
            .io_A0 => pins._40,
            .io_A2 => pins._41,
            .io_A4 => pins._42,
            .io_A6 => pins._43,
            .io_A8 => pins._44,
            .io_A10 => pins._2,
            .io_A12 => pins._3,
            .io_A14 => pins._4,
            .io_B0 => pins._7,
            .io_B2 => pins._8,
            .io_B4 => pins._9,
            .io_B8 => pins._13,
            .io_B10 => pins._14,
            .io_B12 => pins._15,
            .io_B14 => pins._16,
            .io_C0 => pins._18,
            .io_C2 => pins._19,
            .io_C4 => pins._20,
            .io_C6 => pins._21,
            .io_C8 => pins._22,
            .io_C10 => pins._24,
            .io_C12 => pins._25,
            .io_C14 => pins._26,
            .io_D0 => pins._29,
            .io_D2 => pins._30,
            .io_D4 => pins._31,
            .io_D8 => pins._35,
            .io_D10 => pins._36,
            .io_D12 => pins._37,
            .io_D14 => pins._38,
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
    .{ .mc_C0, .mc_C1, .mc_C2, .mc_C3, .mc_C4, .mc_C5, .mc_C6, .mc_C7, .mc_C8, .mc_C9, .mc_C10, .mc_C11, .mc_C12, .mc_C13, .mc_C14, .mc_C15, },
    .{ .mc_D0, .mc_D1, .mc_D2, .mc_D3, .mc_D4, .mc_D5, .mc_D6, .mc_D7, .mc_D8, .mc_D9, .mc_D10, .mc_D11, .mc_D12, .mc_D13, .mc_D14, .mc_D15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?GRP {
    .{ .io_A0, null, .io_A2, null, .io_A4, null, .io_A6, null, .io_A8, null, .io_A10, null, .io_A12, null, .io_A14, null, },
    .{ .io_B0, null, .io_B2, null, .io_B4, null, .io_B6, null, .io_B8, null, .io_B10, null, .io_B12, null, .io_B14, null, },
    .{ .io_C0, null, .io_C2, null, .io_C4, null, .io_C6, null, .io_C8, null, .io_C10, null, .io_C12, null, .io_C14, null, },
    .{ .io_D0, null, .io_D2, null, .io_D4, null, .io_D6, null, .io_D8, null, .io_D10, null, .io_D12, null, .io_D14, null, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .mc_B9, .mc_A6, .mc_A11, .mc_B1, .mc_A1, .mc_C8, .mc_C10, .mc_D12, .mc_C2, .mc_C0, },
    .{ .io_A8, .io_A4, .mc_B4, .mc_B13, .mc_B0, .mc_C8, .io_D4, .io_C2, .mc_D1, .io_C14, },
    .{ .mc_B9, .mc_A9, .mc_B12, .mc_B2, .mc_B15, .io_C8, .mc_D6, .mc_C4, .mc_D1, .mc_C14, },
    .{ .mc_B6, .io_B4, .mc_A11, .mc_A13, .io_B14, .mc_C9, .io_D10, .mc_C11, .mc_D1, .mc_C15, },
    .{ .mc_B6, .mc_B10, .mc_A3, .mc_A2, .mc_B15, .mc_D7, .io_D4, .mc_C12, .mc_D14, .io_D0, },
    .{ .io_A8, .mc_B5, .mc_A12, .clk0, .io_A0, .io_C6, .mc_D9, .mc_C4, .mc_D14, .mc_C15, },
    .{ .io_B8, .mc_A6, .mc_B11, .mc_B13, .mc_A0, .mc_C7, .io_C4, .mc_D11, .clk3, .mc_C14, },
    .{ .mc_B7, .io_B10, .io_B12, .mc_A13, .mc_A14, .mc_D8, .mc_D5, .mc_C4, .io_D12, .mc_C0, },
    .{ .mc_A7, .io_A10, .mc_A3, .mc_B1, .io_B14, .io_C8, .mc_D9, .mc_D3, .io_D12, .mc_C1, },
    .{ .io_B6, .mc_A5, .mc_A11, .mc_A2, .mc_B0, .io_D8, .io_C10, .mc_C4, .mc_D13, .mc_C1, },
    .{ .mc_B9, .mc_A10, .mc_B3, .mc_A13, .io_A0, .mc_C7, .io_D4, .mc_D4, .mc_D13, .mc_D0, },
    .{ .io_A6, .mc_A5, .io_B12, .mc_B13, .io_A0, .io_C8, .mc_D10, .mc_D12, .mc_C13, .mc_D15, },
    .{ .mc_B6, .mc_A10, .mc_B12, .mc_B14, .mc_A14, .io_D6, .mc_D9, .mc_D11, .mc_C2, .mc_D15, },
    .{ .mc_B8, .io_A10, .mc_A4, .mc_B2, .mc_A0, .mc_C8, .mc_D10, .mc_C12, .clk2, .mc_C15, },
    .{ .mc_A7, .mc_A9, .mc_B3, .mc_B14, .mc_A0, .mc_D8, .io_D10, .mc_D12, .io_D2, .io_D0, },
    .{ .io_B6, .mc_A9, .mc_B4, .mc_A13, .io_A14, .mc_D7, .mc_C10, .mc_D3, .mc_D2, .mc_D15, },
    .{ .mc_B8, .mc_A5, .io_B2, .mc_B1, .mc_A14, .mc_C7, .io_D10, .io_C12, .mc_D2, .io_C0, },
    .{ .mc_B6, .mc_A5, .mc_B4, .clk1, .io_B0, .mc_C6, .io_C4, .mc_D4, .io_D2, .io_D14, },
    .{ .mc_A7, .io_A4, .io_B2, .mc_A2, .mc_A1, .mc_C6, .mc_D5, .mc_D11, .mc_C13, .mc_C15, },
    .{ .mc_B7, .mc_A6, .io_B2, .io_A2, .mc_B15, .io_D6, .io_C10, .mc_D3, .clk2, .mc_D0, },
    .{ .mc_A7, .mc_B5, .mc_B11, .clk1, .mc_A14, .mc_D7, .mc_D10, .mc_C3, .mc_D1, .mc_D0, },
    .{ .mc_B7, .mc_B5, .mc_B12, .io_A12, .io_B14, .mc_C8, .mc_C5, .mc_D4, .mc_D2, .io_D0, },
    .{ .mc_A8, .mc_A10, .mc_A4, .mc_B1, .io_B0, .mc_D8, .io_C10, .mc_C12, .mc_C13, .mc_C14, },
    .{ .io_A6, .mc_A6, .mc_B4, .clk0, .mc_A15, .mc_D8, .mc_D6, .mc_C11, .mc_D13, .io_C0, },
    .{ .io_B8, .mc_B10, .mc_A4, .io_A2, .mc_B0, .io_C6, .mc_D6, .mc_D12, .mc_D2, .io_D14, },
    .{ .mc_A8, .io_B10, .mc_A3, .io_A12, .mc_A1, .mc_C7, .mc_D6, .mc_C3, .io_D2, .mc_D15, },
    .{ .mc_B8, .mc_A9, .mc_A12, .clk1, .mc_B0, .io_D6, .mc_C5, .mc_C11, .clk3, .mc_C0, },
    .{ .io_A8, .mc_B10, .io_B12, .mc_B14, .mc_A1, .mc_C9, .mc_C5, .mc_D3, .mc_D13, .mc_C14, },
    .{ .io_A6, .mc_B5, .mc_B3, .mc_A2, .io_A14, .mc_C9, .io_C4, .io_C2, .clk2, .mc_C0, },
    .{ .mc_A8, .io_A10, .mc_B11, .mc_B14, .io_A14, .io_D8, .mc_D5, .mc_C11, .mc_D14, .io_C14, },
    .{ .mc_A8, .mc_B10, .mc_B12, .clk0, .mc_A0, .mc_C6, .mc_C10, .io_C2, .io_D12, .mc_D0, },
    .{ .io_B6, .io_B4, .mc_B3, .mc_B2, .io_B0, .io_C6, .mc_D5, .mc_C3, .mc_C2, .io_C0, },
    .{ .io_B8, .io_A4, .mc_A12, .io_A12, .mc_B15, .mc_C9, .mc_D10, .io_C12, .mc_C2, .mc_C1, },
    .{ .mc_B7, .mc_A10, .mc_A3, .mc_B2, .mc_A15, .io_D8, .mc_C10, .io_C12, .clk3, .io_D14, },
    .{ .mc_B8, .io_B10, .mc_A11, .io_A2, .mc_A15, .mc_D7, .mc_D9, .mc_D4, .mc_C13, .io_C14, },
    .{ .mc_B9, .io_B4, .mc_A4, .mc_B13, .mc_A15, .mc_C6, .mc_C5, .mc_C3, .mc_D14, .mc_C1, },
};

pub const gi_options_by_grp = lc4k.invert_gi_mapping(GRP, gi_mux_size, &gi_options);

const base = @import("LC4064x_TQFP48.zig");
pub const get_glb_range = base.get_glb_range;
pub const get_gi_range = base.get_gi_range;
pub const get_bclock_range = base.get_bclock_range;

pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(90, 351),
        1 => Fuse.init(91, 351),
        2 => Fuse.init(92, 351),
        3 => Fuse.init(93, 351),
        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 351),
        1 => Fuse.init(89, 351),
        else => unreachable,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 351);
}


pub fn get_global_bus_maintenance_range() Fuse_Range {
    return Fuse.init(85, 351).range().expand_to_contain(Fuse.init(86, 351));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{
        Fuse.init(89, 40),
        Fuse.init(89, 216),
    };
}

pub fn get_input_threshold_fuse(input: GRP) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(94, 348),
        .clk2 => Fuse.init(94, 350),
        else => unreachable,
    };
}

pub const pins = struct {
    pub const _1 = Pin.init_misc("1", .tdi);
    pub const _2 = Pin.init_io("2", .io_A10);
    pub const _3 = Pin.init_io("3", .io_A12);
    pub const _4 = Pin.init_io("4", .io_A14);
    pub const _5 = Pin.init_misc("5", .gnd);
    pub const _6 = Pin.init_misc("6", .vcco);
    pub const _7 = Pin.init_io("7", .io_B0);
    pub const _8 = Pin.init_io("8", .io_B2);
    pub const _9 = Pin.init_io("9", .io_B4);
    pub const _10 = Pin.init_misc("10", .tck);
    pub const _11 = Pin.init_misc("11", .vcc_core);
    pub const _12 = Pin.init_misc("12", .gnd);
    pub const _13 = Pin.init_io("13", .io_B8);
    pub const _14 = Pin.init_io("14", .io_B10);
    pub const _15 = Pin.init_io("15", .io_B12);
    pub const _16 = Pin.init_io("16", .io_B14);
    pub const _17 = Pin.init_clk("17", .clk2, 2, 2);
    pub const _18 = Pin.init_io("18", .io_C0);
    pub const _19 = Pin.init_io("19", .io_C2);
    pub const _20 = Pin.init_io("20", .io_C4);
    pub const _21 = Pin.init_io("21", .io_C6);
    pub const _22 = Pin.init_io("22", .io_C8);
    pub const _23 = Pin.init_misc("23", .tms);
    pub const _24 = Pin.init_io("24", .io_C10);
    pub const _25 = Pin.init_io("25", .io_C12);
    pub const _26 = Pin.init_io("26", .io_C14);
    pub const _27 = Pin.init_misc("27", .gnd);
    pub const _28 = Pin.init_misc("28", .vcco);
    pub const _29 = Pin.init_io("29", .io_D0);
    pub const _30 = Pin.init_io("30", .io_D2);
    pub const _31 = Pin.init_io("31", .io_D4);
    pub const _32 = Pin.init_misc("32", .tdo);
    pub const _33 = Pin.init_misc("33", .vcc_core);
    pub const _34 = Pin.init_misc("34", .gnd);
    pub const _35 = Pin.init_io("35", .io_D8);
    pub const _36 = Pin.init_io("36", .io_D10);
    pub const _37 = Pin.init_io("37", .io_D12);
    pub const _38 = Pin.init_oe("38", .io_D14, 1);
    pub const _39 = Pin.init_clk("39", .clk0, 0, 0);
    pub const _40 = Pin.init_oe("40", .io_A0, 0);
    pub const _41 = Pin.init_io("41", .io_A2);
    pub const _42 = Pin.init_io("42", .io_A4);
    pub const _43 = Pin.init_io("43", .io_A6);
    pub const _44 = Pin.init_io("44", .io_A8);
};

pub const clock_pins = [_]Pin {
    pins._39,
    pins._17,
};

pub const oe_pins = [_]Pin {
    pins._40,
    pins._38,
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
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
