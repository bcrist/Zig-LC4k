pub const Options = struct {
    max_product_terms: u8 = 80,
    optimize: bool = false,
    dont_care: []const u8 = "",
    debug: bool = false,
    polarity: ?lc4k.Polarity = null,
};

pub fn Logic_Parser(comptime Device_Struct: type) type {
    return struct {
        gpa: std.mem.Allocator,
        arena: std.mem.Allocator,
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

            std.debug.assert(p.options.polarity == null);

            const ir_normalized = try p.ir_data.normalize(p.ir, .{ .iteration_limit = 100_000 });
            const ir_optimized = try qmc.optimize(&p.ir_data, ir_normalized, p.dc_ir, p.opt_signal_limit);

            if (p.options.debug) {
                var buf: [64]u8 = undefined;
                var stderr = std.debug.lockStderr(&buf);
                defer std.debug.unlockStderr();
                const w = &stderr.file_writer.interface;

                try w.writeAll("Normalized:\n");
                try p.ir_data.debug(ir_normalized, 0, false, w);
                try w.writeAll("Optimized:\n");
                try p.ir_data.debug(ir_optimized, 0, false, w);
                try w.flush();
            }

            const num_pts = p.ir_data.count_pts(ir_optimized);
            if (num_pts > 1) {
                const diag: Ast(Device).Diag = .{
                    .eqn = equation,
                    .scratch = self.gpa,
                    .slice = p.ast.nodes.slice(),
                };
                diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ num_pts });

                var buf: [64]u8 = undefined;
                var stderr = std.debug.lockStderr(&buf);
                defer std.debug.unlockStderr();
                const w = &stderr.file_writer.interface;

                p.ir_data.debug(ir_optimized, 0, false, w) catch {};
                w.flush() catch {};
                return error.TooManyProductTerms;
            }

            return try p.ir_data.get_pt(Device.Signal, self.arena, ir_optimized, 0);
        }

        pub fn pt_with_polarity(self: *Self, equation: []const u8, extra: anytype) !PTP {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            const diag: Ast(Device).Diag = .{
                .eqn = equation,
                .scratch = self.gpa,
                .slice = p.ast.nodes.slice(),
            };

            if (p.options.polarity) |polarity| switch (polarity) {
                .positive => {
                    if (p.normalize_and_optimize(p.ir, .{ .iteration_limit = 100_000 })) |result| {
                        if (result.num_pts == 1) {
                            return .{
                                .pt = try p.ir_data.get_pt(Device.Signal, self.arena, result.id, 0),
                                .polarity = .positive,
                            };
                        } else {
                            diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ result.num_pts });
                            return error.TooManyProductTerms;
                        }
                    } else {
                        diag.report_node_error_fmt(p.ast.root, "Failed to normalize expression.", .{});
                        return error.ExpressionTooComplex;
                    }
                },
                .negative => {
                    if (p.normalize_and_optimize(try p.ir_data.make_complement(p.ir), .{ .iteration_limit = 100_000 })) |result| {
                        if (result.num_pts == 1) {
                            return .{
                                .pt = try p.ir_data.get_pt(Device.Signal, self.arena, result.id, 0),
                                .polarity = .negative,
                            };
                        } else {
                            diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ result.num_pts });
                            return error.TooManyProductTerms;
                        }
                    } else {
                        diag.report_node_error_fmt(p.ast.root, "Failed to normalize expression.", .{});
                        return error.ExpressionTooComplex;
                    }
                },
            } else {
                const positive = p.normalize_and_optimize(p.ir, .{});
                if (positive) |result| {
                    if (result.num_pts == 1) {
                        return .{
                            .pt = try p.ir_data.get_pt(Device.Signal, self.arena, result.id, 0),
                            .polarity = .positive,
                        };
                    }
                }

                const negative = p.normalize_and_optimize(try p.ir_data.make_complement(p.ir), .{});
                if (negative) |result| {
                    if (result.num_pts == 1) {
                        return .{
                            .pt = try p.ir_data.get_pt(Device.Signal, self.arena, result.id, 0),
                            .polarity = .negative,
                        };
                    }
                }

                if (positive == null and negative == null) {
                    diag.report_node_error_fmt(p.ast.root, "Unable to guess correct polarity for expression; please specify with .{{ .polarity = .positive }} or .{{ .polarity = .negative }}", .{});
                    return error.ExpressionTooComplex;
                } else {
                    var min_num_pts: u32 = std.math.maxInt(u32);
                    if (positive) |result| min_num_pts = @min(min_num_pts, result.num_pts);
                    if (negative) |result| min_num_pts = @min(min_num_pts, result.num_pts);
                    diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only 1 is allowed.", .{ min_num_pts });
                    return error.TooManyProductTerms;
                }
            }
        }

        pub fn sum(self: *Self, equation: []const u8, extra: anytype) ![]PT {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            std.debug.assert(p.options.polarity == null);

            const result = p.normalize_and_optimize(p.ir, .{ .iteration_limit = 100_000 }) orelse return error.ExpressionTooComplex;
            const allocator = self.arena;
            if (result.num_pts > p.options.max_product_terms) {
                const diag: Ast(Device).Diag = .{
                    .eqn = equation,
                    .scratch = self.gpa,
                    .slice = p.ast.nodes.slice(),
                };
                diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                    result.num_pts,
                    p.options.max_product_terms,
                });
                var buf: [64]u8 = undefined;
                var stderr = std.debug.lockStderr(&buf);
                defer std.debug.unlockStderr();
                const w = &stderr.file_writer.interface;
                p.ir_data.debug(result.id, 0, false, w) catch {};
                w.flush() catch {};
                return error.TooManyProductTerms;
            }
            const pts = try allocator.alloc(PT, result.num_pts);
            for (0.., pts) |i, *term| {
                term.* = try p.ir_data.get_pt(Device.Signal, allocator, result.id, i);
            }
            return pts;
        }

        pub fn sum_with_polarity(self: *Self, equation: []const u8, extra: anytype) !SumP {
            var p = try self.process_single_bit(equation, extra);
            defer p.deinit();

            var maybe_best: ?IR_Result = null;
            var best_polarity: lc4k.Polarity = undefined;

            if (p.options.polarity) |polarity| switch (polarity) {
                .positive => {
                    if (p.normalize_and_optimize(p.ir, .{ .iteration_limit = 100_000 })) |result| {
                        best_polarity = .positive;
                        maybe_best = result;
                    }
                },
                .negative => {
                    if (p.normalize_and_optimize(try p.ir_data.make_complement(p.ir), .{ .iteration_limit = 100_000 })) |result| {
                        best_polarity = .negative;
                        maybe_best = result;
                    }
                },
            } else {
                const maybe_positive = p.normalize_and_optimize(p.ir, .{});
                const maybe_negative = p.normalize_and_optimize(try p.ir_data.make_complement(p.ir), .{});

                if (maybe_positive) |positive| {
                    best_polarity = .positive;
                    maybe_best = positive;
                    if (maybe_negative) |negative| {
                        if (negative.num_pts < positive.num_pts) {
                            best_polarity = .negative;
                            maybe_best = negative;
                        }
                    }
                } else if (maybe_negative) |negative| {
                    best_polarity = .negative;
                    maybe_best = negative;
                } else {
                    const diag: Ast(Device).Diag = .{
                        .eqn = equation,
                        .scratch = self.gpa,
                        .slice = p.ast.nodes.slice(),
                    };
                    diag.report_node_error_fmt(p.ast.root, "Unable to guess correct polarity for expression; please specify with .{{ .polarity = .positive }} or .{{ .polarity = .negative }}", .{});
                }
            }

            if (maybe_best) |best| {
                if (best.num_pts > p.options.max_product_terms) {
                    const diag: Ast(Device).Diag = .{
                        .eqn = equation,
                        .scratch = self.gpa,
                        .slice = p.ast.nodes.slice(),
                    };
                    diag.report_node_error_fmt(p.ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                        best.num_pts,
                        p.options.max_product_terms,
                    });
                    var buf: [64]u8 = undefined;
                    var stderr = std.debug.lockStderr(&buf);
                    defer std.debug.unlockStderr();
                    const w = &stderr.file_writer.interface;
                    p.ir_data.debug(best.id, 0, false, w) catch {};
                    w.flush() catch {};
                    return error.TooManyProductTerms;
                }
                const allocator = self.arena;
                const pts = try allocator.alloc(PT, best.num_pts);
                for (0.., pts) |i, *term| {
                    term.* = try p.ir_data.get_pt(Device.Signal, allocator, best.id, i);
                }
                return .{
                    .sum = pts,
                    .polarity = best_polarity,
                };

            } else {
                return error.ExpressionTooComplex;
            }
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
            const allocator = self.arena;

            const optimization_signal_limit = if (options.optimize) self.optimization_signal_limit else 0;

            const raw_ir = try ir_data.normalize(try ast.build_ir(ir_data, bit_index), .{
                .max_xor_depth = 0xFF,
                .demorgan = false,
                .distribute = false,
            });

            const is_xor = ir_data.get(raw_ir) == .xor;

            const dc_ir = if (maybe_dc_ast) |dc_ast| try ir_data.normalize(try dc_ast.build_ir(ir_data, bit_index), .{}) else null;

            var maybe_best_ir: ?IR_Result = null;
            var best_ir_kind: std.meta.Tag(lc4k.Macrocell_Logic(Device.Signal)) = undefined;
            var best_ir_polarity: lc4k.Polarity = undefined;

            if (options.polarity != .negative) {
                if (ir_data.maybe_normalize(raw_ir, .{ .iteration_limit = if (!is_xor and options.polarity == .positive) 100_000 else 500 })) |normalized| {
                    const optimized = try qmc.optimize(ir_data, normalized, dc_ir, optimization_signal_limit);
                    const num_pts = ir_data.count_pts(optimized);
                    if (num_pts == 1) {
                        return .{ .pt0 = .{
                            .pt = try ir_data.get_pt(Device.Signal, allocator, optimized, 0),
                            .polarity = .positive,
                        }};
                    } else {
                        maybe_best_ir = .{
                            .id = optimized,
                            .num_pts = @intCast(num_pts),
                        };
                        best_ir_kind = .sum;
                        best_ir_polarity = .positive;
                    }
                }
            }

            if (options.polarity != .positive) {
                const complement = try ir_data.make_complement(raw_ir);
                if (ir_data.maybe_normalize(complement, .{ .iteration_limit = if (!is_xor and options.polarity == .negative) 100_000 else 500 })) |normalized| {
                    const optimized = try qmc.optimize(ir_data, normalized, dc_ir, optimization_signal_limit);
                    const num_pts = ir_data.count_pts(optimized);
                    if (num_pts == 1) {
                        return .{ .pt0 = .{
                            .pt = try ir_data.get_pt(Device.Signal, allocator, optimized, 0),
                            .polarity = .negative,
                        }};
                    } else if (maybe_best_ir == null or maybe_best_ir.?.num_pts > num_pts) {
                        maybe_best_ir = .{
                            .id = optimized,
                            .num_pts = @intCast(num_pts),
                        };
                        best_ir_kind = .sum;
                        best_ir_polarity = .negative;
                    }
                }
            }

            if (is_xor) {
                const xor_bin = ir_data.get(raw_ir).xor;

                const maybe_lhs: ?IR_Result = .init(ir_data, xor_bin.lhs, dc_ir, optimization_signal_limit, .{});
                const maybe_rhs: ?IR_Result = .init(ir_data, xor_bin.rhs, dc_ir, optimization_signal_limit, .{});

                const maybe_lhs_inverted: ?IR_Result = .init(ir_data, try ir_data.make_complement(xor_bin.lhs), dc_ir, optimization_signal_limit, .{});
                const maybe_rhs_inverted: ?IR_Result = .init(ir_data, try ir_data.make_complement(xor_bin.rhs), dc_ir, optimization_signal_limit, .{});

                var polarity: lc4k.Polarity = .positive;

                const best_lhs = if (maybe_lhs) |ir| result: {
                    if (maybe_lhs_inverted) |ir_inverted| {
                        if (ir_inverted.num_pts < ir.num_pts) {
                            polarity = polarity.invert();
                            break :result ir_inverted;
                        }
                    }
                    break :result ir;
                } else maybe_lhs_inverted;

                const best_rhs = if (maybe_rhs) |ir| result: {
                    if (maybe_rhs_inverted) |ir_inverted| {
                        if (ir_inverted.num_pts < ir.num_pts) {
                            polarity = polarity.invert();
                            break :result ir_inverted;
                        }
                    }
                    break :result ir;
                } else maybe_rhs_inverted;

                if (best_lhs) |lhs| {
                    if (best_rhs) |rhs| {
                        if (maybe_best_ir == null or maybe_best_ir.?.num_pts > lhs.num_pts + rhs.num_pts) {
                            if (lhs.num_pts == 1 or rhs.num_pts == 1) {
                                maybe_best_ir = .{
                                    .id = try ir_data.make_binary(.xor, lhs.id, rhs.id),
                                    .num_pts = lhs.num_pts + rhs.num_pts,
                                };
                                best_ir_kind = .sum_xor_pt0;
                                best_ir_polarity = polarity;
                            }
                        }
                    }
                }
            }

            if (maybe_best_ir) |best_ir| {
                if (options.debug) {
                    var buf: [64]u8 = undefined;
                    var stderr = std.debug.lockStderr(&buf);
                    defer std.debug.unlockStderr();
                    const w = &stderr.file_writer.interface;
                    try w.print("Best ({t}):\n", .{ best_ir_kind });
                    try ir_data.debug(best_ir.id, 0, false, w);
                    try w.flush();
                }

                if (best_ir.num_pts > options.max_product_terms) {
                    const diag: Ast(Device).Diag = .{
                        .eqn = ast.eqn,
                        .scratch = self.gpa,
                        .slice = ast.nodes.slice(),
                    };
                    diag.report_node_error_fmt(ast.root, "After normalization, expression requires {} product terms, but a maximum of only {} are allowed.", .{
                        best_ir.num_pts,
                        options.max_product_terms,
                    });
                    var buf: [64]u8 = undefined;
                    var stderr = std.debug.lockStderr(&buf);
                    defer std.debug.unlockStderr();
                    const w = &stderr.file_writer.interface;
                    ir_data.debug(best_ir.id, 0, false, w) catch {};
                    w.flush() catch {};
                    return error.TooManyProductTerms;
                }

                switch (best_ir_kind) {
                    .sum => {
                        const pts = try allocator.alloc(PT, best_ir.num_pts);
                        for (0.., pts) |i, *term| {
                            term.* = try ir_data.get_pt(Device.Signal, allocator, best_ir.id, i);
                        }
                        return .{ .sum = .{
                            .sum = pts,
                            .polarity = best_ir_polarity,
                        }};
                    },
                    .sum_xor_pt0 => {
                        const xor_bin = ir_data.get(best_ir.id).xor;
                        var pt0_ir = xor_bin.lhs;
                        var sum_ir = xor_bin.rhs;
                        if (ir_data.count_pts(xor_bin.lhs) > 1) {
                            pt0_ir = xor_bin.rhs;
                            sum_ir = xor_bin.lhs;
                        }
                        const sum_pts = try allocator.alloc(PT, best_ir.num_pts - 1);
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
            } else {
                return error.ExpressionTooComplex;
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

            pub fn normalize_and_optimize(self: *Process_Single_Bit_Results, ir: IR.ID, normalize_options: IR_Data.Normalize_Options) ?IR_Result {
                return .init(&self.ir_data, ir, self.dc_ir, self.opt_signal_limit, normalize_options);
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
                break :dc_ir try ir_data.normalize(dc, .{});
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

            if (@hasField(T, "polarity")) {
                options.polarity = extra.polarity;
            }

            if (@hasField(T, "debug")) {
                options.debug = true;
            }

            return options;
        }

        fn parse_extra_names(self: *Self, temp_arena: std.mem.Allocator, extra: anytype) !Names {
            var names: Names = .{
                .gpa = self.gpa,
                .fallback = self.names,
                .allow_multiple_names = true,
            };
            errdefer names.deinit();

            inline for (@typeInfo(@TypeOf(extra)).@"struct".fields) |field| {
                if (comptime !std.mem.eql(u8, field.name, "dont_care") and !std.mem.eql(u8, field.name, "max_product_terms") and !std.mem.eql(u8, field.name, "optimize") and !std.mem.eql(u8, field.name, "polarity") and !std.mem.eql(u8, field.name, "debug")) {
                    try names.add_names_alloc(temp_arena, @field(extra, field.name), .{ .name = field.name });
                }
            }

            return names;
        }
    };
}

pub const IR_Result = struct {
    id: IR.ID,
    num_pts: u32,

    pub fn init(ir_data: *IR_Data, ir: IR.ID, dc_ir: ?IR.ID, opt_signal_limit: u5, normalize_options: IR_Data.Normalize_Options) ?IR_Result {
        var result = ir_data.normalize(ir, normalize_options) catch return null;
        result = qmc.optimize(ir_data, result, dc_ir, opt_signal_limit) catch result;
        const num_pts = ir_data.count_pts(result);
        return .{
            .id = result,
            .num_pts = @intCast(num_pts),
        };
    }
};

pub const Literal = @import("logic_parser/Literal.zig");
pub const lexer = @import("logic_parser/lexer.zig");
pub const Ast = @import("logic_parser/ast.zig").Ast;
pub const IR = IR_Data.IR;
pub const IR_Data = @import("logic_parser/IR_Data.zig");

const log = std.log.scoped(.lc4k_logic_parser);

const qmc = @import("logic_parser/qmc.zig");
const naming = @import("naming.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
