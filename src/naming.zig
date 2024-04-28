pub fn Names(comptime GRP: type) type {
    return struct {
        gpa: std.mem.Allocator,
        fallback: ?*Self,

        glb_names: std.AutoHashMapUnmanaged(GLB_Index, []const u8) = .{},
        glb_lookup: std.StringHashMapUnmanaged(GLB_Index) = .{},

        macrocell_names: std.AutoHashMapUnmanaged(MC_Ref, []const u8) = .{},
        macrocell_lookup: std.StringHashMapUnmanaged(MC_Ref) = .{},

        signal_names: std.AutoHashMapUnmanaged(GRP, []const u8) = .{},
        signal_lookup: std.StringHashMapUnmanaged(GRP) = .{},

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator, device_type: device.Type) Self {
            return .{
                .gpa = allocator,
                .fallback = &device_type.get().get_names(),
            };
        }

        pub fn init_defaults(allocator: std.mem.Allocator, comptime D: type) Self {
            var self: Self = .{
                .gpa = allocator,
                .fallback = null,
            };

            self.glb_names.ensureTotalCapacity(self.gpa, D.num_glbs) catch unreachable;
            self.glb_lookup.ensureTotalCapacity(self.gpa, D.num_glbs) catch unreachable;

            self.macrocell_names.ensureTotalCapacity(self.gpa, D.num_mcs) catch unreachable;
            self.macrocell_lookup.ensureTotalCapacity(self.gpa, D.num_mcs) catch unreachable;

            self.signal_names.ensureTotalCapacity(self.gpa, @intCast(std.enums.values(D.GRP).len)) catch unreachable;
            self.signal_lookup.ensureTotalCapacity(self.gpa, @intCast(std.enums.values(D.GRP).len)) catch unreachable;

            inline for (0..D.num_glbs) |glb| {
                const glb_name = @tagName(D.GRP.mc_fb(MC_Ref.init(glb, 0)))[3..4];
                self.add_glb_name(@intCast(glb), glb_name) catch unreachable;

                for (0..D.num_mcs_per_glb) |mc| {
                    const mcref = MC_Ref.init(glb, mc);
                    const mc_name = @tagName(D.GRP.mc_fb(mcref))[3..];
                    self.add_mc_name(mcref, mc_name) catch unreachable;
                }
            }

            for (std.enums.values(D.GRP)) |signal| {
                self.add_signal_name(signal, @tagName(signal)) catch unreachable;
            }

            return self;
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

        pub fn add_signal_name(self: *Self, signal: GRP, name: []const u8) !void {
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

            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[glb..glb+1];
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

            if (self.signal_names.get(GRP.mc_fb(mc))) |name| {
                return name;
            }

            if (GRP.maybe_mc_pad(mc)) |signal| {
                if (self.signal_names.get(signal)) |name| {
                    return name;
                }
            }

            if (self.fallback) |fallback| {
                return fallback.get_mc_name(mc);
            }

            return "Unnamed MC";
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

        pub fn get_signal_name(self: Self, signal: GRP) []const u8 {
            if (self.signal_names.get(signal)) |name| {
                return name;
            }

            if (self.fallback) |fallback| {
                return fallback.get_signal_name(signal);
            }

            return @tagName(signal);
        }

        pub fn lookup_signal(self: Self, name: []const u8) ?GRP {
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
