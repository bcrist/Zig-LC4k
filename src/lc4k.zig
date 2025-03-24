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
        pub const Names = D.Names;
        pub const Logic_Parser = D.Logic_Parser;
        pub const PT = D.PT;
        pub const F = D.F;
        pub const Pin = D.Pin;
        pub const Signal = D.Signal;

        pub const pins = D.pins;
        pub const all_pins = D.all_pins;
        pub const oe_pins = D.oe_pins;
        pub const clock_pins = D.clock_pins;
        pub const input_pins = D.input_pins;

        const Self = @This();

        pub fn mc(self: *Self, mcref: MC_Ref) *Macrocell_Config(D.family, D.Signal) {
            return &self.glb[mcref.glb].mc[mcref.mc];
        }

        pub fn mc_const(self: *const Self, mcref: MC_Ref) *const Macrocell_Config(D.family, D.Signal) {
            return &self.glb[mcref.glb].mc[mcref.mc];
        }

        pub fn simulator(self: *const Self) Simulator(D) {
            var sim: Simulator(D) = .{ .chip = self };
            sim.set_init_state();
            return sim;
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
        mc: [D.num_mcs_per_glb] Macrocell_Config(D.family, D.Signal),
        shared_pt_init: Product_Term_With_Polarity(D.Signal),
        shared_pt_clock: Product_Term_With_Polarity(D.Signal),
        shared_pt_enable: Product_Term(D.Signal),
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
                .shared_pt_init = .{
                    .polarity = .negative,
                    .pt = .always(),
                },
                .shared_pt_clock = .{
                    .polarity = .positive,
                    .pt = .always(),
                },
                .shared_pt_enable = .always(),
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
                mc.* = .init_unused();
            }

            return self;
        }
    };
}

pub fn Macrocell_Logic(comptime Signal: type) type {
    return union (enum) {
        pt0: Product_Term_With_Polarity(Signal),
        sum: Sum_With_Polarity(Signal),
        sum_xor_pt0: Sum_XOR_PT0(Signal),
        input_buffer,
        sum_xor_input_buffer: []const Product_Term(Signal), // TODO test this; datasheet's schematic of MC implies it is, but timing model implies it isn't.

        pub fn debug(self: @This(), w: std.io.AnyWriter) !void {
            switch (self) {
                .pt0 => |ptp| try ptp.debug(w),
                .sum => |sp| try sp.debug(w),
                .sum_xor_pt0 => |sxpt| try sxpt.debug(w),
                .input_buffer => try w.writeAll("<input>"),
                .sum_xor_input_buffer => |pts| {
                    try w.writeAll("<input> ^ ");
                    if (pts.len == 0) {
                        try w.writeByte('0');
                        return;
                    }
                    try w.writeByte('(');
                    try pts[0].debug(w);
                    for (pts[1..]) |pt| {
                        try w.writeAll(" | ");
                        try pt.debug(w);
                    }
                    try w.writeByte(')');
                },
            }
        }
    };
}

pub fn Macrocell_Config(comptime family: Device_Family, comptime Signal: type) type {
    const MC_Input_Config = switch (family) {
        .zero_power_enhanced => Input_Config_ZE,
        else => Input_Config,
    };
    const MC_Output_Config = switch (family) {
        .zero_power_enhanced => Output_Config_ZE(Signal),
        else => Output_Config(Signal),
    };

    return struct {
        sum_routing: ?Cluster_Routing = null,
        wide_sum_routing: ?Wide_Routing = null,
        logic: Macrocell_Logic(Signal),
        func: union(Macrocell_Function) {
            combinational: void,
            latch: Register_Config(Signal),
            t_ff: Register_Config(Signal),
            d_ff: Register_Config(Signal),
        },
        pt4_oe: ?Product_Term(Signal) = null,
        input: MC_Input_Config = .{},
        output: MC_Output_Config,

        const Self = @This();

        pub fn init_unused() Self {
            return .{
                .logic = .{ .sum = .{
                    .polarity = .positive,
                    .sum = &.{ .always() }
                }},
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

pub fn Output_Config(comptime Signal: type) type {
    return struct {
        slew_rate: ?Slew_Rate = null,
        drive_type: ?Drive_Type = null,
        oe: Output_Enable_Mode,
        oe_routing: Output_Routing(Signal) = .{ .relative = 0 },
        routing: union (enum) {
            same_as_oe,
            self,
            five_pt_fast_bypass: Sum_With_Polarity(Signal),

            pub fn mode(self: @This()) Output_Routing_Mode {
                return switch (self) {
                    .same_as_oe => .same_as_oe,
                    .self => .self,
                    .five_pt_fast_bypass => |sp| switch (sp.polarity) {
                        .positive => .five_pt_fast_bypass,
                        .negative => .five_pt_fast_bypass_inverted,
                    },
                };
            }
        } = .same_as_oe,

        pub fn output_routing(self: @This()) Output_Routing(Signal) {
            return self.oe_routing;
        }
    };
}
pub fn Output_Config_ZE(comptime Signal: type) type {
    return struct {
        slew_rate: ?Slew_Rate = null,
        drive_type: ?Drive_Type = null,
        oe: Output_Enable_Mode,
        routing: Output_Routing(Signal) = .{ .relative = 0 },

        pub fn output_routing(self: @This()) Output_Routing(Signal) {
            return self.routing;
        }
    };
}

pub fn Output_Routing(comptime Signal: type) type {
    return union(enum) {
        relative: u3,
        absolute: Signal,

        pub fn to_absolute(self: @This(), io_mc: MC_Ref) Signal {
             switch (self) {
                .relative => |offset| {
                    const target_mcref = MC_Ref.init(io_mc.glb, (io_mc.mc + offset) % 16);
                    return Signal.mc_fb(target_mcref);
                },
                .absolute => |signal| {
                    return signal;
                },
            }
        }

        pub fn to_relative(self: @This(), io_mc: MC_Ref) ?u3 {
            switch (self) {
                .relative => |offset| {
                    return offset;
                },
                .absolute => |signal| {
                    if (signal.maybe_fb() != signal) return null;
                    const mc = signal.maybe_mc() orelse return null;
                    if (mc.glb != io_mc.glb) return null;
                    const delta = if (mc.mc < io_mc.mc) mc.mc + 16 - io_mc.mc else mc.mc - io_mc.mc;
                    if (delta < 0 or delta >= 8) return null;
                    return @intCast(delta);
                },
            }
        }
    };
}

pub const GOE_Config_Pin = struct {
    polarity: Polarity = .positive,
};

pub const GOE_Config_Bus = struct {
    polarity: Polarity = .positive,
    source: union(enum) {
        constant_high: void,
        glb_shared_pt_enable: GLB_Index,
    } = .constant_high,
};

pub const GOE_Config_Bus_Or_Pin = struct {
    polarity: Polarity = .positive,
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

pub fn Sum_XOR_PT0(comptime Signal: type) type {
    return struct {
        sum: []const Product_Term(Signal),
        pt0: Product_Term(Signal),
        polarity: Polarity,

        pub fn debug(self: @This(), w: std.io.AnyWriter) !void {
            if (self.polarity == .negative) {
                try w.writeByte('~');
            }
            try w.writeByte('(');
            try self.pt0.debug(w);
            try w.writeAll(") ^ ");
            if (self.sum.len == 0) {
                try w.writeByte('0');
            } else {
                try w.writeByte('(');
                try self.sum[0].debug(w);
                for (self.sum[1..]) |pt| {
                    try w.writeAll(" | ");
                    try pt.debug(w);
                }
                try w.writeByte(')');
            }
        }
    };
}

pub fn Register_Config(comptime Signal: type) type {
    return struct {
        clock: union (enum) {
            none,
            shared_pt_clock,
            pt1: Product_Term_With_Polarity(Signal),
            bclock0,
            bclock1,
            bclock2,
            bclock3,

            pub fn source(self: @This()) Clock_Source {
                return switch (self) {
                    .none => .none,
                    .shared_pt_clock => .shared_pt_clock,
                    .pt1 => |ptp| switch (ptp.polarity) {
                        .positive => .pt1_positive,
                        .negative => .pt1_negative,
                    },
                    .bclock0 => .bclock0,
                    .bclock1 => .bclock1,
                    .bclock2 => .bclock2,
                    .bclock3 => .bclock3,
                };
            }
        } = .none,
        ce: union (enum) {
            pt2: Product_Term_With_Polarity(Signal),
            shared_pt_clock,
            always_active,

            pub fn source(self: @This()) Clock_Enable_Source {
                return switch (self) {
                    .pt2 => |ptp| switch (ptp.polarity) {
                        .positive => .pt2_active_high,
                        .negative => .pt2_active_low,
                    },
                    .shared_pt_clock => .shared_pt_clock,
                    .always_active => .always_active,
                };
            }
        } = .always_active,
        init_state: u1 = 0,
        init_source: union(Init_Source) {
            pt3_active_high: Product_Term(Signal),
            shared_pt_init,
        } = .shared_pt_init,
        async_source: union(Async_Trigger_Source) {
            pt2_active_high: Product_Term(Signal),
            none,
        } = .none,
    };
}

pub fn Sum_With_Polarity(comptime Device_Signal: type) type {
    return struct {
        sum: []const Product_Term(Device_Signal),
        polarity: Polarity,

        pub fn debug(self: @This(), w: std.io.AnyWriter) !void {
            if (self.polarity == .negative) {
                try w.writeAll("~(");
            }

            if (self.sum.len == 0) {
                try w.writeByte('0');
                return;
            }
            try self.sum[0].debug(w);
            for (self.sum[1..]) |pt| {
                try w.writeAll(" | ");
                try pt.debug(w);
            }

            if (self.polarity == .negative) {
                try w.writeAll(")");
            }
        }
    };
}

pub fn Product_Term_With_Polarity(comptime Device_Signal: type) type {
    return struct {
        pt: Product_Term(Device_Signal),
        polarity: Polarity,

        pub fn is_always(self: @This()) bool {
            return switch (self.polarity) {
                .positive => self.pt.is_always(),
                .negative => self.pt.is_never(),
            };
        }

        pub fn is_never(self: @This()) bool {
            return switch (self.polarity) {
                .positive => self.pt.is_never(),
                .negative => self.pt.is_always(),
            };
        }

        pub fn debug(self: @This(), w: std.io.AnyWriter) !void {
            if (self.polarity == .negative) {
                try w.writeAll("~(");
                try self.pt.debug(w);
                try w.writeByte(')');
            } else {
                try self.pt.debug(w);
            }
        }
    };
}

pub fn Product_Term(comptime Device_Signal: type) type {
    return struct {
        factors: []const Factor(Signal),

        pub const Signal = Device_Signal;
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

        pub inline fn and_factor(comptime self: Self, comptime factor: Factor(Signal)) Self {
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

        pub fn when_eql(comptime signals: []const Signal, comptime value: usize) Self {
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
        pub fn when_eql_alloc(allocator: std.mem.Allocator, signals: []const Signal, value: usize) Self {
            var pt: Self = .{
                .factors = try allocator.alloc(Factor(Signal), signals.len),
            };
            var bit_value: usize = 1;
            for (signals, &pt.factors) |signal, *factor| {
                factor.* = if ((value & bit_value) == 0) signal.when_low() else signal.when_high();
                bit_value <<= 1;
            }
            return pt;
        }

        pub fn debug(self: Self, w: std.io.AnyWriter) !void {
            if (self.factors.len == 0) {
                try w.writeAll("1");
                return;
            }

            try self.factors[0].debug(w);

            for (self.factors[1..]) |factor| {
                try w.writeAll(" & ");
                try factor.debug(w);
            }
        }
    };
}

pub fn Factor(comptime Device_Signal: type) type {
    return union(enum) {
        // "always" can normally just be represented by an empty PT,
        // but sometimes necessary to represent it in a Factor instead:
        always,
        never,
        when_high: Signal,
        when_low: Signal,

        const Signal = Device_Signal;
        const Self = @This();

        pub inline fn negate(self: Self) Self {
            return switch(self) {
                .always => .never,
                .never => .always,
                .when_high => |grp| .{ .when_low = grp },
                .when_low => |grp| .{ .when_high = grp },
            };
        }

        pub inline fn pt(comptime self: Self) Product_Term(Signal) {
            return comptime .{ .factors = &.{ self } };
        }
        pub inline fn pt_indirect(self: *const Self) Product_Term(Signal) {
            return .{ .factors = self[0..1] };
        }
        pub inline fn pt_alloc(self: Self, allocator: std.mem.Allocator) !Product_Term(Signal) {
            return .{ .factors = try allocator.dupe(Self, self.pt_indirect().factors) };
        }

        pub fn debug(self: Self, w: std.io.AnyWriter) !void {
            switch (self) {
                .always => try w.writeAll("1"),
                .never => try w.writeAll("0"),
                .when_high => |signal| try w.writeAll(@tagName(signal)),
                .when_low => |signal| {
                    try w.writeByte('~');
                    try w.writeAll(@tagName(signal));
                },
            }
        }

        pub fn less_than(_: void, a: Self, b: Self) bool {
            const at: std.meta.Tag(Self) = a;
            const bt: std.meta.Tag(Self) = b;
            const at2 = if (at == .when_low) .when_high else at;
            const bt2 = if (bt == .when_low) .when_high else bt;
            if (at2 != bt2) return @intFromEnum(at2) < @intFromEnum(bt2);
            switch (a) {
                .always, .never => return false,
                .when_high, .when_low => |as| {
                    const bs = switch (b) {
                        .when_high, .when_low => |s| s,
                        else => unreachable,
                    };
                    return if (as != bs) @intFromEnum(as) < @intFromEnum(bs) else @intFromEnum(at) < @intFromEnum(bt);
                }
            }
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

    pub fn input(self: MC_Ref, comptime Signal: type) Signal {
        return Signal.mc_pad(self);
    }

    pub fn fb(self: MC_Ref, comptime Signal: type) Signal {
        return Signal.mc_fb(self);
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

pub const Signal_Kind = enum {
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

pub fn Pin(comptime Signal: type) type {
    return struct {
        info: Pin_Info,

        const Self = @This();

        pub fn init_io(pin_id: []const u8, grp: Signal) Self {
            const mcref = grp.mc();
            return .{ .info = .{
                .id = pin_id,
                .func = .{ .io = mcref.mc },
                .glb = mcref.glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_oe(pin_id: []const u8, grp: Signal, comptime oe_index: comptime_int) Self {
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

        pub fn init_clk(pin_id: []const u8, grp: Signal, clock_index: Clock_Index, glb: GLB_Index) Self {
            return .{ .info = .{
                .id = pin_id,
                .func = .{ .clock = clock_index },
                .glb = glb,
                .grp_ordinal = @intFromEnum(grp),
            }};
        }

        pub fn init_input(pin_id: []const u8, grp: Signal, glb: GLB_Index) Self {
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

        pub inline fn id(self: Self) []const u8 {
            return self.info.id;
        }

        pub inline fn func(self: Self) Pin_Function {
            return self.info.func;
        }

        pub inline fn mc(self: Self) MC_Ref {
            return self.info.mc().?;
        }

        pub inline fn pad(self: Self) Signal {
            return @enumFromInt(self.info.grp_ordinal.?);
        }

        pub inline fn fb(self: Self) Signal {
            return self.pad().fb();
        }

        pub inline fn when_high(self: Self) Factor(Signal) {
            return .{ .when_high = @enumFromInt(self.info.grp_ordinal.?) };
        }

        pub inline fn when_low(self: Self) Factor(Signal) {
            return .{ .when_low = @enumFromInt(self.info.grp_ordinal.?) };
        }
    };
}

pub const Pin_Info = struct {
    id: []const u8, // pin number or ball location
    func: Pin_Function,
    glb: ?GLB_Index = null, // only meaningful when func is io, io_oe0, io_oe1, input, or clock
    grp_ordinal: ?u16 = null, // use with @intToEnum(Signal, grp_ordinal)

    pub inline fn mc(self: Pin_Info) ?MC_Ref {
        return if (self.glb) |glb| switch (self.func) {
            .io, .io_oe0, .io_oe1 => |mc_index| MC_Ref.init(glb, mc_index),
            else => null,
        } else null;
    }
};

pub fn Simulator(comptime Device: type) type {
    return struct {
        pub const Signal = Device.Signal;

        pub const State = struct {
            last_data: std.EnumSet(Signal) = .initEmpty(), // used to detect rising/falling clock edges; do not modify this manually!
            data: std.EnumSet(Signal) = .initEmpty(),
            oe: std.EnumSet(Signal) = .initEmpty(),
        };

        chip: *const Chip_Config(Device.device_type),
        state: State = .{},

        pub fn set_inputs(self: *@This(), signals: []const Signal, value: usize) void {
            var remaining_value = value;
            for (signals) |signal| {
                const bit: u1 = @truncate(remaining_value);
                remaining_value >>= 1;
                self.state.data.setPresent(signal, bit == 1);
            }
        }

        pub fn set_init_state(self: *@This()) void {
            for (self.chip.glb, 0..) |glb_config, glb| {
                for (glb_config.mc, 0..) |mc_config, mc| {
                    const mcref = MC_Ref.init(glb, mc);
                    const fb_signal = mcref.fb(Signal);
                    const init_state = switch (mc_config.func) {
                        .combinational => false,
                        .latch, .t_ff, .d_ff => |reg_config| reg_config.init_state == 1,
                    };
                    self.state.last_data.setPresent(fb_signal, init_state);
                    self.state.data.setPresent(fb_signal, init_state);
                }
            }
        }

        const Simulate_Options = struct {
            max_iterations: usize = 100,
            log_unstable: bool = true,
        };

        // Make sure you've updated any input signals before calling simulate!
        pub fn simulate(self: *@This(), comptime options: Simulate_Options) bool {
            for (0..options.max_iterations) |_| {
                var new_state = self.state;
                new_state.last_data = new_state.data;

                self.update_all_macrocells(&new_state);
                self.update_all_outputs(&new_state);

                // TODO osctimer & power guard impl for ZE devices
                // probably need a Simulator flag to indicate when the user wants to pretend that
                // enough time has passed for the oscillator to toggle

                if (new_state.data.eql(self.state.data) and new_state.oe.eql(self.state.oe)) {
                    self.state = new_state;
                    return true;
                }
                self.state = new_state;
            } else if (options.log_unstable) {
                std.log.scoped(.lc4k).warn("Simulation state failed to settle after {} iterations (possible unstable/oscillating circuit?)", .{ options.max_iterations });
                return false;
            }
        }

        fn update_all_macrocells(self: @This(), new_state: *State) void {
            for (self.chip.glb, 0..) |glb_config, glb| {
                for (glb_config.mc, 0..) |mc_config, mc| {
                    const mcref = MC_Ref.init(glb, mc);
                    const fb_signal = mcref.fb(Signal);
                    switch (mc_config.func) {
                        .combinational => {
                            const state = self.evaluate_mc_data(mcref);
                            new_state.data.setPresent(fb_signal, state);
                        },
                        .latch, .t_ff, .d_ff => |reg_config| {
                            if (self.evaluate_init_condition(reg_config, mcref)) {
                                new_state.data.setPresent(fb_signal, reg_config.init_state == 1);
                            } else if (self.evaluate_async_condition(reg_config)) {
                                new_state.data.setPresent(fb_signal, reg_config.init_state != 1);
                            } else if (self.evaluate_clock(mc_config.func, reg_config, mcref)) {
                                const mcd = self.evaluate_mc_data(mcref);
                                if (mc_config.func == .t_ff) {
                                    if (mcd) new_state.data.toggle(fb_signal);
                                } else {
                                    new_state.data.setPresent(fb_signal, mcd);
                                }
                            }
                        },
                    }

                    if (mc_config.pt4_oe) |pt| {
                        new_state.oe.setPresent(fb_signal, evaluate_pt(self.state.data, pt));
                    }
                }
            }
        }

        fn update_all_outputs(self: @This(), new_state: *State) void {
            const goe0 = self.evaluate_goe(0);
            const goe1 = self.evaluate_goe(1);
            const goe2 = self.evaluate_goe(2);
            const goe3 = self.evaluate_goe(3);

            for (self.chip.glb, 0..) |glb_config, glb| {
                for (glb_config.mc, 0..) |mc_config, mc| {
                    const mcref = MC_Ref.init(glb, mc);
                    if (Signal.maybe_mc_pad(mcref)) |io_signal| {
                        switch (mc_config.output.oe) {
                            .goe0 => if (goe0) {
                                new_state.oe.insert(io_signal);
                                self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                            } else {
                                new_state.oe.remove(io_signal);
                            },
                            .goe1 => if (goe1) {
                                new_state.oe.insert(io_signal);
                                self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                            } else {
                                new_state.oe.remove(io_signal);
                            },
                            .goe2 => if (goe2) {
                                new_state.oe.insert(io_signal);
                                self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                            } else {
                                new_state.oe.remove(io_signal);
                            },
                            .goe3 => if (goe3) {
                                new_state.oe.insert(io_signal);
                                self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                            } else {
                                new_state.oe.remove(io_signal);
                            },
                            .from_orm_active_high, .from_orm_active_low => {
                                const oe_routing = if (Device.family == .zero_power_enhanced) mc_config.output.routing else mc_config.output.oe_routing;
                                var oe_state = new_state.data.contains(oe_routing.to_absolute(mcref));
                                if (mc_config.output.oe == .from_orm_active_low) oe_state = !oe_state;
                                new_state.oe.setPresent(io_signal, oe_state);
                                if (oe_state) {
                                    self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                                }
                            },
                            .output_only => {
                                new_state.oe.insert(io_signal);
                                self.update_output_data(io_signal, mcref, mc_config.output, &new_state.data);
                            },
                            .input_only => {
                                new_state.oe.remove(io_signal);
                            },
                        }
                    }
                }
            }
        }

        fn evaluate_goe(self: @This(), comptime goe: u2) bool {
            const config = switch (goe) {
                0 => self.chip.goe0,
                1 => self.chip.goe1,
                2 => self.chip.goe2,
                3 => self.chip.goe3,
            };

            const oe_state = switch (@TypeOf(config)) {
                GOE_Config_Pin => self.state.data.contains(Device.oe_pins[goe].pad()),
                GOE_Config_Bus => switch (config.source) {
                    .constant_high => true,
                    .glb_shared_pt_enable => |glb| evaluate_pt(self.state.data, self.chip.glb[glb].shared_pt_enable),
                },
                GOE_Config_Bus_Or_Pin => switch (config.source) {
                    .constant_high => true,
                    .input => self.state.data.contains(Device.oe_pins[goe].pad()),
                    .glb_shared_pt_enable => |glb| evaluate_pt(self.state.data, self.chip.glb[glb].shared_pt_enable),
                },
                else => unreachable,
            };

            return switch (config.polarity) {
                .positive => oe_state,
                .negative => !oe_state,
            };
        }

        fn update_output_data(self: @This(), io_signal: Signal, mcref: MC_Ref, output_config: anytype, new_state_data: *std.EnumSet(Signal)) void {
            if (Device.family == .zero_power_enhanced) {
                new_state_data.setPresent(io_signal, new_state_data.contains(output_config.routing.to_absolute(mcref)));
            } else {
                std.debug.assert(@TypeOf(output_config) == Output_Config);
                switch (output_config.routing) {
                    .same_as_oe => {
                        new_state_data.setPresent(io_signal, new_state_data.contains(output_config.oe_routing.to_absolute(mcref)));
                    },
                    .self => {
                        const fb_signal = mcref.fb(Signal);
                        new_state_data.setPresent(io_signal, new_state_data.contains(fb_signal));
                    },
                    .five_pt_fast_bypass => |pts| {
                        const result = for (pts) |pt| {
                            if (evaluate_pt(self.state.data, pt)) break true;
                        } else false;
                        new_state_data.setPresent(io_signal, result);
                    },
                    .five_pt_fast_bypass_inverted => |pts| {
                        const result = for (pts) |pt| {
                            if (evaluate_pt(self.state.data, pt)) break true;
                        } else false;
                        new_state_data.setPresent(io_signal, !result);
                    },
                }
            }
        }

        fn evaluate_init_condition(self: @This(), reg_config: Register_Config(Signal), mc: MC_Ref) bool {
            return switch (reg_config.init_source) {
                .pt3_active_high => |pt| evaluate_pt(self.state.data, pt),
                .shared_pt_init => switch (self.chip.glb[mc.glb].shared_pt_init.polarity) {
                    .positive => |pt| evaluate_pt(self.state.data, pt),
                    .negative => |pt| !evaluate_pt(self.state.data, pt),
                },
            };
        }

        fn evaluate_async_condition(self: @This(), reg_config: Register_Config(Signal)) bool {
            return switch (reg_config.async_source) {
                .pt2_active_high => |pt| evaluate_pt(self.state.data, pt),
                .none => false,
            };
        }

        fn evaluate_clock(self: @This(), func: Macrocell_Function, reg_config: Register_Config(Signal), mc: MC_Ref) bool {
            switch (reg_config.ce) {
                .pt2_active_high => |pt| if (!evaluate_pt(self.state.data, pt)) return false,
                .pt2_active_low => |pt| if (evaluate_pt(self.state.data, pt)) return false,
                .shared_pt_clock => switch (self.chip.glb[mc.glb].shared_pt_clock) {
                    .positive => |pt| if (!evaluate_pt(self.state.data, pt)) return false,
                    .negative => |pt| if (evaluate_pt(self.state.data, pt)) return false,
                },
                .always_active => {},
            }

            if (!self.evaluate_clock_state(self.state.data, reg_config, mc)) return false;
            
            return func == .latch or !self.evaluate_clock_state(self.state.last_data, reg_config, mc);
        }

        fn evaluate_clock_state(self: @This(), data: std.EnumSet(Signal), reg_config: Register_Config(Signal), mc: MC_Ref) bool {
            return switch (reg_config.clock) {
                .none => return false,
                .shared_pt_clock => switch (self.chip.glb[mc.glb].shared_pt_clock) {
                    .positive => |pt| evaluate_pt(data, pt),
                    .negative => |pt| !evaluate_pt(data, pt),
                },
                .pt1_positive => |pt| evaluate_pt(data, pt),
                .pt1_negative => |pt| !evaluate_pt(data, pt),
                .bclock0 => switch (self.chip.glb[mc.glb].bclock0) {
                    .clk0_pos => data.contains(.clk0),
                    .clk1_neg => !data.contains(.clk1),
                },
                .bclock1 => switch (self.chip.glb[mc.glb].bclock1) {
                    .clk1_pos => data.contains(.clk1),
                    .clk0_neg => !data.contains(.clk0),
                },
                .bclock2 => switch (self.chip.glb[mc.glb].bclock2) {
                    .clk2_pos => data.contains(.clk2),
                    .clk3_neg => !data.contains(.clk3),
                },
                .bclock3 => switch (self.chip.glb[mc.glb].bclock3) {
                    .clk3_pos => data.contains(.clk3),
                    .clk2_neg => !data.contains(.clk2),
                },
            };
        }

        fn evaluate_mc_data(self: @This(), mc: MC_Ref) bool {
            switch (self.chip.mc_const(mc).logic) {
                .sum => |pts| {
                    for (pts) |pt| {
                        if (evaluate_pt(self.state.data, pt)) return true;
                    }
                    return false;
                },
                .sum_inverted => |pts| {
                    for (pts) |pt| {
                        if (evaluate_pt(self.state.data, pt)) return false;
                    }
                    return true;
                },
                .input_buffer => {
                    const signal = mc.input(Signal);
                    return self.state.data.contains(signal);
                },
                .pt0 => |pt| return evaluate_pt(self.state.data, pt),
                .pt0_inverted => |pt| return !evaluate_pt(self.state.data, pt),
                .sum_xor_pt0 => |sum_xor_pt0| {
                    const pt0 = evaluate_pt(self.state.data, sum_xor_pt0.pt0);
                    const sum = for (sum_xor_pt0.sum) |pt| {
                        if (evaluate_pt(self.state.data, pt)) break true;
                    } else false;
                    return pt0 != sum;
                },
                .sum_xor_pt0_inverted => |sum_xor_pt0| {
                    const pt0 = evaluate_pt(self.state.data, sum_xor_pt0.pt0);
                    const sum = for (sum_xor_pt0.sum) |pt| {
                        if (evaluate_pt(self.state.data, pt)) break true;
                    } else false;
                    return pt0 == sum;
                },
                .sum_xor_input_buffer => |pts| {
                    const input_signal = mc.input(Signal);
                    const input = self.state.data.contains(input_signal);
                    const sum = for (pts) |pt| {
                        if (evaluate_pt(self.state.data, pt)) break true;
                    } else false;
                    return input != sum;
                },
            }
        }

        fn evaluate_pt(data: std.EnumSet(Signal), pt: Product_Term(Signal)) bool {
            for (pt.factors) |factor| {
                switch (factor) {
                    .always => {},
                    .never => return false,
                    .when_high => |signal| if (!data.contains(signal)) return false,
                    .when_low => |signal| if (data.contains(signal)) return false,
                }
            }
            return true;
        }

        pub fn expect_signal_state(self: @This(), signals: []const Signal, expected_state: usize, names: ?*const Device.Names) !void {
            errdefer test_print_signals("For signals:\n", signals, names);

            var actual_state: usize = 0;
            var bit: usize = 1;
            for (signals) |signal| {
                if (self.state.data.contains(signal)) {
                    actual_state |= bit;
                }
                bit = @shlExact(bit, 1);
            }

            try std.testing.expectEqual(expected_state, actual_state);
        }
        
        pub fn expect_oe_state(self: @This(), signals: []const Signal, expected_state: usize, names: ?*const Device.Names) !void {
            errdefer test_print_signals("For output enables:\n", signals, names);

            var actual_state: usize = 0;
            var bit: usize = 1;
            for (signals) |signal| {
                if (self.state.oe.contains(signal)) {
                    actual_state |= bit;
                }
                bit = @shlExact(bit, 1);
            }

            try std.testing.expectEqual(expected_state, actual_state);
        }

        fn test_print_signals(prefix: []const u8, signals: []const Signal, maybe_names: ?*const Device.Names) void {
            var buf: [2048]u8 = undefined;
            var stream = std.io.fixedBufferStream(&buf);
            const w = stream.writer();

            w.writeAll(prefix) catch {};

            for (signals) |signal| {
                w.writeAll("   ") catch {};
                w.writeAll(@tagName(signal)) catch {};
                if (maybe_names) |names| {
                    w.print(" ({s})", .{ names.get_signal_name(signal) }) catch {};
                }
                w.writeByte('\n') catch {};
            }

            if (@inComptime()) {
                @compileError(stream.getWritten());
            } else if (std.testing.backend_can_print) {
                std.debug.print("{s}", .{ stream.getWritten() });
            }
        }
    };
}

pub const Polarity = enum (u1) {
    negative = 0, // inverted / active low / falling edge clock
    positive = 1, // not inverted / active high / rising edge clock

    pub fn invert(self: Polarity) Polarity {
        return @enumFromInt(@intFromEnum(self) ^ 1);
    }

    pub fn xor(self: Polarity, other: Polarity) Polarity {
        return @enumFromInt(@intFromEnum(self) ^ @intFromEnum(other) ^ 1);
    }
};

pub const Bus_Maintenance = enum (u2) {
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

pub inline fn invert_gi_mapping(comptime Signal: type, comptime gi_mux_size: comptime_int, comptime mapping: []const[gi_mux_size]Signal) std.EnumMap(Signal, []const u8) {
    return comptime blk: {
        @setEvalBranchQuota(10_000);
        var results: std.EnumMap(Signal, []const u8) = .{};
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
pub const Logic_Parser = logic_parser.Logic_Parser;
pub const logic_parser = @import("logic_parser.zig");
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
