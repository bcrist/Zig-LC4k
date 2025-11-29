//[[!! include('devices', 'LC4128ZE_csBGA144') !! 1041 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4128ZE_csBGA144;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.csBGA144;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;
pub const oe_bus_size = 4;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(740, 100);

pub const Logic_Parser = @import("../logic_parser.zig").Logic_Parser(@This());
pub const F = lc4k.Factor(Signal);
pub const PT = lc4k.Product_Term(Signal);
pub const Pin = lc4k.Pin(Signal);
pub const Names = naming.Names(@This());

var name_buf: [51200]u8 = undefined;
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
    pub const timer_out = Signal.mc_G15;
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
    io_A4 = 7,
    io_A5 = 8,
    io_A6 = 9,
    io_A8 = 10,
    io_A9 = 11,
    io_A10 = 12,
    io_A12 = 13,
    io_A13 = 14,
    io_A14 = 15,
    io_B0 = 16,
    io_B1 = 17,
    io_B2 = 18,
    io_B4 = 19,
    io_B5 = 20,
    io_B6 = 21,
    io_B8 = 22,
    io_B9 = 23,
    io_B10 = 24,
    io_B12 = 25,
    io_B13 = 26,
    io_B14 = 27,
    io_C0 = 28,
    io_C1 = 29,
    io_C2 = 30,
    io_C4 = 31,
    io_C5 = 32,
    io_C6 = 33,
    io_C8 = 34,
    io_C9 = 35,
    io_C10 = 36,
    io_C12 = 37,
    io_C13 = 38,
    io_C14 = 39,
    io_D0 = 40,
    io_D1 = 41,
    io_D2 = 42,
    io_D4 = 43,
    io_D5 = 44,
    io_D6 = 45,
    io_D8 = 46,
    io_D9 = 47,
    io_D10 = 48,
    io_D12 = 49,
    io_D13 = 50,
    io_D14 = 51,
    io_E0 = 52,
    io_E1 = 53,
    io_E2 = 54,
    io_E4 = 55,
    io_E5 = 56,
    io_E6 = 57,
    io_E8 = 58,
    io_E9 = 59,
    io_E10 = 60,
    io_E12 = 61,
    io_E13 = 62,
    io_E14 = 63,
    io_F0 = 64,
    io_F1 = 65,
    io_F2 = 66,
    io_F4 = 67,
    io_F5 = 68,
    io_F6 = 69,
    io_F8 = 70,
    io_F9 = 71,
    io_F10 = 72,
    io_F12 = 73,
    io_F13 = 74,
    io_F14 = 75,
    io_G0 = 76,
    io_G1 = 77,
    io_G2 = 78,
    io_G4 = 79,
    io_G5 = 80,
    io_G6 = 81,
    io_G8 = 82,
    io_G9 = 83,
    io_G10 = 84,
    io_G12 = 85,
    io_G13 = 86,
    io_G14 = 87,
    io_H0 = 88,
    io_H1 = 89,
    io_H2 = 90,
    io_H4 = 91,
    io_H5 = 92,
    io_H6 = 93,
    io_H8 = 94,
    io_H9 = 95,
    io_H10 = 96,
    io_H12 = 97,
    io_H13 = 98,
    io_H14 = 99,
    mc_A0 = 100,
    mc_A1 = 101,
    mc_A2 = 102,
    mc_A3 = 103,
    mc_A4 = 104,
    mc_A5 = 105,
    mc_A6 = 106,
    mc_A7 = 107,
    mc_A8 = 108,
    mc_A9 = 109,
    mc_A10 = 110,
    mc_A11 = 111,
    mc_A12 = 112,
    mc_A13 = 113,
    mc_A14 = 114,
    mc_A15 = 115,
    mc_B0 = 116,
    mc_B1 = 117,
    mc_B2 = 118,
    mc_B3 = 119,
    mc_B4 = 120,
    mc_B5 = 121,
    mc_B6 = 122,
    mc_B7 = 123,
    mc_B8 = 124,
    mc_B9 = 125,
    mc_B10 = 126,
    mc_B11 = 127,
    mc_B12 = 128,
    mc_B13 = 129,
    mc_B14 = 130,
    mc_B15 = 131,
    mc_C0 = 132,
    mc_C1 = 133,
    mc_C2 = 134,
    mc_C3 = 135,
    mc_C4 = 136,
    mc_C5 = 137,
    mc_C6 = 138,
    mc_C7 = 139,
    mc_C8 = 140,
    mc_C9 = 141,
    mc_C10 = 142,
    mc_C11 = 143,
    mc_C12 = 144,
    mc_C13 = 145,
    mc_C14 = 146,
    mc_C15 = 147,
    mc_D0 = 148,
    mc_D1 = 149,
    mc_D2 = 150,
    mc_D3 = 151,
    mc_D4 = 152,
    mc_D5 = 153,
    mc_D6 = 154,
    mc_D7 = 155,
    mc_D8 = 156,
    mc_D9 = 157,
    mc_D10 = 158,
    mc_D11 = 159,
    mc_D12 = 160,
    mc_D13 = 161,
    mc_D14 = 162,
    mc_D15 = 163,
    mc_E0 = 164,
    mc_E1 = 165,
    mc_E2 = 166,
    mc_E3 = 167,
    mc_E4 = 168,
    mc_E5 = 169,
    mc_E6 = 170,
    mc_E7 = 171,
    mc_E8 = 172,
    mc_E9 = 173,
    mc_E10 = 174,
    mc_E11 = 175,
    mc_E12 = 176,
    mc_E13 = 177,
    mc_E14 = 178,
    mc_E15 = 179,
    mc_F0 = 180,
    mc_F1 = 181,
    mc_F2 = 182,
    mc_F3 = 183,
    mc_F4 = 184,
    mc_F5 = 185,
    mc_F6 = 186,
    mc_F7 = 187,
    mc_F8 = 188,
    mc_F9 = 189,
    mc_F10 = 190,
    mc_F11 = 191,
    mc_F12 = 192,
    mc_F13 = 193,
    mc_F14 = 194,
    mc_F15 = 195,
    mc_G0 = 196,
    mc_G1 = 197,
    mc_G2 = 198,
    mc_G3 = 199,
    mc_G4 = 200,
    mc_G5 = 201,
    mc_G6 = 202,
    mc_G7 = 203,
    mc_G8 = 204,
    mc_G9 = 205,
    mc_G10 = 206,
    mc_G11 = 207,
    mc_G12 = 208,
    mc_G13 = 209,
    mc_G14 = 210,
    mc_G15 = 211,
    mc_H0 = 212,
    mc_H1 = 213,
    mc_H2 = 214,
    mc_H3 = 215,
    mc_H4 = 216,
    mc_H5 = 217,
    mc_H6 = 218,
    mc_H7 = 219,
    mc_H8 = 220,
    mc_H9 = 221,
    mc_H10 = 222,
    mc_H11 = 223,
    mc_H12 = 224,
    mc_H13 = 225,
    mc_H14 = 226,
    mc_H15 = 227,

    pub inline fn kind(self: Signal) lc4k.Signal_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.clk0)...@intFromEnum(Signal.clk3) => .clk,
            @intFromEnum(Signal.io_A0)...@intFromEnum(Signal.io_H14) => .io,
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_H15) => .mc,
            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: Signal) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {
            @intFromEnum(Signal.io_A0) => .{ .glb = 0, .mc = 0 },
            @intFromEnum(Signal.io_A1) => .{ .glb = 0, .mc = 1 },
            @intFromEnum(Signal.io_A2) => .{ .glb = 0, .mc = 2 },
            @intFromEnum(Signal.io_A4) => .{ .glb = 0, .mc = 4 },
            @intFromEnum(Signal.io_A5) => .{ .glb = 0, .mc = 5 },
            @intFromEnum(Signal.io_A6) => .{ .glb = 0, .mc = 6 },
            @intFromEnum(Signal.io_A8) => .{ .glb = 0, .mc = 8 },
            @intFromEnum(Signal.io_A9) => .{ .glb = 0, .mc = 9 },
            @intFromEnum(Signal.io_A10) => .{ .glb = 0, .mc = 10 },
            @intFromEnum(Signal.io_A12) => .{ .glb = 0, .mc = 12 },
            @intFromEnum(Signal.io_A13) => .{ .glb = 0, .mc = 13 },
            @intFromEnum(Signal.io_A14) => .{ .glb = 0, .mc = 14 },
            @intFromEnum(Signal.mc_A0)...@intFromEnum(Signal.mc_A15) => .{ .glb = 0, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_A0)) },
            @intFromEnum(Signal.io_B0) => .{ .glb = 1, .mc = 0 },
            @intFromEnum(Signal.io_B1) => .{ .glb = 1, .mc = 1 },
            @intFromEnum(Signal.io_B2) => .{ .glb = 1, .mc = 2 },
            @intFromEnum(Signal.io_B4) => .{ .glb = 1, .mc = 4 },
            @intFromEnum(Signal.io_B5) => .{ .glb = 1, .mc = 5 },
            @intFromEnum(Signal.io_B6) => .{ .glb = 1, .mc = 6 },
            @intFromEnum(Signal.io_B8) => .{ .glb = 1, .mc = 8 },
            @intFromEnum(Signal.io_B9) => .{ .glb = 1, .mc = 9 },
            @intFromEnum(Signal.io_B10) => .{ .glb = 1, .mc = 10 },
            @intFromEnum(Signal.io_B12) => .{ .glb = 1, .mc = 12 },
            @intFromEnum(Signal.io_B13) => .{ .glb = 1, .mc = 13 },
            @intFromEnum(Signal.io_B14) => .{ .glb = 1, .mc = 14 },
            @intFromEnum(Signal.mc_B0)...@intFromEnum(Signal.mc_B15) => .{ .glb = 1, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_B0)) },
            @intFromEnum(Signal.io_C0) => .{ .glb = 2, .mc = 0 },
            @intFromEnum(Signal.io_C1) => .{ .glb = 2, .mc = 1 },
            @intFromEnum(Signal.io_C2) => .{ .glb = 2, .mc = 2 },
            @intFromEnum(Signal.io_C4) => .{ .glb = 2, .mc = 4 },
            @intFromEnum(Signal.io_C5) => .{ .glb = 2, .mc = 5 },
            @intFromEnum(Signal.io_C6) => .{ .glb = 2, .mc = 6 },
            @intFromEnum(Signal.io_C8) => .{ .glb = 2, .mc = 8 },
            @intFromEnum(Signal.io_C9) => .{ .glb = 2, .mc = 9 },
            @intFromEnum(Signal.io_C10) => .{ .glb = 2, .mc = 10 },
            @intFromEnum(Signal.io_C12) => .{ .glb = 2, .mc = 12 },
            @intFromEnum(Signal.io_C13) => .{ .glb = 2, .mc = 13 },
            @intFromEnum(Signal.io_C14) => .{ .glb = 2, .mc = 14 },
            @intFromEnum(Signal.mc_C0)...@intFromEnum(Signal.mc_C15) => .{ .glb = 2, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_C0)) },
            @intFromEnum(Signal.io_D0) => .{ .glb = 3, .mc = 0 },
            @intFromEnum(Signal.io_D1) => .{ .glb = 3, .mc = 1 },
            @intFromEnum(Signal.io_D2) => .{ .glb = 3, .mc = 2 },
            @intFromEnum(Signal.io_D4) => .{ .glb = 3, .mc = 4 },
            @intFromEnum(Signal.io_D5) => .{ .glb = 3, .mc = 5 },
            @intFromEnum(Signal.io_D6) => .{ .glb = 3, .mc = 6 },
            @intFromEnum(Signal.io_D8) => .{ .glb = 3, .mc = 8 },
            @intFromEnum(Signal.io_D9) => .{ .glb = 3, .mc = 9 },
            @intFromEnum(Signal.io_D10) => .{ .glb = 3, .mc = 10 },
            @intFromEnum(Signal.io_D12) => .{ .glb = 3, .mc = 12 },
            @intFromEnum(Signal.io_D13) => .{ .glb = 3, .mc = 13 },
            @intFromEnum(Signal.io_D14) => .{ .glb = 3, .mc = 14 },
            @intFromEnum(Signal.mc_D0)...@intFromEnum(Signal.mc_D15) => .{ .glb = 3, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_D0)) },
            @intFromEnum(Signal.io_E0) => .{ .glb = 4, .mc = 0 },
            @intFromEnum(Signal.io_E1) => .{ .glb = 4, .mc = 1 },
            @intFromEnum(Signal.io_E2) => .{ .glb = 4, .mc = 2 },
            @intFromEnum(Signal.io_E4) => .{ .glb = 4, .mc = 4 },
            @intFromEnum(Signal.io_E5) => .{ .glb = 4, .mc = 5 },
            @intFromEnum(Signal.io_E6) => .{ .glb = 4, .mc = 6 },
            @intFromEnum(Signal.io_E8) => .{ .glb = 4, .mc = 8 },
            @intFromEnum(Signal.io_E9) => .{ .glb = 4, .mc = 9 },
            @intFromEnum(Signal.io_E10) => .{ .glb = 4, .mc = 10 },
            @intFromEnum(Signal.io_E12) => .{ .glb = 4, .mc = 12 },
            @intFromEnum(Signal.io_E13) => .{ .glb = 4, .mc = 13 },
            @intFromEnum(Signal.io_E14) => .{ .glb = 4, .mc = 14 },
            @intFromEnum(Signal.mc_E0)...@intFromEnum(Signal.mc_E15) => .{ .glb = 4, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_E0)) },
            @intFromEnum(Signal.io_F0) => .{ .glb = 5, .mc = 0 },
            @intFromEnum(Signal.io_F1) => .{ .glb = 5, .mc = 1 },
            @intFromEnum(Signal.io_F2) => .{ .glb = 5, .mc = 2 },
            @intFromEnum(Signal.io_F4) => .{ .glb = 5, .mc = 4 },
            @intFromEnum(Signal.io_F5) => .{ .glb = 5, .mc = 5 },
            @intFromEnum(Signal.io_F6) => .{ .glb = 5, .mc = 6 },
            @intFromEnum(Signal.io_F8) => .{ .glb = 5, .mc = 8 },
            @intFromEnum(Signal.io_F9) => .{ .glb = 5, .mc = 9 },
            @intFromEnum(Signal.io_F10) => .{ .glb = 5, .mc = 10 },
            @intFromEnum(Signal.io_F12) => .{ .glb = 5, .mc = 12 },
            @intFromEnum(Signal.io_F13) => .{ .glb = 5, .mc = 13 },
            @intFromEnum(Signal.io_F14) => .{ .glb = 5, .mc = 14 },
            @intFromEnum(Signal.mc_F0)...@intFromEnum(Signal.mc_F15) => .{ .glb = 5, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_F0)) },
            @intFromEnum(Signal.io_G0) => .{ .glb = 6, .mc = 0 },
            @intFromEnum(Signal.io_G1) => .{ .glb = 6, .mc = 1 },
            @intFromEnum(Signal.io_G2) => .{ .glb = 6, .mc = 2 },
            @intFromEnum(Signal.io_G4) => .{ .glb = 6, .mc = 4 },
            @intFromEnum(Signal.io_G5) => .{ .glb = 6, .mc = 5 },
            @intFromEnum(Signal.io_G6) => .{ .glb = 6, .mc = 6 },
            @intFromEnum(Signal.io_G8) => .{ .glb = 6, .mc = 8 },
            @intFromEnum(Signal.io_G9) => .{ .glb = 6, .mc = 9 },
            @intFromEnum(Signal.io_G10) => .{ .glb = 6, .mc = 10 },
            @intFromEnum(Signal.io_G12) => .{ .glb = 6, .mc = 12 },
            @intFromEnum(Signal.io_G13) => .{ .glb = 6, .mc = 13 },
            @intFromEnum(Signal.io_G14) => .{ .glb = 6, .mc = 14 },
            @intFromEnum(Signal.mc_G0)...@intFromEnum(Signal.mc_G15) => .{ .glb = 6, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_G0)) },
            @intFromEnum(Signal.io_H0) => .{ .glb = 7, .mc = 0 },
            @intFromEnum(Signal.io_H1) => .{ .glb = 7, .mc = 1 },
            @intFromEnum(Signal.io_H2) => .{ .glb = 7, .mc = 2 },
            @intFromEnum(Signal.io_H4) => .{ .glb = 7, .mc = 4 },
            @intFromEnum(Signal.io_H5) => .{ .glb = 7, .mc = 5 },
            @intFromEnum(Signal.io_H6) => .{ .glb = 7, .mc = 6 },
            @intFromEnum(Signal.io_H8) => .{ .glb = 7, .mc = 8 },
            @intFromEnum(Signal.io_H9) => .{ .glb = 7, .mc = 9 },
            @intFromEnum(Signal.io_H10) => .{ .glb = 7, .mc = 10 },
            @intFromEnum(Signal.io_H12) => .{ .glb = 7, .mc = 12 },
            @intFromEnum(Signal.io_H13) => .{ .glb = 7, .mc = 13 },
            @intFromEnum(Signal.io_H14) => .{ .glb = 7, .mc = 14 },
            @intFromEnum(Signal.mc_H0)...@intFromEnum(Signal.mc_H15) => .{ .glb = 7, .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_H0)) },
            else => null,
        };
    }
    pub inline fn mc(self: Signal) lc4k.MC_Ref {
        return self.maybe_mc() orelse std.debug.panic("Signal {t} is not associated with a macrocell", .{ self });
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
        return switch (self) {
            .clk0 => pins.A7,
            .clk1 => pins.L6,
            .clk2 => pins.M6,
            .clk3 => pins.C7,
            .io_A0 => pins.D6,
            .io_A1 => pins.B6,
            .io_A2 => pins.A6,
            .io_A4 => pins.C6,
            .io_A5 => pins.B5,
            .io_A6 => pins.A5,
            .io_A8 => pins.A4,
            .io_A9 => pins.B4,
            .io_A10 => pins.C5,
            .io_A12 => pins.A3,
            .io_A13 => pins.C4,
            .io_A14 => pins.B3,
            .io_B0 => pins.B2,
            .io_B1 => pins.B1,
            .io_B2 => pins.C3,
            .io_B4 => pins.C2,
            .io_B5 => pins.C1,
            .io_B6 => pins.D1,
            .io_B8 => pins.E1,
            .io_B9 => pins.E2,
            .io_B10 => pins.F2,
            .io_B12 => pins.D4,
            .io_B13 => pins.F1,
            .io_B14 => pins.F3,
            .io_C0 => pins.L1,
            .io_C1 => pins.K2,
            .io_C2 => pins.K1,
            .io_C4 => pins.J2,
            .io_C5 => pins.J3,
            .io_C6 => pins.J1,
            .io_C8 => pins.H3,
            .io_C9 => pins.H1,
            .io_C10 => pins.G3,
            .io_C12 => pins.G2,
            .io_C13 => pins.E3,
            .io_C14 => pins.G1,
            .io_D0 => pins.K6,
            .io_D1 => pins.M5,
            .io_D2 => pins.J6,
            .io_D4 => pins.K5,
            .io_D5 => pins.L5,
            .io_D6 => pins.M4,
            .io_D8 => pins.L4,
            .io_D9 => pins.M3,
            .io_D10 => pins.K4,
            .io_D12 => pins.J4,
            .io_D13 => pins.L3,
            .io_D14 => pins.M2,
            .io_E0 => pins.K7,
            .io_E1 => pins.M7,
            .io_E2 => pins.L7,
            .io_E4 => pins.J7,
            .io_E5 => pins.L8,
            .io_E6 => pins.M8,
            .io_E8 => pins.M9,
            .io_E9 => pins.L9,
            .io_E10 => pins.K8,
            .io_E12 => pins.M10,
            .io_E13 => pins.L10,
            .io_E14 => pins.K9,
            .io_F0 => pins.L12,
            .io_F1 => pins.L11,
            .io_F2 => pins.K10,
            .io_F4 => pins.K12,
            .io_F5 => pins.J10,
            .io_F6 => pins.K11,
            .io_F8 => pins.H10,
            .io_F9 => pins.H12,
            .io_F10 => pins.G11,
            .io_F12 => pins.H11,
            .io_F13 => pins.G12,
            .io_F14 => pins.G10,
            .io_G0 => pins.B12,
            .io_G1 => pins.C11,
            .io_G2 => pins.C12,
            .io_G4 => pins.E9,
            .io_G5 => pins.D11,
            .io_G6 => pins.E10,
            .io_G8 => pins.F10,
            .io_G9 => pins.D10,
            .io_G10 => pins.E12,
            .io_G12 => pins.E11,
            .io_G13 => pins.F11,
            .io_G14 => pins.F12,
            .io_H0 => pins.B7,
            .io_H1 => pins.D7,
            .io_H2 => pins.A8,
            .io_H4 => pins.C8,
            .io_H5 => pins.B8,
            .io_H6 => pins.A9,
            .io_H8 => pins.A10,
            .io_H9 => pins.C9,
            .io_H10 => pins.B9,
            .io_H12 => pins.D9,
            .io_H13 => pins.A11,
            .io_H14 => pins.B10,
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
    .{ .mc_E0, .mc_E1, .mc_E2, .mc_E3, .mc_E4, .mc_E5, .mc_E6, .mc_E7, .mc_E8, .mc_E9, .mc_E10, .mc_E11, .mc_E12, .mc_E13, .mc_E14, .mc_E15, },
    .{ .mc_F0, .mc_F1, .mc_F2, .mc_F3, .mc_F4, .mc_F5, .mc_F6, .mc_F7, .mc_F8, .mc_F9, .mc_F10, .mc_F11, .mc_F12, .mc_F13, .mc_F14, .mc_F15, },
    .{ .mc_G0, .mc_G1, .mc_G2, .mc_G3, .mc_G4, .mc_G5, .mc_G6, .mc_G7, .mc_G8, .mc_G9, .mc_G10, .mc_G11, .mc_G12, .mc_G13, .mc_G14, .mc_G15, },
    .{ .mc_H0, .mc_H1, .mc_H2, .mc_H3, .mc_H4, .mc_H5, .mc_H6, .mc_H7, .mc_H8, .mc_H9, .mc_H10, .mc_H11, .mc_H12, .mc_H13, .mc_H14, .mc_H15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?Signal {
    .{ .io_A0, .io_A1, .io_A2, null, .io_A4, .io_A5, .io_A6, null, .io_A8, .io_A9, .io_A10, null, .io_A12, .io_A13, .io_A14, null, },
    .{ .io_B0, .io_B1, .io_B2, null, .io_B4, .io_B5, .io_B6, null, .io_B8, .io_B9, .io_B10, null, .io_B12, .io_B13, .io_B14, null, },
    .{ .io_C0, .io_C1, .io_C2, null, .io_C4, .io_C5, .io_C6, null, .io_C8, .io_C9, .io_C10, null, .io_C12, .io_C13, .io_C14, null, },
    .{ .io_D0, .io_D1, .io_D2, null, .io_D4, .io_D5, .io_D6, null, .io_D8, .io_D9, .io_D10, null, .io_D12, .io_D13, .io_D14, null, },
    .{ .io_E0, .io_E1, .io_E2, null, .io_E4, .io_E5, .io_E6, null, .io_E8, .io_E9, .io_E10, null, .io_E12, .io_E13, .io_E14, null, },
    .{ .io_F0, .io_F1, .io_F2, null, .io_F4, .io_F5, .io_F6, null, .io_F8, .io_F9, .io_F10, null, .io_F12, .io_F13, .io_F14, null, },
    .{ .io_G0, .io_G1, .io_G2, null, .io_G4, .io_G5, .io_G6, null, .io_G8, .io_G9, .io_G10, null, .io_G12, .io_G13, .io_G14, null, },
    .{ .io_H0, .io_H1, .io_H2, null, .io_H4, .io_H5, .io_H6, null, .io_H8, .io_H9, .io_H10, null, .io_H12, .io_H13, .io_H14, null, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]Signal {
    .{ .io_H12, .mc_H7, .mc_H5, .io_H1, .io_G13, .mc_E10, .mc_E9, .io_F5, .io_E1, .mc_C15, .io_C10, .mc_D7, .io_D4, .io_C1, .io_A14, .mc_A11, .io_B6, .io_A4, .mc_B1, },
    .{ .mc_G12, .mc_G8, .mc_G4, .mc_G1, .io_H14, .mc_F10, .io_F9, .io_F4, .mc_E0, .io_E14, .mc_D12, .io_C6, .mc_D4, .io_C1, .clk0, .mc_B10, .io_A6, .io_B5, .io_A1, },
    .{ .mc_H10, .mc_H8, .mc_H5, .mc_G0, .io_F13, .io_E12, .io_E8, .mc_E4, .io_F0, .io_D14, .mc_C13, .mc_C8, .mc_D4, .io_D1, .mc_B14, .mc_B13, .io_A6, .mc_A3, .mc_A2, },
    .{ .mc_H11, .mc_G9, .io_H4, .mc_G0, .io_G14, .io_F10, .io_E6, .mc_F5, .mc_F0, .mc_D15, .mc_D10, .mc_C7, .mc_C5, .io_C2, .clk1, .mc_A13, .mc_A7, .io_A4, .mc_B0, },
    .{ .mc_H12, .io_G9, .mc_G6, .io_H1, .mc_H14, .mc_E12, .mc_F9, .io_E5, .io_F2, .io_C14, .mc_D10, .io_C9, .mc_D4, .mc_D2, .mc_A14, .mc_A13, .io_B9, .mc_A4, .io_B2, },
    .{ .mc_G13, .io_G8, .io_G4, .io_H2, .io_G14, .io_F12, .mc_E9, .io_E5, .io_F0, .io_E14, .mc_C13, .mc_C9, .mc_C6, .mc_C1, .mc_A15, .io_B10, .io_B8, .io_B4, .io_A2, },
    .{ .mc_G12, .io_H6, .mc_G3, .io_G1, .mc_H14, .mc_F13, .io_E9, .mc_F4, .mc_F1, .mc_E15, .mc_C13, .io_D6, .mc_D5, .mc_C2, .mc_B15, .io_B12, .io_B6, .io_A5, .mc_B0, },
    .{ .mc_H13, .mc_H8, .io_G5, .io_G2, .mc_H15, .mc_F12, .mc_E7, .mc_E6, .io_E2, .mc_C15, .mc_C10, .mc_D9, .mc_C5, .io_D0, .mc_B15, .mc_B10, .mc_A9, .mc_B4, .io_B2, },
    .{ .mc_G11, .io_H8, .mc_G6, .mc_H2, .io_F14, .io_F10, .mc_F7, .mc_F6, .io_E0, .io_E13, .io_C10, .io_C6, .mc_C4, .mc_C1, .clk3, .mc_B11, .mc_A9, .io_A5, .mc_A2, },
    .{ .io_G12, .mc_H9, .mc_G6, .mc_G2, .mc_F14, .io_E10, .io_F9, .mc_E6, .io_F1, .mc_C14, .io_D12, .io_D9, .mc_C5, .io_C0, .mc_B14, .io_A12, .io_B6, .io_B4, .mc_A0, },
    .{ .mc_G12, .mc_G7, .io_G4, .mc_G0, .io_F14, .mc_F12, .io_F6, .io_F5, .io_F2, .mc_C14, .mc_C10, .mc_D8, .io_C4, .mc_C0, .clk2, .mc_B12, .mc_B7, .mc_B6, .io_B1, },
    .{ .mc_G10, .mc_G7, .mc_H3, .io_H1, .mc_F14, .mc_F11, .io_E6, .mc_E6, .mc_E1, .io_D14, .mc_D12, .mc_C9, .mc_C4, .mc_C2, .io_B13, .mc_A10, .mc_A8, .mc_A6, .io_A0, },
    .{ .io_H10, .mc_G8, .io_H5, .mc_H2, .mc_F14, .io_E12, .mc_E9, .mc_E5, .mc_E0, .mc_E15, .io_D10, .io_C9, .mc_D3, .mc_D0, .clk2, .mc_A12, .io_A9, .io_B4, .io_B2, },
    .{ .io_G10, .mc_H9, .mc_G3, .mc_H1, .io_H13, .mc_E10, .mc_F8, .mc_E4, .io_E0, .mc_D15, .mc_C10, .io_C8, .mc_C6, .mc_D1, .clk0, .mc_A12, .io_A8, .mc_A4, .io_A0, },
    .{ .mc_H10, .io_G6, .mc_G5, .mc_H0, .mc_H15, .io_F12, .mc_F8, .mc_F5, .mc_E0, .io_E13, .io_D12, .io_D6, .io_C5, .mc_D2, .clk1, .mc_A11, .mc_A8, .mc_B3, .io_B1, },
    .{ .io_G10, .mc_G9, .mc_G5, .io_H2, .io_H14, .mc_F10, .mc_E7, .mc_F6, .io_E1, .io_C13, .mc_D11, .io_D9, .io_C4, .io_D2, .mc_A14, .mc_B13, .io_A9, .mc_A6, .mc_B0, },
    .{ .mc_H12, .mc_G7, .mc_G4, .io_G2, .io_G13, .mc_E11, .io_E9, .mc_E4, .mc_F2, .mc_E14, .io_C12, .io_C9, .mc_C3, .io_D2, .clk3, .io_B10, .mc_A7, .mc_B3, .mc_A0, },
    .{ .io_G12, .io_G9, .mc_H6, .mc_G1, .mc_G14, .io_F10, .io_E8, .io_E4, .mc_E2, .io_C13, .io_D10, .mc_D8, .mc_C4, .io_D0, .mc_A15, .io_B12, .io_A8, .mc_B3, .mc_B1, },
    .{ .mc_G13, .io_G6, .mc_G3, .mc_H0, .mc_G15, .mc_E11, .io_E8, .io_F4, .mc_F1, .mc_C15, .mc_D10, .io_D9, .mc_D6, .mc_D0, .io_B13, .mc_B11, .mc_B7, .mc_B6, .mc_A1, },
    .{ .io_H12, .mc_H8, .mc_H3, .mc_H2, .mc_G14, .io_F12, .io_F8, .mc_F6, .mc_F1, .io_C14, .mc_C11, .mc_C7, .mc_C3, .io_C0, .clk0, .mc_B12, .mc_B9, .mc_B5, .io_B0, },
    .{ .mc_G13, .mc_G9, .mc_H3, .io_G0, .mc_H14, .io_E12, .mc_F7, .mc_E3, .io_F1, .mc_E14, .mc_D13, .io_C8, .io_C5, .mc_C0, .io_A14, .mc_B10, .io_A8, .mc_B4, .mc_B2, },
    .{ .mc_H12, .io_H9, .io_H5, .io_H0, .mc_G15, .mc_E13, .mc_F7, .io_E4, .mc_F0, .mc_D14, .mc_C12, .mc_D8, .mc_C6, .io_C0, .mc_B15, .mc_B13, .mc_A8, .io_A4, .io_A1, },
    .{ .io_H12, .io_G9, .io_G5, .mc_G2, .mc_G15, .mc_F12, .mc_E8, .mc_E5, .mc_E1, .io_E14, .io_C12, .mc_C8, .io_C4, .mc_D1, .clk1, .io_A10, .mc_B8, .io_A5, .mc_B2, },
    .{ .io_H10, .io_G8, .mc_H5, .mc_G1, .io_G13, .io_E10, .io_F8, .mc_F4, .mc_F0, .io_D13, .mc_D11, .io_D8, .io_C5, .mc_D1, .io_A13, .mc_A10, .mc_A9, .mc_A4, .mc_A1, },
    .{ .mc_G10, .io_H9, .mc_H6, .io_G2, .io_H13, .mc_F11, .io_F6, .mc_F3, .io_F0, .io_C14, .mc_D11, .io_D6, .mc_D3, .io_C2, .io_A14, .mc_B11, .mc_B8, .io_B5, .mc_A0, },
    .{ .mc_H13, .io_G6, .io_H5, .mc_H1, .mc_F15, .mc_E12, .mc_E8, .io_F5, .io_F1, .io_C13, .io_C12, .io_C6, .io_D5, .io_C2, .io_A13, .mc_A10, .mc_B9, .mc_A3, .io_A2, },
    .{ .mc_G10, .io_H8, .io_H4, .io_H2, .io_F13, .mc_E12, .io_E9, .mc_E5, .io_E2, .io_D13, .mc_C12, .io_C8, .io_D4, .io_D0, .io_B14, .mc_A11, .mc_B7, .mc_B5, .io_A1, },
    .{ .mc_H13, .io_H9, .mc_H4, .io_G1, .io_F13, .mc_F10, .mc_F8, .mc_F4, .io_F2, .mc_E14, .io_D10, .mc_C7, .mc_D6, .mc_C1, .io_B13, .io_A12, .mc_B8, .mc_A5, .mc_B1, },
    .{ .mc_H11, .io_G8, .mc_G5, .mc_H1, .io_F14, .mc_E13, .io_F9, .mc_F3, .mc_E2, .io_D14, .io_C10, .mc_C8, .mc_D5, .mc_D0, .io_B14, .io_B10, .io_B9, .mc_B4, .io_B0, },
    .{ .mc_G11, .mc_G8, .io_H4, .io_G1, .mc_H15, .mc_E10, .io_F6, .io_E5, .mc_E2, .mc_D14, .mc_C11, .mc_D7, .io_D5, .mc_C0, .mc_B14, .io_A10, .mc_A7, .mc_A6, .mc_A1, },
    .{ .mc_H10, .mc_H7, .io_G5, .io_G0, .io_G14, .io_E10, .mc_F9, .io_F4, .io_E0, .mc_D14, .mc_D13, .mc_C9, .mc_D3, .io_D2, .io_B14, .io_B12, .mc_B9, .mc_A5, .io_B1, },
    .{ .io_H10, .mc_H7, .io_G4, .mc_H0, .io_H13, .mc_F13, .mc_E7, .io_E4, .mc_F2, .mc_D15, .mc_D12, .io_D8, .io_D5, .io_D1, .clk3, .io_A12, .io_B9, .mc_B5, .mc_B2, },
    .{ .io_G12, .mc_H9, .mc_H4, .io_G0, .io_H14, .mc_F13, .io_E6, .mc_F3, .io_E1, .mc_E15, .mc_C12, .mc_D9, .mc_C3, .mc_D2, .io_A13, .io_A10, .io_B8, .mc_B6, .mc_A2, },
    .{ .mc_H11, .io_H8, .mc_H4, .io_H0, .mc_F15, .mc_E11, .mc_F9, .mc_E3, .mc_E1, .io_D13, .io_D12, .mc_D7, .mc_D5, .io_D1, .mc_A15, .mc_B12, .io_A9, .io_B5, .io_A0, },
    .{ .mc_G11, .io_H6, .mc_G4, .io_H0, .mc_G14, .mc_F11, .mc_E8, .mc_F5, .io_E2, .mc_C14, .mc_D13, .io_D8, .mc_D6, .io_C1, .mc_A14, .mc_A12, .io_B8, .mc_A3, .io_B0, },
    .{ .io_G10, .io_H6, .mc_H6, .mc_G2, .mc_F15, .mc_E13, .io_F8, .mc_E3, .mc_F2, .io_E13, .mc_C11, .mc_D9, .io_D4, .mc_C2, .clk2, .mc_A13, .io_A6, .mc_A5, .io_A2, },
};

pub const gi_options_by_signal = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

const base = @import("LC4128V_TQFP144.zig");
pub const get_glb_range = base.get_glb_range;
pub const get_gi_range = base.get_gi_range;
pub const get_bclock_range = base.get_bclock_range;

pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(90, 101),
        1 => Fuse.init(91, 101),
        2 => Fuse.init(92, 101),
        3 => Fuse.init(93, 101),
        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) ?Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 101),
        1 => Fuse.init(89, 101),
        else => null,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 101);
}

pub fn get_osctimer_enable_range() Fuse_Range {
    return Fuse_Range.between(
        Fuse.init(91, 98),
        Fuse.init(92, 98),
    );
}

pub fn get_osc_out_fuse() Fuse {
    return Fuse.init(93, 100);
}

pub fn get_timer_out_fuse() Fuse {
    return Fuse.init(93, 99);
}

pub fn get_timer_div_range() Fuse_Range {
    return Fuse.init(92, 99)
        .range().expand_to_contain(Fuse.init(92, 100));
}

pub fn get_input_power_guard_fuse(input: Signal) ?Fuse {
    return switch (input) {
        .clk0 => Fuse.init(87, 98),
        .clk1 => Fuse.init(88, 98),
        .clk2 => Fuse.init(89, 98),
        .clk3 => Fuse.init(90, 98),
        else => null,
    };
}

pub fn get_input_bus_maintenance_range(input: Signal) ?Fuse_Range {
    return switch (input) {
        .clk0 => Fuse_Range.between(Fuse.init(85, 101), Fuse.init(86, 101)),
        .clk1 => Fuse_Range.between(Fuse.init(85, 100), Fuse.init(86, 100)),
        .clk2 => Fuse_Range.between(Fuse.init(85, 99), Fuse.init(86, 99)),
        .clk3 => Fuse_Range.between(Fuse.init(85, 98), Fuse.init(86, 98)),
        else => null,
    };
}

pub fn get_input_threshold_fuse(input: Signal) ?Fuse {
    return switch (input) {
        .clk0 => Fuse.init(94, 98),
        .clk1 => Fuse.init(94, 99),
        .clk2 => Fuse.init(94, 100),
        .clk3 => Fuse.init(94, 101),
        else => null,
    };
}

pub const pins = struct {
    pub const A1 = Pin.init_misc(0, "A1", null, .tdi);
    pub const A2 = Pin.init_misc(1, "A2", null, .no_connect);
    pub const A3 = Pin.init_io(2, "A3", 0, .io_A12);
    pub const A4 = Pin.init_io(3, "A4", 0, .io_A8);
    pub const A5 = Pin.init_io(4, "A5", 0, .io_A6);
    pub const A6 = Pin.init_io(5, "A6", 0, .io_A2);
    pub const A7 = Pin.init_clk(6, "A7", 0, .clk0, 0, 0);
    pub const A8 = Pin.init_io(7, "A8", 1, .io_H2);
    pub const A9 = Pin.init_io(8, "A9", 1, .io_H6);
    pub const A10 = Pin.init_io(9, "A10", 1, .io_H8);
    pub const A11 = Pin.init_io(10, "A11", 1, .io_H13);
    pub const A12 = Pin.init_misc(11, "A12", null, .no_connect);
    pub const B1 = Pin.init_io(12, "B1", 0, .io_B1);
    pub const B2 = Pin.init_io(13, "B2", 0, .io_B0);
    pub const B3 = Pin.init_io(14, "B3", 0, .io_A14);
    pub const B4 = Pin.init_io(15, "B4", 0, .io_A9);
    pub const B5 = Pin.init_io(16, "B5", 0, .io_A5);
    pub const B6 = Pin.init_io(17, "B6", 0, .io_A1);
    pub const B7 = Pin.init_oe(18, "B7", 1, .io_H0, 1);
    pub const B8 = Pin.init_io(19, "B8", 1, .io_H5);
    pub const B9 = Pin.init_io(20, "B9", 1, .io_H10);
    pub const B10 = Pin.init_io(21, "B10", 1, .io_H14);
    pub const B11 = Pin.init_misc(22, "B11", null, .tdo);
    pub const B12 = Pin.init_io(23, "B12", 1, .io_G0);
    pub const C1 = Pin.init_io(24, "C1", 0, .io_B5);
    pub const C2 = Pin.init_io(25, "C2", 0, .io_B4);
    pub const C3 = Pin.init_io(26, "C3", 0, .io_B2);
    pub const C4 = Pin.init_io(27, "C4", 0, .io_A13);
    pub const C5 = Pin.init_io(28, "C5", 0, .io_A10);
    pub const C6 = Pin.init_io(29, "C6", 0, .io_A4);
    pub const C7 = Pin.init_clk(30, "C7", 1, .clk3, 3, 7);
    pub const C8 = Pin.init_io(31, "C8", 1, .io_H4);
    pub const C9 = Pin.init_io(32, "C9", 1, .io_H9);
    pub const C10 = Pin.init_misc(33, "C10", null, .no_connect);
    pub const C11 = Pin.init_io(34, "C11", 1, .io_G1);
    pub const C12 = Pin.init_io(35, "C12", 1, .io_G2);
    pub const D1 = Pin.init_io(36, "D1", 0, .io_B6);
    pub const D2 = Pin.init_misc(37, "D2", null, .no_connect);
    pub const D3 = Pin.init_misc(38, "D3", null, .no_connect);
    pub const D4 = Pin.init_io(39, "D4", 0, .io_B12);
    pub const D5 = Pin.init_misc(40, "D5", 0, .vcco);
    pub const D6 = Pin.init_oe(41, "D6", 0, .io_A0, 0);
    pub const D7 = Pin.init_io(42, "D7", 1, .io_H1);
    pub const D8 = Pin.init_misc(43, "D8", 1, .vcco);
    pub const D9 = Pin.init_io(44, "D9", 1, .io_H12);
    pub const D10 = Pin.init_io(45, "D10", 1, .io_G9);
    pub const D11 = Pin.init_io(46, "D11", 1, .io_G5);
    pub const D12 = Pin.init_misc(47, "D12", null, .no_connect);
    pub const E1 = Pin.init_io(48, "E1", 0, .io_B8);
    pub const E2 = Pin.init_io(49, "E2", 0, .io_B9);
    pub const E3 = Pin.init_io(50, "E3", 0, .io_C13);
    pub const E4 = Pin.init_misc(51, "E4", 0, .vcco);
    pub const E5 = Pin.init_misc(52, "E5", null, .vcc_core);
    pub const E6 = Pin.init_misc(53, "E6", 0, .gndo);
    pub const E7 = Pin.init_misc(54, "E7", 1, .gndo);
    pub const E8 = Pin.init_misc(55, "E8", null, .vcc_core);
    pub const E9 = Pin.init_io(56, "E9", 1, .io_G4);
    pub const E10 = Pin.init_io(57, "E10", 1, .io_G6);
    pub const E11 = Pin.init_io(58, "E11", 1, .io_G12);
    pub const E12 = Pin.init_io(59, "E12", 1, .io_G10);
    pub const F1 = Pin.init_io(60, "F1", 0, .io_B13);
    pub const F2 = Pin.init_io(61, "F2", 0, .io_B10);
    pub const F3 = Pin.init_io(62, "F3", 0, .io_B14);
    pub const F4 = Pin.init_misc(63, "F4", 0, .vcco);
    pub const F5 = Pin.init_misc(64, "F5", 0, .gndo);
    pub const F6 = Pin.init_misc(65, "F6", null, .gnd);
    pub const F7 = Pin.init_misc(66, "F7", null, .gnd);
    pub const F8 = Pin.init_misc(67, "F8", 1, .gndo);
    pub const F9 = Pin.init_misc(68, "F9", 1, .vcco);
    pub const F10 = Pin.init_io(69, "F10", 1, .io_G8);
    pub const F11 = Pin.init_io(70, "F11", 1, .io_G13);
    pub const F12 = Pin.init_io(71, "F12", 1, .io_G14);
    pub const G1 = Pin.init_io(72, "G1", 0, .io_C14);
    pub const G2 = Pin.init_io(73, "G2", 0, .io_C12);
    pub const G3 = Pin.init_io(74, "G3", 0, .io_C10);
    pub const G4 = Pin.init_misc(75, "G4", 0, .vcco);
    pub const G5 = Pin.init_misc(76, "G5", 0, .gndo);
    pub const G6 = Pin.init_misc(77, "G6", null, .gnd);
    pub const G7 = Pin.init_misc(78, "G7", null, .gnd);
    pub const G8 = Pin.init_misc(79, "G8", 1, .gndo);
    pub const G9 = Pin.init_misc(80, "G9", 1, .vcco);
    pub const G10 = Pin.init_io(81, "G10", 1, .io_F14);
    pub const G11 = Pin.init_io(82, "G11", 1, .io_F10);
    pub const G12 = Pin.init_io(83, "G12", 1, .io_F13);
    pub const H1 = Pin.init_io(84, "H1", 0, .io_C9);
    pub const H2 = Pin.init_misc(85, "H2", null, .no_connect);
    pub const H3 = Pin.init_io(86, "H3", 0, .io_C8);
    pub const H4 = Pin.init_misc(87, "H4", 0, .gndo);
    pub const H5 = Pin.init_misc(88, "H5", null, .vcc_core);
    pub const H6 = Pin.init_misc(89, "H6", 0, .gndo);
    pub const H7 = Pin.init_misc(90, "H7", 1, .gndo);
    pub const H8 = Pin.init_misc(91, "H8", null, .vcc_core);
    pub const H9 = Pin.init_misc(92, "H9", 1, .vcco);
    pub const H10 = Pin.init_io(93, "H10", 1, .io_F8);
    pub const H11 = Pin.init_io(94, "H11", 1, .io_F12);
    pub const H12 = Pin.init_io(95, "H12", 1, .io_F9);
    pub const J1 = Pin.init_io(96, "J1", 0, .io_C6);
    pub const J2 = Pin.init_io(97, "J2", 0, .io_C4);
    pub const J3 = Pin.init_io(98, "J3", 0, .io_C5);
    pub const J4 = Pin.init_io(99, "J4", 0, .io_D12);
    pub const J5 = Pin.init_misc(100, "J5", 0, .vcco);
    pub const J6 = Pin.init_io(101, "J6", 0, .io_D2);
    pub const J7 = Pin.init_io(102, "J7", 1, .io_E4);
    pub const J8 = Pin.init_misc(103, "J8", 1, .vcco);
    pub const J9 = Pin.init_misc(104, "J9", 1, .gndo);
    pub const J10 = Pin.init_io(105, "J10", 1, .io_F5);
    pub const J11 = Pin.init_misc(106, "J11", null, .no_connect);
    pub const J12 = Pin.init_misc(107, "J12", null, .no_connect);
    pub const K1 = Pin.init_io(108, "K1", 0, .io_C2);
    pub const K2 = Pin.init_io(109, "K2", 0, .io_C1);
    pub const K3 = Pin.init_misc(110, "K3", null, .no_connect);
    pub const K4 = Pin.init_io(111, "K4", 0, .io_D10);
    pub const K5 = Pin.init_io(112, "K5", 0, .io_D4);
    pub const K6 = Pin.init_io(113, "K6", 0, .io_D0);
    pub const K7 = Pin.init_io(114, "K7", 1, .io_E0);
    pub const K8 = Pin.init_io(115, "K8", 1, .io_E10);
    pub const K9 = Pin.init_io(116, "K9", 1, .io_E14);
    pub const K10 = Pin.init_io(117, "K10", 1, .io_F2);
    pub const K11 = Pin.init_io(118, "K11", 1, .io_F6);
    pub const K12 = Pin.init_io(119, "K12", 1, .io_F4);
    pub const L1 = Pin.init_io(120, "L1", 0, .io_C0);
    pub const L2 = Pin.init_misc(121, "L2", null, .tck);
    pub const L3 = Pin.init_io(122, "L3", 0, .io_D13);
    pub const L4 = Pin.init_io(123, "L4", 0, .io_D8);
    pub const L5 = Pin.init_io(124, "L5", 0, .io_D5);
    pub const L6 = Pin.init_clk(125, "L6", 0, .clk1, 1, 3);
    pub const L7 = Pin.init_io(126, "L7", 1, .io_E2);
    pub const L8 = Pin.init_io(127, "L8", 1, .io_E5);
    pub const L9 = Pin.init_io(128, "L9", 1, .io_E9);
    pub const L10 = Pin.init_io(129, "L10", 1, .io_E13);
    pub const L11 = Pin.init_io(130, "L11", 1, .io_F1);
    pub const L12 = Pin.init_io(131, "L12", 1, .io_F0);
    pub const M1 = Pin.init_misc(132, "M1", null, .no_connect);
    pub const M2 = Pin.init_io(133, "M2", 0, .io_D14);
    pub const M3 = Pin.init_io(134, "M3", 0, .io_D9);
    pub const M4 = Pin.init_io(135, "M4", 0, .io_D6);
    pub const M5 = Pin.init_io(136, "M5", 0, .io_D1);
    pub const M6 = Pin.init_clk(137, "M6", 1, .clk2, 2, 4);
    pub const M7 = Pin.init_io(138, "M7", 1, .io_E1);
    pub const M8 = Pin.init_io(139, "M8", 1, .io_E6);
    pub const M9 = Pin.init_io(140, "M9", 1, .io_E8);
    pub const M10 = Pin.init_io(141, "M10", 1, .io_E12);
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
    pins.E4,
    pins.F4,
    pins.G4,
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
    pins.F9,
    pins.G9,
    pins.H9,
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
