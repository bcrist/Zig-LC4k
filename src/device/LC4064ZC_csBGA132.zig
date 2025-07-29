//[[!! include('devices', 'LC4064ZC_csBGA132') !! 767 ]]
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

pub const Logic_Parser = @import("../logic_parser.zig").Logic_Parser(@This());
pub const F = lc4k.Factor(Signal);
pub const PT = lc4k.Product_Term(Signal);
pub const Pin = lc4k.Pin(Signal);
pub const Names = naming.Names(@This());

var name_buf: [33280]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator(), pins);
    return &default_names.?;
}


pub const Signal = enum (u16) {
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

    pub inline fn kind(self: Signal) lc4k.Signal_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.clk0)...@intFromEnum(Signal.clk3) => .clk,
            @intFromEnum(Signal.in0)...@intFromEnum(Signal.in5) => .in,
            @intFromEnum(Signal.io_A0)...@intFromEnum(Signal.io_D15) => .io,
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_D15) => .mc,
            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: Signal) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.io_A0)...@intFromEnum(Signal.io_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_A0)) },
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_A0)) },
            @intFromEnum(Signal.io_B0)...@intFromEnum(Signal.io_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_B0)) },
            @intFromEnum(Signal.mc_B0)...@intFromEnum(Signal.mc_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_B0)) },
            @intFromEnum(Signal.io_C0)...@intFromEnum(Signal.io_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_C0)) },
            @intFromEnum(Signal.mc_C0)...@intFromEnum(Signal.mc_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_C0)) },
            @intFromEnum(Signal.io_D0)...@intFromEnum(Signal.io_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_D0)) },
            @intFromEnum(Signal.mc_D0)...@intFromEnum(Signal.mc_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_D0)) },
            else => null,
        };
    }
    pub inline fn mc(self: Signal) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
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
    .{ .mc_C0, .mc_C1, .mc_C2, .mc_C3, .mc_C4, .mc_C5, .mc_C6, .mc_C7, .mc_C8, .mc_C9, .mc_C10, .mc_C11, .mc_C12, .mc_C13, .mc_C14, .mc_C15, },
    .{ .mc_D0, .mc_D1, .mc_D2, .mc_D3, .mc_D4, .mc_D5, .mc_D6, .mc_D7, .mc_D8, .mc_D9, .mc_D10, .mc_D11, .mc_D12, .mc_D13, .mc_D14, .mc_D15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?Signal {
    .{ .io_A0, .io_A1, .io_A2, .io_A3, .io_A4, .io_A5, .io_A6, .io_A7, .io_A8, .io_A9, .io_A10, .io_A11, .io_A12, .io_A13, .io_A14, .io_A15, },
    .{ .io_B0, .io_B1, .io_B2, .io_B3, .io_B4, .io_B5, .io_B6, .io_B7, .io_B8, .io_B9, .io_B10, .io_B11, .io_B12, .io_B13, .io_B14, .io_B15, },
    .{ .io_C0, .io_C1, .io_C2, .io_C3, .io_C4, .io_C5, .io_C6, .io_C7, .io_C8, .io_C9, .io_C10, .io_C11, .io_C12, .io_C13, .io_C14, .io_C15, },
    .{ .io_D0, .io_D1, .io_D2, .io_D3, .io_D4, .io_D5, .io_D6, .io_D7, .io_D8, .io_D9, .io_D10, .io_D11, .io_D12, .io_D13, .io_D14, .io_D15, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]Signal {
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

pub const gi_options_by_signal = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

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

pub fn get_input_threshold_fuse(input: Signal) Fuse {
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
    pub const A1 = Pin.init_misc(0, "A1", null, .no_connect);
    pub const A2 = Pin.init_io(1, "A2", 0, .io_A7);
    pub const A3 = Pin.init_io(2, "A3", 0, .io_A5);
    pub const A4 = Pin.init_misc(3, "A4", null, .no_connect);
    pub const A5 = Pin.init_misc(4, "A5", null, .no_connect);
    pub const A6 = Pin.init_io(5, "A6", 0, .io_A1);
    pub const A7 = Pin.init_misc(6, "A7", null, .no_connect);
    pub const A8 = Pin.init_oe(7, "A8", 1, .io_D0, 1);
    pub const A9 = Pin.init_io(8, "A9", 1, .io_D2);
    pub const A10 = Pin.init_misc(9, "A10", 1, .vcco);
    pub const A11 = Pin.init_io(10, "A11", 1, .io_D5);
    pub const A12 = Pin.init_input(11, "A12", 1, .in5, 3);
    pub const A13 = Pin.init_misc(12, "A13", null, .gnd);
    pub const A14 = Pin.init_misc(13, "A14", null, .vcc_core);
    pub const B1 = Pin.init_misc(14, "B1", null, .gnd);
    pub const B2 = Pin.init_misc(15, "B2", null, .tdi);
    pub const B3 = Pin.init_io(16, "B3", 0, .io_A6);
    pub const B4 = Pin.init_misc(17, "B4", 0, .gndo);
    pub const B5 = Pin.init_misc(18, "B5", null, .no_connect);
    pub const B6 = Pin.init_io(19, "B6", 0, .io_A2);
    pub const B7 = Pin.init_misc(20, "B7", null, .vcc_core);
    pub const B8 = Pin.init_clk(21, "B8", 1, .clk3, 3, 3);
    pub const B9 = Pin.init_io(22, "B9", 1, .io_D3);
    pub const B10 = Pin.init_misc(23, "B10", null, .no_connect);
    pub const B11 = Pin.init_misc(24, "B11", 1, .gndo);
    pub const B12 = Pin.init_io(25, "B12", 1, .io_D6);
    pub const B13 = Pin.init_misc(26, "B13", null, .no_connect);
    pub const B14 = Pin.init_misc(27, "B14", null, .tdo);
    pub const C1 = Pin.init_misc(28, "C1", null, .no_connect);
    pub const C2 = Pin.init_io(29, "C2", 0, .io_A8);
    pub const C3 = Pin.init_misc(30, "C3", null, .no_connect);
    pub const C4 = Pin.init_io(31, "C4", 0, .io_A4);
    pub const C5 = Pin.init_misc(32, "C5", 0, .vcco);
    pub const C6 = Pin.init_io(33, "C6", 0, .io_A3);
    pub const C7 = Pin.init_oe(34, "C7", 0, .io_A0, 0);
    pub const C8 = Pin.init_clk(35, "C8", 0, .clk0, 0, 0);
    pub const C9 = Pin.init_io(36, "C9", 1, .io_D1);
    pub const C10 = Pin.init_misc(37, "C10", null, .no_connect);
    pub const C11 = Pin.init_io(38, "C11", 1, .io_D4);
    pub const C12 = Pin.init_io(39, "C12", 1, .io_D7);
    pub const C13 = Pin.init_misc(40, "C13", null, .no_connect);
    pub const C14 = Pin.init_input(41, "C14", 1, .in4, 3);
    pub const D1 = Pin.init_io(42, "D1", 0, .io_A9);
    pub const D2 = Pin.init_io(43, "D2", 0, .io_A11);
    pub const D3 = Pin.init_io(44, "D3", 0, .io_A10);
    pub const D12 = Pin.init_io(45, "D12", 1, .io_D8);
    pub const D13 = Pin.init_io(46, "D13", 1, .io_D10);
    pub const D14 = Pin.init_io(47, "D14", 1, .io_D9);
    pub const E1 = Pin.init_misc(48, "E1", null, .no_connect);
    pub const E2 = Pin.init_misc(49, "E2", 0, .gndo);
    pub const E3 = Pin.init_misc(50, "E3", null, .no_connect);
    pub const E12 = Pin.init_io(51, "E12", 1, .io_D11);
    pub const E13 = Pin.init_misc(52, "E13", 1, .gndo);
    pub const E14 = Pin.init_misc(53, "E14", null, .no_connect);
    pub const F1 = Pin.init_io(54, "F1", 0, .io_A13);
    pub const F2 = Pin.init_io(55, "F2", 0, .io_A12);
    pub const F3 = Pin.init_io(56, "F3", 0, .io_A14);
    pub const F12 = Pin.init_io(57, "F12", 1, .io_D12);
    pub const F13 = Pin.init_io(58, "F13", 1, .io_D13);
    pub const F14 = Pin.init_io(59, "F14", 1, .io_D14);
    pub const G1 = Pin.init_io(60, "G1", 0, .io_A15);
    pub const G2 = Pin.init_input(61, "G2", 0, .in0, 0);
    pub const G3 = Pin.init_misc(62, "G3", 0, .vcco);
    pub const G12 = Pin.init_io(63, "G12", 1, .io_D15);
    pub const G13 = Pin.init_misc(64, "G13", null, .no_connect);
    pub const G14 = Pin.init_misc(65, "G14", null, .no_connect);
    pub const H1 = Pin.init_io(66, "H1", 0, .io_B15);
    pub const H2 = Pin.init_misc(67, "H2", null, .no_connect);
    pub const H3 = Pin.init_io(68, "H3", 0, .io_B14);
    pub const H12 = Pin.init_misc(69, "H12", 1, .vcco);
    pub const H13 = Pin.init_input(70, "H13", 1, .in3, 2);
    pub const H14 = Pin.init_io(71, "H14", 1, .io_C15);
    pub const J1 = Pin.init_io(72, "J1", 0, .io_B13);
    pub const J2 = Pin.init_io(73, "J2", 0, .io_B12);
    pub const J3 = Pin.init_misc(74, "J3", null, .no_connect);
    pub const J12 = Pin.init_io(75, "J12", 1, .io_C14);
    pub const J13 = Pin.init_io(76, "J13", 1, .io_C12);
    pub const J14 = Pin.init_io(77, "J14", 1, .io_C13);
    pub const K1 = Pin.init_misc(78, "K1", null, .no_connect);
    pub const K2 = Pin.init_misc(79, "K2", 0, .gndo);
    pub const K3 = Pin.init_io(80, "K3", 0, .io_B11);
    pub const K12 = Pin.init_misc(81, "K12", null, .no_connect);
    pub const K13 = Pin.init_misc(82, "K13", 1, .gndo);
    pub const K14 = Pin.init_misc(83, "K14", null, .no_connect);
    pub const L1 = Pin.init_io(84, "L1", 0, .io_B9);
    pub const L2 = Pin.init_io(85, "L2", 0, .io_B10);
    pub const L3 = Pin.init_io(86, "L3", 0, .io_B8);
    pub const L12 = Pin.init_io(87, "L12", 1, .io_C10);
    pub const L13 = Pin.init_io(88, "L13", 1, .io_C11);
    pub const L14 = Pin.init_io(89, "L14", 1, .io_C9);
    pub const M1 = Pin.init_input(90, "M1", 0, .in1, 1);
    pub const M2 = Pin.init_misc(91, "M2", null, .no_connect);
    pub const M3 = Pin.init_io(92, "M3", 0, .io_B6);
    pub const M4 = Pin.init_misc(93, "M4", null, .no_connect);
    pub const M5 = Pin.init_io(94, "M5", 0, .io_B3);
    pub const M6 = Pin.init_io(95, "M6", 0, .io_B0);
    pub const M7 = Pin.init_clk(96, "M7", 1, .clk2, 2, 2);
    pub const M8 = Pin.init_misc(97, "M8", null, .no_connect);
    pub const M9 = Pin.init_io(98, "M9", 1, .io_C2);
    pub const M10 = Pin.init_misc(99, "M10", 1, .vcco);
    pub const M11 = Pin.init_io(100, "M11", 1, .io_C4);
    pub const M12 = Pin.init_misc(101, "M12", null, .no_connect);
    pub const M13 = Pin.init_io(102, "M13", 1, .io_C8);
    pub const M14 = Pin.init_misc(103, "M14", null, .no_connect);
    pub const N1 = Pin.init_misc(104, "N1", null, .tck);
    pub const N2 = Pin.init_input(105, "N2", 0, .in2, 1);
    pub const N3 = Pin.init_io(106, "N3", 0, .io_B5);
    pub const N4 = Pin.init_misc(107, "N4", 0, .gndo);
    pub const N5 = Pin.init_misc(108, "N5", null, .no_connect);
    pub const N6 = Pin.init_io(109, "N6", 0, .io_B2);
    pub const N7 = Pin.init_clk(110, "N7", 0, .clk1, 1, 1);
    pub const N8 = Pin.init_misc(111, "N8", null, .vcc_core);
    pub const N9 = Pin.init_io(112, "N9", 1, .io_C1);
    pub const N10 = Pin.init_io(113, "N10", 1, .io_C3);
    pub const N11 = Pin.init_misc(114, "N11", 1, .gndo);
    pub const N12 = Pin.init_io(115, "N12", 1, .io_C6);
    pub const N13 = Pin.init_misc(116, "N13", null, .tms);
    pub const N14 = Pin.init_misc(117, "N14", null, .gnd);
    pub const P1 = Pin.init_misc(118, "P1", null, .vcc_core);
    pub const P2 = Pin.init_misc(119, "P2", null, .gnd);
    pub const P3 = Pin.init_io(120, "P3", 0, .io_B7);
    pub const P4 = Pin.init_io(121, "P4", 0, .io_B4);
    pub const P5 = Pin.init_misc(122, "P5", 0, .vcco);
    pub const P6 = Pin.init_io(123, "P6", 0, .io_B1);
    pub const P7 = Pin.init_misc(124, "P7", null, .no_connect);
    pub const P8 = Pin.init_misc(125, "P8", null, .no_connect);
    pub const P9 = Pin.init_io(126, "P9", 1, .io_C0);
    pub const P10 = Pin.init_misc(127, "P10", null, .no_connect);
    pub const P11 = Pin.init_misc(128, "P11", null, .no_connect);
    pub const P12 = Pin.init_io(129, "P12", 1, .io_C5);
    pub const P13 = Pin.init_io(130, "P13", 1, .io_C7);
    pub const P14 = Pin.init_misc(131, "P14", null, .no_connect);
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
    pins.A12,
    pins.C14,
    pins.G2,
    pins.H13,
    pins.M1,
    pins.N2,
};

pub const vcc_pins = [_]Pin {
    pins.A14,
    pins.B7,
    pins.N8,
    pins.P1,
};

pub const gnd_pins = [_]Pin {
    pins.A13,
    pins.B1,
    pins.N14,
    pins.P2,
};

pub const vcco_bank0_pins = [_]Pin {
    pins.C5,
    pins.G3,
    pins.P5,
};

pub const gnd_bank0_pins = [_]Pin {
    pins.B4,
    pins.E2,
    pins.K2,
    pins.N4,
};

pub const vcco_bank1_pins = [_]Pin {
    pins.A10,
    pins.H12,
    pins.M10,
};

pub const gnd_bank1_pins = [_]Pin {
    pins.B11,
    pins.E13,
    pins.K13,
    pins.N11,
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
