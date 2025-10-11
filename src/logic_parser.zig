pub const Options = struct {
    max_product_terms: u8 = 80,
    optimize: bool = false,
    dont_care: []const u8 = "",
};

pub fn Logic_Parser(comptime Device_Struct: type) type {
    return struct {
        gpa: std.mem.Allocator,
        arena: std.heap.ArenaAllocator,
        names: *const Device.Names,
        optimization_signal_limit: u5 = 16,

        pub const Device = Device_Struct;

        const Self = @This();
        const Node = Ast(Device).Node;
        const Names = naming.Names(Device);
        const Logic = lc4k.Macrocell_Logic(Device.Signal);
        const SumP = lc4k.Sum_With_Polarity(Device.Signal);
        const PT = lc4k.Product_Term(Device.Signal);
        const PTP = lc4k.Product_Term_With_Polarity(Device.Signal);
        const F = lc4k.Factor(Device.Signal);

        pub fn pt(self: *Self, equation: []const u8, extra: anytype) !PT {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            const ir_normalized = try p.ir_data.normalize(p.ir, .{ .max_xor_depth = 0 });
            const ir_optimized = try qmc.optimize(&p.ir_data, ir_normalized, p.dc_ir, p.opt_signal_limit);

            const num_pts = p.ir_data.count_pts(ir_optimized);
            if (num_pts > 1) {
                Ast(Device).report_node_error_fmt(self.gpa, p.ast.nodes.slice(), equation, p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ num_pts });
                var buf: [64]u8 = undefined;
                var w = std.fs.File.stderr().writer(&buf);
                p.ir_data.debug(ir_optimized, 0, false, &w.interface) catch {};
                w.interface.flush() catch {};
                return error.TooManyProductTerms;
            }

            return try p.ir_data.get_pt(Device.Signal, self.arena.allocator(), ir_optimized, 0);
        }

        pub fn pt_with_polarity(self: *Self, equation: []const u8, extra: anytype) !PTP {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            const ir_normalized = try p.ir_data.normalize(p.ir, .{ .max_xor_depth = 0 });
            const ir_optimized = try qmc.optimize(&p.ir_data, ir_normalized, p.dc_ir, p.opt_signal_limit);

            const num_pts = p.ir_data.count_pts(ir_optimized);
            if (num_pts == 1) {
                return .{
                    .pt = try p.ir_data.get_pt(Device.Signal, self.arena.allocator(), ir_optimized, 0),
                    .polarity = .positive,
                };
            }

            const ir_inverted = ir_inverted: {
                const complement = try p.ir_data.make_complement(p.ir);
                const normalized = try p.ir_data.normalize(complement, .{ .max_xor_depth = 0 });
                break :ir_inverted try qmc.optimize(&p.ir_data, normalized, p.dc_ir, p.opt_signal_limit);
            };
            const num_pts_inverted = p.ir_data.count_pts(ir_inverted);
            if (num_pts_inverted == 1) {
                return .{
                    .pt = try p.ir_data.get_pt(Device.Signal, self.arena.allocator(), ir_inverted, 0),
                    .polarity = .negative,
                };
            }

            Ast(Device).report_node_error_fmt(self.gpa, p.ast.nodes.slice(), equation, p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ @min(num_pts, num_pts_inverted) });
            var buf: [64]u8 = undefined;
            var w = std.fs.File.stderr().writer(&buf);
            p.ir_data.debug(if (num_pts_inverted < num_pts) ir_inverted else ir_optimized, 0, false, &w.interface) catch {};
            w.interface.flush() catch {};
            return error.TooManyProductTerms;
        }

        pub fn sum(self: *Self, equation: []const u8, extra: anytype) ![]PT {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            const ir_normalized = try p.ir_data.normalize(p.ir, .{ .max_xor_depth = 0 });
            const ir_optimized = try qmc.optimize(&p.ir_data, ir_normalized, p.dc_ir, p.opt_signal_limit);
                
            const allocator = self.arena.allocator();
            const num_pts = p.ir_data.count_pts(ir_optimized);
            if (num_pts > p.options.max_product_terms) {
                Ast(Device).report_node_error_fmt(self.gpa, p.ast.nodes.slice(), equation, p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    num_pts,
                    p.options.max_product_terms,
                });
                var buf: [64]u8 = undefined;
                var w = std.fs.File.stderr().writer(&buf);
                p.ir_data.debug(ir_optimized, 0, false, &w.interface) catch {};
                w.interface.flush() catch {};
                return error.TooManyProductTerms;
            }
            const pts = try allocator.alloc(PT, num_pts);
            for (0.., pts) |i, *term| {
                term.* = try p.ir_data.get_pt(Device.Signal, allocator, ir_optimized, i);
            }
            return pts;
        }

        pub fn sum_with_polarity(self: *Self, equation: []const u8, extra: anytype) !SumP {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            const ir_normalized = try p.ir_data.normalize(p.ir, .{ .max_xor_depth = 0 });
            const ir_optimized = try qmc.optimize(&p.ir_data, ir_normalized, p.dc_ir, p.opt_signal_limit);

            const ir_inverted = ir_inverted: {
                const complement = try p.ir_data.make_complement(p.ir);
                const normalized = try p.ir_data.normalize(complement, .{ .max_xor_depth = 0 });
                break :ir_inverted try qmc.optimize(&p.ir_data, normalized, p.dc_ir, p.opt_signal_limit);
            };
                
            const num_pts_not_inverted = p.ir_data.count_pts(ir_optimized);
            const num_pts_inverted = p.ir_data.count_pts(ir_inverted);
            const num_pts = @min(num_pts_not_inverted, num_pts_inverted);
            const best_ir = if (num_pts_inverted < num_pts_not_inverted) ir_inverted else ir_optimized;

            if (num_pts > p.options.max_product_terms) {
                Ast(Device).report_node_error_fmt(self.gpa, p.ast.nodes.slice(), equation, p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    num_pts,
                    p.options.max_product_terms,
                });
                var buf: [64]u8 = undefined;
                var w = std.fs.File.stderr().writer(&buf);
                p.ir_data.debug(best_ir, 0, false, &w.interface) catch {};
                w.interface.flush() catch {};
                return error.TooManyProductTerms;
            }
            const allocator = self.arena.allocator();
            const pts = try allocator.alloc(PT, num_pts);
            for (0.., pts) |i, *term| {
                term.* = try p.ir_data.get_pt(Device.Signal, allocator, best_ir, i);
            }
            return .{
                .sum = pts,
                .polarity = if (best_ir == ir_inverted) .negative else .positive,
            };
        }

        pub fn logic(self: *Self, equation: []const u8, extra: anytype) !Logic {
            var names_arena = std.heap.ArenaAllocator.init(self.gpa);
            defer names_arena.deinit();

            const options = parse_options(extra);
            var names = try self.parse_extra_names(names_arena.allocator(), extra);
            defer names.deinit();

            var ast = try Ast(Device).parse(self.gpa, &names, equation);
            defer ast.deinit();

            _ = try ast.infer_and_check_max_bit(.{ .max_result_bits = 1 });

            var dc_ast: Ast(Device) = .{
                .gpa = self.gpa,
                .eqn = "",
                .root = undefined,
            };
            defer if (dc_ast.eqn.len > 0) dc_ast.deinit();

            const maybe_dc_ast: ?*Ast(Device) = if (options.dont_care.len > 0) ptr: {
                dc_ast = try Ast(Device).parse(self.gpa, &names, options.dont_care);
                _ = try dc_ast.infer_and_check_max_bit(.{ .max_result_bits = 1 });
                break :ptr &dc_ast;
            } else null;

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            return try self.find_best_logic(&ast, maybe_dc_ast, &ir_data, 0, options);
        }
        
        pub fn assign_logic(self: *Self, chip: *lc4k.Chip_Config(Device.device_type), mc_signals: []const Device.Signal, equation: []const u8, extra: anytype) !void {
            var names_arena = std.heap.ArenaAllocator.init(self.gpa);
            defer names_arena.deinit();

            const options = parse_options(extra);
            var names = try self.parse_extra_names(names_arena.allocator(), extra);
            defer names.deinit();

            var ast = try Ast(Device).parse(self.gpa, &names, equation);
            defer ast.deinit();

            _ = try ast.infer_and_check_max_bit(.{
                .min_result_bits = @intCast(mc_signals.len),
                .max_result_bits = @intCast(mc_signals.len),
            });

            var dc_ast: Ast(Device) = .{
                .gpa = self.gpa,
                .eqn = "",
                .root = undefined,
            };
            defer if (dc_ast.eqn.len > 0) dc_ast.deinit();

            const maybe_dc_ast: ?*Ast(Device) = if (options.dont_care.len > 0) ptr: {
                dc_ast = try Ast(Device).parse(self.gpa, &names, options.dont_care);
                _ = try dc_ast.infer_and_check_max_bit(.{
                    .min_result_bits = @intCast(mc_signals.len),
                    .max_result_bits = @intCast(mc_signals.len),
                });
                break :ptr &dc_ast;
            } else null;

            var ir_data = try IR_Data.init(self.gpa);
            defer ir_data.deinit();

            for (0.., mc_signals) |bit_index, signal| {
                chip.mc(signal.mc()).logic = try self.find_best_logic(&ast, maybe_dc_ast, &ir_data, @intCast(bit_index), options);
            }
        }

        fn find_best_logic(self: *Self, ast: *Ast(Device), maybe_dc_ast: ?*Ast(Device), ir_data: *IR_Data, bit_index: u6, options: Options) !Logic {
            const allocator = self.arena.allocator();

            const optimization_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;

            const ir = try ir_data.normalize(try ast.build_ir(ir_data, bit_index), .{
                .max_xor_depth = 0xFFFF,
                .demorgan = false,
                .distribute = false,
            });

            const dc_ir = if (maybe_dc_ast) |dc_ast| try ir_data.normalize(try dc_ast.build_ir(ir_data, bit_index), .{ .max_xor_depth = 0 }) else null;

            var ir_sum = try ir_data.normalize(ir, .{ .max_xor_depth = 0 });
            ir_sum = try qmc.optimize(ir_data, ir_sum, dc_ir, optimization_signal_limit);
            const ir_sum_pts = ir_data.count_pts(ir_sum);
            if (ir_sum_pts == 1) {
                return .{ .pt0 = .{
                    .pt = try ir_data.get_pt(Device.Signal, allocator, ir_sum, 0),
                    .polarity = .positive,
                }};
            }

            var best_ir = ir_sum;
            var best_ir_pts = ir_sum_pts;
            var best_ir_kind: std.meta.Tag(lc4k.Macrocell_Logic(Device.Signal)) = .sum;
            var best_ir_polarity: lc4k.Polarity = .positive;

            var ir_sum_inverted = try ir_data.normalize(try ir_data.make_complement(ir), .{ .max_xor_depth = 0 });
            ir_sum_inverted = try qmc.optimize(ir_data, ir_sum_inverted, dc_ir, optimization_signal_limit);
            const ir_sum_inverted_pts = ir_data.count_pts(ir_sum_inverted);
            if (ir_sum_inverted_pts == 1) {
                return .{ .pt0 = .{
                    .pt = try ir_data.get_pt(Device.Signal, allocator, ir_sum_inverted, 0),
                    .polarity = .negative,
                }};
            } else if (ir_sum_inverted_pts < best_ir_pts) {
                best_ir = ir_sum_inverted;
                best_ir_pts = ir_sum_inverted_pts;
                best_ir_kind = .sum;
                best_ir_polarity = .negative;
            }

            switch (ir_data.get(ir)) {
                .xor => |raw_xor_bin| {
                    const lhs, const rhs = bin: {
                        const xor_bin = ir_data.get(try ir_data.normalize(ir, .{})).xor;
                        break :bin .{
                            try qmc.optimize(ir_data, xor_bin.lhs, dc_ir, optimization_signal_limit),
                            try qmc.optimize(ir_data, xor_bin.rhs, dc_ir, optimization_signal_limit),
                        };
                    };
                    const lhs_pts = ir_data.count_pts(lhs);
                    const rhs_pts = ir_data.count_pts(rhs);

                    const lhs_inverted, const rhs_inverted = bin: {
                        const lhs_inverted = try ir_data.normalize(try ir_data.make_complement(raw_xor_bin.lhs), .{ .max_xor_depth = 0 });
                        const rhs_inverted = try ir_data.normalize(try ir_data.make_complement(raw_xor_bin.rhs), .{ .max_xor_depth = 0 });
                        break :bin .{
                            try qmc.optimize(ir_data, lhs_inverted, dc_ir, optimization_signal_limit),
                            try qmc.optimize(ir_data, rhs_inverted, dc_ir, optimization_signal_limit),
                        };
                    };
                    const lhs_inverted_pts = ir_data.count_pts(lhs_inverted);
                    const rhs_inverted_pts = ir_data.count_pts(rhs_inverted);

                    if (lhs_pts == 1) {
                        if (rhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs);
                            best_ir_pts = rhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .positive;
                        }
                        if (rhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs_inverted);
                            best_ir_pts = rhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .negative;
                        }
                    }
                    if (rhs_pts == 1) {
                        if (lhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs);
                            best_ir_pts = lhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .positive;
                        }
                        if (lhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs);
                            best_ir_pts = lhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .negative;
                        }
                    }
                    if (lhs_inverted_pts == 1) {
                        if (rhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs_inverted);
                            best_ir_pts = rhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .positive;
                        }
                        if (rhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs);
                            best_ir_pts = rhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .negative;
                        }
                    }
                    if (rhs_inverted_pts == 1) {
                        if (lhs_inverted_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs_inverted, rhs_inverted);
                            best_ir_pts = lhs_inverted_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .positive;
                        }
                        if (lhs_pts + 1 < best_ir_pts) {
                            best_ir = try ir_data.make_binary(.xor, lhs, rhs_inverted);
                            best_ir_pts = lhs_pts + 1;
                            best_ir_kind = .sum_xor_pt0;
                            best_ir_polarity = .negative;
                        }
                    }
                },
                else => {}
            }

            if (best_ir_pts > options.max_product_terms) {
                Ast(Device).report_node_error_fmt(self.gpa, ast.nodes.slice(), ast.eqn, ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    best_ir_pts,
                    options.max_product_terms,
                });
                var buf: [64]u8 = undefined;
                var w = std.fs.File.stderr().writer(&buf);
                ir_data.debug(best_ir, 0, false, &w.interface) catch {};
                w.interface.flush() catch {};
                return error.TooManyProductTerms;
            }

            switch (best_ir_kind) {
                .sum => {
                    const pts = try allocator.alloc(PT, best_ir_pts);
                    for (0.., pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, best_ir, i);
                    }
                    return .{ .sum = .{
                        .sum = pts,
                        .polarity = best_ir_polarity,
                    }};
                },
                .sum_xor_pt0 => {
                    const xor_bin = ir_data.get(best_ir).xor;
                    var pt0_ir = xor_bin.lhs;
                    var sum_ir = xor_bin.rhs;
                    if (ir_data.count_pts(xor_bin.lhs) > 1) {
                        pt0_ir = xor_bin.rhs;
                        sum_ir = xor_bin.lhs;
                    }
                    const sum_pts = try allocator.alloc(PT, best_ir_pts - 1);
                    for (0.., sum_pts) |i, *term| {
                        term.* = try ir_data.get_pt(Device.Signal, allocator, sum_ir, i);
                    }
                    return .{ .sum_xor_pt0 = .{
                        .sum = sum_pts,
                        .pt0 = try ir_data.get_pt(Device.Signal, allocator, pt0_ir, 0),
                        .polarity = best_ir_polarity,
                    }};
                },
                else => unreachable,
            }
        }

        const Process_Single_Bit_Results = struct {
            options: Options,
            opt_signal_limit: u5,
            ast: Ast(Device),
            ir_data: IR_Data,
            ir: IR.ID,
            dc_ir: ?IR.ID,

            pub fn deinit(self: *Process_Single_Bit_Results) void {
                self.ir_data.deinit();
                self.ast.deinit();
            }
        };

        fn process_single_bit(self: *Self, equation: []const u8, extra: anytype) !Process_Single_Bit_Results {
            var names_arena = std.heap.ArenaAllocator.init(self.gpa);
            defer names_arena.deinit();

            const options = parse_options(extra);
            var names = try self.parse_extra_names(names_arena.allocator(), extra);
            defer names.deinit();

            const opt_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;

            var ir_data = try IR_Data.init(self.gpa);
            errdefer ir_data.deinit();
            
            var ast = try Ast(Device).parse(self.gpa, &names, equation);
            errdefer ast.deinit();

            _ = try ast.infer_and_check_max_bit(.{ .max_result_bits = 1 });

            const ir = try ast.build_ir(&ir_data, 0);

            const dc_ir = if (options.dont_care.len > 0) dc_ir: {
                var dc_ast = try Ast(Device).parse(self.gpa, &names, options.dont_care);
                defer dc_ast.deinit();

                _ = try dc_ast.infer_and_check_max_bit(.{ .max_result_bits = 1 });

                const dc = try dc_ast.build_ir(&ir_data, 0);
                break :dc_ir try ir_data.normalize(dc, .{ .max_xor_depth = 0 });
            } else null;

            return .{
                .options = options,
                .opt_signal_limit = opt_signal_limit,
                .ast = ast,
                .ir_data = ir_data,
                .ir = ir,
                .dc_ir = dc_ir,
            };
        }

        fn parse_options(extra: anytype) Options {
            var options: Options = .{};

            const T = @TypeOf(extra);

            if (@hasField(T, "max_product_terms")) {
                options.max_product_terms = extra.max_product_terms;
            }

            if (@hasField(T, "optimize")) {
                options.optimize = extra.optimize;
            }

            if (@hasField(T, "dont_care")) {
                options.dont_care = extra.dont_care;
            }

            return options;
        }

        fn parse_extra_names(self: *Self, temp_arena: std.mem.Allocator, extra: anytype) !Names {
            var names: Names = .{
                .gpa = self.gpa,
                .fallback = self.names,
            };
            errdefer names.deinit();

            inline for (@typeInfo(@TypeOf(extra)).@"struct".fields) |field| {
                if (comptime !std.mem.eql(u8, field.name, "dont_care") and !std.mem.eql(u8, field.name, "max_product_terms") and !std.mem.eql(u8, field.name, "optimize")) {
                    try names.add_names_alloc(temp_arena, @field(extra, field.name), .{ .name = field.name });
                }
            }

            return names;
        }
    };
}

pub const Literal = @import("logic_parser/Literal.zig");
pub const lexer = @import("logic_parser/lexer.zig");
pub const Ast = @import("logic_parser/ast.zig").Ast;
pub const IR = IR_Data.IR;
pub const IR_Data = @import("logic_parser/IR_Data.zig");

const qmc = @import("logic_parser/qmc.zig");
const naming = @import("naming.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
