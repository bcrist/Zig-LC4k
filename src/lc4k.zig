const std = @import("std");
const common = @import("common.zig");
pub usingnamespace common;

pub const LC4032V_TQFP44 = LC4k(.LC4032x_TQFP44);
pub const LC4032B_TQFP44 = LC4k(.LC4032x_TQFP44);
pub const LC4032C_TQFP44 = LC4k(.LC4032x_TQFP44);
pub const LC4032V_TQFP48 = LC4k(.LC4032x_TQFP48);
pub const LC4032B_TQFP48 = LC4k(.LC4032x_TQFP48);
pub const LC4032C_TQFP48 = LC4k(.LC4032x_TQFP48);
pub const LC4032ZC_TQFP48 = LC4k(.LC4032ZC_TQFP48);
pub const LC4032ZE_TQFP48 = LC4k(.LC4032ZE_TQFP48);
pub const LC4032ZC_csBGA56 = LC4k(.LC4032ZC_csBGA56);
pub const LC4032ZE_csBGA64 = LC4k(.LC4032ZE_csBGA64);

pub const LC4064V_TQFP44 = LC4k(.LC4064x_TQFP44);
pub const LC4064B_TQFP44 = LC4k(.LC4064x_TQFP44);
pub const LC4064C_TQFP44 = LC4k(.LC4064x_TQFP44);
pub const LC4064V_TQFP48 = LC4k(.LC4064x_TQFP48);
pub const LC4064B_TQFP48 = LC4k(.LC4064x_TQFP48);
pub const LC4064C_TQFP48 = LC4k(.LC4064x_TQFP48);
pub const LC4064ZC_TQFP48 = LC4k(.LC4064ZC_TQFP48);
pub const LC4064ZE_TQFP48 = LC4k(.LC4064ZE_TQFP48);
pub const LC4064V_TQFP100 = LC4k(.LC4064x_TQFP100);
pub const LC4064B_TQFP100 = LC4k(.LC4064x_TQFP100);
pub const LC4064C_TQFP100 = LC4k(.LC4064x_TQFP100);
pub const LC4064ZC_TQFP100 = LC4k(.LC4064ZC_TQFP100);
pub const LC4064ZE_TQFP100 = LC4k(.LC4064ZE_TQFP100);
pub const LC4064ZC_csBGA56 = LC4k(.LC4064ZC_csBGA56);
pub const LC4064ZE_csBGA64 = LC4k(.LC4064ZE_csBGA64);
pub const LC4064ZE_ucBGA64 = LC4k(.LC4064ZE_ucBGA64);
pub const LC4064ZC_csBGA132 = LC4k(.LC4064ZC_csBGA132);
pub const LC4064ZE_csBGA144 = LC4k(.LC4064ZE_csBGA144);

pub const LC4128V_TQFP100 = LC4k(.LC4128x_TQFP100);
pub const LC4128B_TQFP100 = LC4k(.LC4128x_TQFP100);
pub const LC4128C_TQFP100 = LC4k(.LC4128x_TQFP100);
pub const LC4128ZC_TQFP100 = LC4k(.LC4128ZC_TQFP100);
pub const LC4128ZE_TQFP100 = LC4k(.LC4128ZE_TQFP100);
pub const LC4128V_TQFP128 = LC4k(.LC4128x_TQFP128);
pub const LC4128B_TQFP128 = LC4k(.LC4128x_TQFP128);
pub const LC4128C_TQFP128 = LC4k(.LC4128x_TQFP128);
pub const LC4128V_TQFP144 = LC4k(.LC4128V_TQFP144);
pub const LC4128ZE_TQFP144 = LC4k(.LC4128ZE_TQFP144);
pub const LC4128ZC_csBGA132 = LC4k(.LC4128ZC_csBGA132);
pub const LC4128ZE_csBGA144 = LC4k(.LC4128ZE_csBGA144);
pub const LC4128ZE_ucBGA132 = LC4k(.LC4128ZE_ucBGA132);

pub fn LC4k(comptime device: common.DeviceType) type {
    const D = device.get();

    const GOE01_Config = switch (D.num_glbs) {
        2 => GOEConfig,
        else => GOEConfigWithSource,
    };

    return switch (D.family) {
        .zero_power_enhanced => struct {
            glb: [D.num_glbs] GlbConfig(D) = GlbConfig(D).initAllUnused(D.num_glbs),
            clock: [D.clock_pins.len] InputConfigZE = [_]InputConfigZE { .{} } ** D.clock_pins.len,
            input: [D.input_pins.len] InputConfigZE = [_]InputConfigZE { .{} } ** D.input_pins.len,

            goe0: GOE01_Config = .{},
            goe1: GOE01_Config = .{},
            goe2: GOEConfig = .{},
            goe3: GOEConfig = .{},

            zero_hold_time: bool = false,
            osctimer: struct {
                pub const signals = D.osctimer;
                enable_osc_out_and_disable: bool = false,
                enable_timer_out_and_reset: bool = false,
            } = .{},

            default_bus_maintenance: common.BusMaintenance = .keeper,
            default_input_threshold: common.InputThreshold = .high,
            default_slew_rate: common.SlewRate = .slow,
            default_drive_type: common.DriveType = .push_pull,

            pub usingnamespace D;
        },
        else => struct {
            glb: [D.num_glbs] GlbConfig(D) = GlbConfig(D).initAllUnused(D.num_glbs),
            clock: [D.clock_pins.len] InputConfigZE = [_]InputConfigZE { .{} } ** D.clock_pins.len,
            input: [D.input_pins.len] InputConfigZE = [_]InputConfigZE { .{} } ** D.input_pins.len,

            goe0: GOE01_Config = .{},
            goe1: GOE01_Config = .{},
            goe2: GOEConfig = .{},
            goe3: GOEConfig = .{},

            bus_maintenance: common.BusMaintenance = .keeper,

            default_input_threshold: common.InputThreshold = .high,
            default_slew_rate: common.SlewRate = .slow,
            default_drive_type: common.DriveType = .push_pull,

            pub usingnamespace D;
        },
    };
}

fn GlbConfig(comptime D: type) type {
    return struct {
        mc: [D.num_mcs_per_glb] MacrocellConfig(D.family, D.GRP),
        shared_pt_init: union(enum) {
            active_high: []const Factor(D.GRP),
            active_low: []const Factor(D.GRP),
        },
        shared_pt_clock: union(enum) {
            active_high: []const Factor(D.GRP),
            active_low: []const Factor(D.GRP),
        },
        shared_pt_enable: []const Factor(D.GRP),
        shared_pt_enable_to_oe_bus: [D.oe_bus_size] bool,
        bclock0: enum { clk0_pos, clk1_neg },
        bclock1: enum { clk1_pos, clk0_neg },
        bclock2: enum { clk2_pos, clk3_neg },
        bclock3: enum { clk3_pos, clk2_neg },

        const Self = @This();

        pub fn initAllUnused(comptime num_glbs: comptime_int) [num_glbs]Self { comptime {
            var configs: [num_glbs]Self = undefined;
            var i = 0;
            while (i < num_glbs) : (i += 1) {
                configs[i] = initUnused(i);
            }
            return configs;
        }}

        pub fn initUnused(glb: usize) Self {
            var self = Self {

            };

            if (glb < D.oe_bus_size) {
                self.shared_pt_enable = &.{ .{ .always } };
                self.shared_pt_enable_to_oe_bus[glb] = true;
            }

            return self;
        }
    };
}

pub fn MacrocellConfig(comptime family: common.DeviceFamily, comptime GRP: type) type {
    const Input_Config = switch (family) {
        .zero_power_enhanced => InputConfigZE,
        else => InputConfig,
    };
    const Output_Config = switch (family) {
        .zero_power_enhanced => OutputConfigZE,
        else => OutputConfig,
    };

    return struct {
        sum: []const[]const GRP = &[_][]const GRP {},
        xor: union(enum) {
            input,
            pt0: InvertPolarity,
            constant: InvertPolarity,
        } = .{ .constant = .non_inverted },
        func: common.MacrocellFunction,
        clock: union(enum) {
            none,
            shared_pt_clock,
            pt1_pos: []const GRP,
            pt1_neg: []const GRP,
            bclock: u2,
        } = .{ .none },
        ce: union(enum) {
            pt2_active_high: []const GRP,
            pt2_active_low: []const GRP,
            shared_pt_clock,
            always_active,
        } = .{ .always_active },
        init_state: u1 = 0,
        init_source: enum {
            pt3,
            shared_pt_init,
        } = .shared_pt_init,
        async_source: union(enum) {
            none,
            pt2_active_high: []const GRP,
        } = .{ .none },

        input: Input_Config,
        output: Output_Config,
    };
}

pub fn Factor(comptime GRP: type) type {
    return union(enum) {
        always,
        never,
        when_high: GRP,
        when_low: GRP,
    };
}

pub const InputConfig = struct {
    threshold: ?common.InputThreshold = null,
};
pub const InputConfigZE = struct {
    threshold: ?common.InputThreshold = null,
    bus_maintenance: ?common.BusMaintenance = null,
    power_guard: common.PowerGuard = .disabled,
};

pub const OutputConfig = struct {
    slew_rate: ?common.SlewRate = null,
    drive_type: ?common.DriveType = null,
    oe: common.OutputEnableSource,
    oe_routing: OutputRouting = .{ .relative = 0 },
    routing: union(enum) {
        same_as_oe,
        self,
        five_pt_fast_bypass: InvertPolarity,
    } = .{ .same_as_oe },
};
pub const OutputConfigZE = struct {
    slew_rate: ?common.SlewRate = null,
    drive_type: ?common.DriveType = null,
    oe: common.OutputEnableSource,
    routing: OutputRouting = .{ .relative = 0 },
};

pub const OutputRouting = union(enum) {
    relative: u3,
    absolute: common.MacrocellRef,
};

pub const GOEPolarity = enum {
    active_high,
    active_low,
};

pub const InvertPolarity = enum {
    non_inverted,
    inverted,
};

pub const GOEConfig = struct {
    polarity: GOEPolarity = .active_high,
};

pub const GOEConfigWithSource = struct {
    polarity: GOEPolarity = .active_high,
    source: enum {
        bus,
        input,
    } = .bus,
};
