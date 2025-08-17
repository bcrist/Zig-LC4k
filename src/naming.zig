pub fn Names(comptime Device: type) type {
    const Signal = Device.Signal;

    return struct {
        gpa: std.mem.Allocator,
        fallback: ?*const Self,

        glb_names: std.AutoHashMapUnmanaged(GLB_Index, []const u8) = .empty,
        glb_lookup: std.StringHashMapUnmanaged(GLB_Index) = .empty,

        macrocell_names: std.AutoHashMapUnmanaged(MC_Ref, []const u8) = .empty,
        macrocell_lookup: std.StringHashMapUnmanaged(MC_Ref) = .empty,

        signal_names: std.AutoHashMapUnmanaged(Signal, []const u8) = .empty,
        signal_lookup: std.StringHashMapUnmanaged(Signal) = .empty,

        bus_lookup: std.StringHashMapUnmanaged([]const Signal) = .empty,

        constant_lookup: std.StringHashMapUnmanaged(Literal) = .empty,

        allow_multiple_names: bool = false, // set to true to allow multiple names to refer to the same signal/MC/etc.

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .gpa = allocator,
                .fallback = Device.get_names(),
            };
        }

        pub fn init_defaults(allocator: std.mem.Allocator, comptime Pins: type) Self {
            var self: Self = .{
                .gpa = allocator,
                .fallback = null,
            };

            self.glb_names.ensureTotalCapacity(self.gpa, Device.num_glbs) catch unreachable;
            self.glb_lookup.ensureTotalCapacity(self.gpa, Device.num_glbs) catch unreachable;

            self.macrocell_names.ensureTotalCapacity(self.gpa, Device.num_mcs) catch unreachable;
            self.macrocell_lookup.ensureTotalCapacity(self.gpa, Device.num_mcs) catch unreachable;

            self.signal_names.ensureTotalCapacity(self.gpa, @intCast(std.enums.values(Signal).len)) catch unreachable;
            self.signal_lookup.ensureTotalCapacity(self.gpa, @intCast(std.enums.values(Signal).len)) catch unreachable;

            inline for (0..Device.num_glbs) |glb| {
                const glb_name = @tagName(Signal.mc_fb(MC_Ref.init(glb, 0)))[3..4];
                self.add_glb_name(@intCast(glb), glb_name) catch unreachable;

                for (0..Device.num_mcs_per_glb) |mc| {
                    const mcref = MC_Ref.init(glb, mc);
                    const mc_name = @tagName(Signal.mc_fb(mcref))[3..];
                    self.add_mc_name(mcref, mc_name) catch unreachable;
                }
            }

            for (std.enums.values(Signal)) |signal| {
                self.add_signal_name(signal, @tagName(signal)) catch unreachable;
            }

            inline for (@typeInfo(Pins).@"struct".decls) |decl| {
                if (@field(Pins, decl.name).info.signal_index) |signal_index| {
                    const name = if (comptime std.mem.startsWith(u8, decl.name, "_")) "pin" ++ decl.name else "pin_" ++ decl.name;
                    self.add_bus_name(&.{ @enumFromInt(signal_index) }, name) catch unreachable;
                }
            }

            return self;
        }

        pub fn deinit(self: *Self) void {
            self.glb_names.deinit(self.gpa);
            self.glb_lookup.deinit(self.gpa);
            self.macrocell_names.deinit(self.gpa);
            self.macrocell_lookup.deinit(self.gpa);
            self.signal_names.deinit(self.gpa);
            self.signal_lookup.deinit(self.gpa);
            self.bus_lookup.deinit(self.gpa);
            self.constant_lookup.deinit(self.gpa);
        }

        pub const Add_Names_Options = struct {
            prefix: []const u8 = "",
            name: []const u8 = "",
            suffix: []const u8 = "",
        };

        pub fn add_names(self: *Self, comptime what: anytype, comptime options: Add_Names_Options) !void {
            const T = @TypeOf(what);
            switch (T) {
                GLB_Index => try self.add_glb_name(what, options.prefix ++ options.name ++ options.suffix),
                MC_Ref => try self.add_mc_name(what, options.prefix ++ options.name ++ options.suffix),
                Signal => try self.add_signal_name(what, options.prefix ++ options.name ++ options.suffix),
                type => {
                    const name_is_suffix = comptime std.mem.startsWith(u8, options.name, ".");
                    const prefix = options.prefix ++ if (name_is_suffix) "" else options.name ++ if (options.name.len > 0) "." else "";
                    const suffix = if (name_is_suffix) options.name ++ options.suffix else options.suffix;

                    const decls = switch (@typeInfo(what)) {
                        .@"struct" => |info| info.decls,
                        .@"union" => |info| info.decls,
                        else => @compileError("Expected struct or union type; found " ++ @typeName(what)),
                    };

                    inline for (decls) |decl| {
                        if (@typeInfo(@TypeOf(@field(what, decl.name))) != .@"fn") {
                            try self.add_names(@field(what, decl.name), .{
                                .prefix = prefix,
                                .name = decl.name,
                                .suffix = suffix,
                            });
                        }
                    }
                },
                else => switch (@typeInfo(T)) {
                    .@"struct" => |struct_info| {
                        const name_is_suffix = comptime std.mem.startsWith(u8, options.name, ".");
                        const prefix = options.prefix ++ if (name_is_suffix) "" else options.name ++ if (options.name.len > 0) "." else "";
                        const suffix = if (name_is_suffix) options.name ++ options.suffix else options.suffix;

                        inline for (struct_info.fields) |field| {
                            try self.add_names(@field(what, field.name), .{
                                .prefix = prefix,
                                .name = field.name,
                                .suffix = suffix,
                            });
                        }
                    },
                    .array => |info| {
                        inline for (0.., what) |i, elem| {
                            try self.add_names(elem, .{
                                .prefix = options.prefix,
                                .name = std.fmt.comptimePrint("{s}[{}]", .{ options.name, i }),
                                .suffix = options.suffix,
                            });
                        }
                        if (info.child == Signal) {
                            try self.add_bus_name(&what, options.prefix ++ options.name ++ options.suffix);
                        }
                    },
                    .pointer => |info| {
                        if (info.size != .slice) {
                            @compileError("Unexpected type: " ++ @typeName(T) ++ " for " ++ options.prefix ++ options.name ++ options.suffix);
                        }
                        inline for (0.., what) |i, elem| {
                            try self.add_names(elem, .{
                                .prefix = options.prefix,
                                .name = std.fmt.comptimePrint("{s}[{}]", .{ options.name, i }),
                                .suffix = options.suffix,
                            });
                        }
                        if (info.child == Signal) {
                            try self.add_bus_name(what, options.prefix ++ options.name ++ options.suffix);
                        }
                    },
                    .int => {
                        try self.add_constant(what, options.prefix ++ options.name ++ options.suffix);
                    },
                    else => @compileError("Unexpected type: " ++ @typeName(T) ++ " for " ++ options.prefix ++ options.name ++ options.suffix), 
                },
            }
        }

        pub fn add_glb_name(self: *Self, glb: GLB_Index, name: []const u8) !void {
            try self.glb_names.ensureUnusedCapacity(self.gpa, 1);
            try self.glb_lookup.ensureUnusedCapacity(self.gpa, 1);

            if (self.glb_lookup.contains(name)) return error.Duplicate_Name;
            if (self.glb_names.contains(glb)) {
                if (!self.allow_multiple_names) return error.Already_Named;
            } else {
                self.glb_names.putAssumeCapacityNoClobber(glb, name);
            }

            self.glb_lookup.putAssumeCapacityNoClobber(name, glb);
        }

        pub fn add_mc_name(self: *Self, mc: MC_Ref, name: []const u8) !void {
            try self.macrocell_names.ensureUnusedCapacity(self.gpa, 1);
            try self.macrocell_lookup.ensureUnusedCapacity(self.gpa, 1);

            if (self.macrocell_lookup.contains(name)) return error.Duplicate_Name;
            if (self.macrocell_names.contains(mc)) {
                if (!self.allow_multiple_names) return error.Already_Named;
            } else {
                self.macrocell_names.putAssumeCapacityNoClobber(mc, name);
            }

            self.macrocell_lookup.putAssumeCapacityNoClobber(name, mc);
        }

        pub fn add_signal_name(self: *Self, signal: Signal, name: []const u8) !void {
            try self.signal_names.ensureUnusedCapacity(self.gpa, 1);
            try self.signal_lookup.ensureUnusedCapacity(self.gpa, 1);

            if (self.signal_lookup.contains(name)) return error.Duplicate_Name;
            if (self.signal_names.contains(signal)) {
                if (!self.allow_multiple_names) return error.Already_Named;
            } else {
                self.signal_names.putAssumeCapacity(signal, name);
            }

            self.signal_lookup.putAssumeCapacityNoClobber(name, signal);
        }

        pub fn add_bus_name(self: *Self, comptime signals: []const Signal, name: []const u8) !void {
            if (self.bus_lookup.contains(name)) return error.Duplicate_Name;
            try self.bus_lookup.ensureUnusedCapacity(self.gpa, 1);
            self.bus_lookup.putAssumeCapacityNoClobber(name, signals);
        }

        pub fn add_constant(self: *Self, constant: anytype, name: []const u8) !void {
            const T = @TypeOf(constant);
            if (self.constant_lookup.contains(name)) return error.Duplicate_Name;
            try self.constant_lookup.ensureUnusedCapacity(self.gpa, 1);
            self.constant_lookup.putAssumeCapacityNoClobber(name, if (T == Literal) constant else .{
                .value = if (T == u64 or T == usize) constant else @bitCast(@as(i64, constant)),
                .max_bit_index = @intCast(@typeInfo(T).int.bits - 1),
            });
        }

        pub fn propagate_names(self: *Self, arena: std.mem.Allocator, chip: *const lc4k.Chip_Config(Device.device_type)) !void {
            // Based on ORM routing, give names to any MC feedback signals that are routed to named I/O signals
            // Macrocell name lookup will automatically look at feedback signal names, so no need to propagate that,
            for (0..Device.num_glbs) |glb| {
                for (0..Device.num_mcs_per_glb) |mc| {
                    const mcref: lc4k.MC_Ref = .init(glb, mc);
                    const pad = Device.Signal.maybe_mc_pad(mcref) orelse continue;

                    if (!self.signal_names.contains(pad)) continue;

                    const out = chip.mc_const(mcref).output;

                    if (out.oe == .input_only) continue;

                    const pad_name = self.get_signal_name(pad);

                    if (Device.family != .zero_power_enhanced) {
                        switch (out.routing) {
                            .same_as_oe => {},
                            .five_pt_fast_bypass => continue,
                            .self => {
                                const fb = Device.Signal.mc_fb(mcref);
                                if (self.signal_names.contains(fb)) continue;

                                const new_name = try std.mem.concat(arena, u8, &.{ pad_name, "$" });
                                try self.add_signal_name(fb, new_name);
                                continue;
                            },
                        }
                    }

                    const source_fb = out.output_routing().to_absolute(mcref);
                    if (self.signal_names.contains(source_fb)) continue;

                    const new_name = try std.mem.concat(arena, u8, &.{ pad_name, "$" });
                    try self.add_signal_name(source_fb, new_name);
                }
            }
        }

        pub fn debug(self: Self, w: std.io.AnyWriter) !void {
            if (self.constant_lookup.count() > 0) {
                try w.writeAll("\nConstants:\n");
                var constant_iter = self.constant_lookup.iterator();
                while (constant_iter.next()) |entry| {
                    const constant = entry.value_ptr.*;
                    const constant_bits: std.StaticBitSet(64) = .{ .mask = constant.value };
                    try w.print("   {s}: {}'0b", .{ entry.key_ptr.*, constant.bits });
                    for (0..constant.bits) |i| {
                        try w.writeByte(if (constant_bits.isSet(constant.bits - i - 1)) "1" else "0");
                    }
                    try w.writeByte('\n');
                }
            }

            if (self.bus_lookup.count() > 0) {
                try w.writeAll("\nBuses:\n");
                var bus_iter = self.bus_lookup.iterator();
                while (bus_iter.next()) |entry| {
                    try w.print("   {s}:", .{ entry.key_ptr.* });
                    for (entry.value_ptr.*) |signal| {
                        try w.print(" {s}", .{ @tagName(signal) });
                    }
                    try w.writeByte('\n');
                }
            }

            if (self.signal_lookup.count() > 0) {
                try w.writeAll("\nSignals:\n");
                var sig_iter = self.signal_lookup.iterator();
                while (sig_iter.next()) |entry| {
                    try w.print("   {s}: {s}\n", .{ entry.key_ptr.*, @tagName(entry.value_ptr.*) });
                }
            }

            if (self.macrocell_lookup.count() > 0) {
                try w.writeAll("\nMacrocells:\n");
                var mc_iter = self.macrocell_lookup.iterator();
                while (mc_iter.next()) |entry| {
                    try w.print("   {s}: GLB {} MC {}\n", .{ entry.key_ptr.*, entry.value_ptr.glb, entry.value_ptr.mc });
                }
            }

            if (self.glb_lookup.count() > 0) {
                try w.writeAll("\nGLBs:\n");
                var glb_iter = self.glb_lookup.iterator();
                while (glb_iter.next()) |entry| {
                    try w.print("   {s}: {}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
                }
            }

            if (self.fallback) |fallback| {
                try w.writeAll("\nFallback:\n");
                try fallback.debug(w);
            }
        }

        pub fn get_glb_name(self: Self, glb: GLB_Index) []const u8 {
            if (self.glb_names.get(glb)) |name| {
                return name;
            }

            if (self.fallback) |fallback| {
                return fallback.get_glb_name(glb);
            }

            return "unused";
        }

        pub fn lookup_glb(self: Self, name: []const u8) ?GLB_Index {
            if (self.glb_lookup.get(name)) |glb| {
                return glb;
            }

            if (self.fallback) |fallback| {
                return fallback.lookup_glb(name);
            }

            return null;
        }

        pub fn get_mc_name(self: Self, mc: MC_Ref) []const u8 {
            if (self.macrocell_names.get(mc)) |name| {
                return name;
            }

            if (self.signal_names.get(Signal.mc_fb(mc))) |name| {
                if (std.mem.endsWith(u8, name, ".fb")) {
                    return name[0 .. name.len - 3];
                }
                if (std.mem.endsWith(u8, name, "$")) {
                    return name[0 .. name.len - 1];
                }
                return name;
            }

            if (self.fallback) |fallback| {
                return fallback.get_mc_name(mc);
            }

            return "unused";
        }

        pub fn lookup_mc(self: Self, name: []const u8) ?MC_Ref {
            if (self.macrocell_lookup.get(name)) |mcref| {
                return mcref;
            }

            if (self.signal_lookup.get(name)) |signal| {
                if (signal.kind() == .mc) {
                    if (signal.maybe_mc()) |mcref| {
                        return mcref;
                    }
                }
            }

            if (self.fallback) |fallback| {
                return fallback.lookup_mc(name);
            }

            return null;
        }

        pub fn get_signal_name(self: Self, signal: Signal) []const u8 {
            if (self.signal_names.get(signal)) |name| {
                return name;
            }

            if (self.fallback) |fallback| {
                return fallback.get_signal_name(signal);
            }

            return "unused";
        }

        pub fn lookup_signal(self: Self, name: []const u8) ?Signal {
            if (self.signal_lookup.get(name)) |signal| {
                return signal;
            }

            if (self.fallback) |fallback| {
                return fallback.lookup_signal(name);
            }

            return null;
        }

        pub fn lookup_bus(self: Self, name: []const u8) ?[]const Signal {
            if (self.bus_lookup.get(name)) |bus| {
                return bus;
            }

            if (self.fallback) |fallback| {
                return fallback.lookup_bus(name);
            }

            return null;
        }

        pub fn lookup_constant(self: Self, name: []const u8) ?Literal {
            if (self.constant_lookup.get(name)) |literal| {
                return literal;
            }

            if (self.fallback) |fallback| {
                return fallback.lookup_constant(name);
            }

            return null;
        }
    };
}

const Literal = @import("logic_parser/Literal.zig");
const GLB_Index = lc4k.GLB_Index;
const MC_Ref = lc4k.MC_Ref;
const device = @import("device.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
