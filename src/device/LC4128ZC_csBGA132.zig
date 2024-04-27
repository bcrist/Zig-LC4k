//[[!! include('devices', 'LC4128ZC_csBGA132') !! 813 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");

pub const device_type = lc4k.Device_Type.LC4128ZC_csBGA132;

pub const family = lc4k.Device_Family.zero_power;
pub const package = lc4k.Device_Package.csBGA132;

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
    pub const A1 = Pin.init_io("A1", .io_A14);
    pub const A2 = Pin.init_io("A2", .io_A13);
    pub const A3 = Pin.init_io("A3", .io_A10);
    pub const A4 = Pin.init_io("A4", .io_A8);
    pub const A5 = Pin.init_io("A5", .io_A6);
    pub const A6 = Pin.init_io("A6", .io_A1);
    pub const A7 = Pin.init_misc("A7", .no_connect);
    pub const A8 = Pin.init_oe("A8", .io_H0, 1);
    pub const A9 = Pin.init_io("A9", .io_H2);
    pub const A10 = Pin.init_misc("A10", .vcco);
    pub const A11 = Pin.init_io("A11", .io_H9);
    pub const A12 = Pin.init_io("A12", .io_H13);
    pub const A13 = Pin.init_misc("A13", .gnd);
    pub const A14 = Pin.init_misc("A14", .vcc_core);
    pub const B1 = Pin.init_misc("B1", .gnd);
    pub const B2 = Pin.init_misc("B2", .tdi);
    pub const B3 = Pin.init_io("B3", .io_A12);
    pub const B4 = Pin.init_misc("B4", .gnd);
    pub const B5 = Pin.init_io("B5", .io_A5);
    pub const B6 = Pin.init_io("B6", .io_A2);
    pub const B7 = Pin.init_misc("B7", .vcc_core);
    pub const B8 = Pin.init_clk("B8", .clk3, 3, 7);
    pub const B9 = Pin.init_io("B9", .io_H4);
    pub const B10 = Pin.init_io("B10", .io_H6);
    pub const B11 = Pin.init_misc("B11", .gnd);
    pub const B12 = Pin.init_io("B12", .io_H10);
    pub const B13 = Pin.init_io("B13", .io_H14);
    pub const B14 = Pin.init_misc("B14", .tdo);
    pub const C1 = Pin.init_misc("C1", .vcco);
    pub const C2 = Pin.init_io("C2", .io_B1);
    pub const C3 = Pin.init_io("C3", .io_B0);
    pub const C4 = Pin.init_io("C4", .io_A9);
    pub const C5 = Pin.init_misc("C5", .vcco);
    pub const C6 = Pin.init_io("C6", .io_A4);
    pub const C7 = Pin.init_oe("C7", .io_A0, 0);
    pub const C8 = Pin.init_clk("C8", .clk0, 0, 0);
    pub const C9 = Pin.init_io("C9", .io_H1);
    pub const C10 = Pin.init_io("C10", .io_H5);
    pub const C11 = Pin.init_io("C11", .io_H8);
    pub const C12 = Pin.init_io("C12", .io_H12);
    pub const C13 = Pin.init_misc("C13", .vcco);
    pub const C14 = Pin.init_io("C14", .io_G0);
    pub const D1 = Pin.init_io("D1", .io_B2);
    pub const D2 = Pin.init_io("D2", .io_B5);
    pub const D3 = Pin.init_io("D3", .io_B4);
    pub const D12 = Pin.init_io("D12", .io_G1);
    pub const D13 = Pin.init_io("D13", .io_G4);
    pub const D14 = Pin.init_io("D14", .io_G2);
    pub const E1 = Pin.init_io("E1", .io_B6);
    pub const E2 = Pin.init_misc("E2", .gnd);
    pub const E3 = Pin.init_io("E3", .io_B8);
    pub const E12 = Pin.init_io("E12", .io_G5);
    pub const E13 = Pin.init_misc("E13", .gnd);
    pub const E14 = Pin.init_io("E14", .io_G6);
    pub const F1 = Pin.init_io("F1", .io_B10);
    pub const F2 = Pin.init_io("F2", .io_B9);
    pub const F3 = Pin.init_io("F3", .io_B12);
    pub const F12 = Pin.init_io("F12", .io_G8);
    pub const F13 = Pin.init_io("F13", .io_G9);
    pub const F14 = Pin.init_io("F14", .io_G10);
    pub const G1 = Pin.init_io("G1", .io_B13);
    pub const G2 = Pin.init_io("G2", .io_B14);
    pub const G3 = Pin.init_misc("G3", .vcco);
    pub const G12 = Pin.init_io("G12", .io_G12);
    pub const G13 = Pin.init_io("G13", .io_G14);
    pub const G14 = Pin.init_io("G14", .io_G13);
    pub const H1 = Pin.init_io("H1", .io_C13);
    pub const H2 = Pin.init_io("H2", .io_C14);
    pub const H3 = Pin.init_io("H3", .io_C12);
    pub const H12 = Pin.init_misc("H12", .vcco);
    pub const H13 = Pin.init_io("H13", .io_F14);
    pub const H14 = Pin.init_io("H14", .io_F13);
    pub const J1 = Pin.init_io("J1", .io_C10);
    pub const J2 = Pin.init_io("J2", .io_C9);
    pub const J3 = Pin.init_io("J3", .io_C8);
    pub const J12 = Pin.init_io("J12", .io_F12);
    pub const J13 = Pin.init_io("J13", .io_F9);
    pub const J14 = Pin.init_io("J14", .io_F10);
    pub const K1 = Pin.init_io("K1", .io_C6);
    pub const K2 = Pin.init_misc("K2", .gnd);
    pub const K3 = Pin.init_io("K3", .io_C5);
    pub const K12 = Pin.init_io("K12", .io_F8);
    pub const K13 = Pin.init_misc("K13", .gnd);
    pub const K14 = Pin.init_io("K14", .io_F6);
    pub const L1 = Pin.init_io("L1", .io_C2);
    pub const L2 = Pin.init_io("L2", .io_C4);
    pub const L3 = Pin.init_io("L3", .io_C1);
    pub const L12 = Pin.init_io("L12", .io_F4);
    pub const L13 = Pin.init_io("L13", .io_F5);
    pub const L14 = Pin.init_io("L14", .io_F2);
    pub const M1 = Pin.init_io("M1", .io_C0);
    pub const M2 = Pin.init_misc("M2", .vcco);
    pub const M3 = Pin.init_io("M3", .io_D12);
    pub const M4 = Pin.init_io("M4", .io_D8);
    pub const M5 = Pin.init_io("M5", .io_D5);
    pub const M6 = Pin.init_io("M6", .io_D1);
    pub const M7 = Pin.init_clk("M7", .clk2, 2, 4);
    pub const M8 = Pin.init_io("M8", .io_E0);
    pub const M9 = Pin.init_io("M9", .io_E4);
    pub const M10 = Pin.init_misc("M10", .vcco);
    pub const M11 = Pin.init_io("M11", .io_E9);
    pub const M12 = Pin.init_io("M12", .io_F0);
    pub const M13 = Pin.init_io("M13", .io_F1);
    pub const M14 = Pin.init_misc("M14", .vcco);
    pub const N1 = Pin.init_misc("N1", .tck);
    pub const N2 = Pin.init_io("N2", .io_D14);
    pub const N3 = Pin.init_io("N3", .io_D10);
    pub const N4 = Pin.init_misc("N4", .gnd);
    pub const N5 = Pin.init_io("N5", .io_D6);
    pub const N6 = Pin.init_io("N6", .io_D4);
    pub const N7 = Pin.init_clk("N7", .clk1, 1, 3);
    pub const N8 = Pin.init_misc("N8", .vcc_core);
    pub const N9 = Pin.init_io("N9", .io_E2);
    pub const N10 = Pin.init_io("N10", .io_E5);
    pub const N11 = Pin.init_misc("N11", .gnd);
    pub const N12 = Pin.init_io("N12", .io_E12);
    pub const N13 = Pin.init_misc("N13", .tms);
    pub const N14 = Pin.init_misc("N14", .gnd);
    pub const P1 = Pin.init_misc("P1", .vcc_core);
    pub const P2 = Pin.init_misc("P2", .gnd);
    pub const P3 = Pin.init_io("P3", .io_D13);
    pub const P4 = Pin.init_io("P4", .io_D9);
    pub const P5 = Pin.init_misc("P5", .vcco);
    pub const P6 = Pin.init_io("P6", .io_D2);
    pub const P7 = Pin.init_io("P7", .io_D0);
    pub const P8 = Pin.init_misc("P8", .no_connect);
    pub const P9 = Pin.init_io("P9", .io_E1);
    pub const P10 = Pin.init_io("P10", .io_E6);
    pub const P11 = Pin.init_io("P11", .io_E8);
    pub const P12 = Pin.init_io("P12", .io_E10);
    pub const P13 = Pin.init_io("P13", .io_E13);
    pub const P14 = Pin.init_io("P14", .io_E14);
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
