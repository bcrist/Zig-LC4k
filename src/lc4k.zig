const std = @import("std");
const common = @import("common.zig");
const jedec = @import("jedec.zig");
const assembly = @import("assembly.zig");
const disassembly = @import("disassembly.zig");
const routing = @import("routing.zig");
const jed_file = @import("jed_file.zig");
const svf_file = @import("svf_file.zig");
const report = @import("report.zig");
pub usingnamespace common;
pub usingnamespace jedec;
const lc4k = @This();

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

    const Input_Config = switch (D.family) {
        .zero_power_enhanced => InputConfigZE,
        else => InputConfig,
    };

    const GOE01_Config = switch (D.num_glbs) {
        2 => GOEConfigBus,
        else => GOEConfigBusOrPin,
    };
    const GOE23_Config = switch (D.num_glbs) {
        2 => GOEConfigPin,
        else => GOEConfigBus,
    };

    const Ext = switch (D.family) {
        .zero_power_enhanced => struct {
            default_power_guard: common.PowerGuard = .disabled,
            osctimer: ?OscTimerConfig(D) = null,
        },
        else => struct {},
    };

    return struct {
        glb: [D.num_glbs] GlbConfig(D) = GlbConfig(D).initAllUnused(D.num_glbs),
        clock: [D.clock_pins.len] Input_Config = [_]Input_Config { .{} } ** D.clock_pins.len,
        input: [D.input_pins.len] Input_Config = [_]Input_Config { .{} } ** D.input_pins.len,

        goe0: GOE01_Config = .{},
        goe1: GOE01_Config = .{},
        goe2: GOE23_Config = .{},
        goe3: GOE23_Config = .{},

        zero_hold_time: bool = false,

        usercode: ?u32 = null,
        security: bool = false,

        default_bus_maintenance: common.BusMaintenance = .keeper,
        default_input_threshold: common.InputThreshold = .high,
        default_slew_rate: common.SlewRate = .slow,
        default_drive_type: common.DriveType = .push_pull,

        ext: Ext = .{},

        pub usingnamespace D;
        pub const PT = lc4k.PT(D.GRP);
        pub const PTs = PTBuilder(D);

        const Self = @This();

        pub fn glb(self: *Self, comptime which: anytype) *GlbConfig(D) {
            return &self.glb[D.getGlbIndex(which)];
        }
        pub fn mc(self: *Self, comptime which: anytype) *MacrocellConfig(D.family, D.GRP) {
            const mcref = D.getMacrocellRef(which);
            return &self.glb[mcref.glb].mc[mcref.mc];
        }
        pub fn assemble(self: Self, allocator: std.mem.Allocator) !assembly.AssemblyResults {
            return assembly.assemble(D, self, allocator);
        }
        pub fn disassemble(allocator: std.mem.Allocator, file: jedec.JedecFile) !disassembly.DisassemblyResults(D) {
            return disassembly.disassemble(D, allocator, file);
        }
        pub fn parseJED(allocator: std.mem.Allocator, text: []const u8) !jedec.JedecFile {
            return jed_file.parse(allocator, D.jedec_dimensions.width(), D.jedec_dimensions.height(), text);
        }
        pub fn writeJED(allocator: std.mem.Allocator, file: jedec.JedecFile, writer: anytype, options: jed_file.WriteOptions) !void {
            return jed_file.write(D.device_type, allocator, file, writer, options);
        }
        pub fn writeSVF(file: jedec.JedecFile, writer: anytype, options: svf_file.WriteOptions) !void {
            return svf_file.write(D, file, writer, options);
        }
        pub fn writeReport(file: jedec.JedecFile, writer: anytype, options: report.WriteOptions(D)) !void {
            return report.write(D, file, writer, options);
        }
    };
}

pub fn GlbConfig(comptime D: type) type {
    return struct {
        mc: [D.num_mcs_per_glb] MacrocellConfig(D.family, D.GRP),
        shared_pt_init: union(enum) {
            active_high: PT(D.GRP),
            active_low: PT(D.GRP),
        },
        shared_pt_clock: union(enum) {
            positive: PT(D.GRP), // active high when used as a latch or clock enable
            negative: PT(D.GRP), // active low when used as a latch or clock enable
        },
        shared_pt_enable: PT(D.GRP),
        bclock0: enum { clk0_pos, clk1_neg },
        bclock1: enum { clk1_pos, clk0_neg },
        bclock2: enum { clk2_pos, clk3_neg },
        bclock3: enum { clk3_pos, clk2_neg },

        const Self = @This();

        pub fn initAllUnused(comptime num_glbs: comptime_int) [num_glbs]Self { comptime {
            var configs: [num_glbs]Self = undefined;
            var i = 0;
            while (i < num_glbs) : (i += 1) {
                configs[i] = initUnused();
            }
            return configs;
        }}

        pub fn initUnused() Self {
            var self = Self {
                .mc = undefined,
                .shared_pt_init = .{ .active_low = PTBuilder(D).always() },
                .shared_pt_clock = .{ .positive = PTBuilder(D).always() },
                .shared_pt_enable = PTBuilder(D).always(),
                .bclock0 = .clk0_pos,
                .bclock1 = .clk1_pos,
                .bclock2 = .clk2_pos,
                .bclock3 = .clk3_pos,
            };

            if (D.clock_pins.len < 4) {
                self.bclock1 = .clk0_neg;
                self.bclock3 = .clk2_neg;
            }

            for (self.mc) |*mc| {
                mc.* = MacrocellConfig(D.family, D.GRP).initUnused();
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
        else => OutputConfig(GRP),
    };

    return struct {
        sum_routing: ?common.ClusterRouting = null,
        wide_sum_routing: ?common.WideRouting = null,
        logic: union(enum) {
            sum: []const PT(GRP),
            sum_inverted: []const PT(GRP),
            input_buffer,
            pt0: PT(GRP),
            pt0_inverted: PT(GRP),
            sum_xor_pt0: SumXorPt0(GRP),
            sum_xor_pt0_inverted: SumXorPt0(GRP),
        },
        func: union(common.MacrocellFunction) {
            combinational: void,
            latch: RegisterConfig(GRP),
            t_ff: RegisterConfig(GRP),
            d_ff: RegisterConfig(GRP),
        },
        pt4_oe: ?PT(GRP) = null,
        input: Input_Config = .{},
        output: Output_Config,

        const Self = @This();

        pub fn initUnused() Self {
            return .{
                .logic = .{ .sum = &[_]PT(GRP) { &.{} } },
                .func = .{ .combinational = {} },
                .output = .{ .oe = .input_only },
            };
        }
    };
}

pub const InputConfig = struct {
    threshold: ?common.InputThreshold = null,
};
pub const InputConfigZE = struct {
    threshold: ?common.InputThreshold = null,
    bus_maintenance: ?common.BusMaintenance = null,
    power_guard: ?common.PowerGuard = null,
};

pub fn OutputConfig(comptime GRP: type) type {
    return struct {
        slew_rate: ?common.SlewRate = null,
        drive_type: ?common.DriveType = null,
        oe: common.OutputEnableMode,
        oe_routing: OutputRouting = .{ .relative = 0 },
        routing: union(enum) {
            same_as_oe,
            self,
            five_pt_fast_bypass: []const PT(GRP),
            five_pt_fast_bypass_inverted: []const PT(GRP),
        } = .{ .same_as_oe = {} },
    };
}
pub const OutputConfigZE = struct {
    slew_rate: ?common.SlewRate = null,
    drive_type: ?common.DriveType = null,
    oe: common.OutputEnableMode,
    routing: OutputRouting = .{ .relative = 0 },
};

pub const OutputRouting = union(enum) {
    relative: u3,
    absolute: common.MacrocellIndex,
};

pub const GOEPolarity = enum {
    active_high,
    active_low,
};

pub const GOEConfigPin = struct {
    polarity: GOEPolarity = .active_high,
};

pub const GOEConfigBus = struct {
    polarity: GOEPolarity = .active_high,
    source: union(enum) {
        constant_high: void,
        glb_shared_pt_enable: common.GlbIndex,
    } = .{ .constant_high = {} },
};

pub const GOEConfigBusOrPin = struct {
    polarity: GOEPolarity = .active_high,
    source: union(enum) {
        constant_high: void,
        input: void,
        glb_shared_pt_enable: common.GlbIndex,
    } = .{ .constant_high = {} },
};

pub fn OscTimerConfig(comptime Device: type) type {
    return struct {
        pub const signals = Device.osctimer;
        enable_osc_out_and_disable: bool = false,
        enable_timer_out_and_reset: bool = false,
        timer_divisor: common.TimerDivisor = .div1048576,
    };
}

pub fn SumXorPt0(comptime GRP: type) type {
    return struct {
        sum: []const PT(GRP),
        pt0: PT(GRP),
    };
}

pub fn RegisterConfig(comptime GRP: type) type {
    return struct {
        clock: union(enum) {
            none,
            shared_pt_clock,
            pt1_positive: PT(GRP),
            pt1_negative: PT(GRP),
            bclock: u2,
        } = .{ .none = {} },
        ce: union(enum) {
            pt2_active_high: PT(GRP),
            pt2_active_low: PT(GRP),
            shared_pt_clock,
            always_active,
        } = .{ .always_active = {} },
        init_state: u1 = 0,
        init_source: union(enum) {
            pt3_active_high: PT(GRP),
            shared_pt_init,
        } = .{ .shared_pt_init = {} },
        async_source: union(enum) {
            none,
            pt2_active_high: PT(GRP),
        } = .{ .none = {} },
    };
}

pub fn PT(comptime GRP: type) type {
    return []const Factor(GRP);
}

pub fn Factor(comptime GRP: type) type {
    return union(enum) {
        // "always" can normally just be represented by an empty PT,
        // but sometimes necessary to represent it in a Factor instead.
        always,
        never,
        when_high: GRP,
        when_low: GRP,
    };
}

pub fn PTBuilder(comptime Device: type) type {
    const GRP = Device.GRP;
    return struct {

        pub fn always() PT(GRP) { comptime {
            return &.{};
        }}

        pub fn never() PT(GRP) { comptime {
            return &.{ .{ .never = {} } };
        }}

        pub fn of(comptime what: anytype) PT(GRP) { comptime {
            return switch (@TypeOf(what)) {
                PT(GRP) => what,
                Factor(GRP) => &.{ what },
                GRP => &.{ .{ .when_high = what } },
                common.PinInfo => &.{ .{ .when_high = @intToEnum(GRP, what.grp_ordinal.?) } },
                else => &.{ .{ .when_high = Device.getGrp(what) } },
            };
        }}

        pub fn not(comptime what: anytype) PT(GRP) { comptime {
            return switch (@TypeOf(what)) {
                PT(GRP) => switch (what.len) {
                    0 => never(),
                    1 => not(what[0]),
                    else => unreachable,
                },
                Factor(GRP) => switch(what) {
                    .always => never(),
                    .never => always(),
                    .when_high => |grp| &.{ Factor(GRP) { .when_low = grp } },
                    .when_low => |grp| &.{ Factor(GRP) { .when_high = grp } },
                },
                GRP => &.{ Factor(GRP) { .when_low = what } },
                common.PinInfo => &.{ Factor(GRP) { .when_low = @intToEnum(GRP, what.grp_ordinal.?) } },
                else => &.{ Factor(GRP) { .when_low = Device.getGrp(what) } },
            };
        }}

        pub fn all(comptime which: anytype) PT(GRP) { comptime {
            var pt: PT(GRP) = &.{};
            switch (@typeInfo(@TypeOf(which))) {
                .Struct => |info| {
                    std.debug.assert(info.is_tuple);
                    for (info.fields) |field| {
                        pt = andPT(pt, of(@field(which, field.name)));
                    }
                },
                .Array => {
                    for (which) |signal| {
                        pt = andPT(pt, of(signal));
                    }
                },
                .Pointer => |info| {
                    std.debug.assert(info.size == .Slice);
                    for (which) |signal| {
                        pt = andPT(pt, of(signal));
                    }
                },
                else => unreachable,
            }
            return pt;
        }}

        pub fn eql(comptime which: anytype, comptime value: usize) PT(GRP) { comptime {
            var pt: PT(GRP) = &.{};
            switch (@typeInfo(@TypeOf(which))) {
                .Struct => |info| {
                    std.debug.assert(info.is_tuple);
                    var bit_value: usize = 1;
                    for (info.fields) |field| {
                        var factor = of(@field(which, field.name));
                        if ((value & bit_value) == 0) {
                            factor = not(factor);
                        }
                        pt = andPT(pt, factor);
                        bit_value <<= 1;
                    }
                },
                .Array => {
                    var bit_value: usize = 1;
                    for (which) |signal| {
                        var factor = of(signal);
                        if ((value & bit_value) == 0) {
                            factor = not(factor);
                        }
                        pt = andPT(pt, factor);
                        bit_value <<= 1;
                    }
                },
                .Pointer => |info| {
                    std.debug.assert(info.size == .Slice);
                    var bit_value: usize = 1;
                    for (which) |signal| {
                        var factor = of(signal);
                        if ((value & bit_value) == 0) {
                            factor = not(factor);
                        }
                        pt = andPT(pt, factor);
                        bit_value <<= 1;
                    }
                },
                else => unreachable,
            }
            return pt;
        }}

        fn andPT(comptime base: PT(GRP), comptime extra: PT(GRP)) PT(GRP) { comptime {
            var pt = base;
            for (extra) |factor| {
                pt = andFactor(pt, factor);
            }
            return pt;
        }}

        fn andFactor(comptime base: PT(GRP), comptime factor: Factor(GRP)) PT(GRP) { comptime {
            switch (factor) {
                .always => return base,
                .never => return &.{ factor },
                .when_high => |new_signal| {
                    for (base) |existing_factor| switch (existing_factor) {
                        .always => return &.{ factor },
                        .never => return base,
                        .when_high => |old_signal| if (new_signal == old_signal) return base,
                        .when_low => |old_signal| if (new_signal == old_signal) return &.{ .{ .never = {} } },
                    };
                },
                .when_low => |new_signal| {
                    for (base) |existing_factor| switch (existing_factor) {
                        .always => return &.{ factor },
                        .never => return base,
                        .when_high => |old_signal| if (new_signal == old_signal) return &.{ .{ .never = {} } },
                        .when_low => |old_signal| if (new_signal == old_signal) return base,
                    };
                },
            }
            return base ++ [_]Factor(GRP) {  factor };
        }}

    };
}
