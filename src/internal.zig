const std = @import("std");
const lc4k = @import("lc4k.zig");

pub fn invertGIMapping(
    comptime GRP: type,
    comptime gi_mux_size: comptime_int,
    comptime mapping: []const[gi_mux_size]GRP
) std.EnumMap(GRP, []const u8) { comptime {
    @setEvalBranchQuota(10_000);
    var results = std.EnumMap(GRP, []const u8) {};
    for (mapping, 0..) |options, gi| {
        for (options) |grp| {
            results.put(grp, (results.get(grp) orelse &[_]u8 {}) ++ [_]u8 { gi });
        }
    }
    return results;
}}

pub fn getMC_Ref(comptime GRP: type, comptime which: anytype) lc4k.MC_Ref { comptime {
    const T = @TypeOf(which);
    const name: []const u8 = switch (T) {
        lc4k.MC_Ref => return which,
        lc4k.Pin_Info => return which.mc_ref().?,
        GRP => @tagName(which),
        else => switch (@typeInfo(T)) {
            .EnumLiteral => @tagName(which),
            else => @compileError("Could not parse macrocell reference from " ++ @typeName(T)),
        },
    };

    if (name.len >= 5 and (std.mem.startsWith(u8, name, "mc_") or std.mem.startsWith(u8, name, "io_"))) {
        const glb = name[3] - 'A';
        const mc = std.fmt.parseUnsigned(lc4k.MC_Index, name[4..], 10) catch unreachable;
        return .{ .glb = glb, .mc = mc };
    }
}}

pub fn getGLB_Index(comptime Device: type, comptime which: anytype) lc4k.GLB_Index { comptime {
    const T = @TypeOf(which);
    const ordinal: usize = @intFromEnum(switch (T) {
        lc4k.MC_Ref => return which.glb,
        lc4k.Pin_Info => return which.glb.?,
        Device.GRP => which,
        else => std.enums.nameCast(Device.GRP, which),
    });

    for (Device.all_pins) |pin| {
        if (pin.grp_ordinal) |pin_ordinal| {
            if (ordinal == pin_ordinal) {
                return pin.glb.?;
            }
        }
    }
}}

pub fn getGrp(comptime GRP: type, comptime which: anytype) GRP { comptime {
    return switch (@TypeOf(which)) {
        lc4k.MC_Ref => @field(GRP, std.fmt.comptimePrint("mc_{s}{}", .{
            lc4k.get_glb_name(which.glb),
            which.mc,
        })),
        lc4k.Pin_Info => @enumFromInt(which.grp_ordinal.?),
        else => std.enums.nameCast(GRP, which),
    };
}}

pub fn getGrpInput(comptime GRP: type, comptime which: anytype) GRP { comptime {
    switch (@TypeOf(which)) {
        lc4k.MC_Ref => return @field(GRP, std.fmt.comptimePrint("io_{s}{}", .{
            lc4k.get_glb_name(which.glb),
            which.mc,
        })),
        lc4k.Pin_Info => return @field(GRP, std.fmt.comptimePrint("io_{s}{}", .{
            lc4k.get_glb_name(which.glb.?),
            switch (which.func) {
                .io, .io_oe0, .io_oe1 => |mc| mc,
                else => unreachable,
            },
        })),
        else => {
            const grp = std.enums.nameCast(GRP, which);
            if (std.mem.startsWith(u8, @tagName(grp), "mc_")) {
                return @field(GRP, "io_" ++ @tagName(grp)[3..]);
            } else {
                return grp;
            }
        },
    }
}}

pub fn getGrpFeedback(comptime GRP: type, comptime which: anytype) GRP { comptime {
    switch (@TypeOf(which)) {
        lc4k.MC_Ref => return @field(GRP, std.fmt.comptimePrint("mc_{s}{}", .{
            lc4k.get_glb_name(which.glb),
            which.mc,
        })),
        lc4k.Pin_Info => return @field(GRP, std.fmt.comptimePrint("mc_{s}{}", .{
            lc4k.get_glb_name(which.glb.?),
            switch (which.func) {
                .io, .io_oe0, .io_oe1 => |mc| mc,
                else => unreachable,
            },
        })),
        else => {
            const grp = std.enums.nameCast(GRP, which);
            if (std.mem.startsWith(u8, @tagName(grp), "mc_")) {
                return which;
            } else if (std.mem.startsWith(u8, @tagName(grp), "io_")) {
                return @field(GRP, "mc_" ++ @tagName(grp)[3..]);
            } else {
                unreachable;
            }
        },
    }
}}

pub fn getPin(comptime Device: type, comptime which: anytype) lc4k.Pin_Info { comptime {
    const T = @TypeOf(which);
    switch (T) {
        lc4k.MC_Ref => {
            for (Device.all_pins) |pin| {
                switch (pin.func) {
                    .io, .io_oe0, .io_oe1 => |mc| if (mc == which.mc and pin.glb.? == which.glb) return pin,
                    else => {},
                }
            }
            unreachable;
        },
        lc4k.Pin_Info => return which,
        else => {
            const ordinal = @intFromEnum(std.enums.nameCast(Device.GRP, which));
            for (Device.all_pins) |pin| {
                if (pin.grp_ordinal) |pin_ordinal| {
                    if (ordinal == pin_ordinal) return pin;
                }
            }
            unreachable;
        },
    }
}}

pub fn getSpecialPT(
    comptime Device: type, 
    mc_config: lc4k.Macrocell_Config(Device.family, Device.GRP),
    pt_index: usize
) ?lc4k.PT(Device.GRP) {
    return switch (pt_index) {
        0 => switch (mc_config.logic) {
            .pt0, .pt0_inverted => |pt| pt,
            .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| logic.pt0,
            .sum, .sum_inverted, .input_buffer => null,
        },
        1 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.clock) {
                .none, .shared_pt_clock, .bclock => null,
                .pt1_positive, .pt1_negative => |pt| pt,
            },
        },
        2 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.ce) {
                .always_active, .shared_pt_clock => switch (reg_config.async_source) {
                    .none => null,
                    .pt2_active_high => |pt| pt,
                },
                .pt2_active_low, .pt2_active_high => |pt| pt,
            },
        },
        3 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.init_source) {
                .shared_pt_init => null,
                .pt3_active_high => |pt| pt,
            },
        },
        4 => if (mc_config.pt4_oe) |pt| pt else null,
        else => unreachable,
    };
}

pub fn isAlways(pt: anytype) bool {
    for (pt) |factor| {
        if (factor != .always) return false;
    }
    return true;
}

pub fn isNever(pt: anytype) bool {
    for (pt) |factor| {
        if (factor == .never) return true;
    }
    return false;
}

pub fn isSumAlways(pts: anytype) bool {
    for (pts) |pt| {
        if (isAlways(pt)) return true;
    }
    return false;
}
