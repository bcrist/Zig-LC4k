//[[!! include('devices', 'LC4128V_TQFP144') !! 1347 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const internal = @import("../internal.zig");
const jedec = @import("../jedec.zig");

pub const device_type = lc4k.DeviceType.LC4128V_TQFP144;

pub const family = lc4k.DeviceFamily.low_power;
pub const package = lc4k.DevicePackage.TQFP144;

pub const num_glbs = 8;
pub const num_mcs = 128;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = 19;
pub const oe_bus_size = 4;

pub const jedec_dimensions = jedec.FuseRange.init(740, 100);

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
};

pub const mc_signals = [num_glbs][num_mcs_per_glb]GRP {
    .{ .mc_A0, .mc_A1, .mc_A2, .mc_A3, .mc_A4, .mc_A5, .mc_A6, .mc_A7, .mc_A8, .mc_A9, .mc_A10, .mc_A11, .mc_A12, .mc_A13, .mc_A14, .mc_A15, },
    .{ .mc_B0, .mc_B1, .mc_B2, .mc_B3, .mc_B4, .mc_B5, .mc_B6, .mc_B7, .mc_B8, .mc_B9, .mc_B10, .mc_B11, .mc_B12, .mc_B13, .mc_B14, .mc_B15, },
    .{ .mc_C0, .mc_C1, .mc_C2, .mc_C3, .mc_C4, .mc_C5, .mc_C6, .mc_C7, .mc_C8, .mc_C9, .mc_C10, .mc_C11, .mc_C12, .mc_C13, .mc_C14, .mc_C15, },
    .{ .mc_D0, .mc_D1, .mc_D2, .mc_D3, .mc_D4, .mc_D5, .mc_D6, .mc_D7, .mc_D8, .mc_D9, .mc_D10, .mc_D11, .mc_D12, .mc_D13, .mc_D14, .mc_D15, },
    .{ .mc_E0, .mc_E1, .mc_E2, .mc_E3, .mc_E4, .mc_E5, .mc_E6, .mc_E7, .mc_E8, .mc_E9, .mc_E10, .mc_E11, .mc_E12, .mc_E13, .mc_E14, .mc_E15, },
    .{ .mc_F0, .mc_F1, .mc_F2, .mc_F3, .mc_F4, .mc_F5, .mc_F6, .mc_F7, .mc_F8, .mc_F9, .mc_F10, .mc_F11, .mc_F12, .mc_F13, .mc_F14, .mc_F15, },
    .{ .mc_G0, .mc_G1, .mc_G2, .mc_G3, .mc_G4, .mc_G5, .mc_G6, .mc_G7, .mc_G8, .mc_G9, .mc_G10, .mc_G11, .mc_G12, .mc_G13, .mc_G14, .mc_G15, },
    .{ .mc_H0, .mc_H1, .mc_H2, .mc_H3, .mc_H4, .mc_H5, .mc_H6, .mc_H7, .mc_H8, .mc_H9, .mc_H10, .mc_H11, .mc_H12, .mc_H13, .mc_H14, .mc_H15, },
};

pub const mc_output_signals = [num_glbs][num_mcs_per_glb]?GRP {
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

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);

pub fn getGlbRange(glb: usize) jedec.FuseRange {
    std.debug.assert(glb < num_glbs);
    var index = num_glbs - glb - 1;
    index ^= @as(u1, @truncate(index >> 1));
    return jedec_dimensions.subColumns(83 * index + gi_mux_size * (index / 2 + 1), 83);
}

pub fn getGiRange(glb: usize, gi: usize) jedec.FuseRange {
    std.debug.assert(gi < num_gis_per_glb);
    var left_glb = glb | 1;
    left_glb ^= @as(u1, @truncate(left_glb >> 1)) ^ 1;
    const row = gi * 2 + @as(u1, @truncate(glb ^ (glb >> 1)));
    return getGlbRange(left_glb).expandColumns(-19).subColumns(0, 19).subRows(row, 1);
}

pub fn getBClockRange(glb: usize) jedec.FuseRange {
    var index = num_glbs - glb - 1;
    index = @as(u1, @truncate((index >> 1) ^ index));
    return getGlbRange(glb).subRows(79, 4).subColumns(82 * index, 1);
}

pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(90, 101),
        1 => jedec.Fuse.init(91, 101),
        2 => jedec.Fuse.init(92, 101),
        3 => jedec.Fuse.init(93, 101),
        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {
        0 => jedec.Fuse.init(88, 101),
        1 => jedec.Fuse.init(89, 101),
        else => unreachable,
    };
}

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(87, 101);
}


pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(85, 101)
    ).expandToContain(
        jedec.Fuse.init(86, 101)
    );
}
pub fn getExtraFloatInputFuses() []const jedec.Fuse {
    return &.{
    };
}

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {
        .clk0 => jedec.Fuse.init(94, 98),
        .clk1 => jedec.Fuse.init(94, 99),
        .clk2 => jedec.Fuse.init(94, 100),
        .clk3 => jedec.Fuse.init(94, 101),
        else => unreachable,
    };
}

pub fn getMacrocellRef(comptime which: anytype) lc4k.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) lc4k.GlbIndex {
    return internal.getGlbIndex(@This(), which);
}

pub fn getGrp(comptime which: anytype) GRP {
    return internal.getGrp(GRP, which);
}

pub fn getGrpInput(comptime which: anytype) GRP {
    return internal.getGrpInput(GRP, which);
}

pub fn getGrpFeedback(comptime which: anytype) GRP {
    return internal.getGrpFeedback(GRP, which);
}

pub fn getPin(comptime which: anytype) lc4k.PinInfo {
    return internal.getPin(@This(), which);
}

pub const pins = struct {
    pub const _1 = lc4k.PinInfo {
        .id = "1",
        .func = .{ .gnd = {} },
    };
    pub const _2 = lc4k.PinInfo {
        .id = "2",
        .func = .{ .tdi = {} },
    };
    pub const _3 = lc4k.PinInfo {
        .id = "3",
        .func = .{ .vcco = {} },
    };
    pub const _4 = lc4k.PinInfo {
        .id = "4",
        .func = .{ .io = 0 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B0),
    };
    pub const _5 = lc4k.PinInfo {
        .id = "5",
        .func = .{ .io = 1 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B1),
    };
    pub const _6 = lc4k.PinInfo {
        .id = "6",
        .func = .{ .io = 2 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B2),
    };
    pub const _7 = lc4k.PinInfo {
        .id = "7",
        .func = .{ .io = 4 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B4),
    };
    pub const _8 = lc4k.PinInfo {
        .id = "8",
        .func = .{ .io = 5 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B5),
    };
    pub const _9 = lc4k.PinInfo {
        .id = "9",
        .func = .{ .io = 6 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B6),
    };
    pub const _10 = lc4k.PinInfo {
        .id = "10",
        .func = .{ .gnd = {} },
    };
    pub const _11 = lc4k.PinInfo {
        .id = "11",
        .func = .{ .io = 8 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B8),
    };
    pub const _12 = lc4k.PinInfo {
        .id = "12",
        .func = .{ .io = 9 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B9),
    };
    pub const _13 = lc4k.PinInfo {
        .id = "13",
        .func = .{ .io = 10 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B10),
    };
    pub const _14 = lc4k.PinInfo {
        .id = "14",
        .func = .{ .io = 12 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B12),
    };
    pub const _15 = lc4k.PinInfo {
        .id = "15",
        .func = .{ .io = 13 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B13),
    };
    pub const _16 = lc4k.PinInfo {
        .id = "16",
        .func = .{ .io = 14 },
        .glb = 1,
        .grp_ordinal = @intFromEnum(GRP.io_B14),
    };
    pub const _17 = lc4k.PinInfo {
        .id = "17",
        .func = .{ .no_connect = {} },
    };
    pub const _18 = lc4k.PinInfo {
        .id = "18",
        .func = .{ .gnd = {} },
    };
    pub const _19 = lc4k.PinInfo {
        .id = "19",
        .func = .{ .vcco = {} },
    };
    pub const _20 = lc4k.PinInfo {
        .id = "20",
        .func = .{ .no_connect = {} },
    };
    pub const _21 = lc4k.PinInfo {
        .id = "21",
        .func = .{ .io = 14 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C14),
    };
    pub const _22 = lc4k.PinInfo {
        .id = "22",
        .func = .{ .io = 13 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C13),
    };
    pub const _23 = lc4k.PinInfo {
        .id = "23",
        .func = .{ .io = 12 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C12),
    };
    pub const _24 = lc4k.PinInfo {
        .id = "24",
        .func = .{ .io = 10 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C10),
    };
    pub const _25 = lc4k.PinInfo {
        .id = "25",
        .func = .{ .io = 9 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C9),
    };
    pub const _26 = lc4k.PinInfo {
        .id = "26",
        .func = .{ .io = 8 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C8),
    };
    pub const _27 = lc4k.PinInfo {
        .id = "27",
        .func = .{ .gnd = {} },
    };
    pub const _28 = lc4k.PinInfo {
        .id = "28",
        .func = .{ .io = 6 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C6),
    };
    pub const _29 = lc4k.PinInfo {
        .id = "29",
        .func = .{ .io = 5 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C5),
    };
    pub const _30 = lc4k.PinInfo {
        .id = "30",
        .func = .{ .io = 4 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C4),
    };
    pub const _31 = lc4k.PinInfo {
        .id = "31",
        .func = .{ .io = 2 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C2),
    };
    pub const _32 = lc4k.PinInfo {
        .id = "32",
        .func = .{ .io = 1 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C1),
    };
    pub const _33 = lc4k.PinInfo {
        .id = "33",
        .func = .{ .io = 0 },
        .glb = 2,
        .grp_ordinal = @intFromEnum(GRP.io_C0),
    };
    pub const _34 = lc4k.PinInfo {
        .id = "34",
        .func = .{ .vcco = {} },
    };
    pub const _35 = lc4k.PinInfo {
        .id = "35",
        .func = .{ .tck = {} },
    };
    pub const _36 = lc4k.PinInfo {
        .id = "36",
        .func = .{ .vcc_core = {} },
    };
    pub const _37 = lc4k.PinInfo {
        .id = "37",
        .func = .{ .gnd = {} },
    };
    pub const _38 = lc4k.PinInfo {
        .id = "38",
        .func = .{ .no_connect = {} },
    };
    pub const _39 = lc4k.PinInfo {
        .id = "39",
        .func = .{ .io = 14 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D14),
    };
    pub const _40 = lc4k.PinInfo {
        .id = "40",
        .func = .{ .io = 13 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D13),
    };
    pub const _41 = lc4k.PinInfo {
        .id = "41",
        .func = .{ .io = 12 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D12),
    };
    pub const _42 = lc4k.PinInfo {
        .id = "42",
        .func = .{ .io = 10 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D10),
    };
    pub const _43 = lc4k.PinInfo {
        .id = "43",
        .func = .{ .io = 9 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D9),
    };
    pub const _44 = lc4k.PinInfo {
        .id = "44",
        .func = .{ .io = 8 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D8),
    };
    pub const _45 = lc4k.PinInfo {
        .id = "45",
        .func = .{ .no_connect = {} },
    };
    pub const _46 = lc4k.PinInfo {
        .id = "46",
        .func = .{ .gnd = {} },
    };
    pub const _47 = lc4k.PinInfo {
        .id = "47",
        .func = .{ .vcco = {} },
    };
    pub const _48 = lc4k.PinInfo {
        .id = "48",
        .func = .{ .io = 6 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D6),
    };
    pub const _49 = lc4k.PinInfo {
        .id = "49",
        .func = .{ .io = 5 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D5),
    };
    pub const _50 = lc4k.PinInfo {
        .id = "50",
        .func = .{ .io = 4 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D4),
    };
    pub const _51 = lc4k.PinInfo {
        .id = "51",
        .func = .{ .io = 2 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D2),
    };
    pub const _52 = lc4k.PinInfo {
        .id = "52",
        .func = .{ .io = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D1),
    };
    pub const _53 = lc4k.PinInfo {
        .id = "53",
        .func = .{ .io = 0 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.io_D0),
    };
    pub const _54 = lc4k.PinInfo {
        .id = "54",
        .func = .{ .clock = 1 },
        .glb = 3,
        .grp_ordinal = @intFromEnum(GRP.clk1),
    };
    pub const _55 = lc4k.PinInfo {
        .id = "55",
        .func = .{ .gnd = {} },
    };
    pub const _56 = lc4k.PinInfo {
        .id = "56",
        .func = .{ .clock = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.clk2),
    };
    pub const _57 = lc4k.PinInfo {
        .id = "57",
        .func = .{ .vcc_core = {} },
    };
    pub const _58 = lc4k.PinInfo {
        .id = "58",
        .func = .{ .io = 0 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E0),
    };
    pub const _59 = lc4k.PinInfo {
        .id = "59",
        .func = .{ .io = 1 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E1),
    };
    pub const _60 = lc4k.PinInfo {
        .id = "60",
        .func = .{ .io = 2 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E2),
    };
    pub const _61 = lc4k.PinInfo {
        .id = "61",
        .func = .{ .io = 4 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E4),
    };
    pub const _62 = lc4k.PinInfo {
        .id = "62",
        .func = .{ .io = 5 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E5),
    };
    pub const _63 = lc4k.PinInfo {
        .id = "63",
        .func = .{ .io = 6 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E6),
    };
    pub const _64 = lc4k.PinInfo {
        .id = "64",
        .func = .{ .vcco = {} },
    };
    pub const _65 = lc4k.PinInfo {
        .id = "65",
        .func = .{ .gnd = {} },
    };
    pub const _66 = lc4k.PinInfo {
        .id = "66",
        .func = .{ .io = 8 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E8),
    };
    pub const _67 = lc4k.PinInfo {
        .id = "67",
        .func = .{ .io = 9 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E9),
    };
    pub const _68 = lc4k.PinInfo {
        .id = "68",
        .func = .{ .io = 10 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E10),
    };
    pub const _69 = lc4k.PinInfo {
        .id = "69",
        .func = .{ .io = 12 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E12),
    };
    pub const _70 = lc4k.PinInfo {
        .id = "70",
        .func = .{ .io = 13 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E13),
    };
    pub const _71 = lc4k.PinInfo {
        .id = "71",
        .func = .{ .io = 14 },
        .glb = 4,
        .grp_ordinal = @intFromEnum(GRP.io_E14),
    };
    pub const _72 = lc4k.PinInfo {
        .id = "72",
        .func = .{ .no_connect = {} },
    };
    pub const _73 = lc4k.PinInfo {
        .id = "73",
        .func = .{ .gnd = {} },
    };
    pub const _74 = lc4k.PinInfo {
        .id = "74",
        .func = .{ .tms = {} },
    };
    pub const _75 = lc4k.PinInfo {
        .id = "75",
        .func = .{ .vcco = {} },
    };
    pub const _76 = lc4k.PinInfo {
        .id = "76",
        .func = .{ .io = 0 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F0),
    };
    pub const _77 = lc4k.PinInfo {
        .id = "77",
        .func = .{ .io = 1 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F1),
    };
    pub const _78 = lc4k.PinInfo {
        .id = "78",
        .func = .{ .io = 2 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F2),
    };
    pub const _79 = lc4k.PinInfo {
        .id = "79",
        .func = .{ .io = 4 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F4),
    };
    pub const _80 = lc4k.PinInfo {
        .id = "80",
        .func = .{ .io = 5 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F5),
    };
    pub const _81 = lc4k.PinInfo {
        .id = "81",
        .func = .{ .io = 6 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F6),
    };
    pub const _82 = lc4k.PinInfo {
        .id = "82",
        .func = .{ .gnd = {} },
    };
    pub const _83 = lc4k.PinInfo {
        .id = "83",
        .func = .{ .io = 8 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F8),
    };
    pub const _84 = lc4k.PinInfo {
        .id = "84",
        .func = .{ .io = 9 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F9),
    };
    pub const _85 = lc4k.PinInfo {
        .id = "85",
        .func = .{ .io = 10 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F10),
    };
    pub const _86 = lc4k.PinInfo {
        .id = "86",
        .func = .{ .io = 12 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F12),
    };
    pub const _87 = lc4k.PinInfo {
        .id = "87",
        .func = .{ .io = 13 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F13),
    };
    pub const _88 = lc4k.PinInfo {
        .id = "88",
        .func = .{ .io = 14 },
        .glb = 5,
        .grp_ordinal = @intFromEnum(GRP.io_F14),
    };
    pub const _89 = lc4k.PinInfo {
        .id = "89",
        .func = .{ .no_connect = {} },
    };
    pub const _90 = lc4k.PinInfo {
        .id = "90",
        .func = .{ .gnd = {} },
    };
    pub const _91 = lc4k.PinInfo {
        .id = "91",
        .func = .{ .vcco = {} },
    };
    pub const _92 = lc4k.PinInfo {
        .id = "92",
        .func = .{ .no_connect = {} },
    };
    pub const _93 = lc4k.PinInfo {
        .id = "93",
        .func = .{ .io = 14 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G14),
    };
    pub const _94 = lc4k.PinInfo {
        .id = "94",
        .func = .{ .io = 13 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G13),
    };
    pub const _95 = lc4k.PinInfo {
        .id = "95",
        .func = .{ .io = 12 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G12),
    };
    pub const _96 = lc4k.PinInfo {
        .id = "96",
        .func = .{ .io = 10 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G10),
    };
    pub const _97 = lc4k.PinInfo {
        .id = "97",
        .func = .{ .io = 9 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G9),
    };
    pub const _98 = lc4k.PinInfo {
        .id = "98",
        .func = .{ .io = 8 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G8),
    };
    pub const _99 = lc4k.PinInfo {
        .id = "99",
        .func = .{ .gnd = {} },
    };
    pub const _100 = lc4k.PinInfo {
        .id = "100",
        .func = .{ .io = 6 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G6),
    };
    pub const _101 = lc4k.PinInfo {
        .id = "101",
        .func = .{ .io = 5 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G5),
    };
    pub const _102 = lc4k.PinInfo {
        .id = "102",
        .func = .{ .io = 4 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G4),
    };
    pub const _103 = lc4k.PinInfo {
        .id = "103",
        .func = .{ .io = 2 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G2),
    };
    pub const _104 = lc4k.PinInfo {
        .id = "104",
        .func = .{ .io = 1 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G1),
    };
    pub const _105 = lc4k.PinInfo {
        .id = "105",
        .func = .{ .io = 0 },
        .glb = 6,
        .grp_ordinal = @intFromEnum(GRP.io_G0),
    };
    pub const _106 = lc4k.PinInfo {
        .id = "106",
        .func = .{ .vcco = {} },
    };
    pub const _107 = lc4k.PinInfo {
        .id = "107",
        .func = .{ .tdo = {} },
    };
    pub const _108 = lc4k.PinInfo {
        .id = "108",
        .func = .{ .vcc_core = {} },
    };
    pub const _109 = lc4k.PinInfo {
        .id = "109",
        .func = .{ .gnd = {} },
    };
    pub const _110 = lc4k.PinInfo {
        .id = "110",
        .func = .{ .no_connect = {} },
    };
    pub const _111 = lc4k.PinInfo {
        .id = "111",
        .func = .{ .io = 14 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H14),
    };
    pub const _112 = lc4k.PinInfo {
        .id = "112",
        .func = .{ .io = 13 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H13),
    };
    pub const _113 = lc4k.PinInfo {
        .id = "113",
        .func = .{ .io = 12 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H12),
    };
    pub const _114 = lc4k.PinInfo {
        .id = "114",
        .func = .{ .io = 10 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H10),
    };
    pub const _115 = lc4k.PinInfo {
        .id = "115",
        .func = .{ .io = 9 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H9),
    };
    pub const _116 = lc4k.PinInfo {
        .id = "116",
        .func = .{ .io = 8 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H8),
    };
    pub const _117 = lc4k.PinInfo {
        .id = "117",
        .func = .{ .no_connect = {} },
    };
    pub const _118 = lc4k.PinInfo {
        .id = "118",
        .func = .{ .gnd = {} },
    };
    pub const _119 = lc4k.PinInfo {
        .id = "119",
        .func = .{ .vcco = {} },
    };
    pub const _120 = lc4k.PinInfo {
        .id = "120",
        .func = .{ .io = 6 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H6),
    };
    pub const _121 = lc4k.PinInfo {
        .id = "121",
        .func = .{ .io = 5 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H5),
    };
    pub const _122 = lc4k.PinInfo {
        .id = "122",
        .func = .{ .io = 4 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H4),
    };
    pub const _123 = lc4k.PinInfo {
        .id = "123",
        .func = .{ .io = 2 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H2),
    };
    pub const _124 = lc4k.PinInfo {
        .id = "124",
        .func = .{ .io = 1 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H1),
    };
    pub const _125 = lc4k.PinInfo {
        .id = "125",
        .func = .{ .io_oe1 = 0 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.io_H0),
    };
    pub const _126 = lc4k.PinInfo {
        .id = "126",
        .func = .{ .clock = 3 },
        .glb = 7,
        .grp_ordinal = @intFromEnum(GRP.clk3),
    };
    pub const _127 = lc4k.PinInfo {
        .id = "127",
        .func = .{ .gnd = {} },
    };
    pub const _128 = lc4k.PinInfo {
        .id = "128",
        .func = .{ .clock = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.clk0),
    };
    pub const _129 = lc4k.PinInfo {
        .id = "129",
        .func = .{ .vcc_core = {} },
    };
    pub const _130 = lc4k.PinInfo {
        .id = "130",
        .func = .{ .io_oe0 = 0 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A0),
    };
    pub const _131 = lc4k.PinInfo {
        .id = "131",
        .func = .{ .io = 1 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A1),
    };
    pub const _132 = lc4k.PinInfo {
        .id = "132",
        .func = .{ .io = 2 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A2),
    };
    pub const _133 = lc4k.PinInfo {
        .id = "133",
        .func = .{ .io = 4 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A4),
    };
    pub const _134 = lc4k.PinInfo {
        .id = "134",
        .func = .{ .io = 5 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A5),
    };
    pub const _135 = lc4k.PinInfo {
        .id = "135",
        .func = .{ .io = 6 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A6),
    };
    pub const _136 = lc4k.PinInfo {
        .id = "136",
        .func = .{ .vcco = {} },
    };
    pub const _137 = lc4k.PinInfo {
        .id = "137",
        .func = .{ .gnd = {} },
    };
    pub const _138 = lc4k.PinInfo {
        .id = "138",
        .func = .{ .io = 8 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A8),
    };
    pub const _139 = lc4k.PinInfo {
        .id = "139",
        .func = .{ .io = 9 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A9),
    };
    pub const _140 = lc4k.PinInfo {
        .id = "140",
        .func = .{ .io = 10 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A10),
    };
    pub const _141 = lc4k.PinInfo {
        .id = "141",
        .func = .{ .io = 12 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A12),
    };
    pub const _142 = lc4k.PinInfo {
        .id = "142",
        .func = .{ .io = 13 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A13),
    };
    pub const _143 = lc4k.PinInfo {
        .id = "143",
        .func = .{ .io = 14 },
        .glb = 0,
        .grp_ordinal = @intFromEnum(GRP.io_A14),
    };
    pub const _144 = lc4k.PinInfo {
        .id = "144",
        .func = .{ .no_connect = {} },
    };
};

pub const clock_pins = [_]lc4k.PinInfo {
    pins._128,
    pins._54,
    pins._56,
    pins._126,
};

pub const oe_pins = [_]lc4k.PinInfo {
    pins._130,
    pins._125,
};

pub const input_pins = [_]lc4k.PinInfo {
};

pub const all_pins = [_]lc4k.PinInfo {
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
