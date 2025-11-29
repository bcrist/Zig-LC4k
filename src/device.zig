pub const Family = enum {
    low_power, // V/B/C suffix
    zero_power, // ZC suffix
    zero_power_enhanced, // ZE suffix
};

pub const Package = enum {
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
    BMC149, // a custom adapter that allows use of csBGA132 devices with more affordable board types (1mm pitch sparse BGA)
};

pub const Type = enum {
    //[[!! include 'devices'
    // for device in spairs(devices) do
    //     write(device, ',', nl)
    // end
    // writeln(nl, 'pub fn get(comptime self: Type) type {', indent)
    // write('return switch(self) {', indent)
    // for device in spairs(devices) do
    //     write(nl, '.', device, ' => @import("device/', device, '.zig"),')
    // end
    // writeln(unindent, nl, '};', unindent, nl, '}')
    //!! 65 ]]
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
    LC4128ZC_BMC149,
    LC4128ZC_TQFP100,
    LC4128ZC_csBGA132,
    LC4128ZE_TQFP100,
    LC4128ZE_TQFP144,
    LC4128ZE_csBGA144,
    LC4128ZE_ucBGA132,
    LC4128x_TQFP100,
    LC4128x_TQFP128,

    pub fn get(comptime self: Type) type {
        return switch(self) {
            .LC4032ZC_TQFP48 => @import("device/LC4032ZC_TQFP48.zig"),
            .LC4032ZC_csBGA56 => @import("device/LC4032ZC_csBGA56.zig"),
            .LC4032ZE_TQFP48 => @import("device/LC4032ZE_TQFP48.zig"),
            .LC4032ZE_csBGA64 => @import("device/LC4032ZE_csBGA64.zig"),
            .LC4032x_TQFP44 => @import("device/LC4032x_TQFP44.zig"),
            .LC4032x_TQFP48 => @import("device/LC4032x_TQFP48.zig"),
            .LC4064ZC_TQFP100 => @import("device/LC4064ZC_TQFP100.zig"),
            .LC4064ZC_TQFP48 => @import("device/LC4064ZC_TQFP48.zig"),
            .LC4064ZC_csBGA132 => @import("device/LC4064ZC_csBGA132.zig"),
            .LC4064ZC_csBGA56 => @import("device/LC4064ZC_csBGA56.zig"),
            .LC4064ZE_TQFP100 => @import("device/LC4064ZE_TQFP100.zig"),
            .LC4064ZE_TQFP48 => @import("device/LC4064ZE_TQFP48.zig"),
            .LC4064ZE_csBGA144 => @import("device/LC4064ZE_csBGA144.zig"),
            .LC4064ZE_csBGA64 => @import("device/LC4064ZE_csBGA64.zig"),
            .LC4064ZE_ucBGA64 => @import("device/LC4064ZE_ucBGA64.zig"),
            .LC4064x_TQFP100 => @import("device/LC4064x_TQFP100.zig"),
            .LC4064x_TQFP44 => @import("device/LC4064x_TQFP44.zig"),
            .LC4064x_TQFP48 => @import("device/LC4064x_TQFP48.zig"),
            .LC4128V_TQFP144 => @import("device/LC4128V_TQFP144.zig"),
            .LC4128ZC_BMC149 => @import("device/LC4128ZC_BMC149.zig"),
            .LC4128ZC_TQFP100 => @import("device/LC4128ZC_TQFP100.zig"),
            .LC4128ZC_csBGA132 => @import("device/LC4128ZC_csBGA132.zig"),
            .LC4128ZE_TQFP100 => @import("device/LC4128ZE_TQFP100.zig"),
            .LC4128ZE_TQFP144 => @import("device/LC4128ZE_TQFP144.zig"),
            .LC4128ZE_csBGA144 => @import("device/LC4128ZE_csBGA144.zig"),
            .LC4128ZE_ucBGA132 => @import("device/LC4128ZE_ucBGA132.zig"),
            .LC4128x_TQFP100 => @import("device/LC4128x_TQFP100.zig"),
            .LC4128x_TQFP128 => @import("device/LC4128x_TQFP128.zig"),
        };
    }

    //[[ ######################### END OF GENERATED CODE ######################### ]]

    pub fn parse(name: []const u8) ?Type {
        for (std.enums.values(Type)) |e| {
            if (std.mem.eql(u8, name, @tagName(e))) {
                return e;
            }
        }
        return null;
    }
};

const std = @import("std");
