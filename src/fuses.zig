pub fn get_pt_range(comptime Device: type, glb: usize, glb_pt_offset: usize) Fuse_Range {
    return Device.get_glb_range(glb).sub_columns(glb_pt_offset, 1).sub_rows(0, Device.num_gis_per_glb * 2);
}

pub fn get_shared_clock_polarity_range(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2;
    return Device.get_glb_range(glb).sub_rows(starting_row, 1).sub_columns(82, 1);
}

pub fn get_shared_enable_to_oe_bus_range(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2 + 1;
    return Device.get_glb_range(glb).sub_rows(starting_row, Device.oe_bus_size).sub_columns(82, 1);
}

pub fn get_shared_init_polarity_range(comptime Device: type, glb: usize) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2 + 1 + Device.oe_bus_size;
    return Device.get_glb_range(glb).sub_rows(starting_row, 1).sub_columns(82, 1);
}

pub fn get_macrocell_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    const starting_row = Device.num_gis_per_glb * 2;
    const range = Device.get_glb_range(mcref.glb).sub_rows(starting_row, Device.jedec_dimensions.height() - starting_row);
    return switch (@as(u1, @truncate(mcref.mc))) {
        0 => range.sub_columns(mcref.mc * 5 + 4, 1),
        1 => range.sub_columns(mcref.mc * 5, 1)
    };
}

pub fn get_macrocell_range_without_io(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(0, 17);
}

// N.B. does not include PGDF bits; use get_power_guard_range for Device.family == .zero_power_enhanced
pub fn get_io_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) return null;
        return get_macrocell_range(Device, mcref).sub_rows(17, 6).expand_columns(1);
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(17, 11);
    }
}

pub fn get_pt0_xor_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(0, 1);
}

pub fn get_invert_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(1, 1);
}

pub fn get_cluster_routing_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(2, 2);
}

pub fn get_clock_source_range_low(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(4, 2);
}

pub fn get_clock_source_range_high(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(9, 1);
}

pub fn get_init_state_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(6, 1);
}

pub fn get_macrocell_function_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(7, 2);
}

pub fn get_async_trigger_source_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(10, 1);
}

pub fn get_init_source_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(11, 1);
}

pub fn get_pt4_output_enable_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(12, 1);
}

pub fn get_input_bypass_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(13, 1);
}

pub fn get_clock_enable_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(14, 2);
}

pub fn get_wide_routing_range(comptime Device: type, mcref: MC_Ref) Fuse_Range {
    return get_macrocell_range(Device, mcref).sub_rows(16, 1);
}

pub fn get_output_routing_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95 and (mcref.mc & 1) == 1) {
        return null;
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(17, 3);
    }
}

pub fn get_output_routing_mode_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.family == .zero_power_enhanced) {
        return null;
    } else if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return get_macrocell_range(Device, mcref).expand_columns(1).sub_rows(20, 1);
        }
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(23, 2);
    }
}

pub fn get_output_enable_source_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return get_macrocell_range(Device, mcref).expand_columns(1).sub_columns(1, 1).sub_rows(17, 3);
        }
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(20, 3);
    }
}

pub fn get_bus_maintenance_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.family != .zero_power_enhanced) return null;
    std.debug.assert(Device.jedec_dimensions.height() != 95);
    return get_macrocell_range(Device, mcref).sub_rows(23, 2);
}

pub fn get_slew_rate_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return get_macrocell_range(Device, mcref).expand_columns(1).sub_columns(1, 1).sub_rows(21, 1);
        }
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(25, 1);
    }
}

pub fn get_drive_type_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return get_macrocell_range(Device, mcref).sub_rows(21, 1);
        }
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(26, 1);
    }
}

pub fn get_input_threshold_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.jedec_dimensions.height() == 95) {
        if ((mcref.mc & 1) == 1) {
            return null;
        } else {
            return get_macrocell_range(Device, mcref).sub_rows(22, 1);
        }
    } else {
        return get_macrocell_range(Device, mcref).sub_rows(27, 1);
    }
}

pub fn get_power_guard_range(comptime Device: type, mcref: MC_Ref) ?Fuse_Range {
    if (Device.family != .zero_power_enhanced) return null;
    const range = Device.get_glb_range(mcref.glb).sub_rows(Device.jedec_dimensions.max.row, 1);
    return range.sub_columns(mcref.mc * 5 + 3, 1);
}

const MC_Ref = lc4k.MC_Ref;
const Fuse_Range = @import("Fuse_Range.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
