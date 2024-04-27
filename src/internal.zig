const std = @import("std");
const lc4k = @import("lc4k.zig");

pub fn getSpecialPT(
    comptime Device: type, 
    mc_config: lc4k.Macrocell_Config(Device.family, Device.GRP),
    pt_index: usize
) ?lc4k.Product_Term(Device.GRP) {
    return switch (pt_index) {
        0 => switch (mc_config.logic) {
            .pt0, .pt0_inverted => |pt| pt,
            .sum_xor_pt0, .sum_xor_pt0_inverted => |logic| logic.pt0,
            .sum, .sum_inverted, .sum_xor_input_buffer, .input_buffer => null,
        },
        1 => switch (mc_config.func) {
            .combinational => null,
            .latch, .t_ff, .d_ff => |reg_config| switch (reg_config.clock) {
                .none, .shared_pt_clock, .bclock0, .bclock1, .bclock2, .bclock3 => null,
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

pub fn isSumAlways(pts: anytype) bool {
    for (pts) |pt| {
        if (pt.is_always()) return true;
    }
    return false;
}
