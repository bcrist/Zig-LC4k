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

        pub fn set_input_high(self: *@This(), signal: Signal) void {
            std.debug.assert(signal.kind() != .mc);
            self.state.data.insert(signal);
        }

        pub fn set_input_low(self: *@This(), signal: Signal) void {
            std.debug.assert(signal.kind() != .mc);
            self.state.data.remove(signal);
        }

        pub fn set_input(self: *@This(), signal: Signal, value: bool) void {
            std.debug.assert(signal.kind() != .mc);
            self.state.data.setPresent(signal, value);
        }

        pub fn set_inputs(self: *@This(), signals: []const Signal, value: usize) void {
            var remaining_value = value;
            for (signals) |signal| {
                std.debug.assert(signal.kind() != .mc);
                const bit: u1 = @truncate(remaining_value);
                remaining_value >>= 1;
                self.state.data.setPresent(signal, bit == 1);
            }
        }

        pub fn set_init_state(self: *@This(), maybe_rng: ?std.Random) void {
            if (maybe_rng) |rng| {
                rng.bytes(std.mem.asBytes(&self.state.data.bits.masks));
            } else {
                self.state.data.bits = .initEmpty();
            }

            for (self.chip.glb, 0..) |glb_config, glb| {
                for (glb_config.mc, 0..) |mc_config, mc| {
                    switch (mc_config.func) {
                        .combinational => {},
                        .latch, .t_ff, .d_ff => |reg_config| {
                            const mcref = MC_Ref.init(glb, mc);
                            const fb_signal = mcref.fb(Signal);
                            self.state.data.setPresent(fb_signal, reg_config.init_state == 1);
                        },
                    }
                }
            }

            self.state.last_data = self.state.data;
        }

        const Simulate_Options = struct {
            max_iterations: usize = 100,
            names: ?*const Chip_Config(Device.device_type).Names = null,
        };

        // Make sure you've updated any input signals before calling simulate!
        pub fn simulate(self: *@This(), options: Simulate_Options) error{Unstable}!void {
            const original_state = self.state;

            var i: usize = 0;
            var new_state = self.state;
            while (i < options.max_iterations) : (i += 1) {
                self.update_all_macrocells(&new_state, false);
                self.update_all_outputs(&new_state);

                // TODO osctimer & power guard impl for ZE devices
                // probably need a Simulator flag to indicate when the user wants to pretend that
                // enough time has passed for the oscillator to toggle

                if (new_state.data.eql(self.state.data) and new_state.oe.eql(self.state.oe)) {
                    break;
                }
                self.state = new_state;
            } else return error.Unstable;

            self.update_all_macrocells(&new_state, true);

            while (i < options.max_iterations) : (i += 1) {
                new_state.last_data = new_state.data;

                self.update_all_macrocells(&new_state, false);
                self.update_all_outputs(&new_state);

                if (new_state.data.eql(self.state.data) and new_state.oe.eql(self.state.oe)) {
                    new_state.last_data = new_state.data;
                    self.state = new_state;
                    break;
                }
                self.state = new_state;
            } else return error.Unstable;

            if (options.names) |names| {
                const data_diff = new_state.data.xorWith(original_state.data);
                var data_iter = data_diff.iterator();
                while (data_iter.next()) |signal| {
                    if (signal.kind() == .mc) {
                        log.warn("{s} {} => {}", .{
                            names.get_mc_name(signal.mc()),
                            @intFromBool(original_state.data.contains(signal)),
                            @intFromBool(new_state.data.contains(signal)),
                        });
                    } else {
                        log.warn("{s} {} => {}", .{
                            names.get_signal_name(signal),
                            @intFromBool(original_state.data.contains(signal)),
                            @intFromBool(new_state.data.contains(signal)),
                        });
                    }
                }

                const oe_diff = new_state.oe.xorWith(original_state.oe);
                var oe_iter = oe_diff.iterator();
                while (oe_iter.next()) |signal| {
                    if (signal.kind() == .mc) {
                        log.warn("{s} OE {s} => {s}", .{
                            names.get_mc_name(signal.mc()),
                            if (original_state.data.contains(signal)) "enabled" else "disabled",
                            if (new_state.oe.contains(signal)) "enabled" else "disabled",
                        });
                    } else {
                        log.warn("{s} OE {s} => {s}", .{
                            names.get_signal_name(signal),
                            if (original_state.oe.contains(signal)) "enabled" else "disabled",
                            if (new_state.oe.contains(signal)) "enabled" else "disabled",
                        });
                    }
                }
            }
        }

        fn update_all_macrocells(self: @This(), new_state: *State, update_ffs: bool) void {
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
                            } else if (self.evaluate_clock(mc_config.func, reg_config, mcref) and (update_ffs or mc_config.func == .latch)) {
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
                GOE_Config_Pin => self.state.data.contains(Device.oe_pins[goe - 2].pad()),
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
                std.debug.assert(@TypeOf(output_config) == Output_Config(Signal));
                switch (output_config.routing) {
                    .same_as_oe => {
                        new_state_data.setPresent(io_signal, new_state_data.contains(output_config.oe_routing.to_absolute(mcref)));
                    },
                    .self => {
                        const fb_signal = mcref.fb(Signal);
                        new_state_data.setPresent(io_signal, new_state_data.contains(fb_signal));
                    },
                    .five_pt_fast_bypass => |sp| {
                        const result = for (sp.sum) |pt| {
                            if (evaluate_pt(self.state.data, pt)) break true;
                        } else false;
                        new_state_data.setPresent(io_signal, switch (sp.polarity) {
                            .positive => result,
                            .negative => !result,
                        });
                    },
                }
            }
        }

        fn evaluate_init_condition(self: @This(), reg_config: Register_Config(Signal), mc: MC_Ref) bool {
            return switch (reg_config.init_source) {
                .pt3_active_high => |pt| evaluate_pt(self.state.data, pt),
                .shared_pt_init => switch (self.chip.glb[mc.glb].shared_pt_init.polarity) {
                    .positive => evaluate_pt(self.state.data, self.chip.glb[mc.glb].shared_pt_init.pt),
                    .negative => !evaluate_pt(self.state.data, self.chip.glb[mc.glb].shared_pt_init.pt),
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
                .pt2 => |ptp| switch (ptp.polarity) {
                    .positive => if (!evaluate_pt(self.state.data, ptp.pt)) return false,
                    .negative => if (evaluate_pt(self.state.data, ptp.pt)) return false,
                },
                .shared_pt_clock => {
                    const pt = evaluate_pt(self.state.data, self.chip.glb[mc.glb].shared_pt_clock.pt);
                    switch (self.chip.glb[mc.glb].shared_pt_clock.polarity) {
                        .positive => if (!pt) return false,
                        .negative => if (pt) return false,
                    }
                },
                .always_active => {},
            }

            if (!self.evaluate_clock_state(self.state.data, reg_config, mc)) return false;
            
            return func == .latch or !self.evaluate_clock_state(self.state.last_data, reg_config, mc);
        }

        fn evaluate_clock_state(self: @This(), data: std.EnumSet(Signal), reg_config: Register_Config(Signal), mc: MC_Ref) bool {
            return switch (reg_config.clock) {
                .none => return false,
                .shared_pt_clock => switch (self.chip.glb[mc.glb].shared_pt_clock.polarity) {
                    .positive => evaluate_pt(data, self.chip.glb[mc.glb].shared_pt_clock.pt),
                    .negative => !evaluate_pt(data, self.chip.glb[mc.glb].shared_pt_clock.pt),
                },
                .pt1 => |ptp| switch (ptp.polarity) {
                    .positive => evaluate_pt(data, ptp.pt),
                    .negative => !evaluate_pt(data, ptp.pt),
                },
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
                .sum => |sp| switch (sp.polarity) {
                    .positive => {
                        for (sp.sum) |pt| {
                            if (evaluate_pt(self.state.data, pt)) return true;
                        }
                        return false;
                    },
                    .negative => {
                        for (sp.sum) |pt| {
                            if (evaluate_pt(self.state.data, pt)) return false;
                        }
                        return true;
                    },
                },
                .input_buffer => {
                    const signal = mc.pad(Signal);
                    return self.state.data.contains(signal);
                },
                .pt0 => |ptp| switch (ptp.polarity) {
                    .positive => return evaluate_pt(self.state.data, ptp.pt),
                    .negative => return !evaluate_pt(self.state.data, ptp.pt),
                },
                .sum_xor_pt0 => |sum_xor_pt0| {
                    const pt0 = evaluate_pt(self.state.data, sum_xor_pt0.pt0);
                    const sum = for (sum_xor_pt0.sum) |pt| {
                        if (evaluate_pt(self.state.data, pt)) break true;
                    } else false;
                    return switch (sum_xor_pt0.polarity) {
                        .positive => pt0 != sum,
                        .negative => pt0 == sum,
                    };
                },
                .sum_xor_input_buffer => |pts| {
                    const input_signal = mc.pad(Signal);
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

        pub fn read_signal(self: @This(), signal: Signal) bool {
            return self.state.data.contains(signal);
        }

        pub fn read_signals(self: @This(), signals: []const Signal) usize {
            var actual_state: usize = 0;
            var bit: usize = 1;
            for (signals) |signal| {
                if (self.state.data.contains(signal)) {
                    actual_state |= bit;
                }
                bit = @shlExact(bit, 1);
            }
            return actual_state;
        }

        pub fn expect_signal(self: @This(), signal: Signal, expected: bool, names: ?*const Device.Names) !void {
            return self.expect_signals(&.{ signal }, @intFromBool(expected), names);
        }

        pub fn expect_signals(self: @This(), signals: []const Signal, expected_state: usize, names: ?*const Device.Names) !void {
            errdefer test_print_signals("For signals:\n", signals, names);
            try expect_equal_bin(expected_state, self.read_signals(signals));
        }

        pub fn read_oe(self: @This(), signal: Signal) bool {
            return self.state.oe.contains(signal);
        }

        pub fn read_oes(self: @This(), signals: []const Signal) usize {
            var actual_state: usize = 0;
            var bit: usize = 1;
            for (signals) |signal| {
                if (self.state.oe.contains(signal)) {
                    actual_state |= bit;
                }
                bit = @shlExact(bit, 1);
            }
            return actual_state;
        }
        
        pub fn expect_oe(self: @This(), signal: Signal, expected: bool, names: ?*const Device.Names) !void {
            return self.expect_oes(&.{ signal }, @intFromBool(expected), names);
        }

        pub fn expect_oes(self: @This(), signals: []const Signal, expected_state: usize, names: ?*const Device.Names) !void {
            errdefer test_print_signals("For output enables:\n", signals, names);
            try expect_equal_bin(expected_state, self.read_oes(signals));
        }

        fn test_print_signals(prefix: []const u8, signals: []const Signal, maybe_names: ?*const Device.Names) void {
            var buf: [2048]u8 = undefined;
            var w = std.io.Writer.fixed(&buf);

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
                @compileError(w.buffered());
            } else if (std.testing.backend_can_print) {
                std.debug.print("{s}", .{ w.buffered() });
            }
        }
    };
}

fn expect_equal_bin(expected: usize, actual: usize) !void {
    if (actual != expected) {
        const fmt = "expected {0d} (0b{0b}), found {1d} (0b{1b})\n";
        if (@inComptime()) {
            @compileError(std.fmt.comptimePrint(fmt, .{ expected, actual }));
        } else if (std.testing.backend_can_print) {
            std.debug.print(fmt, .{ expected, actual });
        }
        return error.TestExpectedEqual;
    }
}

const log = std.log.scoped(.lc4k);

const Chip_Config = lc4k.Chip_Config;
const MC_Ref = lc4k.MC_Ref;
const GOE_Config_Pin = lc4k.GOE_Config_Pin;
const GOE_Config_Bus = lc4k.GOE_Config_Bus;
const GOE_Config_Bus_Or_Pin = lc4k.GOE_Config_Bus_Or_Pin;
const Output_Config = lc4k.Output_Config;
const Register_Config = lc4k.Register_Config;
const Macrocell_Function = lc4k.Macrocell_Function;
const Product_Term = lc4k.Product_Term;

const lc4k = @import("lc4k.zig");
const std = @import("std");
