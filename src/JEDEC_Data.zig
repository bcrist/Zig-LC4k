extents: Fuse_Range,
raw: std.DynamicBitSetUnmanaged,

pub fn init(allocator: std.mem.Allocator, extents: Fuse_Range, default: u1) error{OutOfMemory}!JEDEC_Data {
    return if (default == 0) init_empty(allocator, extents) else init_full(allocator, extents);
}

pub fn init_empty(allocator: std.mem.Allocator, extents: Fuse_Range) error{OutOfMemory}!JEDEC_Data {
    return JEDEC_Data {
        .extents = extents,
        .raw = try std.DynamicBitSetUnmanaged.initEmpty(allocator, extents.count()),
    };
}

pub fn init_full(allocator: std.mem.Allocator, extents: Fuse_Range) error{OutOfMemory}!JEDEC_Data {
    return JEDEC_Data {
        .extents = extents,
        .raw = try std.DynamicBitSetUnmanaged.initFull(allocator, extents.count()),
    };
}

pub fn init_diff(allocator: std.mem.Allocator, a: JEDEC_Data, b: JEDEC_Data) !JEDEC_Data {
    std.debug.assert(a.extents.eql(b.extents));

    var result = try a.clone(allocator, a.extents);
    result.raw.toggleSet(b.raw);
    return result;
}

pub fn deinit(self: *JEDEC_Data) void {
    self.raw.deinit();
    self.extents = Fuse_Range.init_empty();
}

pub fn clone(self: JEDEC_Data, allocator: std.mem.Allocator, range: Fuse_Range) error{OutOfMemory}!JEDEC_Data {
    if (self.extents.eql(range)) {
        return JEDEC_Data {
            .extents = self.extents,
            .raw = try self.raw.clone(allocator),
        };
    } else {
        var new = try init_empty(allocator, range);
        new.copy_range(self, range);
        return new;
    }
}

pub fn is_set(self: JEDEC_Data, fuse: Fuse) bool {
    std.debug.assert(self.extents.contains(fuse));
    return self.raw.isSet(fuse.to_offset(self));
}

pub fn get(self: JEDEC_Data, fuse: Fuse) u1 {
    std.debug.assert(self.extents.contains(fuse));
    return @intFromBool(self.raw.isSet(fuse.to_offset(self)));
}

pub fn put(self: *JEDEC_Data, fuse: Fuse, val: u1) void {
    std.debug.assert(self.extents.contains(fuse));
    self.raw.setValue(fuse.to_offset(self), val != 0);
}

pub fn put_range(self: *JEDEC_Data, range: Fuse_Range, val: u1) void {
    std.debug.assert(self.extents.contains_range(range));
    var iter = range.iterator();
    while (iter.next()) |fuse| {
        self.put(fuse, val);
    }
}

pub fn copy_range(self: *JEDEC_Data, other: JEDEC_Data, range: Fuse_Range) void {
    std.debug.assert(self.extents.contains_range(range));
    std.debug.assert(other.extents.contains_range(range));

    var iter = range.iterator();
    while (iter.next()) |fuse| {
        self.put(fuse, other.get(fuse));
    }
}

pub fn union_all(self: *JEDEC_Data, other: JEDEC_Data) void {
    self.union_range(other, other.extents);
}

pub fn union_diff(self: *JEDEC_Data, a: JEDEC_Data, b: JEDEC_Data) void {
    std.debug.assert(a.extents.eql(b.extents));
    if (self.extents.eql(a.extents)) {
        const MaskInt = @TypeOf(self.raw.masks[0]);
        const num_masks = (self.raw.bit_length + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);
        for (self.raw.masks[0..num_masks], 0..) |*mask, i| {
            mask.* |= a.raw.masks[i] ^ b.raw.masks[i];
        }
    } else {
        std.debug.assert(self.extents.contains_range(a.extents));
        var iter = a.extents.iterator();
        while (iter.next()) |fuse| {
            if (0 != (a.get(fuse) ^ b.get(fuse))) {
                self.put(fuse, 1);
            }
        }
    }
}

pub fn union_range(self: JEDEC_Data, other: JEDEC_Data, range: Fuse_Range) void {
    if (self.extents.eql(range) and other.extents.eql(range)) {
        self.raw.setUnion(other.raw);
    } else {
        std.debug.assert(self.extents.contains_range(range));
        std.debug.assert(other.extents.contains_range(range));
        var iter = range.iterator();
        while (iter.next()) |fuse| {
            if (other.is_set(fuse)) {
                self.put(fuse, 1);
            }
        }
    }
}

pub fn count_set(self: JEDEC_Data) usize {
    return self.raw.count();
}

pub fn count_unset(self: JEDEC_Data) usize {
    return self.extents.count() - self.raw.count();
}

pub fn count_set_in_range(self: JEDEC_Data, range: Fuse_Range) usize {
    std.debug.assert(self.extents.contains_range(range));
    var iter = range.iterator();
    var count: usize = 0;
    while (iter.next()) |fuse| {
        if (self.is_set(fuse)) {
            count += 1;
        }
    }
    return count;
}

pub fn count_unset_in_range(self: JEDEC_Data, range: Fuse_Range) usize {
    std.debug.assert(self.extents.contains_range(range));
    var iter = range.iterator();
    var count: usize = 0;
    while (iter.next()) |fuse| {
        if (!self.is_set(fuse)) {
            count += 1;
        }
    }
    return count;
}

pub fn iterator(self: JEDEC_Data, comptime options: std.bit_set.IteratorOptions) Iterator(options) {
    return .{
        .raw = self.raw.iterator(options),
        .extents = self.extents,
    };
}

pub fn Iterator(comptime options: std.bit_set.IteratorOptions) type {
    return struct {
        raw: std.DynamicBitSetUnmanaged.Iterator(options),
        extents: Fuse_Range,

        const Self = @This();

        pub fn next(self: *Self) ?Fuse {
            if (self.raw.next()) |offset| {
                return Fuse.from_offset(offset, self.extents);
            } else {
                return null;
            }
        }
    };
}

pub fn checksum(self: JEDEC_Data) u16 {
    var sum: u16 = 0;

    const MaskInt = std.DynamicBitSetUnmanaged.MaskInt;
    var masks: []MaskInt = undefined;
    masks.ptr = self.raw.masks;
    masks.len = (self.raw.bit_length + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);

    for (masks) |mask| {
        var x = mask;
        comptime var i = 0;
        inline while (i < @sizeOf(MaskInt)) : (i += 1) {
            sum +%= @as(u8, @truncate(x));
            x = x >> 8;
        }
    }

    return sum;
}

const JEDEC_Data = @This();

const Fuse = @import("Fuse.zig");
const Fuse_Range = @import("Fuse_Range.zig");
const device = @import("device.zig");
const std = @import("std");
