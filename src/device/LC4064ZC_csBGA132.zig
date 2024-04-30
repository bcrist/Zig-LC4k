//[[!! include('devices', 'LC4064ZC_csBGA132') !! 708 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4064ZC_csBGA132;

pub const family = lc4k.Device_Family.zero_power;
pub const package = lc4k.Device_Package.csBGA132;

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
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_A0)) },
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_A0)) },
            @intFromEnum(GRP.io_B0)...@intFromEnum(GRP.io_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_B0)) },
            @intFromEnum(GRP.mc_B0)...@intFromEnum(GRP.mc_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_B0)) },
            @intFromEnum(GRP.io_C0)...@intFromEnum(GRP.io_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_C0)) },
            @intFromEnum(GRP.mc_C0)...@intFromEnum(GRP.mc_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_C0)) },
            @intFromEnum(GRP.io_D0)...@intFromEnum(GRP.io_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_D0)) },
            @intFromEnum(GRP.mc_D0)...@intFromEnum(GRP.mc_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_D0)) },
            else => null,
        };
    }
    pub inline fn mc(self: GRP) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: GRP) ?Pin {
        return switch (self) {
            .clk0 => pins.C8,
            .clk1 => pins.N7,
            .clk2 => pins.M7,
            .clk3 => pins.B8,
            .in0 => pins.G2,
            .in1 => pins.M1,
            .in2 => pins.N2,
            .in3 => pins.H13,
            .in4 => pins.C14,
            .in5 => pins.A12,
            .io_A0 => pins.C7,
            .io_A1 => pins.A6,
            .io_A2 => pins.B6,
            .io_A3 => pins.C6,
            .io_A4 => pins.C4,
            .io_A5 => pins.A3,
            .io_A6 => pins.B3,
            .io_A7 => pins.A2,
            .io_A8 => pins.C2,
            .io_A9 => pins.D1,
            .io_A10 => pins.D3,
            .io_A11 => pins.D2,
            .io_A12 => pins.F2,
            .io_A13 => pins.F1,
            .io_A14 => pins.F3,
            .io_A15 => pins.G1,
            .io_B0 => pins.M6,
            .io_B1 => pins.P6,
            .io_B2 => pins.N6,
            .io_B3 => pins.M5,
            .io_B4 => pins.P4,
            .io_B5 => pins.N3,
            .io_B6 => pins.M3,
            .io_B7 => pins.P3,
            .io_B8 => pins.L3,
            .io_B9 => pins.L1,
            .io_B10 => pins.L2,
            .io_B11 => pins.K3,
            .io_B12 => pins.J2,
            .io_B13 => pins.J1,
            .io_B14 => pins.H3,
            .io_B15 => pins.H1,
            .io_C0 => pins.P9,
            .io_C1 => pins.N9,
            .io_C2 => pins.M9,
            .io_C3 => pins.N10,
            .io_C4 => pins.M11,
            .io_C5 => pins.P12,
            .io_C6 => pins.N12,
            .io_C7 => pins.P13,
            .io_C8 => pins.M13,
            .io_C9 => pins.L14,
            .io_C10 => pins.L12,
            .io_C11 => pins.L13,
            .io_C12 => pins.J13,
            .io_C13 => pins.J14,
            .io_C14 => pins.J12,
            .io_C15 => pins.H14,
            .io_D0 => pins.A8,
            .io_D1 => pins.C9,
            .io_D2 => pins.A9,
            .io_D3 => pins.B9,
            .io_D4 => pins.C11,
            .io_D5 => pins.A11,
            .io_D6 => pins.B12,
            .io_D7 => pins.C12,
            .io_D8 => pins.D12,
            .io_D9 => pins.D14,
            .io_D10 => pins.D13,
            .io_D11 => pins.E12,
            .io_D12 => pins.F12,
            .io_D13 => pins.F13,
            .io_D14 => pins.F14,
            .io_D15 => pins.G12,
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


pub fn get_global_bus_maintenance_range() Fuse_Range {
    return Fuse.init(85, 355).range().expand_to_contain(Fuse.init(86, 355));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{
    };
}

pub fn get_input_threshold_fuse(input: GRP) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(94, 351),
        .clk1 => Fuse.init(94, 352),
        .clk2 => Fuse.init(94, 353),
        .clk3 => Fuse.init(94, 354),
        .in0 => Fuse.init(94, 355),
        .in1 => Fuse.init(95, 351),
        .in2 => Fuse.init(95, 352),
        .in3 => Fuse.init(95, 353),
        .in4 => Fuse.init(95, 354),
        .in5 => Fuse.init(95, 355),
        else => unreachable,
    };
}

pub const pins = struct {
    pub const A1 = Pin.init_misc("A1", .no_connect);
    pub const A2 = Pin.init_io("A2", .io_A7);
    pub const A3 = Pin.init_io("A3", .io_A5);
    pub const A4 = Pin.init_misc("A4", .no_connect);
    pub const A5 = Pin.init_misc("A5", .no_connect);
    pub const A6 = Pin.init_io("A6", .io_A1);
    pub const A7 = Pin.init_misc("A7", .no_connect);
    pub const A8 = Pin.init_oe("A8", .io_D0, 1);
    pub const A9 = Pin.init_io("A9", .io_D2);
    pub const A10 = Pin.init_misc("A10", .vcco);
    pub const A11 = Pin.init_io("A11", .io_D5);
    pub const A12 = Pin.init_input("A12", .in5, 3);
    pub const A13 = Pin.init_misc("A13", .gnd);
    pub const A14 = Pin.init_misc("A14", .vcc_core);
    pub const B1 = Pin.init_misc("B1", .gnd);
    pub const B2 = Pin.init_misc("B2", .tdi);
    pub const B3 = Pin.init_io("B3", .io_A6);
    pub const B4 = Pin.init_misc("B4", .gnd);
    pub const B5 = Pin.init_misc("B5", .no_connect);
    pub const B6 = Pin.init_io("B6", .io_A2);
    pub const B7 = Pin.init_misc("B7", .vcc_core);
    pub const B8 = Pin.init_clk("B8", .clk3, 3, 3);
    pub const B9 = Pin.init_io("B9", .io_D3);
    pub const B10 = Pin.init_misc("B10", .no_connect);
    pub const B11 = Pin.init_misc("B11", .gnd);
    pub const B12 = Pin.init_io("B12", .io_D6);
    pub const B13 = Pin.init_misc("B13", .no_connect);
    pub const B14 = Pin.init_misc("B14", .tdo);
    pub const C1 = Pin.init_misc("C1", .no_connect);
    pub const C2 = Pin.init_io("C2", .io_A8);
    pub const C3 = Pin.init_misc("C3", .no_connect);
    pub const C4 = Pin.init_io("C4", .io_A4);
    pub const C5 = Pin.init_misc("C5", .vcco);
    pub const C6 = Pin.init_io("C6", .io_A3);
    pub const C7 = Pin.init_oe("C7", .io_A0, 0);
    pub const C8 = Pin.init_clk("C8", .clk0, 0, 0);
    pub const C9 = Pin.init_io("C9", .io_D1);
    pub const C10 = Pin.init_misc("C10", .no_connect);
    pub const C11 = Pin.init_io("C11", .io_D4);
    pub const C12 = Pin.init_io("C12", .io_D7);
    pub const C13 = Pin.init_misc("C13", .no_connect);
    pub const C14 = Pin.init_input("C14", .in4, 3);
    pub const D1 = Pin.init_io("D1", .io_A9);
    pub const D2 = Pin.init_io("D2", .io_A11);
    pub const D3 = Pin.init_io("D3", .io_A10);
    pub const D12 = Pin.init_io("D12", .io_D8);
    pub const D13 = Pin.init_io("D13", .io_D10);
    pub const D14 = Pin.init_io("D14", .io_D9);
    pub const E1 = Pin.init_misc("E1", .no_connect);
    pub const E2 = Pin.init_misc("E2", .gnd);
    pub const E3 = Pin.init_misc("E3", .no_connect);
    pub const E12 = Pin.init_io("E12", .io_D11);
    pub const E13 = Pin.init_misc("E13", .gnd);
    pub const E14 = Pin.init_misc("E14", .no_connect);
    pub const F1 = Pin.init_io("F1", .io_A13);
    pub const F2 = Pin.init_io("F2", .io_A12);
    pub const F3 = Pin.init_io("F3", .io_A14);
    pub const F12 = Pin.init_io("F12", .io_D12);
    pub const F13 = Pin.init_io("F13", .io_D13);
    pub const F14 = Pin.init_io("F14", .io_D14);
    pub const G1 = Pin.init_io("G1", .io_A15);
    pub const G2 = Pin.init_input("G2", .in0, 0);
    pub const G3 = Pin.init_misc("G3", .vcco);
    pub const G12 = Pin.init_io("G12", .io_D15);
    pub const G13 = Pin.init_misc("G13", .no_connect);
    pub const G14 = Pin.init_misc("G14", .no_connect);
    pub const H1 = Pin.init_io("H1", .io_B15);
    pub const H2 = Pin.init_misc("H2", .no_connect);
    pub const H3 = Pin.init_io("H3", .io_B14);
    pub const H12 = Pin.init_misc("H12", .vcco);
    pub const H13 = Pin.init_input("H13", .in3, 2);
    pub const H14 = Pin.init_io("H14", .io_C15);
    pub const J1 = Pin.init_io("J1", .io_B13);
    pub const J2 = Pin.init_io("J2", .io_B12);
    pub const J3 = Pin.init_misc("J3", .no_connect);
    pub const J12 = Pin.init_io("J12", .io_C14);
    pub const J13 = Pin.init_io("J13", .io_C12);
    pub const J14 = Pin.init_io("J14", .io_C13);
    pub const K1 = Pin.init_misc("K1", .no_connect);
    pub const K2 = Pin.init_misc("K2", .gnd);
    pub const K3 = Pin.init_io("K3", .io_B11);
    pub const K12 = Pin.init_misc("K12", .no_connect);
    pub const K13 = Pin.init_misc("K13", .gnd);
    pub const K14 = Pin.init_misc("K14", .no_connect);
    pub const L1 = Pin.init_io("L1", .io_B9);
    pub const L2 = Pin.init_io("L2", .io_B10);
    pub const L3 = Pin.init_io("L3", .io_B8);
    pub const L12 = Pin.init_io("L12", .io_C10);
    pub const L13 = Pin.init_io("L13", .io_C11);
    pub const L14 = Pin.init_io("L14", .io_C9);
    pub const M1 = Pin.init_input("M1", .in1, 1);
    pub const M2 = Pin.init_misc("M2", .no_connect);
    pub const M3 = Pin.init_io("M3", .io_B6);
    pub const M4 = Pin.init_misc("M4", .no_connect);
    pub const M5 = Pin.init_io("M5", .io_B3);
    pub const M6 = Pin.init_io("M6", .io_B0);
    pub const M7 = Pin.init_clk("M7", .clk2, 2, 2);
    pub const M8 = Pin.init_misc("M8", .no_connect);
    pub const M9 = Pin.init_io("M9", .io_C2);
    pub const M10 = Pin.init_misc("M10", .vcco);
    pub const M11 = Pin.init_io("M11", .io_C4);
    pub const M12 = Pin.init_misc("M12", .no_connect);
    pub const M13 = Pin.init_io("M13", .io_C8);
    pub const M14 = Pin.init_misc("M14", .no_connect);
    pub const N1 = Pin.init_misc("N1", .tck);
    pub const N2 = Pin.init_input("N2", .in2, 1);
    pub const N3 = Pin.init_io("N3", .io_B5);
    pub const N4 = Pin.init_misc("N4", .gnd);
    pub const N5 = Pin.init_misc("N5", .no_connect);
    pub const N6 = Pin.init_io("N6", .io_B2);
    pub const N7 = Pin.init_clk("N7", .clk1, 1, 1);
    pub const N8 = Pin.init_misc("N8", .vcc_core);
    pub const N9 = Pin.init_io("N9", .io_C1);
    pub const N10 = Pin.init_io("N10", .io_C3);
    pub const N11 = Pin.init_misc("N11", .gnd);
    pub const N12 = Pin.init_io("N12", .io_C6);
    pub const N13 = Pin.init_misc("N13", .tms);
    pub const N14 = Pin.init_misc("N14", .gnd);
    pub const P1 = Pin.init_misc("P1", .vcc_core);
    pub const P2 = Pin.init_misc("P2", .gnd);
    pub const P3 = Pin.init_io("P3", .io_B7);
    pub const P4 = Pin.init_io("P4", .io_B4);
    pub const P5 = Pin.init_misc("P5", .vcco);
    pub const P6 = Pin.init_io("P6", .io_B1);
    pub const P7 = Pin.init_misc("P7", .no_connect);
    pub const P8 = Pin.init_misc("P8", .no_connect);
    pub const P9 = Pin.init_io("P9", .io_C0);
    pub const P10 = Pin.init_misc("P10", .no_connect);
    pub const P11 = Pin.init_misc("P11", .no_connect);
    pub const P12 = Pin.init_io("P12", .io_C5);
    pub const P13 = Pin.init_io("P13", .io_C7);
    pub const P14 = Pin.init_misc("P14", .no_connect);
};

pub const clock_pins = [_]Pin {
    pins.C8,
    pins.N7,
    pins.M7,
    pins.B8,
};

pub const oe_pins = [_]Pin {
    pins.C7,
    pins.A8,
};

pub const input_pins = [_]Pin {
    pins.G2,
    pins.M1,
    pins.N2,
    pins.H13,
    pins.C14,
    pins.A12,
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
