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

pub fn Chip_Config(comptime device_type: Device_Type) type {
    const D = device_type.get();

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

        pub const Device = D;
        pub const PT = D.PT;
        pub const F = D.F;
        pub const Pin = D.Pin;
        pub const GRP = D.GRP;

        pub const pins = D.pins;
        pub const all_pins = D.all_pins;
        pub const oe_pins = D.oe_pins;
        pub const clock_pins = D.clock_pins;
        pub const input_pins = D.input_pins;

        const Self = @This();

        pub fn mc(self: *Self, mcref: MC_Ref) *Macrocell_Config(D.family, D.GRP) {
            return &self.glb[mcref.glb].mc[mcref.mc];
        }

        pub fn assemble(self: Self, allocator: std.mem.Allocator) !assembly.Assembly_Results {
            return assembly.assemble(D, self, allocator);
        }

        pub fn disassemble(allocator: std.mem.Allocator, file: JEDEC_File) !disassembly.Disassembly_Results(D) {
            return disassembly.disassemble(D, allocator, file);
        }

        pub fn parse_jed(allocator: std.mem.Allocator, text: []const u8) !JEDEC_File {
            return JEDEC_File.parse(allocator, D.jedec_dimensions.width(), D.jedec_dimensions.height(), text);
        }

        pub fn write_jed(file: JEDEC_File, writer: anytype, options: JEDEC_File.Write_Options) !void {
            const any_writer = if (@hasDecl(@TypeOf(writer), "any")) writer.any() else writer;
            return file.write(D.device_type, any_writer, options);
        }
        pub fn write_svf(file: JEDEC_File, writer: anytype, options: svf.Write_Options) !void {
            const any_writer = if (@hasDecl(@TypeOf(writer), "any")) writer.any() else writer;
            return svf.write(D, file, any_writer, options);
        }
        pub fn write_report(speed_grade: comptime_int, file: JEDEC_File, writer: anytype, options: report.Write_Options(D)) !void {
            const any_writer = if (@hasDecl(@TypeOf(writer), "any")) writer.any() else writer;
            return report.write(D, speed_grade, file, any_writer, options);
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
                .shared_pt_init = .{ .active_low = Product_Term(D.GRP).always() },
                .shared_pt_clock = .{ .positive = Product_Term(D.GRP).always() },
                .shared_pt_enable = Product_Term(D.GRP).always(),
                .bclock0 = .clk0_pos,
                .bclock1 = .clk1_pos,
                .bclock2 = .clk2_pos,
                .bclock3 = .clk3_pos,
            };

            if (D.clock_pins.len < 4) {
                self.bclock1 = .clk0_neg;
                self.bclock3 = .clk2_neg;
            }

            for (&self.mc) |*mc| {
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
                .logic = .{ .sum = &.{ Product_Term(GRP).always() } },
                .func = .combinational,
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
        } = .same_as_oe,
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
    } = .constant_high,
};

pub const GOE_Config_Bus_Or_Pin = struct {
    polarity: GOE_Polarity = .active_high,
    source: union(enum) {
        constant_high: void,
        input: void,
        glb_shared_pt_enable: GLB_Index,
    } = .constant_high,
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
        } = .none,
        ce: union(Clock_Enable_Source) {
            pt2_active_high: Product_Term(GRP),
            pt2_active_low: Product_Term(GRP),
            shared_pt_clock,
            always_active,
        } = .always_active,
        init_state: u1 = 0,
        init_source: union(Init_Source) {
            pt3_active_high: Product_Term(GRP),
            shared_pt_init,
        } = .shared_pt_init,
        async_source: union(Async_Trigger_Source) {
            pt2_active_high: Product_Term(GRP),
            none,
        } = .none,
    };
}

pub fn Product_Term(comptime Device_GRP: type) type {
    return struct {
        factors: []const Factor(GRP),

        pub const GRP = Device_GRP;
        const Self = @This();

        pub inline fn always() Self {
            return comptime .{
                .factors = &.{},
            };
        }
        pub inline fn is_always(self: Self) bool {
            for (self.factors) |factor| {
                if (factor != .always) return false;
            }
            return true;
        }

        pub inline fn never() Self {
            return comptime .{
                .factors = &.{ .never },
            };
        }
        pub inline fn is_never(self: Self) bool {
            for (self.factors) |factor| {
                if (factor == .never) return true;
            }
            return false;
        }

        pub inline fn negate(comptime self: Self) Self {
            return comptime switch (self.factors.len) {
                0 => never(),
                1 => self.factors[0].negate().pt(),
                else => unreachable,
            };
        }
        pub fn negate_alloc(self: Self, alloc: std.mem.Allocator) Self {
            return switch (self.factors.len) {
                0 => never(),
                1 => self.factors[0].negate().pt_alloc(alloc),
                else => unreachable,
            };
        }

        pub inline fn and_factor(comptime self: Self, comptime factor: Factor(GRP)) Self {
            switch (factor) {
                .always => return self,
                .never => return never(),
                .when_high => |new_signal| {
                    inline for (self.factors) |existing_factor| switch (existing_factor) {
                        .always => return factor.pt(),
                        .never => return never(),
                        .when_high => |old_signal| if (new_signal == old_signal) return self,
                        .when_low => |old_signal| if (new_signal == old_signal) return never(),
                    };
                },
                .when_low => |new_signal| {
                    inline for (self.factors) |existing_factor| switch (existing_factor) {
                        .always => return factor.pt(),
                        .never => return never(),
                        .when_high => |old_signal| if (new_signal == old_signal) return never(),
                        .when_low => |old_signal| if (new_signal == old_signal) return self,
                    };
                },
            }
            return comptime .{
                .factors = self.factors ++ .{ factor },
            };
        }

        pub inline fn and_pt(comptime self: Self, comptime other: Self) Self {
            comptime var pt = self;
            inline for (other.factors) |factor| {
                pt = pt.and_factor(factor);
            }
            return pt;
        }

        pub fn when_eql(comptime signals: []const GRP, comptime value: usize) Self {
            comptime var pt: Self = always();
            comptime var bit_value: usize = 1;
            inline for (signals) |signal| {
                const factor = comptime signal.when_high();
                const final_factor = comptime if ((value & bit_value) == 0) factor.negate() else factor;
                pt = pt.and_factor(final_factor);
                bit_value <<= 1;
            }
            return pt;
        }
        pub fn when_eql_alloc(allocator: std.mem.Allocator, signals: []const GRP, value: usize) Self {
            var pt: Self = .{
                .factors = try allocator.alloc(Factor(GRP), signals.len),
            };
            var bit_value: usize = 1;
            for (signals, &pt.factors) |signal, *factor| {
                factor.* = if ((value & bit_value) == 0) signal.when_low() else signal.when_high();
                bit_value <<= 1;
            }
            return pt;
        }
    };
}

pub fn Factor(comptime Device_GRP: type) type {
    return union(enum) {
        // "always" can normally just be represented by an empty PT,
        // but sometimes necessary to represent it in a Factor instead:
        always,
        never,
        when_high: GRP,
        when_low: GRP,

        const GRP = Device_GRP;
        const Self = @This();

        pub fn negate(self: Self) Self {
            return switch(self) {
                .always => .never,
                .never => .always,
                .when_high => |grp| .{ .when_low = grp },
                .when_low => |grp| .{ .when_high = grp },
            };
        }

        pub fn pt(comptime self: Self) Product_Term(GRP) {
            return comptime .{ .factors = &.{ self } };
        }
        pub fn pt_indirect(self: *Self) Product_Term(GRP) {
            return .{ .factors = self[0..1] };
        }
        pub fn pt_alloc(self: Self, allocator: std.mem.Allocator) !Product_Term(GRP) {
            return .{ .factors = try allocator.dupe(Self, self.pt_indirect().factors) };
        }
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

pub const GRP_Kind = enum {
    io,
    mc,
    in,
    clk,
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

pub fn Pin(comptime GRP: type) type {
    return struct {
        info: Pin_Info,

        const Self = @This();

        pub fn init_io(pin_id: []const u8, grp: GRP) Self {
            const mcref = grp.mc();
            return .{ .info = .{
                .id = pin_id,
                .func = .{ .io = mcref.mc },
                .glb = mcref.glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_oe(pin_id: []const u8, grp: GRP, comptime oe_index: comptime_int) Self {
            const mcref = grp.mc();
            return .{ .info = .{
                .id = pin_id,
                .func = switch (oe_index) {
                    0 => .{ .io_oe0 = mcref.mc },
                    1 => .{ .io_oe1 = mcref.mc },
                    else => @compileError("Invalid OE index"),
                },
                .glb = mcref.glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_clk(pin_id: []const u8, grp: GRP, clock_index: Clock_Index, glb: GLB_Index) Self {
            return .{ .info = .{
                .id = pin_id,
                .func = .{ .clock = clock_index },
                .glb = glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_input(pin_id: []const u8, grp: GRP, glb: GLB_Index) Self {
            return .{ .info = .{
                .id = pin_id,
                .func = .input,
                .glb = glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_misc(pin_id: []const u8, function: Pin_Function) Self {
            return .{ .info = .{
                .id = pin_id,
                .func = function,
            }};
        }

        pub fn id(self: Self) []const u8 {
            return self.info.id;
        }

        pub fn func(self: Self) Pin_Function {
            return self.info.func;
        }

        pub fn mc(self: Self) MC_Ref {
            return self.info.mc().?;
        }

        pub fn signal(self: Self) GRP {
            return @enumFromInt(self.info.grp_ordinal.?);
        }

        pub fn when_high(self: Self) Factor(GRP) {
            return self.signal().when_high();
        }

        pub fn when_low(self: Self) Factor(GRP) {
            return self.signal().when_low();
        }
    };
}

pub const Pin_Info = struct {
    id: []const u8, // pin number or ball location
    func: Pin_Function,
    glb: ?GLB_Index = null, // only meaningful when func is io, io_oe0, io_oe1, input, or clock
    grp_ordinal: ?u16 = null, // use with @intToEnum(GRP, grp_ordinal)

    pub fn mc(self: Pin_Info) ?MC_Ref {
        return if (self.glb) |glb| switch (self.func) {
            .io, .io_oe0, .io_oe1 => |mc_index| MC_Ref.init(glb, mc_index),
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



pub inline fn invert_gi_mapping(comptime GRP: type, comptime gi_mux_size: comptime_int, comptime mapping: []const[gi_mux_size]GRP) std.EnumMap(GRP, []const u8) {
    return comptime blk: {
        @setEvalBranchQuota(10_000);
        var results: std.EnumMap(GRP, []const u8) = .{};
        for (mapping, 0..) |options, gi| {
            for (options) |grp| {
                results.put(grp, (results.get(grp) orelse &[_]u8 {}) ++ [_]u8 { gi });
            }
        }
        break :blk results;
    };
}

pub fn is_sum_always(pts: anytype) bool {
    for (pts) |pt| {
        if (pt.is_always()) return true;
    }
    return false;
}

const device = @import("device.zig");
pub const Device_Type = device.Type;
pub const Device_Family = device.Family;
pub const Device_Package = device.Package;
pub const JEDEC_Data = @import("JEDEC_Data.zig");
pub const JEDEC_File = @import("JEDEC_File.zig");
pub const Fuse = @import("Fuse.zig");
pub const Fuse_Range = @import("Fuse_Range.zig");
pub const svf = @import("svf.zig");
const assembly = @import("assembly.zig");
const disassembly = @import("disassembly.zig");
const routing = @import("routing.zig");
const report = @import("report.zig");
const std = @import("std");
