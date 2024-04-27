//[[!! include('devices', 'LC4064ZE_csBGA64') !! 584 ]]
//[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");

pub const device_type = lc4k.Device_Type.LC4064ZE_csBGA64;

pub const family = lc4k.Device_Family.zero_power_enhanced;
pub const package = lc4k.Device_Package.csBGA64;

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
pub const osctimer = struct {
    pub const osc_out = GRP.mc_A15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_D15;
    pub const timer_reset = timer_out;
};


pub const GRP = enum {
    clk0,
    clk1,
    clk2,
    clk3,
    in0,
    in1,
    in2,
    in3,
    in4,
    in5,
    io_A0,
    io_A1,
    io_A2,
    io_A3,
    io_A4,
    io_A5,
    io_A6,
    io_A7,
    io_A8,
    io_A9,
    io_A10,
    io_A11,
    io_A12,
    io_A13,
    io_A14,
    io_A15,
    io_B0,
    io_B1,
    io_B2,
    io_B3,
    io_B4,
    io_B5,
    io_B6,
    io_B7,
    io_B8,
    io_B9,
    io_B10,
    io_B11,
    io_B12,
    io_B13,
    io_B14,
    io_B15,
    io_C0,
    io_C1,
    io_C2,
    io_C3,
    io_C4,
    io_C5,
    io_C6,
    io_C7,
    io_C8,
    io_C9,
    io_C10,
    io_C11,
    io_C12,
    io_C13,
    io_C14,
    io_C15,
    io_D0,
    io_D1,
    io_D2,
    io_D3,
    io_D4,
    io_D5,
    io_D6,
    io_D7,
    io_D8,
    io_D9,
    io_D10,
    io_D11,
    io_D12,
    io_D13,
    io_D14,
    io_D15,
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

    pub inline fn kind(self: GRP) lc4k.GRP_Kind {
        return switch (@intFromEnum(self)) {
            @intFromEnum(GRP.clk0)...@intFromEnum(GRP.clk3) => .clk,
            @intFromEnum(GRP.in0)...@intFromEnum(GRP.in5) => .in,
            @intFromEnum(GRP.io_A0)...@intFromEnum(GRP.io_D15) => .io,
            @intFromEnum(GRP.mc_A0)...@intFromEnum(GRP.mc_D15) => .mc,
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
            .clk0 => pins._89,
            .clk1 => pins._38,
            .clk2 => pins._39,
            .clk3 => pins._88,
            .in0 => pins._12,
            .in1 => pins._23,
            .in2 => pins._27,
            .in3 => pins._62,
            .in4 => pins._73,
            .in5 => pins._77,
            .io_A0 => pins._91,
            .io_A1 => pins._92,
            .io_A2 => pins._93,
            .io_A3 => pins._94,
            .io_A4 => pins._97,
            .io_A5 => pins._98,
            .io_A6 => pins._99,
            .io_A7 => pins._100,
            .io_A8 => pins._3,
            .io_A9 => pins._4,
            .io_A10 => pins._5,
            .io_A11 => pins._6,
            .io_A12 => pins._8,
            .io_A13 => pins._9,
            .io_A14 => pins._10,
            .io_A15 => pins._11,
            .io_B0 => pins._37,
            .io_B1 => pins._36,
            .io_B2 => pins._35,
            .io_B3 => pins._34,
            .io_B4 => pins._31,
            .io_B5 => pins._30,
            .io_B6 => pins._29,
            .io_B7 => pins._28,
            .io_B8 => pins._22,
            .io_B9 => pins._21,
            .io_B10 => pins._20,
            .io_B11 => pins._19,
            .io_B12 => pins._17,
            .io_B13 => pins._16,
            .io_B14 => pins._15,
            .io_B15 => pins._14,
            .io_C0 => pins._41,
            .io_C1 => pins._42,
            .io_C2 => pins._43,
            .io_C3 => pins._44,
            .io_C4 => pins._47,
            .io_C5 => pins._48,
            .io_C6 => pins._49,
            .io_C7 => pins._50,
            .io_C8 => pins._53,
            .io_C9 => pins._54,
            .io_C10 => pins._55,
            .io_C11 => pins._56,
            .io_C12 => pins._58,
            .io_C13 => pins._59,
            .io_C14 => pins._60,
            .io_C15 => pins._61,
            .io_D0 => pins._87,
            .io_D1 => pins._86,
            .io_D2 => pins._85,
            .io_D3 => pins._84,
            .io_D4 => pins._81,
            .io_D5 => pins._80,
            .io_D6 => pins._79,
            .io_D7 => pins._78,
            .io_D8 => pins._72,
            .io_D9 => pins._71,
            .io_D10 => pins._70,
            .io_D11 => pins._69,
            .io_D12 => pins._67,
            .io_D13 => pins._66,
            .io_D14 => pins._65,
            .io_D15 => pins._64,
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
    pub const A1 = Pin.init_io("A1", .io_A6);
    pub const A2 = Pin.init_io("A2", .io_A4);
    pub const A3 = Pin.init_io("A3", .io_A2);
    pub const A4 = Pin.init_clk("A4", .clk3, 3, 3);
    pub const A5 = Pin.init_io("A5", .io_D2);
    pub const A6 = Pin.init_io("A6", .io_D4);
    pub const A7 = Pin.init_io("A7", .io_D6);
    pub const A8 = Pin.init_io("A8", .io_D7);
    pub const B1 = Pin.init_io("B1", .io_A8);
    pub const B2 = Pin.init_misc("B2", .tdi);
    pub const B3 = Pin.init_io("B3", .io_A1);
    pub const B4 = Pin.init_oe("B4", .io_A0, 0);
    pub const B5 = Pin.init_oe("B5", .io_D0, 1);
    pub const B6 = Pin.init_io("B6", .io_D3);
    pub const B7 = Pin.init_io("B7", .io_D5);
    pub const B8 = Pin.init_misc("B8", .tdo);
    pub const C1 = Pin.init_io("C1", .io_A11);
    pub const C2 = Pin.init_io("C2", .io_A10);
    pub const C3 = Pin.init_io("C3", .io_A12);
    pub const C4 = Pin.init_clk("C4", .clk0, 0, 0);
    pub const C5 = Pin.init_io("C5", .io_D10);
    pub const C6 = Pin.init_misc("C6", .vcco);
    pub const C7 = Pin.init_io("C7", .io_D9);
    pub const C8 = Pin.init_io("C8", .io_D8);
    pub const D1 = Pin.init_io("D1", .io_B15);
    pub const D2 = Pin.init_io("D2", .io_B14);
    pub const D3 = Pin.init_io("D3", .io_B12);
    pub const D4 = Pin.init_misc("D4", .gnd);
    pub const D5 = Pin.init_misc("D5", .vcc_core);
    pub const D6 = Pin.init_misc("D6", .vcco);
    pub const D7 = Pin.init_io("D7", .io_D12);
    pub const D8 = Pin.init_io("D8", .io_D11);
    pub const E1 = Pin.init_io("E1", .io_B13);
    pub const E2 = Pin.init_io("E2", .io_B10);
    pub const E3 = Pin.init_misc("E3", .vcco);
    pub const E4 = Pin.init_misc("E4", .vcc_core);
    pub const E5 = Pin.init_misc("E5", .gnd);
    pub const E6 = Pin.init_io("E6", .io_D13);
    pub const E7 = Pin.init_io("E7", .io_D14);
    pub const E8 = Pin.init_io("E8", .io_D15);
    pub const F1 = Pin.init_io("F1", .io_B11);
    pub const F2 = Pin.init_io("F2", .io_B8);
    pub const F3 = Pin.init_io("F3", .io_B2);
    pub const F4 = Pin.init_misc("F4", .vcco);
    pub const F5 = Pin.init_io("F5", .io_C0);
    pub const F6 = Pin.init_io("F6", .io_C5);
    pub const F7 = Pin.init_io("F7", .io_C10);
    pub const F8 = Pin.init_io("F8", .io_C12);
    pub const G1 = Pin.init_io("G1", .io_B9);
    pub const G2 = Pin.init_io("G2", .io_B6);
    pub const G3 = Pin.init_io("G3", .io_B3);
    pub const G4 = Pin.init_clk("G4", .clk1, 1, 1);
    pub const G5 = Pin.init_io("G5", .io_C1);
    pub const G6 = Pin.init_io("G6", .io_C2);
    pub const G7 = Pin.init_io("G7", .io_C8);
    pub const G8 = Pin.init_io("G8", .io_C11);
    pub const H1 = Pin.init_misc("H1", .tck);
    pub const H2 = Pin.init_io("H2", .io_B5);
    pub const H3 = Pin.init_io("H3", .io_B4);
    pub const H4 = Pin.init_io("H4", .io_B0);
    pub const H5 = Pin.init_clk("H5", .clk2, 2, 2);
    pub const H6 = Pin.init_io("H6", .io_C4);
    pub const H7 = Pin.init_io("H7", .io_C6);
    pub const H8 = Pin.init_misc("H8", .tms);
};

pub const clock_pins = [_]Pin {
    pins.C4,
    pins.G4,
    pins.H5,
    pins.A4,
};

pub const oe_pins = [_]Pin {
    pins.B4,
    pins.B5,
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
    pins.B1,
    pins.B2,
    pins.B3,
    pins.B4,
    pins.B5,
    pins.B6,
    pins.B7,
    pins.B8,
    pins.C1,
    pins.C2,
    pins.C3,
    pins.C4,
    pins.C5,
    pins.C6,
    pins.C7,
    pins.C8,
    pins.D1,
    pins.D2,
    pins.D3,
    pins.D4,
    pins.D5,
    pins.D6,
    pins.D7,
    pins.D8,
    pins.E1,
    pins.E2,
    pins.E3,
    pins.E4,
    pins.E5,
    pins.E6,
    pins.E7,
    pins.E8,
    pins.F1,
    pins.F2,
    pins.F3,
    pins.F4,
    pins.F5,
    pins.F6,
    pins.F7,
    pins.F8,
    pins.G1,
    pins.G2,
    pins.G3,
    pins.G4,
    pins.G5,
    pins.G6,
    pins.G7,
    pins.G8,
    pins.H1,
    pins.H2,
    pins.H3,
    pins.H4,
    pins.H5,
    pins.H6,
    pins.H7,
    pins.H8,
};

//[[ ######################### END OF GENERATED CODE ######################### ]]
