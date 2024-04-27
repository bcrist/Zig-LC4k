
pub const DeviceFamily = enum {
    low_power, // V/B/C suffix
    zero_power, // ZC suffix
    zero_power_enhanced, // ZE suffix
};

pub const DevicePackage = enum {
    TQFP44,
    TQFP48,
    csBGA56,
    csBGA64,
    ucBGA64,
    TQFP100,
    TQFP128,
    csBGA132,
    ucBGA132,
    TQFP144,
    csBGA144,
};

pub const DeviceType = enum {
    //[[!! include 'devices'
    // for device in spairs(devices) do
    //     write(device, ',', nl)
    // end
    // writeln(nl, 'pub fn get(comptime self: DeviceType) type {', indent)
    // write('return switch(self) {', indent)
    // for device in spairs(devices) do
    //     write(nl, '.', device, ' => @import("device/', device, '.zig"),')
    // end
    // writeln(unindent, nl, '};', unindent, nl, '}')
    //!! 63 ]]
    //[[ ################# !! GENERATED CODE -- DO NOT MODIFY !! ################# ]]
    LC4032ZC_TQFP48,
    LC4032ZC_csBGA56,
    LC4032ZE_TQFP48,
    LC4032ZE_csBGA64,
    LC4032x_TQFP44,
    LC4032x_TQFP48,
    LC4064ZC_TQFP100,
    LC4064ZC_TQFP48,
    LC4064ZC_csBGA132,
    LC4064ZC_csBGA56,
    LC4064ZE_TQFP100,
    LC4064ZE_TQFP48,
    LC4064ZE_csBGA144,
    LC4064ZE_csBGA64,
    LC4064ZE_ucBGA64,
    LC4064x_TQFP100,
    LC4064x_TQFP44,
    LC4064x_TQFP48,
    LC4128V_TQFP144,
    LC4128ZC_TQFP100,
    LC4128ZC_csBGA132,
    LC4128ZE_TQFP100,
    LC4128ZE_TQFP144,
    LC4128ZE_csBGA144,
    LC4128ZE_ucBGA132,
    LC4128x_TQFP100,
    LC4128x_TQFP128,

    pub fn get(comptime self: DeviceType) type {
        return switch(self) {
            .LC4032ZC_TQFP48 => @import("device/LC4032ZC_TQFP48.zig"),
            .LC4032ZC_csBGA56 => @import("device/LC4032ZC_csBGA56.zig"),
            .LC4032ZE_TQFP48 => @import("device/LC4032ZE_TQFP48.zig"),
            .LC4032ZE_csBGA64 => @import("device/LC4032ZE_csBGA64.zig"),
            .LC4032x_TQFP44 => @import("device/LC4032x_TQFP44.zig"),
            .LC4032x_TQFP48 => @import("device/LC4032x_TQFP48.zig"),
            .LC4064ZC_TQFP100 => @import("device/LC4064ZC_TQFP100.zig"),
            .LC4064ZC_TQFP48 => @import("device/LC4064ZC_TQFP48.zig"),
            .LC4064ZC_csBGA132 => @import("device/LC4064ZC_csBGA132.zig"),
            .LC4064ZC_csBGA56 => @import("device/LC4064ZC_csBGA56.zig"),
            .LC4064ZE_TQFP100 => @import("device/LC4064ZE_TQFP100.zig"),
            .LC4064ZE_TQFP48 => @import("device/LC4064ZE_TQFP48.zig"),
            .LC4064ZE_csBGA144 => @import("device/LC4064ZE_csBGA144.zig"),
            .LC4064ZE_csBGA64 => @import("device/LC4064ZE_csBGA64.zig"),
            .LC4064ZE_ucBGA64 => @import("device/LC4064ZE_ucBGA64.zig"),
            .LC4064x_TQFP100 => @import("device/LC4064x_TQFP100.zig"),
            .LC4064x_TQFP44 => @import("device/LC4064x_TQFP44.zig"),
            .LC4064x_TQFP48 => @import("device/LC4064x_TQFP48.zig"),
            .LC4128V_TQFP144 => @import("device/LC4128V_TQFP144.zig"),
            .LC4128ZC_TQFP100 => @import("device/LC4128ZC_TQFP100.zig"),
            .LC4128ZC_csBGA132 => @import("device/LC4128ZC_csBGA132.zig"),
            .LC4128ZE_TQFP100 => @import("device/LC4128ZE_TQFP100.zig"),
            .LC4128ZE_TQFP144 => @import("device/LC4128ZE_TQFP144.zig"),
            .LC4128ZE_csBGA144 => @import("device/LC4128ZE_csBGA144.zig"),
            .LC4128ZE_ucBGA132 => @import("device/LC4128ZE_ucBGA132.zig"),
            .LC4128x_TQFP100 => @import("device/LC4128x_TQFP100.zig"),
            .LC4128x_TQFP128 => @import("device/LC4128x_TQFP128.zig"),
        };
    }

    //[[ ######################### END OF GENERATED CODE ######################### ]]

    pub fn parse(name: []const u8) ?DeviceType {
        for (std.enums.values(DeviceType)) |e| {
            if (std.mem.eql(u8, name, @tagName(e))) {
                return e;
            }
        }
        return null;
    }
};

pub const GiIndex = u8;
pub const GlbIndex = u8;
pub const MacrocellIndex = u8;
pub const PTIndex = u8;
pub const ClockIndex = u8;
pub const GoeIndex = u8;

pub const MacrocellRef = struct {
    glb: GlbIndex,
    mc: MacrocellIndex,

    pub fn init(glb: usize, mc: usize) MacrocellRef {
        return .{
            .glb = @intCast(glb),
            .mc = @intCast(mc),
        };
    }
};

pub const PTRef = struct {
    mcref: MacrocellRef,
    pt: PTIndex,

    pub fn init(glb: usize, mc: usize, pt: usize) PTRef {
        return .{
            .mcref = MacrocellRef.init(glb, mc),
            .pt = @intCast(pt),
        };
    }
};

pub const PinFunction = union(enum) {
    io: MacrocellIndex,
    io_oe0: MacrocellIndex,
    io_oe1: MacrocellIndex,
    input,
    clock: ClockIndex,
    no_connect,
    gnd,
    vcc_core,
    vcco,
    tck,
    tms,
    tdi,
    tdo,
};

pub const PinInfo = struct {
    id: []const u8, // pin number or ball location
    func: PinFunction,
    glb: ?GlbIndex = null, // only meaningful when func is io, io_oe0, io_oe1, input, or clock
    grp_ordinal: ?u16 = null, // use with @intToEnum(GRP, grp_ordinal)

    pub fn mcRef(self: PinInfo) ?MacrocellRef {
        return if (self.glb) |glb| switch (self.func) {
            .io, .io_oe0, .io_oe1 => |mc| MacrocellRef { .glb = glb, .mc = mc },
            else => null,
        } else null;
    }
};

pub const BusMaintenance = enum(u2) {
    pulldown = 0,
    float = 1,
    keeper = 2,
    pullup = 3,
};

// The datasheets and IBIS models are quite vague about
// the actual input structure used in the devices, and
// in particular what the input threshold fuse actually
// does.  So these are mostly guesses based on the published
// Vil and Vih limits in the datasheet, and assuming that
// the threshold voltage is always based on Vcc, not Vcco.
//
// Generally speaking, the high threshold is suitable for
// either 2.5V or 3.3V signals, and the low threshold is
// for 1.8V or 1.5V signals.
pub const InputThreshold = enum(u1) {
                //   ZE                   C/ZC         B           V
    low = 1,    // 0.50*Vcc             0.50*Vcc    0.36*Vcc    0.28*Vcc
    high = 0,   // 0.68*Vcc (falling)   0.73*Vcc    0.50*Vcc    0.40*Vcc
                // 0.79*Vcc (rising)
};

pub const DriveType = enum(u1) {
    push_pull = 1,
    open_drain = 0,
};

pub const SlewRate = enum(u1) {
    slow = 1,
    fast = 0,
};

pub const OutputEnableMode = enum(u3) {
    goe0 = 0,
    goe1 = 1,
    goe2 = 2,
    goe3 = 3,
    from_orm_active_high = 4,
    from_orm_active_low = 5,
    output_only = 6,
    input_only = 7,
};

// note: non-ZE family only
pub const OutputRoutingMode = enum(u2) {
    same_as_oe = 2,
    self = 3,
    five_pt_fast_bypass = 0,
    five_pt_fast_bypass_inverted = 1,
};

pub const PowerGuard = enum(u1) {
    from_bie = 0,
    disabled = 1,
};

pub const TimerDivisor = enum(u2) {
    div128 = 0,
    div1024 = 2,
    div1048576 = 1,
    _
};

pub const MacrocellFunction = enum(u2) {
    combinational = 0,
    latch = 1,
    t_ff = 2,
    d_ff = 3,
};

pub const ClusterRouting = enum(u2) {
    self_minus_two = 0,
    self = 1,
    self_plus_one = 2,
    self_minus_one = 3,
};

pub const WideRouting = enum(u1) {
    self_plus_four = 0,
    self = 1,
};

pub const Clock_Source = enum(u3) {
    none,
    shared_pt_clock,
    pt1_positive,
    pt1_negative,
    bclock0,
    bclock1,
    bclock2,
    bclock3,
};

pub const Clock_Enable_Source = enum(u2) {
    pt2_active_high = 0,
    pt2_active_low = 1,
    shared_pt_clock = 2,
    always_active = 3,
};

pub const Async_Trigger_Source = enum(u1) {
    pt2_active_high = 0,
    none = 1,
};

pub const Init_Source = enum(u1) {
    pt3_active_high = 0,
    shared_pt_init = 1,
};

pub const Macrocell_Output_Enable_Source = enum(u1) {
    pt4_active_high = 0,
    always_low = 1,
};

pub fn getGlbName(glb: usize) []const u8 {
    return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[glb..glb+1];
}

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

pub fn LC4k(comptime device: DeviceType) type {
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
            default_power_guard: PowerGuard = .disabled,
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

        default_bus_maintenance: BusMaintenance = .keeper,
        default_input_threshold: InputThreshold = .high,
        default_slew_rate: SlewRate = .slow,
        default_drive_type: DriveType = .push_pull,

        ext: Ext = .{},

        pub usingnamespace D;
        pub const PT = ProductTerm(D.GRP);
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
            active_high: ProductTerm(D.GRP),
            active_low: ProductTerm(D.GRP),
        },
        shared_pt_clock: union(enum) {
            positive: ProductTerm(D.GRP), // active high when used as a latch or clock enable
            negative: ProductTerm(D.GRP), // active low when used as a latch or clock enable
        },
        shared_pt_enable: ProductTerm(D.GRP),
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

pub fn MacrocellConfig(comptime family: DeviceFamily, comptime GRP: type) type {
    const Input_Config = switch (family) {
        .zero_power_enhanced => InputConfigZE,
        else => InputConfig,
    };
    const Output_Config = switch (family) {
        .zero_power_enhanced => OutputConfigZE,
        else => OutputConfig(GRP),
    };

    return struct {
        sum_routing: ?ClusterRouting = null,
        wide_sum_routing: ?WideRouting = null,
        logic: union(enum) {
            sum: []const ProductTerm(GRP),
            sum_inverted: []const ProductTerm(GRP),
            input_buffer,
            pt0: ProductTerm(GRP),
            pt0_inverted: ProductTerm(GRP),
            sum_xor_pt0: SumXorPt0(GRP),
            sum_xor_pt0_inverted: SumXorPt0(GRP),
            sum_xor_input_buffer: []const ProductTerm(GRP), // TODO test this; datasheet's schematic of MC implies it is, but timing model implies it isn't.
        },
        func: union(MacrocellFunction) {
            combinational: void,
            latch: RegisterConfig(GRP),
            t_ff: RegisterConfig(GRP),
            d_ff: RegisterConfig(GRP),
        },
        pt4_oe: ?ProductTerm(GRP) = null,
        input: Input_Config = .{},
        output: Output_Config,

        const Self = @This();

        pub fn initUnused() Self {
            return .{
                .logic = .{ .sum = &[_]ProductTerm(GRP) { &.{} } },
                .func = .{ .combinational = {} },
                .output = .{ .oe = .input_only },
            };
        }
    };
}

pub const InputConfig = struct {
    threshold: ?InputThreshold = null,
};
pub const InputConfigZE = struct {
    threshold: ?InputThreshold = null,
    bus_maintenance: ?BusMaintenance = null,
    power_guard: ?PowerGuard = null,
};

pub fn OutputConfig(comptime GRP: type) type {
    return struct {
        slew_rate: ?SlewRate = null,
        drive_type: ?DriveType = null,
        oe: OutputEnableMode,
        oe_routing: OutputRouting = .{ .relative = 0 },
        routing: union(OutputRoutingMode) {
            same_as_oe,
            self,
            five_pt_fast_bypass: []const ProductTerm(GRP),
            five_pt_fast_bypass_inverted: []const ProductTerm(GRP),
        } = .{ .same_as_oe = {} },
    };
}
pub const OutputConfigZE = struct {
    slew_rate: ?SlewRate = null,
    drive_type: ?DriveType = null,
    oe: OutputEnableMode,
    routing: OutputRouting = .{ .relative = 0 },
};

pub const OutputRouting = union(enum) {
    relative: u3,
    absolute: MacrocellIndex,
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
        glb_shared_pt_enable: GlbIndex,
    } = .{ .constant_high = {} },
};

pub const GOEConfigBusOrPin = struct {
    polarity: GOEPolarity = .active_high,
    source: union(enum) {
        constant_high: void,
        input: void,
        glb_shared_pt_enable: GlbIndex,
    } = .{ .constant_high = {} },
};

pub fn OscTimerConfig(comptime Device: type) type {
    return struct {
        pub const signals = Device.osctimer;
        enable_osc_out_and_disable: bool = false,
        enable_timer_out_and_reset: bool = false,
        timer_divisor: TimerDivisor = .div1048576,
    };
}

pub fn SumXorPt0(comptime GRP: type) type {
    return struct {
        sum: []const ProductTerm(GRP),
        pt0: ProductTerm(GRP),
    };
}

pub fn RegisterConfig(comptime GRP: type) type {
    return struct {
        clock: union(Clock_Source) {
            none,
            shared_pt_clock,
            pt1_positive: ProductTerm(GRP),
            pt1_negative: ProductTerm(GRP),
            bclock0,
            bclock1,
            bclock2,
            bclock3,
        } = .{ .none = {} },
        ce: union(Clock_Enable_Source) {
            pt2_active_high: ProductTerm(GRP),
            pt2_active_low: ProductTerm(GRP),
            shared_pt_clock,
            always_active,
        } = .{ .always_active = {} },
        init_state: u1 = 0,
        init_source: union(Init_Source) {
            pt3_active_high: ProductTerm(GRP),
            shared_pt_init,
        } = .{ .shared_pt_init = {} },
        async_source: union(Async_Trigger_Source) {
            pt2_active_high: ProductTerm(GRP),
            none,
        } = .{ .none = {} },
    };
}

pub fn ProductTerm(comptime GRP: type) type {
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

        pub fn always() ProductTerm(GRP) { comptime {
            return &.{};
        }}

        pub fn never() ProductTerm(GRP) { comptime {
            return &.{ .{ .never = {} } };
        }}

        pub fn of(comptime what: anytype) ProductTerm(GRP) { comptime {
            return switch (@TypeOf(what)) {
                ProductTerm(GRP) => what,
                Factor(GRP) => &.{ what },
                GRP => &.{ .{ .when_high = what } },
                PinInfo => &.{ .{ .when_high = @enumFromInt(what.grp_ordinal.?) } },
                else => &.{ .{ .when_high = Device.getGrp(what) } },
            };
        }}

        pub fn not(comptime what: anytype) ProductTerm(GRP) { comptime {
            return switch (@TypeOf(what)) {
                ProductTerm(GRP) => switch (what.len) {
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
                PinInfo => &.{ Factor(GRP) { .when_low = @enumFromInt(what.grp_ordinal.?) } },
                else => &.{ Factor(GRP) { .when_low = Device.getGrp(what) } },
            };
        }}

        pub fn all(comptime which: anytype) ProductTerm(GRP) { comptime {
            var pt: ProductTerm(GRP) = &.{};
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

        pub fn eql(comptime which: anytype, comptime value: usize) ProductTerm(GRP) { comptime {
            var pt: ProductTerm(GRP) = &.{};
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

        fn andPT(comptime base: ProductTerm(GRP), comptime extra: ProductTerm(GRP)) ProductTerm(GRP) { comptime {
            var pt = base;
            for (extra) |factor| {
                pt = andFactor(pt, factor);
            }
            return pt;
        }}

        fn andFactor(comptime base: ProductTerm(GRP), comptime factor: Factor(GRP)) ProductTerm(GRP) { comptime {
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

pub const jedec = @import("jedec.zig");
pub const jed_file = @import("jed_file.zig");
pub const svf_file = @import("svf_file.zig");
const assembly = @import("assembly.zig");
const disassembly = @import("disassembly.zig");
const routing = @import("routing.zig");
const report = @import("report.zig");
const std = @import("std");
