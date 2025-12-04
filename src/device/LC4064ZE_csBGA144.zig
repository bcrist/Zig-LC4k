//[[!! include('devices', 'LC4064ZE_csBGA144') !! 842 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4064ZE_csBGA144;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.csBGA144;

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

var name_buf: [34816]u8 = undefined;
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
    pub const timer_out = Signal.mc_D15;
    pub const timer_reset = timer_out;
};

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
        return self.maybe_mc() orelse lc4k.panic("Signal {t} is not associated with a macrocell", .{ self });
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
        return switch (self) {
            .clk0 => pins.A7,
            .clk1 => pins.L6,
            .clk2 => pins.M6,
            .clk3 => pins.C7,
            .in0 => pins.F3,
            .in1 => pins.K2,
            .in2 => pins.L3,
            .in3 => pins.G10,
            .in4 => pins.C11,
            .in5 => pins.A11,
            .io_A0 => pins.D6,
            .io_A1 => pins.B6,
            .io_A2 => pins.A6,
            .io_A3 => pins.C6,
            .io_A4 => pins.A4,
            .io_A5 => pins.B4,
            .io_A6 => pins.C5,
            .io_A7 => pins.A3,
            .io_A8 => pins.C3,
            .io_A9 => pins.C2,
            .io_A10 => pins.C1,
            .io_A11 => pins.D1,
            .io_A12 => pins.E2,
            .io_A13 => pins.F2,
            .io_A14 => pins.D4,
            .io_A15 => pins.F1,
            .io_B0 => pins.K6,
            .io_B1 => pins.M5,
            .io_B2 => pins.J6,
            .io_B3 => pins.K5,
            .io_B4 => pins.L4,
            .io_B5 => pins.M3,
            .io_B6 => pins.K4,
            .io_B7 => pins.J4,
            .io_B8 => pins.K1,
            .io_B9 => pins.J2,
            .io_B10 => pins.J3,
            .io_B11 => pins.J1,
            .io_B12 => pins.G3,
            .io_B13 => pins.G2,
            .io_B14 => pins.E3,
            .io_B15 => pins.G1,
            .io_C0 => pins.K7,
            .io_C1 => pins.M7,
            .io_C2 => pins.L7,
            .io_C3 => pins.J7,
            .io_C4 => pins.M9,
            .io_C5 => pins.L9,
            .io_C6 => pins.K8,
            .io_C7 => pins.M10,
            .io_C8 => pins.K10,
            .io_C9 => pins.K12,
            .io_C10 => pins.J10,
            .io_C11 => pins.K11,
            .io_C12 => pins.H12,
            .io_C13 => pins.G11,
            .io_C14 => pins.H11,
            .io_C15 => pins.G12,
            .io_D0 => pins.B7,
            .io_D1 => pins.D7,
            .io_D2 => pins.A8,
            .io_D3 => pins.C8,
            .io_D4 => pins.A10,
            .io_D5 => pins.C9,
            .io_D6 => pins.B9,
            .io_D7 => pins.D9,
            .io_D8 => pins.C12,
            .io_D9 => pins.E9,
            .io_D10 => pins.D11,
            .io_D11 => pins.E10,
            .io_D12 => pins.E12,
            .io_D13 => pins.E11,
            .io_D14 => pins.F11,
            .io_D15 => pins.F12,
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

pub fn get_goe_source_fuse(goe: usize) ?Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 355),
        1 => Fuse.init(89, 355),
        else => null,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 355);
}

pub fn get_osctimer_enable_range() Fuse_Range {
    return Fuse_Range.between(
        Fuse.init(92, 351),
        Fuse.init(92, 352),
    );
}

pub fn get_osc_out_fuse() Fuse {
    return Fuse.init(93, 354);
}

pub fn get_timer_out_fuse() Fuse {
    return Fuse.init(93, 353);
}

pub fn get_timer_div_range() Fuse_Range {
    return Fuse.init(92, 353)
        .range().expand_to_contain(Fuse.init(92, 354));
}

pub fn get_input_power_guard_fuse(input: Signal) ?Fuse {
    return switch (input) {
        .clk0 => Fuse.init(85, 351),
        .clk1 => Fuse.init(86, 351),
        .clk2 => Fuse.init(87, 351),
        .clk3 => Fuse.init(88, 351),
        .in0 => Fuse.init(89, 351),
        .in1 => Fuse.init(90, 351),
        .in2 => Fuse.init(91, 351),
        .in3 => Fuse.init(91, 352),
        .in4 => Fuse.init(91, 353),
        .in5 => Fuse.init(91, 354),
        else => null,
    };
}

pub fn get_input_bus_maintenance_range(input: Signal) ?Fuse_Range {
    return switch (input) {
        .clk0 => Fuse_Range.between(Fuse.init(85, 355), Fuse.init(86, 355)),
        .clk1 => Fuse_Range.between(Fuse.init(85, 354), Fuse.init(86, 354)),
        .clk2 => Fuse_Range.between(Fuse.init(85, 353), Fuse.init(86, 353)),
        .clk3 => Fuse_Range.between(Fuse.init(85, 352), Fuse.init(86, 352)),
        .in0 => Fuse_Range.between(Fuse.init(87, 354), Fuse.init(88, 354)),
        .in1 => Fuse_Range.between(Fuse.init(87, 353), Fuse.init(88, 353)),
        .in2 => Fuse_Range.between(Fuse.init(87, 352), Fuse.init(88, 352)),
        .in3 => Fuse_Range.between(Fuse.init(89, 354), Fuse.init(90, 354)),
        .in4 => Fuse_Range.between(Fuse.init(89, 353), Fuse.init(90, 353)),
        .in5 => Fuse_Range.between(Fuse.init(89, 352), Fuse.init(90, 352)),
        else => null,
    };
}

pub fn get_input_threshold_fuse(input: Signal) ?Fuse {
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
        else => null,
    };
}

pub const pins = struct {
    pub const A1 = Pin.init_misc(0, "A1", null, .tdi);
    pub const A2 = Pin.init_misc(1, "A2", null, .no_connect);
    pub const A3 = Pin.init_io(2, "A3", 0, .io_A7);
    pub const A4 = Pin.init_io(3, "A4", 0, .io_A4);
    pub const A5 = Pin.init_misc(4, "A5", null, .no_connect);
    pub const A6 = Pin.init_io(5, "A6", 0, .io_A2);
    pub const A7 = Pin.init_clk(6, "A7", 0, .clk0, 0, 0);
    pub const A8 = Pin.init_io(7, "A8", 1, .io_D2);
    pub const A9 = Pin.init_misc(8, "A9", null, .no_connect);
    pub const A10 = Pin.init_io(9, "A10", 1, .io_D4);
    pub const A11 = Pin.init_input(10, "A11", 1, .in5, 3);
    pub const A12 = Pin.init_misc(11, "A12", null, .no_connect);
    pub const B1 = Pin.init_misc(12, "B1", null, .no_connect);
    pub const B2 = Pin.init_misc(13, "B2", null, .no_connect);
    pub const B3 = Pin.init_misc(14, "B3", null, .no_connect);
    pub const B4 = Pin.init_io(15, "B4", 0, .io_A5);
    pub const B5 = Pin.init_misc(16, "B5", null, .no_connect);
    pub const B6 = Pin.init_io(17, "B6", 0, .io_A1);
    pub const B7 = Pin.init_oe(18, "B7", 1, .io_D0, 1);
    pub const B8 = Pin.init_misc(19, "B8", null, .no_connect);
    pub const B9 = Pin.init_io(20, "B9", 1, .io_D6);
    pub const B10 = Pin.init_misc(21, "B10", null, .no_connect);
    pub const B11 = Pin.init_misc(22, "B11", null, .tdo);
    pub const B12 = Pin.init_misc(23, "B12", null, .no_connect);
    pub const C1 = Pin.init_io(24, "C1", 0, .io_A10);
    pub const C2 = Pin.init_io(25, "C2", 0, .io_A9);
    pub const C3 = Pin.init_io(26, "C3", 0, .io_A8);
    pub const C4 = Pin.init_misc(27, "C4", null, .no_connect);
    pub const C5 = Pin.init_io(28, "C5", 0, .io_A6);
    pub const C6 = Pin.init_io(29, "C6", 0, .io_A3);
    pub const C7 = Pin.init_clk(30, "C7", 1, .clk3, 3, 3);
    pub const C8 = Pin.init_io(31, "C8", 1, .io_D3);
    pub const C9 = Pin.init_io(32, "C9", 1, .io_D5);
    pub const C10 = Pin.init_misc(33, "C10", null, .no_connect);
    pub const C11 = Pin.init_input(34, "C11", 1, .in4, 3);
    pub const C12 = Pin.init_io(35, "C12", 1, .io_D8);
    pub const D1 = Pin.init_io(36, "D1", 0, .io_A11);
    pub const D2 = Pin.init_misc(37, "D2", null, .no_connect);
    pub const D3 = Pin.init_misc(38, "D3", null, .no_connect);
    pub const D4 = Pin.init_io(39, "D4", 0, .io_A14);
    pub const D5 = Pin.init_misc(40, "D5", 0, .vcco);
    pub const D6 = Pin.init_oe(41, "D6", 0, .io_A0, 0);
    pub const D7 = Pin.init_io(42, "D7", 1, .io_D1);
    pub const D8 = Pin.init_misc(43, "D8", 1, .vcco);
    pub const D9 = Pin.init_io(44, "D9", 1, .io_D7);
    pub const D10 = Pin.init_misc(45, "D10", null, .no_connect);
    pub const D11 = Pin.init_io(46, "D11", 1, .io_D10);
    pub const D12 = Pin.init_misc(47, "D12", null, .no_connect);
    pub const E1 = Pin.init_misc(48, "E1", null, .no_connect);
    pub const E2 = Pin.init_io(49, "E2", 0, .io_A12);
    pub const E3 = Pin.init_io(50, "E3", 0, .io_B14);
    pub const E4 = Pin.init_misc(51, "E4", null, .no_connect);
    pub const E5 = Pin.init_misc(52, "E5", null, .vcc_core);
    pub const E6 = Pin.init_misc(53, "E6", 0, .gndo);
    pub const E7 = Pin.init_misc(54, "E7", 1, .gndo);
    pub const E8 = Pin.init_misc(55, "E8", null, .vcc_core);
    pub const E9 = Pin.init_io(56, "E9", 1, .io_D9);
    pub const E10 = Pin.init_io(57, "E10", 1, .io_D11);
    pub const E11 = Pin.init_io(58, "E11", 1, .io_D13);
    pub const E12 = Pin.init_io(59, "E12", 1, .io_D12);
    pub const F1 = Pin.init_io(60, "F1", 0, .io_A15);
    pub const F2 = Pin.init_io(61, "F2", 0, .io_A13);
    pub const F3 = Pin.init_input(62, "F3", 0, .in0, 0);
    pub const F4 = Pin.init_misc(63, "F4", 0, .vcco);
    pub const F5 = Pin.init_misc(64, "F5", 0, .gndo);
    pub const F6 = Pin.init_misc(65, "F6", null, .gnd);
    pub const F7 = Pin.init_misc(66, "F7", null, .gnd);
    pub const F8 = Pin.init_misc(67, "F8", 1, .gndo);
    pub const F9 = Pin.init_misc(68, "F9", null, .no_connect);
    pub const F10 = Pin.init_misc(69, "F10", null, .no_connect);
    pub const F11 = Pin.init_io(70, "F11", 1, .io_D14);
    pub const F12 = Pin.init_io(71, "F12", 1, .io_D15);
    pub const G1 = Pin.init_io(72, "G1", 0, .io_B15);
    pub const G2 = Pin.init_io(73, "G2", 0, .io_B13);
    pub const G3 = Pin.init_io(74, "G3", 0, .io_B12);
    pub const G4 = Pin.init_misc(75, "G4", null, .no_connect);
    pub const G5 = Pin.init_misc(76, "G5", 0, .gndo);
    pub const G6 = Pin.init_misc(77, "G6", null, .gnd);
    pub const G7 = Pin.init_misc(78, "G7", null, .gnd);
    pub const G8 = Pin.init_misc(79, "G8", 1, .gndo);
    pub const G9 = Pin.init_misc(80, "G9", 1, .vcco);
    pub const G10 = Pin.init_input(81, "G10", 1, .in3, 2);
    pub const G11 = Pin.init_io(82, "G11", 1, .io_C13);
    pub const G12 = Pin.init_io(83, "G12", 1, .io_C15);
    pub const H1 = Pin.init_misc(84, "H1", null, .no_connect);
    pub const H2 = Pin.init_misc(85, "H2", null, .no_connect);
    pub const H3 = Pin.init_misc(86, "H3", null, .no_connect);
    pub const H4 = Pin.init_misc(87, "H4", 0, .gndo);
    pub const H5 = Pin.init_misc(88, "H5", null, .vcc_core);
    pub const H6 = Pin.init_misc(89, "H6", 0, .gndo);
    pub const H7 = Pin.init_misc(90, "H7", 1, .gndo);
    pub const H8 = Pin.init_misc(91, "H8", null, .vcc_core);
    pub const H9 = Pin.init_misc(92, "H9", null, .no_connect);
    pub const H10 = Pin.init_misc(93, "H10", null, .no_connect);
    pub const H11 = Pin.init_io(94, "H11", 1, .io_C14);
    pub const H12 = Pin.init_io(95, "H12", 1, .io_C12);
    pub const J1 = Pin.init_io(96, "J1", 0, .io_B11);
    pub const J2 = Pin.init_io(97, "J2", 0, .io_B9);
    pub const J3 = Pin.init_io(98, "J3", 0, .io_B10);
    pub const J4 = Pin.init_io(99, "J4", 0, .io_B7);
    pub const J5 = Pin.init_misc(100, "J5", 0, .vcco);
    pub const J6 = Pin.init_io(101, "J6", 0, .io_B2);
    pub const J7 = Pin.init_io(102, "J7", 1, .io_C3);
    pub const J8 = Pin.init_misc(103, "J8", 1, .vcco);
    pub const J9 = Pin.init_misc(104, "J9", 1, .gndo);
    pub const J10 = Pin.init_io(105, "J10", 1, .io_C10);
    pub const J11 = Pin.init_misc(106, "J11", null, .no_connect);
    pub const J12 = Pin.init_misc(107, "J12", null, .no_connect);
    pub const K1 = Pin.init_io(108, "K1", 0, .io_B8);
    pub const K2 = Pin.init_input(109, "K2", 0, .in1, 1);
    pub const K3 = Pin.init_misc(110, "K3", null, .no_connect);
    pub const K4 = Pin.init_io(111, "K4", 0, .io_B6);
    pub const K5 = Pin.init_io(112, "K5", 0, .io_B3);
    pub const K6 = Pin.init_io(113, "K6", 0, .io_B0);
    pub const K7 = Pin.init_io(114, "K7", 1, .io_C0);
    pub const K8 = Pin.init_io(115, "K8", 1, .io_C6);
    pub const K9 = Pin.init_misc(116, "K9", null, .no_connect);
    pub const K10 = Pin.init_io(117, "K10", 1, .io_C8);
    pub const K11 = Pin.init_io(118, "K11", 1, .io_C11);
    pub const K12 = Pin.init_io(119, "K12", 1, .io_C9);
    pub const L1 = Pin.init_misc(120, "L1", null, .no_connect);
    pub const L2 = Pin.init_misc(121, "L2", null, .tck);
    pub const L3 = Pin.init_input(122, "L3", 0, .in2, 1);
    pub const L4 = Pin.init_io(123, "L4", 0, .io_B4);
    pub const L5 = Pin.init_misc(124, "L5", null, .no_connect);
    pub const L6 = Pin.init_clk(125, "L6", 0, .clk1, 1, 1);
    pub const L7 = Pin.init_io(126, "L7", 1, .io_C2);
    pub const L8 = Pin.init_misc(127, "L8", null, .no_connect);
    pub const L9 = Pin.init_io(128, "L9", 1, .io_C5);
    pub const L10 = Pin.init_misc(129, "L10", null, .no_connect);
    pub const L11 = Pin.init_misc(130, "L11", null, .no_connect);
    pub const L12 = Pin.init_misc(131, "L12", null, .no_connect);
    pub const M1 = Pin.init_misc(132, "M1", null, .no_connect);
    pub const M2 = Pin.init_misc(133, "M2", null, .no_connect);
    pub const M3 = Pin.init_io(134, "M3", 0, .io_B5);
    pub const M4 = Pin.init_misc(135, "M4", null, .no_connect);
    pub const M5 = Pin.init_io(136, "M5", 0, .io_B1);
    pub const M6 = Pin.init_clk(137, "M6", 1, .clk2, 2, 2);
    pub const M7 = Pin.init_io(138, "M7", 1, .io_C1);
    pub const M8 = Pin.init_misc(139, "M8", null, .no_connect);
    pub const M9 = Pin.init_io(140, "M9", 1, .io_C4);
    pub const M10 = Pin.init_io(141, "M10", 1, .io_C7);
    pub const M11 = Pin.init_misc(142, "M11", null, .no_connect);
    pub const M12 = Pin.init_misc(143, "M12", null, .tms);
};

pub const clock_pins = [_]Pin {
    pins.A7,
    pins.L6,
    pins.M6,
    pins.C7,
};

pub const oe_pins = [_]Pin {
    pins.D6,
    pins.B7,
};

pub const input_pins = [_]Pin {
    pins.A11,
    pins.C11,
    pins.F3,
    pins.G10,
    pins.K2,
    pins.L3,
};

pub const vcc_pins = [_]Pin {
    pins.E5,
    pins.E8,
    pins.H5,
    pins.H8,
};

pub const gnd_pins = [_]Pin {
    pins.F6,
    pins.F7,
    pins.G6,
    pins.G7,
};

pub const vcco_bank0_pins = [_]Pin {
    pins.D5,
    pins.F4,
    pins.J5,
};

pub const gnd_bank0_pins = [_]Pin {
    pins.E6,
    pins.F5,
    pins.G5,
    pins.H4,
    pins.H6,
};

pub const vcco_bank1_pins = [_]Pin {
    pins.D8,
    pins.G9,
    pins.J8,
};

pub const gnd_bank1_pins = [_]Pin {
    pins.E7,
    pins.F8,
    pins.G8,
    pins.H7,
    pins.J9,
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
    pins.D5,
    pins.D6,
    pins.D7,
    pins.D8,
    pins.D9,
    pins.D10,
    pins.D11,
    pins.D12,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E4,
    pins.E5,
    pins.E6,
    pins.E7,
    pins.E8,
    pins.E9,
    pins.E10,
    pins.E11,
    pins.E12,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F4,
    pins.F5,
    pins.F6,
    pins.F7,
    pins.F8,
    pins.F9,
    pins.F10,
    pins.F11,
    pins.F12,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G4,
    pins.G5,
    pins.G6,
    pins.G7,
    pins.G8,
    pins.G9,
    pins.G10,
    pins.G11,
    pins.G12,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H4,
    pins.H5,
    pins.H6,
    pins.H7,
    pins.H8,
    pins.H9,
    pins.H10,
    pins.H11,
    pins.H12,
    pins.J1,
    pins.J2,
    pins.J3,
    pins.J4,
    pins.J5,
    pins.J6,
    pins.J7,
    pins.J8,
    pins.J9,
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
    pins.L2,
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
