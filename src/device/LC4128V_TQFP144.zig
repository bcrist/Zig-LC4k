//[[!! include('devices', 'LC4128V_TQFP144') !! 854 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");

pub const device_type = lc4k.Device_Type.LC4128V_TQFP144;

pub const family = lc4k.Device_Family.low_power;
pub const package = lc4k.Device_Package.TQFP144;

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

pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
    io_A0,
    io_A1,
    io_A2,
    io_A4,
    io_A5,
    io_A6,
    io_A8,
    io_A9,
    io_A10,
    io_A12,
    io_A13,
    io_A14,
    io_B0,
    io_B1,
    io_B2,
    io_B4,
    io_B5,
    io_B6,
    io_B8,
    io_B9,
    io_B10,
    io_B12,
    io_B13,
    io_B14,
    io_C0,
    io_C1,
    io_C2,
    io_C4,
    io_C5,
    io_C6,
    io_C8,
    io_C9,
    io_C10,
    io_C12,
    io_C13,
    io_C14,
    io_D0,
    io_D1,
    io_D2,
    io_D4,
    io_D5,
    io_D6,
    io_D8,
    io_D9,
    io_D10,
    io_D12,
    io_D13,
    io_D14,
    io_E0,
    io_E1,
    io_E2,
    io_E4,
    io_E5,
    io_E6,
    io_E8,
    io_E9,
    io_E10,
    io_E12,
    io_E13,
    io_E14,
    io_F0,
    io_F1,
    io_F2,
    io_F4,
    io_F5,
    io_F6,
    io_F8,
    io_F9,
    io_F10,
    io_F12,
    io_F13,
    io_F14,
    io_G0,
    io_G1,
    io_G2,
    io_G4,
    io_G5,
    io_G6,
    io_G8,
    io_G9,
    io_G10,
    io_G12,
    io_G13,
    io_G14,
    io_H0,
    io_H1,
    io_H2,
    io_H4,
    io_H5,
    io_H6,
    io_H8,
    io_H9,
    io_H10,
    io_H12,
    io_H13,
    io_H14,
    mc_A0,
    mc_A1,
    mc_A2,
    mc_A3,
    mc_A4,
    mc_A5,
    mc_A6,
    mc_A7,
    mc_A8,
    mc_A9,
    mc_A10,
    mc_A11,
    mc_A12,
    mc_A13,
    mc_A14,
    mc_A15,
    mc_B0,
    mc_B1,
    mc_B2,
    mc_B3,
    mc_B4,
    mc_B5,
    mc_B6,
    mc_B7,
    mc_B8,
    mc_B9,
    mc_B10,
    mc_B11,
    mc_B12,
    mc_B13,
    mc_B14,
    mc_B15,
    mc_C0,
    mc_C1,
    mc_C2,
    mc_C3,
    mc_C4,
    mc_C5,
    mc_C6,
    mc_C7,
    mc_C8,
    mc_C9,
    mc_C10,
    mc_C11,
    mc_C12,
    mc_C13,
    mc_C14,
    mc_C15,
    mc_D0,
    mc_D1,
    mc_D2,
    mc_D3,
    mc_D4,
    mc_D5,
    mc_D6,
    mc_D7,
    mc_D8,
    mc_D9,
    mc_D10,
    mc_D11,
    mc_D12,
    mc_D13,
    mc_D14,
    mc_D15,
    mc_E0,
    mc_E1,
    mc_E2,
    mc_E3,
    mc_E4,
    mc_E5,
    mc_E6,
    mc_E7,
    mc_E8,
    mc_E9,
    mc_E10,
    mc_E11,
    mc_E12,
    mc_E13,
    mc_E14,
    mc_E15,
    mc_F0,
    mc_F1,
    mc_F2,
    mc_F3,
    mc_F4,
    mc_F5,
    mc_F6,
    mc_F7,
    mc_F8,
    mc_F9,
    mc_F10,
    mc_F11,
    mc_F12,
    mc_F13,
    mc_F14,
    mc_F15,
    mc_G0,
    mc_G1,
    mc_G2,
    mc_G3,
    mc_G4,
    mc_G5,
    mc_G6,
    mc_G7,
    mc_G8,
    mc_G9,
    mc_G10,
    mc_G11,
    mc_G12,
    mc_G13,
    mc_G14,
    mc_G15,
    mc_H0,
    mc_H1,
    mc_H2,
    mc_H3,
    mc_H4,
    mc_H5,
    mc_H6,
    mc_H7,
    mc_H8,
    mc_H9,
    mc_H10,
    mc_H11,
    mc_H12,
    mc_H13,
    mc_H14,
    mc_H15,

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_H14) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_H15) => .mc,
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
            @intFromEnum(GRP.io_E0)...@intFromEnum(GRP.io_E15) => .{ .glb = 4, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_E0) },
            @intFromEnum(GRP.mc_E0)...@intFromEnum(GRP.mc_E15) => .{ .glb = 4, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_E0) },
            @intFromEnum(GRP.io_F0)...@intFromEnum(GRP.io_F15) => .{ .glb = 5, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_F0) },
            @intFromEnum(GRP.mc_F0)...@intFromEnum(GRP.mc_F15) => .{ .glb = 5, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_F0) },
            @intFromEnum(GRP.io_G0)...@intFromEnum(GRP.io_G15) => .{ .glb = 6, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_G0) },
            @intFromEnum(GRP.mc_G0)...@intFromEnum(GRP.mc_G15) => .{ .glb = 6, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_G0) },
            @intFromEnum(GRP.io_H0)...@intFromEnum(GRP.io_H15) => .{ .glb = 7, .mc = @intFromEnum(self) - @intFromEnum(GRP.io_H0) },
            @intFromEnum(GRP.mc_H0)...@intFromEnum(GRP.mc_H15) => .{ .glb = 7, .mc = @intFromEnum(self) - @intFromEnum(GRP.mc_H0) },
            else => null,
        };
    }
    pub inline fn mc(self: GRP) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: GRP) ?Pin {
        return switch (self) {
            .clk0 => pins._128,
            .clk1 => pins._54,
            .clk2 => pins._56,
            .clk3 => pins._126,
            .io_A0 => pins._130,
            .io_A1 => pins._131,
            .io_A2 => pins._132,
            .io_A4 => pins._133,
            .io_A5 => pins._134,
            .io_A6 => pins._135,
            .io_A8 => pins._138,
            .io_A9 => pins._139,
            .io_A10 => pins._140,
            .io_A12 => pins._141,
            .io_A13 => pins._142,
            .io_A14 => pins._143,
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
            .io_C0 => pins._33,
            .io_C1 => pins._32,
            .io_C2 => pins._31,
            .io_C4 => pins._30,
            .io_C5 => pins._29,
            .io_C6 => pins._28,
            .io_C8 => pins._26,
            .io_C9 => pins._25,
            .io_C10 => pins._24,
            .io_C12 => pins._23,
            .io_C13 => pins._22,
            .io_C14 => pins._21,
            .io_D0 => pins._53,
            .io_D1 => pins._52,
            .io_D2 => pins._51,
            .io_D4 => pins._50,
            .io_D5 => pins._49,
            .io_D6 => pins._48,
            .io_D8 => pins._44,
            .io_D9 => pins._43,
            .io_D10 => pins._42,
            .io_D12 => pins._41,
            .io_D13 => pins._40,
            .io_D14 => pins._39,
            .io_E0 => pins._58,
            .io_E1 => pins._59,
            .io_E2 => pins._60,
            .io_E4 => pins._61,
            .io_E5 => pins._62,
            .io_E6 => pins._63,
            .io_E8 => pins._66,
            .io_E9 => pins._67,
            .io_E10 => pins._68,
            .io_E12 => pins._69,
            .io_E13 => pins._70,
            .io_E14 => pins._71,
            .io_F0 => pins._76,
            .io_F1 => pins._77,
            .io_F2 => pins._78,
            .io_F4 => pins._79,
            .io_F5 => pins._80,
            .io_F6 => pins._81,
            .io_F8 => pins._83,
            .io_F9 => pins._84,
            .io_F10 => pins._85,
            .io_F12 => pins._86,
            .io_F13 => pins._87,
            .io_F14 => pins._88,
            .io_G0 => pins._105,
            .io_G1 => pins._104,
            .io_G2 => pins._103,
            .io_G4 => pins._102,
            .io_G5 => pins._101,
            .io_G6 => pins._100,
            .io_G8 => pins._98,
            .io_G9 => pins._97,
            .io_G10 => pins._96,
            .io_G12 => pins._95,
            .io_G13 => pins._94,
            .io_G14 => pins._93,
            .io_H0 => pins._125,
            .io_H1 => pins._124,
            .io_H2 => pins._123,
            .io_H4 => pins._122,
            .io_H5 => pins._121,
            .io_H6 => pins._120,
            .io_H8 => pins._116,
            .io_H9 => pins._115,
            .io_H10 => pins._114,
            .io_H12 => pins._113,
            .io_H13 => pins._112,
            .io_H14 => pins._111,
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

pub fn get_glb_range(glb: usize) Fuse_Range {
    std.debug.assert(glb < num_glbs);
    var index = num_glbs - glb - 1;
    index ^= @as(u1, @truncate(index >> 1));
    return jedec_dimensions.subColumns(83 * index + gi_mux_size * (index / 2 + 1), 83);

}

pub fn get_gi_range(glb: usize, gi: usize) Fuse_Range {
    std.debug.assert(gi < num_gis_per_glb);
    var left_glb = glb | 1;
    left_glb ^= @as(u1, @truncate(left_glb >> 1)) ^ 1;
    const row = gi * 2 + @as(u1, @truncate(glb ^ (glb >> 1)));
    return get_glb_range(left_glb).expandColumns(-19).subColumns(0, 19).subRows(row, 1);
}

pub fn get_bclock_range(glb: usize) Fuse_Range {
    var index = num_glbs - glb - 1;
    index = @as(u1, @truncate((index >> 1) ^ index));
    return get_glb_range(glb).subRows(79, 4).subColumns(82 * index, 1);
}

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
    return Fuse.init(85, 101).range().expandToContain(Fuse.init(86, 101));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{
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
    pub const _17 = Pin.init_misc("17", .no_connect);
    pub const _18 = Pin.init_misc("18", .gnd);
    pub const _19 = Pin.init_misc("19", .vcco);
    pub const _20 = Pin.init_misc("20", .no_connect);
    pub const _21 = Pin.init_io("21", .io_C14);
    pub const _22 = Pin.init_io("22", .io_C13);
    pub const _23 = Pin.init_io("23", .io_C12);
    pub const _24 = Pin.init_io("24", .io_C10);
    pub const _25 = Pin.init_io("25", .io_C9);
    pub const _26 = Pin.init_io("26", .io_C8);
    pub const _27 = Pin.init_misc("27", .gnd);
    pub const _28 = Pin.init_io("28", .io_C6);
    pub const _29 = Pin.init_io("29", .io_C5);
    pub const _30 = Pin.init_io("30", .io_C4);
    pub const _31 = Pin.init_io("31", .io_C2);
    pub const _32 = Pin.init_io("32", .io_C1);
    pub const _33 = Pin.init_io("33", .io_C0);
    pub const _34 = Pin.init_misc("34", .vcco);
    pub const _35 = Pin.init_misc("35", .tck);
    pub const _36 = Pin.init_misc("36", .vcc_core);
    pub const _37 = Pin.init_misc("37", .gnd);
    pub const _38 = Pin.init_misc("38", .no_connect);
    pub const _39 = Pin.init_io("39", .io_D14);
    pub const _40 = Pin.init_io("40", .io_D13);
    pub const _41 = Pin.init_io("41", .io_D12);
    pub const _42 = Pin.init_io("42", .io_D10);
    pub const _43 = Pin.init_io("43", .io_D9);
    pub const _44 = Pin.init_io("44", .io_D8);
    pub const _45 = Pin.init_misc("45", .no_connect);
    pub const _46 = Pin.init_misc("46", .gnd);
    pub const _47 = Pin.init_misc("47", .vcco);
    pub const _48 = Pin.init_io("48", .io_D6);
    pub const _49 = Pin.init_io("49", .io_D5);
    pub const _50 = Pin.init_io("50", .io_D4);
    pub const _51 = Pin.init_io("51", .io_D2);
    pub const _52 = Pin.init_io("52", .io_D1);
    pub const _53 = Pin.init_io("53", .io_D0);
    pub const _54 = Pin.init_clk("54", .clk1, 1, 3);
    pub const _55 = Pin.init_misc("55", .gnd);
    pub const _56 = Pin.init_clk("56", .clk2, 2, 4);
    pub const _57 = Pin.init_misc("57", .vcc_core);
    pub const _58 = Pin.init_io("58", .io_E0);
    pub const _59 = Pin.init_io("59", .io_E1);
    pub const _60 = Pin.init_io("60", .io_E2);
    pub const _61 = Pin.init_io("61", .io_E4);
    pub const _62 = Pin.init_io("62", .io_E5);
    pub const _63 = Pin.init_io("63", .io_E6);
    pub const _64 = Pin.init_misc("64", .vcco);
    pub const _65 = Pin.init_misc("65", .gnd);
    pub const _66 = Pin.init_io("66", .io_E8);
    pub const _67 = Pin.init_io("67", .io_E9);
    pub const _68 = Pin.init_io("68", .io_E10);
    pub const _69 = Pin.init_io("69", .io_E12);
    pub const _70 = Pin.init_io("70", .io_E13);
    pub const _71 = Pin.init_io("71", .io_E14);
    pub const _72 = Pin.init_misc("72", .no_connect);
    pub const _73 = Pin.init_misc("73", .gnd);
    pub const _74 = Pin.init_misc("74", .tms);
    pub const _75 = Pin.init_misc("75", .vcco);
    pub const _76 = Pin.init_io("76", .io_F0);
    pub const _77 = Pin.init_io("77", .io_F1);
    pub const _78 = Pin.init_io("78", .io_F2);
    pub const _79 = Pin.init_io("79", .io_F4);
    pub const _80 = Pin.init_io("80", .io_F5);
    pub const _81 = Pin.init_io("81", .io_F6);
    pub const _82 = Pin.init_misc("82", .gnd);
    pub const _83 = Pin.init_io("83", .io_F8);
    pub const _84 = Pin.init_io("84", .io_F9);
    pub const _85 = Pin.init_io("85", .io_F10);
    pub const _86 = Pin.init_io("86", .io_F12);
    pub const _87 = Pin.init_io("87", .io_F13);
    pub const _88 = Pin.init_io("88", .io_F14);
    pub const _89 = Pin.init_misc("89", .no_connect);
    pub const _90 = Pin.init_misc("90", .gnd);
    pub const _91 = Pin.init_misc("91", .vcco);
    pub const _92 = Pin.init_misc("92", .no_connect);
    pub const _93 = Pin.init_io("93", .io_G14);
    pub const _94 = Pin.init_io("94", .io_G13);
    pub const _95 = Pin.init_io("95", .io_G12);
    pub const _96 = Pin.init_io("96", .io_G10);
    pub const _97 = Pin.init_io("97", .io_G9);
    pub const _98 = Pin.init_io("98", .io_G8);
    pub const _99 = Pin.init_misc("99", .gnd);
    pub const _100 = Pin.init_io("100", .io_G6);
    pub const _101 = Pin.init_io("101", .io_G5);
    pub const _102 = Pin.init_io("102", .io_G4);
    pub const _103 = Pin.init_io("103", .io_G2);
    pub const _104 = Pin.init_io("104", .io_G1);
    pub const _105 = Pin.init_io("105", .io_G0);
    pub const _106 = Pin.init_misc("106", .vcco);
    pub const _107 = Pin.init_misc("107", .tdo);
    pub const _108 = Pin.init_misc("108", .vcc_core);
    pub const _109 = Pin.init_misc("109", .gnd);
    pub const _110 = Pin.init_misc("110", .no_connect);
    pub const _111 = Pin.init_io("111", .io_H14);
    pub const _112 = Pin.init_io("112", .io_H13);
    pub const _113 = Pin.init_io("113", .io_H12);
    pub const _114 = Pin.init_io("114", .io_H10);
    pub const _115 = Pin.init_io("115", .io_H9);
    pub const _116 = Pin.init_io("116", .io_H8);
    pub const _117 = Pin.init_misc("117", .no_connect);
    pub const _118 = Pin.init_misc("118", .gnd);
    pub const _119 = Pin.init_misc("119", .vcco);
    pub const _120 = Pin.init_io("120", .io_H6);
    pub const _121 = Pin.init_io("121", .io_H5);
    pub const _122 = Pin.init_io("122", .io_H4);
    pub const _123 = Pin.init_io("123", .io_H2);
    pub const _124 = Pin.init_io("124", .io_H1);
    pub const _125 = Pin.init_oe("125", .io_H0, 1);
    pub const _126 = Pin.init_clk("126", .clk3, 3, 7);
    pub const _127 = Pin.init_misc("127", .gnd);
    pub const _128 = Pin.init_clk("128", .clk0, 0, 0);
    pub const _129 = Pin.init_misc("129", .vcc_core);
    pub const _130 = Pin.init_oe("130", .io_A0, 0);
    pub const _131 = Pin.init_io("131", .io_A1);
    pub const _132 = Pin.init_io("132", .io_A2);
    pub const _133 = Pin.init_io("133", .io_A4);
    pub const _134 = Pin.init_io("134", .io_A5);
    pub const _135 = Pin.init_io("135", .io_A6);
    pub const _136 = Pin.init_misc("136", .vcco);
    pub const _137 = Pin.init_misc("137", .gnd);
    pub const _138 = Pin.init_io("138", .io_A8);
    pub const _139 = Pin.init_io("139", .io_A9);
    pub const _140 = Pin.init_io("140", .io_A10);
    pub const _141 = Pin.init_io("141", .io_A12);
    pub const _142 = Pin.init_io("142", .io_A13);
    pub const _143 = Pin.init_io("143", .io_A14);
    pub const _144 = Pin.init_misc("144", .no_connect);
};

pub const clock_pins = [_]Pin {
    pins._128,
    pins._54,
    pins._56,
    pins._126,
};

pub const oe_pins = [_]Pin {
    pins._130,
    pins._125,
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
    pins._129,
    pins._130,
    pins._131,
    pins._132,
    pins._133,
    pins._134,
    pins._135,
    pins._136,
    pins._137,
    pins._138,
    pins._139,
    pins._140,
    pins._141,
    pins._142,
    pins._143,
    pins._144,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
