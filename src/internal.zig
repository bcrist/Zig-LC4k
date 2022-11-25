const std = @import("std");

// pub fn invertGIMapping(
//     comptime GRP: type,
//     comptime gi_mux_size: comptime_int,
//     comptime mapping: []const[gi_mux_size]GRP
// ) [@typeInfo(GRP).Enum.fields.len][]const u8 { comptime {
//     const num_grp_signals = @typeInfo(GRP).Enum.fields.len;
//     var results = [_][]const u8 { &.{} } ** num_grp_signals;
//     for (mapping) |options, gi| {
//         for (options) |grp| {
//             const ordinal = @enumToInt(grp);
//             results[ordinal] = results[ordinal] ++ [_]u8 { gi };
//         }
//     }
//     return results;
// }}

pub fn invertGIMapping(
    comptime GRP: type,
    comptime gi_mux_size: comptime_int,
    comptime mapping: []const[gi_mux_size]GRP
) std.EnumMap(GRP, []const u8) { comptime {
    var results = std.EnumMap(GRP, []const u8) {};
    for (mapping) |options, gi| {
        for (options) |grp| {
            results.put(grp, results.get(grp) ++ [_]u8 { gi });
        }
    }
    return results;
}}