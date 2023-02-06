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

pub const GiIndex = u8;
pub const GlbIndex = u8;
pub const MacrocellIndex = u8;
pub const ClockIndex = u8;

pub const MacrocellRef = struct {
    glb: GlbIndex,
    mc: MacrocellIndex,

    pub fn init(glb: usize, mc: usize) MacrocellRef {
        return .{
            .glb = @intCast(GlbIndex, glb),
            .mc = @intCast(MacrocellIndex, mc),
        };
    }
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

pub const BusMaintenance = enum(u2) {
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
pub const InputThreshold = enum(u1) {
                //   ZE                   C/ZC         B           V
    low = 1,    // 0.50*Vcc             0.50*Vcc    0.36*Vcc    0.28*Vcc
    high = 0,   // 0.68*Vcc (falling)   0.73*Vcc    0.50*Vcc    0.40*Vcc
                // 0.79*Vcc (rising)
};

pub const DriveType = enum(u1) {
    push_pull = 1,
    open_drain = 0,
};

pub const SlewRate = enum(u1) {
    slow = 1,
    fast = 0,
};

pub const OutputEnableMode = enum(u3) {
    goe0 = 0,
    goe1 = 1,
    goe2 = 2,
    goe3 = 3,
    from_orm_active_high = 4,
    from_orm_active_low = 5,
    output_only = 6,
    input_only = 7,
};

pub const PowerGuard = enum(u1) {
    from_bie = 0,
    disabled = 1,
};

pub const TimerDivisor = enum(u2) {
    div128 = 0,
    div1024 = 2,
    div1048576 = 1,
    _
};

pub const MacrocellFunction = enum(u2) {
    combinational = 0,
    latch = 1,
    t_ff = 2,
    d_ff = 3,
};

pub const ClusterRouting = enum(u2) {
    self_minus_two = 0,
    self = 1,
    self_plus_one = 2,
    self_minus_one = 3,
};

pub const WideRouting = enum(u1) {
    self_plus_four = 0,
    self = 1,
};

pub fn getGlbName(glb: usize) []const u8 {
    return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[glb..glb+1];
}
