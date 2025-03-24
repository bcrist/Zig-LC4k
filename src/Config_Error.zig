err: anyerror,
details: []const u8,
fuse: ?lc4k.Fuse = null,
gi: ?lc4k.GI_Index = null,
glb: ?lc4k.GLB_Index = null,
mc: ?lc4k.MC_Index = null,
// mc_pt: ?u8 = null,
signal_ordinal: ?u16 = null,

const lc4k = @import("lc4k.zig");