pub fn Names(comptime Device: type) type {
    const Signal = Device.Signal;

    return struct {
        gpa: std.mem.Allocator,
        fallback: ?*const Self,

        glb_names: std.AutoHashMapUnmanaged(GLB_Index, []const u8) = .{},
        glb_lookup: std.StringHashMapUnmanaged(GLB_Index) = .{},

        macrocell_names: std.AutoHashMapUnmanaged(MC_Ref, []const u8) = .{},
        macrocell_lookup: std.StringHashMapUnmanaged(MC_Ref) = .{},

        signal_names: std.AutoHashMapUnmanaged(Signal, []const u8) = .{},
        signal_lookup: std.StringHashMapUnmanaged(Signal) = .{},

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .gpa = allocator,
                .fallback = Device.get_names(),
            };
        }

        pub fn init_defaults(allocator: std.mem.Allocator) Self {
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

            return self;
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

                    const decls = switch (@typeInfo(T)) {
                        .@"struct" => |info| info.decls,
                        .@"union" => |info| info.decls,
                        else => @compileError("Expected struct or union type"),
                    };

                    inline for (decls) |decl| {
                        try self.add_names(@field(what, decl.name), .{
                            .prefix = prefix,
                            .name = decl.name,
                            .suffix = suffix,
                        });
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
                    .array, .pointer => inline for (0.., what) |i, elem| {
                        try self.add_names(elem, .{
                            .prefix = options.prefix,
                            .name = std.fmt.comptimePrint("{s}[{}]", .{ options.name, i }),
                            .suffix = options.suffix,
                        });
                    },
                    else => @compileError("Unexpected type: " ++ @typeName(T) ++ " for " ++ options.prefix ++ options.name ++ options.suffix), 
                },
            }
        }

        pub fn add_glb_name(self: *Self, glb: GLB_Index, name: []const u8) !void {
            if (self.glb_names.contains(glb)) return error.AlreadyNamed;
            if (self.glb_lookup.contains(name)) return error.DuplicateName;

            try self.glb_names.ensureUnusedCapacity(self.gpa, 1);
            try self.glb_lookup.ensureUnusedCapacity(self.gpa, 1);

            self.glb_names.putAssumeCapacityNoClobber(glb, name);
            self.glb_lookup.putAssumeCapacityNoClobber(name, glb);
        }

        pub fn add_mc_name(self: *Self, mc: MC_Ref, name: []const u8) !void {
            if (self.macrocell_names.contains(mc)) return error.AlreadyNamed;
            if (self.macrocell_lookup.contains(name)) return error.DuplicateName;

            try self.macrocell_names.ensureUnusedCapacity(self.gpa, 1);
            try self.macrocell_lookup.ensureUnusedCapacity(self.gpa, 1);

            self.macrocell_names.putAssumeCapacityNoClobber(mc, name);
            self.macrocell_lookup.putAssumeCapacityNoClobber(name, mc);
        }

        pub fn add_signal_name(self: *Self, signal: Signal, name: []const u8) !void {
            if (self.signal_names.contains(signal)) return error.AlreadyNamed;
            if (self.signal_lookup.contains(name)) return error.DuplicateName;

            try self.signal_names.ensureUnusedCapacity(self.gpa, 1);
            try self.signal_lookup.ensureUnusedCapacity(self.gpa, 1);

            self.signal_names.putAssumeCapacityNoClobber(signal, name);
            self.signal_lookup.putAssumeCapacityNoClobber(name, signal);
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
                return name;
            }

            if (Signal.maybe_mc_pad(mc)) |signal| {
                if (self.signal_names.get(signal)) |name| {
                    return name;
                }
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
                if (signal.maybe_mc()) |mcref| {
                    return mcref;
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
    };
}

const GLB_Index = lc4k.GLB_Index;
const MC_Ref = lc4k.MC_Ref;
const device = @import("device.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
