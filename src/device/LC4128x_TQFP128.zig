//[[!! include('devices', 'LC4128x_TQFP128') !! 819 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.LC4128x_TQFP128;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP128;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;
pub const oe_bus_size = 4;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(740, 100);

pub const F = lc4k.Factor(GRP);
pub const PT = lc4k.Product_Term(GRP);
pub const Pin = lc4k.Pin(GRP);
pub const Names = naming.Names(@This());

var name_buf: [32768]u8 = undefined;
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

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_H14) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_H15) => .mc,
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
            @intFromEnum(GRP.io_E0)...@intFromEnum(GRP.io_E14) => .{ .glb = 4, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_E0)) },
            @intFromEnum(GRP.mc_E0)...@intFromEnum(GRP.mc_E15) => .{ .glb = 4, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_E0)) },
            @intFromEnum(GRP.io_F0)...@intFromEnum(GRP.io_F14) => .{ .glb = 5, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_F0)) },
            @intFromEnum(GRP.mc_F0)...@intFromEnum(GRP.mc_F15) => .{ .glb = 5, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_F0)) },
            @intFromEnum(GRP.io_G0)...@intFromEnum(GRP.io_G14) => .{ .glb = 6, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_G0)) },
            @intFromEnum(GRP.mc_G0)...@intFromEnum(GRP.mc_G15) => .{ .glb = 6, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_G0)) },
            @intFromEnum(GRP.io_H0)...@intFromEnum(GRP.io_H14) => .{ .glb = 7, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.io_H0)) },
            @intFromEnum(GRP.mc_H0)...@intFromEnum(GRP.mc_H15) => .{ .glb = 7, .mc = @intCast(@intFromEnum(self) - @intFromEnum(GRP.mc_H0)) },
            else => null,
        };
    }
    pub inline fn mc(self: GRP) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: GRP) ?Pin {
        return switch (self) {
            .clk0 => pins._114,
            .clk1 => pins._48,
            .clk2 => pins._50,
            .clk3 => pins._112,
            .io_A0 => pins._116,
            .io_A1 => pins._117,
            .io_A2 => pins._118,
            .io_A4 => pins._119,
            .io_A5 => pins._120,
            .io_A6 => pins._121,
            .io_A8 => pins._124,
            .io_A9 => pins._125,
            .io_A10 => pins._126,
            .io_A12 => pins._127,
            .io_A14 => pins._128,
            .io_B0 => pins._4,
            .io_B1 => pins._5,
            .io_B2 => pins._6,
            .io_B4 => pins._7,
            .io_B5 => pins._8,
            .io_B6 => pins._9,
            .io_B8 => pins._11,
            .io_B9 => pins._12,
            .io_B10 => pins._13,
            .io_B12 => pins._14,
            .io_B13 => pins._15,
            .io_B14 => pins._16,
            .io_C0 => pins._29,
            .io_C2 => pins._28,
            .io_C4 => pins._27,
            .io_C5 => pins._26,
            .io_C6 => pins._25,
            .io_C8 => pins._23,
            .io_C9 => pins._22,
            .io_C10 => pins._21,
            .io_C12 => pins._20,
            .io_C13 => pins._19,
            .io_C14 => pins._18,
            .io_D0 => pins._47,
            .io_D1 => pins._46,
            .io_D2 => pins._45,
            .io_D4 => pins._44,
            .io_D5 => pins._43,
            .io_D6 => pins._42,
            .io_D8 => pins._39,
            .io_D9 => pins._38,
            .io_D10 => pins._37,
            .io_D12 => pins._36,
            .io_D13 => pins._35,
            .io_D14 => pins._34,
            .io_E0 => pins._52,
            .io_E1 => pins._53,
            .io_E2 => pins._54,
            .io_E4 => pins._55,
            .io_E5 => pins._56,
            .io_E6 => pins._57,
            .io_E8 => pins._60,
            .io_E9 => pins._61,
            .io_E10 => pins._62,
            .io_E12 => pins._63,
            .io_E14 => pins._64,
            .io_F0 => pins._68,
            .io_F1 => pins._69,
            .io_F2 => pins._70,
            .io_F4 => pins._71,
            .io_F5 => pins._72,
            .io_F6 => pins._73,
            .io_F8 => pins._75,
            .io_F9 => pins._76,
            .io_F10 => pins._77,
            .io_F12 => pins._78,
            .io_F13 => pins._79,
            .io_F14 => pins._80,
            .io_G0 => pins._93,
            .io_G2 => pins._92,
            .io_G4 => pins._91,
            .io_G5 => pins._90,
            .io_G6 => pins._89,
            .io_G8 => pins._87,
            .io_G9 => pins._86,
            .io_G10 => pins._85,
            .io_G12 => pins._84,
            .io_G13 => pins._83,
            .io_G14 => pins._82,
            .io_H0 => pins._111,
            .io_H1 => pins._110,
            .io_H2 => pins._109,
            .io_H4 => pins._108,
            .io_H5 => pins._107,
            .io_H6 => pins._106,
            .io_H8 => pins._103,
            .io_H9 => pins._102,
            .io_H10 => pins._101,
            .io_H12 => pins._100,
            .io_H13 => pins._99,
            .io_H14 => pins._98,
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
    .{ .mc_E0, .mc_E1, .mc_E2, .mc_E3, .mc_E4, .mc_E5, .mc_E6, .mc_E7, .mc_E8, .mc_E9, .mc_E10, .mc_E11, .mc_E12, .mc_E13, .mc_E14, .mc_E15, },
    .{ .mc_F0, .mc_F1, .mc_F2, .mc_F3, .mc_F4, .mc_F5, .mc_F6, .mc_F7, .mc_F8, .mc_F9, .mc_F10, .mc_F11, .mc_F12, .mc_F13, .mc_F14, .mc_F15, },
    .{ .mc_G0, .mc_G1, .mc_G2, .mc_G3, .mc_G4, .mc_G5, .mc_G6, .mc_G7, .mc_G8, .mc_G9, .mc_G10, .mc_G11, .mc_G12, .mc_G13, .mc_G14, .mc_G15, },
    .{ .mc_H0, .mc_H1, .mc_H2, .mc_H3, .mc_H4, .mc_H5, .mc_H6, .mc_H7, .mc_H8, .mc_H9, .mc_H10, .mc_H11, .mc_H12, .mc_H13, .mc_H14, .mc_H15, },
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?GRP {
    .{ .io_A0, .io_A1, .io_A2, null, .io_A4, .io_A5, .io_A6, null, .io_A8, .io_A9, .io_A10, null, .io_A12, .io_A13, .io_A14, null, },
    .{ .io_B0, .io_B1, .io_B2, null, .io_B4, .io_B5, .io_B6, null, .io_B8, .io_B9, .io_B10, null, .io_B12, .io_B13, .io_B14, null, },
    .{ .io_C0, .io_C1, .io_C2, null, .io_C4, .io_C5, .io_C6, null, .io_C8, .io_C9, .io_C10, null, .io_C12, .io_C13, .io_C14, null, },
    .{ .io_D0, .io_D1, .io_D2, null, .io_D4, .io_D5, .io_D6, null, .io_D8, .io_D9, .io_D10, null, .io_D12, .io_D13, .io_D14, null, },
    .{ .io_E0, .io_E1, .io_E2, null, .io_E4, .io_E5, .io_E6, null, .io_E8, .io_E9, .io_E10, null, .io_E12, .io_E13, .io_E14, null, },
    .{ .io_F0, .io_F1, .io_F2, null, .io_F4, .io_F5, .io_F6, null, .io_F8, .io_F9, .io_F10, null, .io_F12, .io_F13, .io_F14, null, },
    .{ .io_G0, .io_G1, .io_G2, null, .io_G4, .io_G5, .io_G6, null, .io_G8, .io_G9, .io_G10, null, .io_G12, .io_G13, .io_G14, null, },
    .{ .io_H0, .io_H1, .io_H2, null, .io_H4, .io_H5, .io_H6, null, .io_H8, .io_H9, .io_H10, null, .io_H12, .io_H13, .io_H14, null, },
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {
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

pub const gi_options_by_grp = lc4k.invert_gi_mapping(GRP, gi_mux_size, &gi_options);

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

pub fn get_goe_source_fuse(goe: usize) Fuse {
    return switch (goe) {
        0 => Fuse.init(88, 101),
        1 => Fuse.init(89, 101),
        else => unreachable,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(87, 101);
}


pub fn get_global_bus_maintenance_range() Fuse_Range {
    return Fuse.init(85, 101).range().expand_to_contain(Fuse.init(86, 101));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{
        Fuse.init(92, 107),
        Fuse.init(92, 269),
        Fuse.init(92, 477),
        Fuse.init(92, 639),
    };
}

pub fn get_input_threshold_fuse(input: GRP) Fuse {
    return switch (input) {
        .clk0 => Fuse.init(94, 98),
        .clk1 => Fuse.init(94, 99),
        .clk2 => Fuse.init(94, 100),
        .clk3 => Fuse.init(94, 101),
        else => unreachable,
    };
}

pub const pins = struct {
    pub const _1 = Pin.init_misc("1", .gnd);
    pub const _2 = Pin.init_misc("2", .tdi);
    pub const _3 = Pin.init_misc("3", .vcco);
    pub const _4 = Pin.init_io("4", .io_B0);
    pub const _5 = Pin.init_io("5", .io_B1);
    pub const _6 = Pin.init_io("6", .io_B2);
    pub const _7 = Pin.init_io("7", .io_B4);
    pub const _8 = Pin.init_io("8", .io_B5);
    pub const _9 = Pin.init_io("9", .io_B6);
    pub const _10 = Pin.init_misc("10", .gnd);
    pub const _11 = Pin.init_io("11", .io_B8);
    pub const _12 = Pin.init_io("12", .io_B9);
    pub const _13 = Pin.init_io("13", .io_B10);
    pub const _14 = Pin.init_io("14", .io_B12);
    pub const _15 = Pin.init_io("15", .io_B13);
    pub const _16 = Pin.init_io("16", .io_B14);
    pub const _17 = Pin.init_misc("17", .vcco);
    pub const _18 = Pin.init_io("18", .io_C14);
    pub const _19 = Pin.init_io("19", .io_C13);
    pub const _20 = Pin.init_io("20", .io_C12);
    pub const _21 = Pin.init_io("21", .io_C10);
    pub const _22 = Pin.init_io("22", .io_C9);
    pub const _23 = Pin.init_io("23", .io_C8);
    pub const _24 = Pin.init_misc("24", .gnd);
    pub const _25 = Pin.init_io("25", .io_C6);
    pub const _26 = Pin.init_io("26", .io_C5);
    pub const _27 = Pin.init_io("27", .io_C4);
    pub const _28 = Pin.init_io("28", .io_C2);
    pub const _29 = Pin.init_io("29", .io_C0);
    pub const _30 = Pin.init_misc("30", .vcco);
    pub const _31 = Pin.init_misc("31", .tck);
    pub const _32 = Pin.init_misc("32", .vcc_core);
    pub const _33 = Pin.init_misc("33", .gnd);
    pub const _34 = Pin.init_io("34", .io_D14);
    pub const _35 = Pin.init_io("35", .io_D13);
    pub const _36 = Pin.init_io("36", .io_D12);
    pub const _37 = Pin.init_io("37", .io_D10);
    pub const _38 = Pin.init_io("38", .io_D9);
    pub const _39 = Pin.init_io("39", .io_D8);
    pub const _40 = Pin.init_misc("40", .gnd);
    pub const _41 = Pin.init_misc("41", .vcco);
    pub const _42 = Pin.init_io("42", .io_D6);
    pub const _43 = Pin.init_io("43", .io_D5);
    pub const _44 = Pin.init_io("44", .io_D4);
    pub const _45 = Pin.init_io("45", .io_D2);
    pub const _46 = Pin.init_io("46", .io_D1);
    pub const _47 = Pin.init_io("47", .io_D0);
    pub const _48 = Pin.init_clk("48", .clk1, 1, 3);
    pub const _49 = Pin.init_misc("49", .gnd);
    pub const _50 = Pin.init_clk("50", .clk2, 2, 4);
    pub const _51 = Pin.init_misc("51", .vcc_core);
    pub const _52 = Pin.init_io("52", .io_E0);
    pub const _53 = Pin.init_io("53", .io_E1);
    pub const _54 = Pin.init_io("54", .io_E2);
    pub const _55 = Pin.init_io("55", .io_E4);
    pub const _56 = Pin.init_io("56", .io_E5);
    pub const _57 = Pin.init_io("57", .io_E6);
    pub const _58 = Pin.init_misc("58", .vcco);
    pub const _59 = Pin.init_misc("59", .gnd);
    pub const _60 = Pin.init_io("60", .io_E8);
    pub const _61 = Pin.init_io("61", .io_E9);
    pub const _62 = Pin.init_io("62", .io_E10);
    pub const _63 = Pin.init_io("63", .io_E12);
    pub const _64 = Pin.init_io("64", .io_E14);
    pub const _65 = Pin.init_misc("65", .gnd);
    pub const _66 = Pin.init_misc("66", .tms);
    pub const _67 = Pin.init_misc("67", .vcco);
    pub const _68 = Pin.init_io("68", .io_F0);
    pub const _69 = Pin.init_io("69", .io_F1);
    pub const _70 = Pin.init_io("70", .io_F2);
    pub const _71 = Pin.init_io("71", .io_F4);
    pub const _72 = Pin.init_io("72", .io_F5);
    pub const _73 = Pin.init_io("73", .io_F6);
    pub const _74 = Pin.init_misc("74", .gnd);
    pub const _75 = Pin.init_io("75", .io_F8);
    pub const _76 = Pin.init_io("76", .io_F9);
    pub const _77 = Pin.init_io("77", .io_F10);
    pub const _78 = Pin.init_io("78", .io_F12);
    pub const _79 = Pin.init_io("79", .io_F13);
    pub const _80 = Pin.init_io("80", .io_F14);
    pub const _81 = Pin.init_misc("81", .vcco);
    pub const _82 = Pin.init_io("82", .io_G14);
    pub const _83 = Pin.init_io("83", .io_G13);
    pub const _84 = Pin.init_io("84", .io_G12);
    pub const _85 = Pin.init_io("85", .io_G10);
    pub const _86 = Pin.init_io("86", .io_G9);
    pub const _87 = Pin.init_io("87", .io_G8);
    pub const _88 = Pin.init_misc("88", .gnd);
    pub const _89 = Pin.init_io("89", .io_G6);
    pub const _90 = Pin.init_io("90", .io_G5);
    pub const _91 = Pin.init_io("91", .io_G4);
    pub const _92 = Pin.init_io("92", .io_G2);
    pub const _93 = Pin.init_io("93", .io_G0);
    pub const _94 = Pin.init_misc("94", .vcco);
    pub const _95 = Pin.init_misc("95", .tdo);
    pub const _96 = Pin.init_misc("96", .vcc_core);
    pub const _97 = Pin.init_misc("97", .gnd);
    pub const _98 = Pin.init_io("98", .io_H14);
    pub const _99 = Pin.init_io("99", .io_H13);
    pub const _100 = Pin.init_io("100", .io_H12);
    pub const _101 = Pin.init_io("101", .io_H10);
    pub const _102 = Pin.init_io("102", .io_H9);
    pub const _103 = Pin.init_io("103", .io_H8);
    pub const _104 = Pin.init_misc("104", .gnd);
    pub const _105 = Pin.init_misc("105", .vcco);
    pub const _106 = Pin.init_io("106", .io_H6);
    pub const _107 = Pin.init_io("107", .io_H5);
    pub const _108 = Pin.init_io("108", .io_H4);
    pub const _109 = Pin.init_io("109", .io_H2);
    pub const _110 = Pin.init_io("110", .io_H1);
    pub const _111 = Pin.init_oe("111", .io_H0, 1);
    pub const _112 = Pin.init_clk("112", .clk3, 3, 7);
    pub const _113 = Pin.init_misc("113", .gnd);
    pub const _114 = Pin.init_clk("114", .clk0, 0, 0);
    pub const _115 = Pin.init_misc("115", .vcc_core);
    pub const _116 = Pin.init_oe("116", .io_A0, 0);
    pub const _117 = Pin.init_io("117", .io_A1);
    pub const _118 = Pin.init_io("118", .io_A2);
    pub const _119 = Pin.init_io("119", .io_A4);
    pub const _120 = Pin.init_io("120", .io_A5);
    pub const _121 = Pin.init_io("121", .io_A6);
    pub const _122 = Pin.init_misc("122", .vcco);
    pub const _123 = Pin.init_misc("123", .gnd);
    pub const _124 = Pin.init_io("124", .io_A8);
    pub const _125 = Pin.init_io("125", .io_A9);
    pub const _126 = Pin.init_io("126", .io_A10);
    pub const _127 = Pin.init_io("127", .io_A12);
    pub const _128 = Pin.init_io("128", .io_A14);
};

pub const clock_pins = [_]Pin {
    pins._114,
    pins._48,
    pins._50,
    pins._112,
};

pub const oe_pins = [_]Pin {
    pins._116,
    pins._111,
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
    pins._49,
    pins._50,
    pins._51,
    pins._52,
    pins._53,
    pins._54,
    pins._55,
    pins._56,
    pins._57,
    pins._58,
    pins._59,
    pins._60,
    pins._61,
    pins._62,
    pins._63,
    pins._64,
    pins._65,
    pins._66,
    pins._67,
    pins._68,
    pins._69,
    pins._70,
    pins._71,
    pins._72,
    pins._73,
    pins._74,
    pins._75,
    pins._76,
    pins._77,
    pins._78,
    pins._79,
    pins._80,
    pins._81,
    pins._82,
    pins._83,
    pins._84,
    pins._85,
    pins._86,
    pins._87,
    pins._88,
    pins._89,
    pins._90,
    pins._91,
    pins._92,
    pins._93,
    pins._94,
    pins._95,
    pins._96,
    pins._97,
    pins._98,
    pins._99,
    pins._100,
    pins._101,
    pins._102,
    pins._103,
    pins._104,
    pins._105,
    pins._106,
    pins._107,
    pins._108,
    pins._109,
    pins._110,
    pins._111,
    pins._112,
    pins._113,
    pins._114,
    pins._115,
    pins._116,
    pins._117,
    pins._118,
    pins._119,
    pins._120,
    pins._121,
    pins._122,
    pins._123,
    pins._124,
    pins._125,
    pins._126,
    pins._127,
    pins._128,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
