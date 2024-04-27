pub const LC4032V_TQFP44 = Chip_Config(.LC4032x_TQFP44);
pub const LC4032B_TQFP44 = Chip_Config(.LC4032x_TQFP44);
pub const LC4032C_TQFP44 = Chip_Config(.LC4032x_TQFP44);
pub const LC4032V_TQFP48 = Chip_Config(.LC4032x_TQFP48);
pub const LC4032B_TQFP48 = Chip_Config(.LC4032x_TQFP48);
pub const LC4032C_TQFP48 = Chip_Config(.LC4032x_TQFP48);
pub const LC4032ZC_TQFP48 = Chip_Config(.LC4032ZC_TQFP48);
pub const LC4032ZE_TQFP48 = Chip_Config(.LC4032ZE_TQFP48);
pub const LC4032ZC_csBGA56 = Chip_Config(.LC4032ZC_csBGA56);
pub const LC4032ZE_csBGA64 = Chip_Config(.LC4032ZE_csBGA64);

pub const LC4064V_TQFP44 = Chip_Config(.LC4064x_TQFP44);
pub const LC4064B_TQFP44 = Chip_Config(.LC4064x_TQFP44);
pub const LC4064C_TQFP44 = Chip_Config(.LC4064x_TQFP44);
pub const LC4064V_TQFP48 = Chip_Config(.LC4064x_TQFP48);
pub const LC4064B_TQFP48 = Chip_Config(.LC4064x_TQFP48);
pub const LC4064C_TQFP48 = Chip_Config(.LC4064x_TQFP48);
pub const LC4064ZC_TQFP48 = Chip_Config(.LC4064ZC_TQFP48);
pub const LC4064ZE_TQFP48 = Chip_Config(.LC4064ZE_TQFP48);
pub const LC4064V_TQFP100 = Chip_Config(.LC4064x_TQFP100);
pub const LC4064B_TQFP100 = Chip_Config(.LC4064x_TQFP100);
pub const LC4064C_TQFP100 = Chip_Config(.LC4064x_TQFP100);
pub const LC4064ZC_TQFP100 = Chip_Config(.LC4064ZC_TQFP100);
pub const LC4064ZE_TQFP100 = Chip_Config(.LC4064ZE_TQFP100);
pub const LC4064ZC_csBGA56 = Chip_Config(.LC4064ZC_csBGA56);
pub const LC4064ZE_csBGA64 = Chip_Config(.LC4064ZE_csBGA64);
pub const LC4064ZE_ucBGA64 = Chip_Config(.LC4064ZE_ucBGA64);
pub const LC4064ZC_csBGA132 = Chip_Config(.LC4064ZC_csBGA132);
pub const LC4064ZE_csBGA144 = Chip_Config(.LC4064ZE_csBGA144);

pub const LC4128V_TQFP100 = Chip_Config(.LC4128x_TQFP100);
pub const LC4128B_TQFP100 = Chip_Config(.LC4128x_TQFP100);
pub const LC4128C_TQFP100 = Chip_Config(.LC4128x_TQFP100);
pub const LC4128ZC_TQFP100 = Chip_Config(.LC4128ZC_TQFP100);
pub const LC4128ZE_TQFP100 = Chip_Config(.LC4128ZE_TQFP100);
pub const LC4128V_TQFP128 = Chip_Config(.LC4128x_TQFP128);
pub const LC4128B_TQFP128 = Chip_Config(.LC4128x_TQFP128);
pub const LC4128C_TQFP128 = Chip_Config(.LC4128x_TQFP128);
pub const LC4128V_TQFP144 = Chip_Config(.LC4128V_TQFP144);
pub const LC4128ZE_TQFP144 = Chip_Config(.LC4128ZE_TQFP144);
pub const LC4128ZC_csBGA132 = Chip_Config(.LC4128ZC_csBGA132);
pub const LC4128ZE_csBGA144 = Chip_Config(.LC4128ZE_csBGA144);
pub const LC4128ZE_ucBGA132 = Chip_Config(.LC4128ZE_ucBGA132);

pub fn Chip_Config(comptime device: Device_Type) type {
    const D = device.get();

    const Chip_Input_Config = switch (D.family) {
        .zero_power_enhanced => Input_Config_ZE,
        else => Input_Config,
    };

    const GOE01_Config = switch (D.num_glbs) {
        2 => GOE_Config_Bus,
        else => GOE_Config_Bus_Or_Pin,
    };
    const GOE23_Config = switch (D.num_glbs) {
        2 => GOE_Config_Pin,
        else => GOE_Config_Bus,
    };

    const Ext = switch (D.family) {
        .zero_power_enhanced => struct {
            default_power_guard: Power_Guard = .disabled,
            osctimer: ?Oscillator_Timer_Config(D) = null,
        },
        else => struct {},
    };

    return struct {
        glb: [D.num_glbs] GLB_Config(D) = GLB_Config(D).init_all_unused(D.num_glbs),
        clock: [D.clock_pins.len] Chip_Input_Config = [_]Chip_Input_Config { .{} } ** D.clock_pins.len,
        input: [D.input_pins.len] Chip_Input_Config = [_]Chip_Input_Config { .{} } ** D.input_pins.len,

        goe0: GOE01_Config = .{},
        goe1: GOE01_Config = .{},
        goe2: GOE23_Config = .{},
        goe3: GOE23_Config = .{},

        zero_hold_time: bool = false,

        usercode: ?u32 = null,
        security: bool = false,

        default_bus_maintenance: Bus_Maintenance = .keeper,
        default_input_threshold: Input_Threshold = .high,
        default_slew_rate: Slew_Rate = .slow,
        default_drive_type: Drive_Type = .push_pull,

        ext: Ext = .{},

        pub usingnamespace D;
        pub const PT = Product_Term(D.GRP);
        pub const PTs = Product_Term_Builder(D);

        const Self = @This();

        pub fn mc(self: *Self, mcref: MC_Ref) *Macrocell_Config(D.family, D.GRP) {
            return &self.glb[mcref.glb].mc[mcref.mc];
        }

        pub fn assemble(self: Self, allocator: std.mem.Allocator) !assembly.Assembly_Results {
            return assembly.assemble(D, self, allocator);
        }

        pub fn disassemble(allocator: std.mem.Allocator, file: jedec.Jedec_File) !disassembly.Disassembly_Results(D) {
            return disassembly.disassemble(D, allocator, file);
        }

        pub fn parse_jed(allocator: std.mem.Allocator, text: []const u8) !jedec.Jedec_File {
            return jed_file.parse(allocator, D.jedec_dimensions.width(), D.jedec_dimensions.height(), text);
        }

        pub fn write_jed(allocator: std.mem.Allocator, file: jedec.Jedec_File, writer: anytype, options: jed_file.Write_Options) !void {
            return jed_file.write(D.device_type, allocator, file, writer, options);
        }
        pub fn write_svf(file: jedec.Jedec_File, writer: anytype, options: svf_file.Write_Options) !void {
            return svf_file.write(D, file, writer, options);
        }
        pub fn write_report(file: jedec.Jedec_File, writer: anytype, options: report.Write_Options(D)) !void {
            return report.write(D, file, writer, options);
        }
    };
}

pub fn GLB_Config(comptime D: type) type {
    return struct {
        mc: [D.num_mcs_per_glb] Macrocell_Config(D.family, D.GRP),
        shared_pt_init: union(enum) {
            active_high: Product_Term(D.GRP),
            active_low: Product_Term(D.GRP),
        },
        shared_pt_clock: union(enum) {
            positive: Product_Term(D.GRP), // active high when used as a latch or clock enable
            negative: Product_Term(D.GRP), // active low when used as a latch or clock enable
        },
        shared_pt_enable: Product_Term(D.GRP),
        bclock0: enum { clk0_pos, clk1_neg },
        bclock1: enum { clk1_pos, clk0_neg },
        bclock2: enum { clk2_pos, clk3_neg },
        bclock3: enum { clk3_pos, clk2_neg },

        const Self = @This();

        pub fn init_all_unused(comptime num_glbs: comptime_int) [num_glbs]Self { comptime {
            var configs: [num_glbs]Self = undefined;
            var i = 0;
            while (i < num_glbs) : (i += 1) {
                configs[i] = init_unused();
            }
            return configs;
        }}

        pub fn init_unused() Self {
            var self = Self {
                .mc = undefined,
                .shared_pt_init = .{ .active_low = Product_Term_Builder(D).always() },
                .shared_pt_clock = .{ .positive = Product_Term_Builder(D).always() },
                .shared_pt_enable = Product_Term_Builder(D).always(),
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
                mc.* = Macrocell_Config(D.family, D.GRP).init_unused();
            }

            return self;
        }
    };
}

pub fn Macrocell_Config(comptime family: Device_Family, comptime GRP: type) type {
    const MC_Input_Config = switch (family) {
        .zero_power_enhanced => Input_Config_ZE,
        else => Input_Config,
    };
    const MC_Output_Config = switch (family) {
        .zero_power_enhanced => Output_Config_ZE,
        else => Output_Config(GRP),
    };

    return struct {
        sum_routing: ?Cluster_Routing = null,
        wide_sum_routing: ?Wide_Routing = null,
        logic: union(enum) {
            sum: []const Product_Term(GRP),
            sum_inverted: []const Product_Term(GRP),
            input_buffer,
            pt0: Product_Term(GRP),
            pt0_inverted: Product_Term(GRP),
            sum_xor_pt0: Sum_XOR_PT0(GRP),
            sum_xor_pt0_inverted: Sum_XOR_PT0(GRP),
            sum_xor_input_buffer: []const Product_Term(GRP), // TODO test this; datasheet's schematic of MC implies it is, but timing model implies it isn't.
        },
        func: union(Macrocell_Function) {
            combinational: void,
            latch: Register_Config(GRP),
            t_ff: Register_Config(GRP),
            d_ff: Register_Config(GRP),
        },
        pt4_oe: ?Product_Term(GRP) = null,
        input: MC_Input_Config = .{},
        output: MC_Output_Config,

        const Self = @This();

        pub fn init_unused() Self {
            return .{
                .logic = .{ .sum = &[_]Product_Term(GRP) { &.{} } },
                .func = .{ .combinational = {} },
                .output = .{ .oe = .input_only },
            };
        }
    };
}

pub const Input_Config = struct {
    threshold: ?Input_Threshold = null,
};
pub const Input_Config_ZE = struct {
    threshold: ?Input_Threshold = null,
    bus_maintenance: ?Bus_Maintenance = null,
    power_guard: ?Power_Guard = null,
};

pub fn Output_Config(comptime GRP: type) type {
    return struct {
        slew_rate: ?Slew_Rate = null,
        drive_type: ?Drive_Type = null,
        oe: Output_Enable_Mode,
        oe_routing: Output_Routing = .{ .relative = 0 },
        routing: union(Output_Routing_Mode) {
            same_as_oe,
            self,
            five_pt_fast_bypass: []const Product_Term(GRP),
            five_pt_fast_bypass_inverted: []const Product_Term(GRP),
        } = .{ .same_as_oe = {} },
    };
}
pub const Output_Config_ZE = struct {
    slew_rate: ?Slew_Rate = null,
    drive_type: ?Drive_Type = null,
    oe: Output_Enable_Mode,
    routing: Output_Routing = .{ .relative = 0 },
};

pub const Output_Routing = union(enum) {
    relative: u3,
    absolute: MC_Index,
};

pub const GOE_Polarity = enum {
    active_high,
    active_low,
};

pub const GOE_Config_Pin = struct {
    polarity: GOE_Polarity = .active_high,
};

pub const GOE_Config_Bus = struct {
    polarity: GOE_Polarity = .active_high,
    source: union(enum) {
        constant_high: void,
        glb_shared_pt_enable: GLB_Index,
    } = .{ .constant_high = {} },
};

pub const GOE_Config_Bus_Or_Pin = struct {
    polarity: GOE_Polarity = .active_high,
    source: union(enum) {
        constant_high: void,
        input: void,
        glb_shared_pt_enable: GLB_Index,
    } = .{ .constant_high = {} },
};

pub fn Oscillator_Timer_Config(comptime Device: type) type {
    return struct {
        pub const signals = Device.osctimer;
        enable_osc_out_and_disable: bool = false,
        enable_timer_out_and_reset: bool = false,
        timer_divisor: Timer_Divisor = .div_1048576,
    };
}

pub fn Sum_XOR_PT0(comptime GRP: type) type {
    return struct {
        sum: []const Product_Term(GRP),
        pt0: Product_Term(GRP),
    };
}

pub fn Register_Config(comptime GRP: type) type {
    return struct {
        clock: union(Clock_Source) {
            none,
            shared_pt_clock,
            pt1_positive: Product_Term(GRP),
            pt1_negative: Product_Term(GRP),
            bclock0,
            bclock1,
            bclock2,
            bclock3,
        } = .{ .none = {} },
        ce: union(Clock_Enable_Source) {
            pt2_active_high: Product_Term(GRP),
            pt2_active_low: Product_Term(GRP),
            shared_pt_clock,
            always_active,
        } = .{ .always_active = {} },
        init_state: u1 = 0,
        init_source: union(Init_Source) {
            pt3_active_high: Product_Term(GRP),
            shared_pt_init,
        } = .{ .shared_pt_init = {} },
        async_source: union(Async_Trigger_Source) {
            pt2_active_high: Product_Term(GRP),
            none,
        } = .{ .none = {} },
    };
}

pub fn Product_Term(comptime GRP: type) type {
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

pub fn Product_Term_Builder(comptime Device: type) type {
    const GRP = Device.GRP;
    return struct {

        pub fn always() Product_Term(GRP) { comptime {
            return &.{};
        }}

        pub fn never() Product_Term(GRP) { comptime {
            return &.{ .{ .never = {} } };
        }}

        pub fn of(comptime what: anytype) Product_Term(GRP) { comptime {
            return switch (@TypeOf(what)) {
                Product_Term(GRP) => what,
                Factor(GRP) => &.{ what },
                GRP => &.{ .{ .when_high = what } },
                Pin_Info => &.{ .{ .when_high = @enumFromInt(what.grp_ordinal.?) } },
                else => &.{ .{ .when_high = Device.getGrp(what) } },
            };
        }}

        pub fn not(comptime what: anytype) Product_Term(GRP) { comptime {
            return switch (@TypeOf(what)) {
                Product_Term(GRP) => switch (what.len) {
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
                Pin_Info => &.{ Factor(GRP) { .when_low = @enumFromInt(what.grp_ordinal.?) } },
                else => &.{ Factor(GRP) { .when_low = Device.getGrp(what) } },
            };
        }}

        pub fn all(comptime which: anytype) Product_Term(GRP) { comptime {
            var pt: Product_Term(GRP) = &.{};
            switch (@typeInfo(@TypeOf(which))) {
                .Struct => |info| {
                    std.debug.assert(info.is_tuple);
                    for (info.fields) |field| {
                        pt = and_pt(pt, of(@field(which, field.name)));
                    }
                },
                .Array => {
                    for (which) |signal| {
                        pt = and_pt(pt, of(signal));
                    }
                },
                .Pointer => |info| {
                    std.debug.assert(info.size == .Slice);
                    for (which) |signal| {
                        pt = and_pt(pt, of(signal));
                    }
                },
                else => unreachable,
            }
            return pt;
        }}

        pub fn eql(comptime which: anytype, comptime value: usize) Product_Term(GRP) { comptime {
            var pt: Product_Term(GRP) = &.{};
            switch (@typeInfo(@TypeOf(which))) {
                .Struct => |info| {
                    std.debug.assert(info.is_tuple);
                    var bit_value: usize = 1;
                    for (info.fields) |field| {
                        var factor = of(@field(which, field.name));
                        if ((value & bit_value) == 0) {
                            factor = not(factor);
                        }
                        pt = and_pt(pt, factor);
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
                        pt = and_pt(pt, factor);
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
                        pt = and_pt(pt, factor);
                        bit_value <<= 1;
                    }
                },
                else => unreachable,
            }
            return pt;
        }}

        fn and_pt(comptime base: Product_Term(GRP), comptime extra: Product_Term(GRP)) Product_Term(GRP) { comptime {
            var pt = base;
            for (extra) |factor| {
                pt = and_factor(pt, factor);
            }
            return pt;
        }}

        fn and_factor(comptime base: Product_Term(GRP), comptime factor: Factor(GRP)) Product_Term(GRP) { comptime {
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


pub const GI_Index = u8;
pub const GLB_Index = u8;
pub const MC_Index = u8;
pub const PT_Index = u8;
pub const Clock_Index = u8;
pub const GOE_Index = u8;

pub const MC_Ref = struct {
    glb: GLB_Index,
    mc: MC_Index,

    pub fn init(glb: usize, mc: usize) MC_Ref {
        return .{
            .glb = @intCast(glb),
            .mc = @intCast(mc),
        };
    }
};

pub const PT_Ref = struct {
    mcref: MC_Ref,
    pt: PT_Index,

    pub fn init(glb: usize, mc: usize, pt: usize) PT_Ref {
        return .{
            .mcref = MC_Ref.init(glb, mc),
            .pt = @intCast(pt),
        };
    }
};

pub const Pin_Function = union(enum) {
    io: MC_Index,
    io_oe0: MC_Index,
    io_oe1: MC_Index,
    input,
    clock: Clock_Index,
    no_connect,
    gnd,
    vcc_core,
    vcco,
    tck,
    tms,
    tdi,
    tdo,
};

pub const Pin_Info = struct {
    id: []const u8, // pin number or ball location
    func: Pin_Function,
    glb: ?GLB_Index = null, // only meaningful when func is io, io_oe0, io_oe1, input, or clock
    grp_ordinal: ?u16 = null, // use with @intToEnum(GRP, grp_ordinal)

    pub fn mc_ref(self: Pin_Info) ?MC_Ref {
        return if (self.glb) |glb| switch (self.func) {
            .io, .io_oe0, .io_oe1 => |mc| MC_Ref { .glb = glb, .mc = mc },
            else => null,
        } else null;
    }
};

pub const Bus_Maintenance = enum(u2) {
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
pub const Input_Threshold = enum(u1) {
                //   ZE                   C/ZC         B           V
    low = 1,    // 0.50*Vcc             0.50*Vcc    0.36*Vcc    0.28*Vcc
    high = 0,   // 0.68*Vcc (falling)   0.73*Vcc    0.50*Vcc    0.40*Vcc
                // 0.79*Vcc (rising)
};

pub const Drive_Type = enum(u1) {
    push_pull = 1,
    open_drain = 0,
};

pub const Slew_Rate = enum(u1) {
    slow = 1,
    fast = 0,
};

pub const Output_Enable_Mode = enum(u3) {
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
pub const Output_Routing_Mode = enum(u2) {
    same_as_oe = 2,
    self = 3,
    five_pt_fast_bypass = 0,
    five_pt_fast_bypass_inverted = 1,
};

pub const Power_Guard = enum(u1) {
    from_bie = 0,
    disabled = 1,
};

pub const Timer_Divisor = enum(u2) {
    div_128 = 0,
    div_1024 = 2,
    div_1048576 = 1,
    _
};

pub const Macrocell_Function = enum(u2) {
    combinational = 0,
    latch = 1,
    t_ff = 2,
    d_ff = 3,
};

pub const Cluster_Routing = enum(u2) {
    self_minus_two = 0,
    self = 1,
    self_plus_one = 2,
    self_minus_one = 3,
};

pub const Wide_Routing = enum(u1) {
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

pub fn get_glb_name(glb: usize) []const u8 {
    return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[glb..glb+1];
}

pub const Device_Family = enum {
    low_power, // V/B/C suffix
    zero_power, // ZC suffix
    zero_power_enhanced, // ZE suffix
};

pub const Device_Package = enum {
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

pub const Device_Type = enum {
    //[[!! include 'devices'
    // for device in spairs(devices) do
    //     write(device, ',', nl)
    // end
    // writeln(nl, 'pub fn get(comptime self: Device_Type) type {', indent)
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

    pub fn get(comptime self: Device_Type) type {
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

    pub fn parse(name: []const u8) ?Device_Type {
        for (std.enums.values(Device_Type)) |e| {
            if (std.mem.eql(u8, name, @tagName(e))) {
                return e;
            }
        }
        return null;
    }
};

pub const jedec = @import("jedec.zig");
pub const jed_file = @import("jed_file.zig");
pub const svf_file = @import("svf_file.zig");

const assembly = @import("assembly.zig");
const disassembly = @import("disassembly.zig");
const routing = @import("routing.zig");
const report = @import("report.zig");
const std = @import("std");
