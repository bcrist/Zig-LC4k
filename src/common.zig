const std = @import("std");

pub const DeviceFamily = enum {
    low_power, // V/B/C suffix
    zero_power, // ZC suffix
    zero_power_enhanced, // ZE suffix
};

pub const DevicePackage = enum {
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

pub const DeviceType = enum {
    //[[!! include 'devices'
    // for device in spairs(devices) do
    //     write(device, ',', nl)
    // end
    // writeln(nl, 'pub fn get(comptime self: DeviceType) type {', indent)
    // write('return switch(self) {', indent)
    // for device in spairs(devices) do
    //     write(nl, '.', device, ' => @import("', device, '.zig"),')
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

    pub fn get(comptime self: DeviceType) type {
        return switch(self) {
            .LC4032ZC_TQFP48 => @import("LC4032ZC_TQFP48.zig"),
            .LC4032ZC_csBGA56 => @import("LC4032ZC_csBGA56.zig"),
            .LC4032ZE_TQFP48 => @import("LC4032ZE_TQFP48.zig"),
            .LC4032ZE_csBGA64 => @import("LC4032ZE_csBGA64.zig"),
            .LC4032x_TQFP44 => @import("LC4032x_TQFP44.zig"),
            .LC4032x_TQFP48 => @import("LC4032x_TQFP48.zig"),
            .LC4064ZC_TQFP100 => @import("LC4064ZC_TQFP100.zig"),
            .LC4064ZC_TQFP48 => @import("LC4064ZC_TQFP48.zig"),
            .LC4064ZC_csBGA132 => @import("LC4064ZC_csBGA132.zig"),
            .LC4064ZC_csBGA56 => @import("LC4064ZC_csBGA56.zig"),
            .LC4064ZE_TQFP100 => @import("LC4064ZE_TQFP100.zig"),
            .LC4064ZE_TQFP48 => @import("LC4064ZE_TQFP48.zig"),
            .LC4064ZE_csBGA144 => @import("LC4064ZE_csBGA144.zig"),
            .LC4064ZE_csBGA64 => @import("LC4064ZE_csBGA64.zig"),
            .LC4064ZE_ucBGA64 => @import("LC4064ZE_ucBGA64.zig"),
            .LC4064x_TQFP100 => @import("LC4064x_TQFP100.zig"),
            .LC4064x_TQFP44 => @import("LC4064x_TQFP44.zig"),
            .LC4064x_TQFP48 => @import("LC4064x_TQFP48.zig"),
            .LC4128V_TQFP144 => @import("LC4128V_TQFP144.zig"),
            .LC4128ZC_TQFP100 => @import("LC4128ZC_TQFP100.zig"),
            .LC4128ZC_csBGA132 => @import("LC4128ZC_csBGA132.zig"),
            .LC4128ZE_TQFP100 => @import("LC4128ZE_TQFP100.zig"),
            .LC4128ZE_TQFP144 => @import("LC4128ZE_TQFP144.zig"),
            .LC4128ZE_csBGA144 => @import("LC4128ZE_csBGA144.zig"),
            .LC4128ZE_ucBGA132 => @import("LC4128ZE_ucBGA132.zig"),
            .LC4128x_TQFP100 => @import("LC4128x_TQFP100.zig"),
            .LC4128x_TQFP128 => @import("LC4128x_TQFP128.zig"),
        };
    }

    //[[ ######################### END OF GENERATED CODE ######################### ]]

    pub fn parse(name: []const u8) ?DeviceType {
        for (std.enums.values(DeviceType)) |e| {
            if (std.mem.eql(u8, name, @tagName(e))) {
                return e;
            }
        }
        return null;
    }
};

pub const GlbIndex = u8;
pub const MacrocellIndex = u8;
pub const ClockIndex = u8;

pub const MacrocellRef = struct {
    glb: GlbIndex,
    mc: MacrocellIndex,
};

pub const PinFunction = union(enum) {
    io: MacrocellIndex,
    io_oe0: MacrocellIndex,
    io_oe1: MacrocellIndex,
    input,
    clock: ClockIndex,
    no_connect,
    gnd,
    vcc_core,
    vcco,
    tck,
    tms,
    tdi,
    tdo,
};

pub const PinInfo = struct {
    id: []const u8, // pin number or ball location
    func: PinFunction,
    glb: ?GlbIndex = null, // only meaningful when func is io, io_oe0, io_oe1, input, or clock
    grp_ordinal: ?u16 = null, // use with @intToEnum(GRP, grp_ordinal)

    pub fn mcRef(self: PinInfo) ?MacrocellRef {
        return if (self.glb) |glb| switch (self.func) {
            .io, .io_oe0, .io_oe1 => |mc| MacrocellRef { .glb = glb, .mc = mc },
            else => null,
        } else null;
    }
};

pub const BusMaintenance = enum {
    float,
    pulldown,
    pullup,
    keeper,
};

pub const InputThreshold = enum {
    low,  // for 1.5V or 1.8V signals
    high, // for 2.5V or 3.3V signals
};

pub const DriveType = enum {
    push_pull,
    open_drain,
};

pub const SlewRate = enum {
    slow,
    fast,
};

pub const OutputEnableMode = enum {
    goe0,
    goe1,
    goe2,
    goe3,
    from_orm_active_low,
    from_orm_active_high,
    output_only,
    input_only,
};

pub const PowerGuard = enum {
    from_bie,
    disabled,
};

pub const TimerDivisor = enum(u32) {
    div128 = 128,
    div1024 = 1024,
    div1048576 = 1048576,
};

pub const MacrocellFunction = enum {
    combinational,
    latch,
    t_ff,
    d_ff,
};


