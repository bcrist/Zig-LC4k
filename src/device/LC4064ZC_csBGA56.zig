//[[!! include('devices', 'LC4064ZC_csBGA56') !! 575 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4064ZC_csBGA56;

pub const family = lc4k.Device_Family.zero_power;
pub const package = lc4k.Device_Package.csBGA56;

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

var name_buf: [23552]u8 = undefined;
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
            .clk0 => pins.A5,
            .clk1 => pins.H6,
            .clk2 => pins.K6,
            .clk3 => pins.C5,
            .in0 => pins.E1,
            .in1 => pins.J1,
            .in2 => pins.K3,
            .in3 => pins.F10,
            .in4 => pins.B10,
            .in5 => pins.A8,
            .io_A0 => pins.C4,
            .io_A1 => pins.A4,
            .io_A2 => pins.A3,
            .io_A4 => pins.A2,
            .io_A6 => pins.A1,
            .io_A8 => pins.C3,
            .io_A10 => pins.C1,
            .io_A11 => pins.D1,
            .io_A15 => pins.E3,
            .io_B0 => pins.K5,
            .io_B2 => pins.H5,
            .io_B4 => pins.H4,
            .io_B6 => pins.K4,
            .io_B8 => pins.H1,
            .io_B10 => pins.G1,
            .io_B12 => pins.G3,
            .io_B15 => pins.F1,
            .io_C0 => pins.H7,
            .io_C1 => pins.K7,
            .io_C2 => pins.K8,
            .io_C4 => pins.K9,
            .io_C6 => pins.K10,
            .io_C8 => pins.H8,
            .io_C10 => pins.H10,
            .io_C11 => pins.G10,
            .io_C12 => pins.F8,
            .io_D0 => pins.A6,
            .io_D2 => pins.C6,
            .io_D4 => pins.C7,
            .io_D6 => pins.A7,
            .io_D8 => pins.C10,
            .io_D10 => pins.D10,
            .io_D12 => pins.D8,
            .io_D15 => pins.E10,
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

pub const gi_options_by_grp = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

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
        Fuse.init(92, 11),
        Fuse.init(92, 21),
        Fuse.init(92, 31),
        Fuse.init(92, 41),
        Fuse.init(92, 51),
        Fuse.init(92, 61),
        Fuse.init(92, 71),
        Fuse.init(92, 80),
        Fuse.init(92, 110),
        Fuse.init(92, 120),
        Fuse.init(92, 130),
        Fuse.init(92, 140),
        Fuse.init(92, 160),
        Fuse.init(92, 169),
        Fuse.init(92, 170),
        Fuse.init(92, 189),
        Fuse.init(92, 199),
        Fuse.init(92, 209),
        Fuse.init(92, 219),
        Fuse.init(92, 229),
        Fuse.init(92, 239),
        Fuse.init(92, 249),
        Fuse.init(92, 258),
        Fuse.init(92, 288),
        Fuse.init(92, 298),
        Fuse.init(92, 308),
        Fuse.init(92, 318),
        Fuse.init(92, 337),
        Fuse.init(92, 338),
        Fuse.init(92, 347),
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
    pub const A1 = Pin.init_io("A1", .io_A6);
    pub const A2 = Pin.init_io("A2", .io_A4);
    pub const A3 = Pin.init_io("A3", .io_A2);
    pub const A4 = Pin.init_io("A4", .io_A1);
    pub const A5 = Pin.init_clk("A5", .clk0, 0, 0);
    pub const A6 = Pin.init_oe("A6", .io_D0, 1);
    pub const A7 = Pin.init_io("A7", .io_D6);
    pub const A8 = Pin.init_input("A8", .in5, 3);
    pub const A9 = Pin.init_misc("A9", .vcc_core);
    pub const A10 = Pin.init_misc("A10", .tdo);
    pub const B1 = Pin.init_misc("B1", .tdi);
    pub const B10 = Pin.init_input("B10", .in4, 3);
    pub const C1 = Pin.init_io("C1", .io_A10);
    pub const C3 = Pin.init_io("C3", .io_A8);
    pub const C4 = Pin.init_oe("C4", .io_A0, 0);
    pub const C5 = Pin.init_clk("C5", .clk3, 3, 3);
    pub const C6 = Pin.init_io("C6", .io_D2);
    pub const C7 = Pin.init_io("C7", .io_D4);
    pub const C8 = Pin.init_misc("C8", .gnd);
    pub const C10 = Pin.init_io("C10", .io_D8);
    pub const D1 = Pin.init_io("D1", .io_A11);
    pub const D3 = Pin.init_misc("D3", .gnd);
    pub const D8 = Pin.init_io("D8", .io_D12);
    pub const D10 = Pin.init_io("D10", .io_D10);
    pub const E1 = Pin.init_input("E1", .in0, 1);
    pub const E3 = Pin.init_io("E3", .io_A15);
    pub const E8 = Pin.init_misc("E8", .vcco);
    pub const E10 = Pin.init_io("E10", .io_D15);
    pub const F1 = Pin.init_io("F1", .io_B15);
    pub const F3 = Pin.init_misc("F3", .vcco);
    pub const F8 = Pin.init_io("F8", .io_C12);
    pub const F10 = Pin.init_input("F10", .in3, 3);
    pub const G1 = Pin.init_io("G1", .io_B10);
    pub const G3 = Pin.init_io("G3", .io_B12);
    pub const G8 = Pin.init_misc("G8", .gnd);
    pub const G10 = Pin.init_io("G10", .io_C11);
    pub const H1 = Pin.init_io("H1", .io_B8);
    pub const H3 = Pin.init_misc("H3", .gnd);
    pub const H4 = Pin.init_io("H4", .io_B4);
    pub const H5 = Pin.init_io("H5", .io_B2);
    pub const H6 = Pin.init_clk("H6", .clk1, 1, 1);
    pub const H7 = Pin.init_io("H7", .io_C0);
    pub const H8 = Pin.init_io("H8", .io_C8);
    pub const H10 = Pin.init_io("H10", .io_C10);
    pub const J1 = Pin.init_input("J1", .in1, 1);
    pub const J10 = Pin.init_misc("J10", .tms);
    pub const K1 = Pin.init_misc("K1", .tck);
    pub const K2 = Pin.init_misc("K2", .vcc_core);
    pub const K3 = Pin.init_input("K3", .in2, 1);
    pub const K4 = Pin.init_io("K4", .io_B6);
    pub const K5 = Pin.init_io("K5", .io_B0);
    pub const K6 = Pin.init_clk("K6", .clk2, 2, 2);
    pub const K7 = Pin.init_io("K7", .io_C1);
    pub const K8 = Pin.init_io("K8", .io_C2);
    pub const K9 = Pin.init_io("K9", .io_C4);
    pub const K10 = Pin.init_io("K10", .io_C6);
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
    pins.E1,
    pins.J1,
    pins.K3,
    pins.F10,
    pins.B10,
    pins.A8,
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
