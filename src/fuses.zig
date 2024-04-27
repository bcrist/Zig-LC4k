pub fn getPTRange(comptime Device: type, glb: usize, glb_pt_offset: usize) Fuse_Range {
    return Device.get_glb_range(glb).subColumns(glb_pt_offset, 1).subRows(0, Device.num_gis_per_glb * 2);
}

pub fn getSharedClockPolarityRange(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2;
    return Device.get_glb_range(glb).subRows(starting_row, 1).subColumns(82, 1);
}

pub fn getSharedEnableToOEBusRange(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2 + 1;
    return Device.get_glb_range(glb).subRows(starting_row, Device.oe_bus_size).subColumns(82, 1);
}

pub fn getSharedInitPolarityRange(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2 + 1 + Device.oe_bus_size;
    return Device.get_glb_range(glb).subRows(starting_row, 1).subColumns(82, 1);
}

pub fn getMacrocellRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2;
    const range = Device.get_glb_range(mcref.glb).subRows(starting_row, Device.jedec_dimensions.height() - starting_row);
    return switch (@as(u1, @truncate(mcref.mc))) {
        0 => range.subColumns(mcref.mc * 5 + 4, 1),
        1 => range.subColumns(mcref.mc * 5, 1)
    };
}

pub fn getPT0XorRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(0, 1);
}

pub fn getInvertRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(1, 1);
}

pub fn getCluster_RoutingRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(2, 2);
}

pub fn getClockSourceLowRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(4, 2);
}

pub fn getInitStateRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(6, 1);
}

pub fn getMcFuncRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(7, 2);
}

pub fn getClockSourceHighRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(9, 1);
}

pub fn getAsyncSourceRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(10, 1);
}

pub fn getInitSourceRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(11, 1);
}

pub fn getPT4OERange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(12, 1);
}

pub fn getInputBypassRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(13, 1);
}

pub fn getCERange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(14, 2);
}

pub fn getWide_RoutingRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return getMacrocellRange(Device, mcref).subRows(16, 1);
}

pub fn getOutput_RoutingRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95 and (mcref.mc & 1) == 1) {
        return null;
    } else {
        return getMacrocellRange(Device, mcref).subRows(17, 3);
    }
}

pub fn getOutput_Routing_ModeRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.family == .zero_power_enhanced) {
        return null;
    } else if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subRows(20, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(23, 2);
    }
}

pub fn getOESourceRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subColumns(1, 1).subRows(17, 3);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(20, 3);
    }
}

pub fn getBus_MaintenanceRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    std.debug.assert(Device.family == .zero_power_enhanced);
    return getMacrocellRange(Device, mcref).subRows(23, 2);
}

pub fn getSlew_RateRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).expandColumns(1).subColumns(1, 1).subRows(21, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(25, 1);
    }
}

pub fn getDrive_TypeRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).subRows(21, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(26, 1);
    }
}

pub fn getInput_ThresholdRange(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return getMacrocellRange(Device, mcref).subRows(22, 1);
        }
    } else {
        return getMacrocellRange(Device, mcref).subRows(27, 1);
    }
}

pub fn getPower_GuardRange(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    std.debug.assert(Device.family == .zero_power_enhanced);
    const range = Device.get_glb_range(mcref.glb).subRows(Device.jedec_dimensions.max.row, 1);
    return range.subColumns(mcref.mc * 5 + 3, 1);
}

const MC_Ref = lc4k.MC_Ref;
const Fuse_Range = @import("Fuse_Range.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
