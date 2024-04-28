//[[!! include('devices', 'LC4064ZE_TQFP48') !! 527 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4064ZE_TQFP48;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.TQFP48;

pub const num_glbs = 4;
pub const num_mcs = 64;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 12;
pub const oe_bus_size = 4;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(356, 100);

pub const F = lc4k.Factor(GRP);
pub const PT = lc4k.Product_Term(GRP);
pub const Pin = lc4k.Pin(GRP);
pub const Names = naming.Names(GRP);

var name_buf: [16384]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator(), @This());
    return &default_names.?;
}

pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_D15;
    pub const timer_reset = timer_out;
};

pub const GRP = enum (u16) {
    clk0 = 0,
    clk1 = 1,
    clk2 = 2,
    clk3 = 3,
    in0 = 4,
    in1 = 5,
    in2 = 6,
    in3 = 7,
    in4 = 8,
    in5 = 9,
    io_A0 = 10,
    io_A1 = 11,
    io_A2 = 12,
    io_A3 = 13,
    io_A4 = 14,
    io_A5 = 15,
    io_A6 = 16,
    io_A7 = 17,
    io_A8 = 18,
    io_A9 = 19,
    io_A10 = 20,
    io_A11 = 21,
    io_A12 = 22,
    io_A13 = 23,
    io_A14 = 24,
    io_A15 = 25,
    io_B0 = 26,
    io_B1 = 27,
    io_B2 = 28,
    io_B3 = 29,
    io_B4 = 30,
    io_B5 = 31,
    io_B6 = 32,
    io_B7 = 33,
    io_B8 = 34,
    io_B9 = 35,
    io_B10 = 36,
    io_B11 = 37,
    io_B12 = 38,
    io_B13 = 39,
    io_B14 = 40,
    io_B15 = 41,
    io_C0 = 42,
    io_C1 = 43,
    io_C2 = 44,
    io_C3 = 45,
    io_C4 = 46,
    io_C5 = 47,
    io_C6 = 48,
    io_C7 = 49,
    io_C8 = 50,
    io_C9 = 51,
    io_C10 = 52,
    io_C11 = 53,
    io_C12 = 54,
    io_C13 = 55,
    io_C14 = 56,
    io_C15 = 57,
    io_D0 = 58,
    io_D1 = 59,
    io_D2 = 60,
    io_D3 = 61,
    io_D4 = 62,
    io_D5 = 63,
    io_D6 = 64,
    io_D7 = 65,
    io_D8 = 66,
    io_D9 = 67,
    io_D10 = 68,
    io_D11 = 69,
    io_D12 = 70,
    io_D13 = 71,
    io_D14 = 72,
    io_D15 = 73,
    mc_A0 = 74,
    mc_A1 = 75,
    mc_A2 = 76,
    mc_A3 = 77,
    mc_A4 = 78,
    mc_A5 = 79,
    mc_A6 = 80,
    mc_A7 = 81,
    mc_A8 = 82,
    mc_A9 = 83,
    mc_A10 = 84,
    mc_A11 = 85,
    mc_A12 = 86,
    mc_A13 = 87,
    mc_A14 = 88,
    mc_A15 = 89,
    mc_B0 = 90,
    mc_B1 = 91,
    mc_B2 = 92,
    mc_B3 = 93,
    mc_B4 = 94,
    mc_B5 = 95,
    mc_B6 = 96,
    mc_B7 = 97,
    mc_B8 = 98,
    mc_B9 = 99,
    mc_B10 = 100,
    mc_B11 = 101,
    mc_B12 = 102,
    mc_B13 = 103,
    mc_B14 = 104,
    mc_B15 = 105,
    mc_C0 = 106,
    mc_C1 = 107,
    mc_C2 = 108,
    mc_C3 = 109,
    mc_C4 = 110,
    mc_C5 = 111,
    mc_C6 = 112,
    mc_C7 = 113,
    mc_C8 = 114,
    mc_C9 = 115,
    mc_C10 = 116,
    mc_C11 = 117,
    mc_C12 = 118,
    mc_C13 = 119,
    mc_C14 = 120,
    mc_C15 = 121,
    mc_D0 = 122,
    mc_D1 = 123,
    mc_D2 = 124,
    mc_D3 = 125,
    mc_D4 = 126,
    mc_D5 = 127,
    mc_D6 = 128,
    mc_D7 = 129,
    mc_D8 = 130,
    mc_D9 = 131,
    mc_D10 = 132,
    mc_D11 = 133,
    mc_D12 = 134,
    mc_D13 = 135,
    mc_D14 = 136,
    mc_D15 = 137,

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.in0)...@intFromEnum(GRP.in5) => .in,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_D15) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_D15) => .mc,
            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: GRP) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_A15) => .{ .glb = 0, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_A0) },
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_A15) => .{ .glb = 0, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_A0) },
            @intFromEnum(GRP.io_B0)...@intFromEnum(GRP.io_B15) => .{ .glb = 1, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_B0) },
            @intFromEnum(GRP.mc_B0)...@intFromEnum(GRP.mc_B15) => .{ .glb = 1, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_B0) },
            @intFromEnum(GRP.io_C0)...@intFromEnum(GRP.io_C15) => .{ .glb = 2, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_C0) },
            @intFromEnum(GRP.mc_C0)...@intFromEnum(GRP.mc_C15) => .{ .glb = 2, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_C0) },
            @intFromEnum(GRP.io_D0)...@intFromEnum(GRP.io_D15) => .{ .glb = 3, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_D0) },
            @intFromEnum(GRP.mc_D0)...@intFromEnum(GRP.mc_D15) => .{ .glb = 3, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_D0) },
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
            .io_A4 => pins._47,
            .io_A6 => pins._48,
            .io_A8 => pins._2,
            .io_A10 => pins._3,
            .io_A11 => pins._4,
            .io_B0 => pins._17,
            .io_B2 => pins._16,
            .io_B4 => pins._15,
            .io_B6 => pins._14,
            .io_B8 => pins._10,
            .io_B10 => pins._9,
            .io_B12 => pins._8,
            .io_B15 => pins._7,
            .io_C0 => pins._20,
            .io_C1 => pins._21,
            .io_C2 => pins._22,
            .io_C4 => pins._23,
            .io_C6 => pins._24,
            .io_C8 => pins._26,
            .io_C10 => pins._27,
            .io_C11 => pins._28,
            .io_D0 => pins._41,
            .io_D2 => pins._40,
            .io_D4 => pins._39,
            .io_D6 => pins._38,
            .io_D8 => pins._34,
            .io_D10 => pins._33,
            .io_D12 => pins._32,
            .io_D15 => pins._31,
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
    .{ .io_A0, .io_A1, .io_A2, .io_A3, .io_A4, .io_A5, .io_A6, .io_A7, .io_A8, .io_A9, .io_A10, .io_A11, .io_A12, .io_A13, .io_A14, .io_A15, },
    .{ .io_B0, .io_B1, .io_B2, .io_B3, .io_B4, .io_B5, .io_B6, .io_B7, .io_B8, .io_B9, .io_B10, .io_B11, .io_B12, .io_B13, .io_B14, .io_B15, },
    .{ .io_C0, .io_C1, .io_C2, .io_C3, .io_C4, .io_C5, .io_C6, .io_C7, .io_C8, .io_C9, .io_C10, .io_C11, .io_C12, .io_C13, .io_C14, .io_C15, },
    .{ .io_D0, .io_D1, .io_D2, .io_D3, .io_D4, .io_D5, .io_D6, .io_D7, .io_D8, .io_D9, .io_D10, .io_D11, .io_D12, .io_D13, .io_D14, .io_D15, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
    .{ .io_A14, .io_B10, .io_B9, .mc_A5, .mc_A3, .io_A0, .mc_D13, .mc_D10, .mc_D8, .mc_C6, .io_C2, .clk3, },
    .{ .io_B13, .io_B11, .io_A8, .io_A4, .mc_A3, .mc_B2, .io_C14, .io_D10, .mc_C9, .io_D6, .mc_D4, .mc_C0, },
    .{ .mc_B14, .io_A12, .mc_A10, .mc_A7, .io_B2, .io_B0, .io_D14, .io_D12, .mc_C9, .mc_C6, .io_D3, .clk2, },
    .{ .io_A13, .mc_B10, .io_B8, .io_A5, .mc_A2, .clk0, .io_D13, .mc_D12, .mc_C8, .mc_D7, .io_D3, .io_D0, },
    .{ .mc_A14, .mc_B12, .in1, .mc_A7, .mc_B5, .io_A0, .mc_D15, .mc_D12, .io_C7, .mc_D6, .io_D2, .mc_C0, },
    .{ .io_A15, .mc_A12, .mc_A9, .mc_A6, .mc_B4, .mc_B1, .io_C13, .io_C12, .io_C7, .mc_D7, .io_C3, .mc_C1, },
    .{ .io_B14, .io_B12, .io_A9, .mc_A6, .mc_A4, .clk1, .mc_C14, .io_D10, .in5, .mc_C6, .io_D2, .io_C0, },
    .{ .io_B14, .mc_A11, .io_B8, .io_A4, .io_A2, .mc_A0, .mc_D15, .io_D12, .mc_D9, .mc_C5, .mc_C4, .io_C1, },
    .{ .mc_B13, .mc_B11, .io_A8, .mc_A7, .io_A3, .mc_A1, .mc_D13, .io_D11, .io_D9, .io_D5, .mc_C3, .mc_C1, },
    .{ .mc_A15, .io_A10, .io_B8, .io_A6, .mc_B4, .io_A1, .mc_C15, .io_D11, .io_C9, .io_D6, .io_C2, .mc_D1, },
    .{ .mc_B13, .io_B11, .io_A7, .io_B5, .mc_B3, .clk0, .mc_C14, .mc_C13, .mc_D9, .mc_C7, .io_C2, .clk2, },
    .{ .mc_B13, .io_A11, .in1, .io_B6, .io_B4, .io_B0, .io_C14, .mc_D11, .io_C9, .mc_C5, .mc_D3, .clk3, },
    .{ .mc_A14, .mc_B11, .io_A9, .mc_B7, .io_B2, .mc_B0, .mc_D14, .mc_D11, .in4, .mc_D5, .io_C2, .io_D0, },
    .{ .io_A14, .mc_B10, .mc_B8, .io_B6, .mc_B5, .mc_A1, .mc_C14, .mc_C12, .in4, .io_D7, .io_C3, .mc_D2, },
    .{ .in0, .io_B10, .mc_A10, .io_B6, .io_A3, .mc_B1, .mc_D14, .mc_C11, .io_C8, .mc_C7, .io_D2, .mc_D0, },
    .{ .in0, .mc_B12, .in2, .io_B5, .mc_A4, .mc_B2, .in3, .io_D11, .mc_D8, .mc_D7, .mc_D3, .mc_D2, },
    .{ .mc_B15, .mc_B12, .io_A7, .mc_B7, .io_B4, .mc_A1, .io_C13, .io_C10, .mc_C10, .io_D6, .io_D3, .mc_D0, },
    .{ .io_B14, .io_A12, .mc_B9, .mc_B6, .mc_B5, .mc_B2, .io_C13, .mc_D10, .mc_C8, .mc_C7, .io_C4, .mc_D1, },
    .{ .mc_B14, .io_B11, .mc_A9, .mc_B6, .io_B3, .io_A1, .mc_D15, .io_C11, .io_D9, .io_C6, .mc_D3, .io_C0, },
    .{ .io_B13, .mc_A12, .in1, .mc_B7, .io_B3, .clk0, .io_D15, .io_D12, .io_C8, .io_C5, .io_D4, .mc_D1, },
    .{ .mc_A15, .mc_A11, .io_B9, .mc_A6, .io_B3, .io_B1, .io_C14, .mc_C11, .mc_C10, .mc_D5, .mc_C3, .clk2, },
    .{ .io_B13, .io_B10, .mc_B8, .io_A6, .io_A2, .mc_B0, .io_D14, .mc_D12, .mc_C10, .io_D5, .mc_C2, .io_C0, },
    .{ .mc_B15, .mc_B10, .in2, .io_B7, .io_B2, .io_A0, .mc_C15, .mc_C11, .io_D8, .io_C6, .io_D4, .io_C1, },
    .{ .in0, .io_A11, .io_B9, .io_B7, .mc_A2, .io_A1, .io_C15, .io_C10, .mc_D9, .io_D5, .io_C3, .io_D1, },
    .{ .io_A15, .io_B12, .mc_B9, .io_B5, .io_A2, .io_A1, .io_D15, .mc_D11, .io_D8, .mc_D6, .mc_D4, .mc_D0, },
    .{ .io_A14, .io_A10, .mc_A8, .mc_B6, .mc_A4, .io_B1, .mc_D14, .mc_C13, .io_C7, .io_D5, .mc_D4, .io_C1, },
    .{ .mc_A15, .mc_B11, .mc_B8, .io_A4, .io_B4, .clk1, .io_D13, .io_C12, .mc_D8, .io_C6, .io_C4, .io_D1, },
    .{ .io_B15, .io_B12, .io_A8, .mc_A5, .mc_B5, .io_B1, .io_D14, .io_C10, .io_C9, .io_C5, .mc_C4, .io_D0, },
    .{ .mc_B15, .mc_A13, .io_A9, .io_A5, .mc_B4, .mc_A0, .mc_D13, .mc_C12, .io_C8, .mc_D6, .mc_C2, .io_D1, },
    .{ .mc_A14, .mc_A13, .mc_A8, .io_A6, .mc_A2, .mc_A1, .in3, .io_D10, .io_D8, .mc_C5, .io_C4, .clk2, },
    .{ .mc_B14, .mc_A12, .mc_A8, .io_B7, .mc_B3, .mc_B2, .io_D13, .mc_C12, .in5, .mc_D5, .mc_C4, .mc_D0, },
    .{ .io_A13, .mc_A11, .mc_B9, .mc_A5, .mc_B3, .io_B0, .mc_C15, .io_C12, .io_D9, .io_D7, .mc_C2, .mc_C0, },
    .{ .io_B15, .mc_A13, .io_A7, .mc_A7, .mc_A4, .mc_B1, .io_C15, .io_C11, .mc_C8, .mc_D5, .io_D4, .clk3, },
    .{ .io_B15, .io_A10, .mc_A9, .io_B7, .io_A3, .clk1, .io_D15, .mc_D10, .mc_C9, .mc_C5, .mc_C2, .mc_D2, },
    .{ .io_A13, .io_A12, .in2, .io_A6, .io_B4, .mc_A0, .io_C15, .mc_C13, .in4, .io_C5, .io_D2, .mc_C1, },
    .{ .io_A15, .io_A11, .mc_A10, .io_A5, .mc_A3, .mc_B0, .in3, .io_C11, .in5, .io_D7, .mc_C3, .mc_D1, },
};

pub const gi_options_by_grp = lc4k.invert_gi_mapping(GRP, gi_mux_size, &gi_options);

const base = @import("LC4064x_TQFP100.zig");
pub const get_glb_range = base.get_glb_range;
pub const get_gi_range = base.get_gi_range;
pub const get_bclock_range = base.get_bclock_range;

pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(90, 355),
        1 => Fuse.init(91, 355),
        2 => Fuse.init(92, 355),
        3 => Fuse.init(93, 355),
        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 355),
        1 => Fuse.init(89, 355),
        else => unreachable,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 355);
}

pub fn getOscTimerEnableRange() Fuse_Range {
    return Fuse_Range.between(
        Fuse.init(92, 351),
        Fuse.init(92, 352),
    );
}

pub fn getOscOutFuse() Fuse {
    return Fuse.init(93, 354);
}

pub fn getTimerOutFuse() Fuse {
    return Fuse.init(93, 353);
}

pub fn getTimerDivRange() Fuse_Range {
    return Fuse.init(92, 353)
        .range().expand_to_contain(Fuse.init(92, 354));
}

pub fn getInputPower_GuardFuse(input: GRP) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(85, 351),
        .clk1 => Fuse.init(86, 351),
        .clk2 => Fuse.init(87, 351),
        .clk3 => Fuse.init(88, 351),
        else => unreachable,
    };
}

pub fn getInputBus_MaintenanceRange(input: GRP) Fuse_Range {
    return switch (input) {
        .clk0 => Fuse_Range.between(Fuse.init(85, 355), Fuse.init(86, 355)),
        .clk1 => Fuse_Range.between(Fuse.init(85, 354), Fuse.init(86, 354)),
        .clk2 => Fuse_Range.between(Fuse.init(85, 353), Fuse.init(86, 353)),
        .clk3 => Fuse_Range.between(Fuse.init(85, 352), Fuse.init(86, 352)),
        else => unreachable,
    };
}

pub fn get_input_threshold_fuse(input: GRP) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(94, 351),
        .clk1 => Fuse.init(94, 352),
        .clk2 => Fuse.init(94, 353),
        .clk3 => Fuse.init(94, 354),
        else => unreachable,
    };
}

pub const pins = struct {
    pub const _1 = Pin.init_misc("1", .tdi);
    pub const _2 = Pin.init_io("2", .io_A8);
    pub const _3 = Pin.init_io("3", .io_A10);
    pub const _4 = Pin.init_io("4", .io_A11);
    pub const _5 = Pin.init_misc("5", .gnd);
    pub const _6 = Pin.init_misc("6", .vcco);
    pub const _7 = Pin.init_io("7", .io_B15);
    pub const _8 = Pin.init_io("8", .io_B12);
    pub const _9 = Pin.init_io("9", .io_B10);
    pub const _10 = Pin.init_io("10", .io_B8);
    pub const _11 = Pin.init_misc("11", .tck);
    pub const _12 = Pin.init_misc("12", .vcc_core);
    pub const _13 = Pin.init_misc("13", .gnd);
    pub const _14 = Pin.init_io("14", .io_B6);
    pub const _15 = Pin.init_io("15", .io_B4);
    pub const _16 = Pin.init_io("16", .io_B2);
    pub const _17 = Pin.init_io("17", .io_B0);
    pub const _18 = Pin.init_clk("18", .clk1, 1, 1);
    pub const _19 = Pin.init_clk("19", .clk2, 2, 2);
    pub const _20 = Pin.init_io("20", .io_C0);
    pub const _21 = Pin.init_io("21", .io_C1);
    pub const _22 = Pin.init_io("22", .io_C2);
    pub const _23 = Pin.init_io("23", .io_C4);
    pub const _24 = Pin.init_io("24", .io_C6);
    pub const _25 = Pin.init_misc("25", .tms);
    pub const _26 = Pin.init_io("26", .io_C8);
    pub const _27 = Pin.init_io("27", .io_C10);
    pub const _28 = Pin.init_io("28", .io_C11);
    pub const _29 = Pin.init_misc("29", .gnd);
    pub const _30 = Pin.init_misc("30", .vcco);
    pub const _31 = Pin.init_io("31", .io_D15);
    pub const _32 = Pin.init_io("32", .io_D12);
    pub const _33 = Pin.init_io("33", .io_D10);
    pub const _34 = Pin.init_io("34", .io_D8);
    pub const _35 = Pin.init_misc("35", .tdo);
    pub const _36 = Pin.init_misc("36", .vcc_core);
    pub const _37 = Pin.init_misc("37", .gnd);
    pub const _38 = Pin.init_io("38", .io_D6);
    pub const _39 = Pin.init_io("39", .io_D4);
    pub const _40 = Pin.init_io("40", .io_D2);
    pub const _41 = Pin.init_oe("41", .io_D0, 1);
    pub const _42 = Pin.init_clk("42", .clk3, 3, 3);
    pub const _43 = Pin.init_clk("43", .clk0, 0, 0);
    pub const _44 = Pin.init_oe("44", .io_A0, 0);
    pub const _45 = Pin.init_io("45", .io_A1);
    pub const _46 = Pin.init_io("46", .io_A2);
    pub const _47 = Pin.init_io("47", .io_A4);
    pub const _48 = Pin.init_io("48", .io_A6);
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
