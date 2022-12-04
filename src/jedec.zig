const std = @import("std");
const common = @import("common.zig");

const DeviceType = common.DeviceType;

pub const Fuse = struct {
    row: usize,
    col: usize,

    pub fn init(row: usize, col: usize) Fuse {
        return .{ .row = row, .col = col };
    }

    pub fn fromOffset(offset: usize, device_or_jedec: anytype) Fuse {
        const range = getRange(device_or_jedec);
        const width = range.width();
        const row = offset / width;
        const col = (offset - row * width);
        return .{
            .row = range.min.row + row,
            .col = range.min.col + col,
        };
    }

    pub fn toOffset(self: Fuse, device_or_jedec: anytype) usize {
        const range = getRange(device_or_jedec);
        const row = self.row - range.min.row;
        const col = self.col - range.min.col;
        return row * range.width() + col;
    }

    fn getRange(device_or_jedec: anytype) FuseRange {
        const T = @TypeOf(device_or_jedec);
        return switch (T) {
            std.builtin.Type => device_or_jedec.jedec_dimensions,
            DeviceType => device_or_jedec.get().jedec_dimensions,
            FuseRange => device_or_jedec,
            JedecData => device_or_jedec.extents,
            else => switch (@typeInfo(T)) {
                .Pointer => |ptr_info| if (ptr_info.size == .One) switch (ptr_info.child) {
                    DeviceType => device_or_jedec.get().jedec_dimensions,
                    FuseRange => device_or_jedec.*,
                    JedecData => device_or_jedec.extents,
                    else => @compileError("Invalid pointer type: " ++ @typeName(T)),
                } else @compileError("Expected a single pointer, not " ++ @typeName(T)),
                else => @compileError("Expected DeviceType, DeviceType.get(), FuseRange, JedecData, or a pointer to such.  Found: " ++ @typeName(T)),
            },
        };
    }

    pub fn eql(self: Fuse, other: Fuse) bool {
        return self.row == other.row and self.col == other.col;
    }
};

pub const FuseRange = struct {
    min: Fuse,
    max: Fuse,

    pub fn init(w: usize, h: usize) FuseRange {
        if (w == 0 or h == 0) {
            return initEmpty();
        }
        return .{
            .min = Fuse.init(0, 0),
            .max = Fuse.init(h - 1, w - 1),
        };
    }

    pub fn initEmpty() FuseRange {
        return .{
            .min = Fuse.init(1, 1),
            .max = Fuse.init(0, 0),
        };
    }

    pub fn fromFuse(fuse: Fuse) FuseRange {
        return .{
            .min = fuse,
            .max = fuse,
        };
    }

    pub fn between(a: Fuse, b: Fuse) FuseRange {
        return .{
            .min = Fuse.init(@min(a.row, b.row), @min(a.col, b.col)),
            .max = Fuse.init(@max(a.row, b.row), @max(a.col, b.col)),
        };
    }

    pub fn intersection(a: FuseRange, b: FuseRange) FuseRange {
        return .{
            .min = Fuse.init(@max(a.min.row, b.min.row), @max(a.min.col, b.min.col)),
            .max = Fuse.init(@min(a.max.row, b.max.row), @min(a.max.col, b.max.col)),
        };
    }

    pub fn expandToContain(self: FuseRange, fuse: Fuse) FuseRange {
        var result = self;
        if (self.isEmpty()) {
            result.min = fuse;
            result.max = fuse;
        } else {
            if (fuse.row < self.min.row) {
                result.min.row = fuse.row;
            } else if (fuse.row > self.max.row) {
                result.max.row = fuse.row;
            }

            if (fuse.col < self.min.col) {
                result.min.col = fuse.col;
            } else if (fuse.col > self.max.col) {
                result.max.col = fuse.col;
            }
        }
        return result;
    }

    pub fn contains(self: FuseRange, fuse: Fuse) bool {
        return fuse.row >= self.min.row and fuse.row <= self.max.row
            and fuse.col >= self.min.col and fuse.col <= self.max.col;
    }

    pub fn containsRange(self: FuseRange, other: FuseRange) bool {
        return other.isEmpty() or self.contains(other.min) and self.contains(other.max);
    }

    pub fn width(self: FuseRange) usize {
        if (self.max.col >= self.min.col) {
            return self.max.col - self.min.col + 1;
        } else {
            return 0;
        }
    }

    pub fn height(self: FuseRange) usize {
        if (self.max.row >= self.min.row) {
            return self.max.row - self.min.row + 1;
        } else {
            return 0;
        }
    }

    pub fn count(self: FuseRange) usize {
        return self.width() * self.height();
    }

    pub fn isEmpty(self: FuseRange) bool {
        return self.max.row < self.min.row or self.max.col < self.min.col;
    }

    pub fn expandColumns(self: FuseRange, num_columns: isize) FuseRange {
        if (num_columns < 0) {
            return FuseRange.between(
                Fuse.init(self.min.row, self.min.col - @intCast(usize, -num_columns)),
                self.max,
            );
        } else {
            return FuseRange.between(
                self.min,
                Fuse.init(self.max.row, self.max.col + @intCast(usize, num_columns)),
            );
        }
    }

    pub fn expandRows(self: FuseRange, num_rows: isize) FuseRange {
        if (num_rows < 0) {
            return FuseRange.between(
                Fuse.init(self.min.row - @intCast(usize, -num_rows), self.min.col),
                self.max,
            );
        } else {
            return FuseRange.between(
                self.min,
                Fuse.init(self.max.row + @intCast(usize, num_rows), self.max.col),
            );
        }
    }

    pub fn subColumns(self: FuseRange, col_offset: usize, num_cols: usize) FuseRange {
        const col = self.min.col + col_offset;
        std.debug.assert(col + num_cols - 1 <= self.max.col);
        return FuseRange.between(
            Fuse.init(self.min.row, col),
            Fuse.init(self.max.row, col + num_cols - 1),
        );
    }

    pub fn subRows(self: FuseRange, row_offset: usize, num_rows: usize) FuseRange {
        const row = self.min.row + row_offset;
        std.debug.assert(row + num_rows - 1 <= self.max.row);
        return FuseRange.between(
            Fuse.init(row, self.min.col),
            Fuse.init(row + num_rows - 1, self.max.col),
        );
    }

    pub fn at(self: FuseRange, row_offset: usize, col_offset: usize) Fuse {
        const row = self.min.row + row_offset;
        const col = self.min.col + col_offset;
        std.debug.assert(row <= self.max.row);
        std.debug.assert(col <= self.max.col);
        return Fuse.init(row, col);
    }

    pub fn iterator(self: FuseRange) Iterator {
        return .{ .range = self, .next_fuse = self.min };
    }

    pub const Iterator = struct {
        range: FuseRange,
        next_fuse: Fuse,

        pub fn next(self: *Iterator) ?Fuse {
            const fuse = self.next_fuse;

            if (fuse.row > self.range.max.row) {
                return null;
            }

            if (fuse.col == self.range.max.col) {
                self.next_fuse.col = self.range.min.col;
                self.next_fuse.row += 1;
            } else {
                self.next_fuse.col += 1;
            }

            return fuse;
        }

        pub fn skip(self: *Iterator, num_fuses: usize) void {
            const first_col = self.range.min.col;
            const w = self.range.width();
            var fuse = self.next_fuse;
            var num_remaining_in_row = self.range.max.col - fuse.col + 1;
            var remaining = num_fuses;
            while (remaining >= num_remaining_in_row) {
                remaining -= num_remaining_in_row;
                fuse.row += 1;
                fuse.col = first_col;
                num_remaining_in_row = w;
            }
            fuse.col += remaining;
            self.next_fuse = fuse;
        }
    };

    pub fn eql(self: FuseRange, other: FuseRange) bool {
        return self.isEmpty() and other.isEmpty()
            or self.min.eql(other.min) and self.max.eql(other.max);
    }
};

pub const JedecData = struct {
    extents: FuseRange,
    raw: std.DynamicBitSetUnmanaged,

    pub fn init(allocator: std.mem.Allocator, extents: FuseRange, default: u1) error{OutOfMemory}!JedecData {
        return if (default == 0) initEmpty(allocator, extents) else initFull(allocator, extents);
    }

    pub fn initEmpty(allocator: std.mem.Allocator, extents: FuseRange) error{OutOfMemory}!JedecData {
        return JedecData {
            .extents = extents,
            .raw = try std.DynamicBitSetUnmanaged.initEmpty(allocator, extents.count()),
        };
    }

    pub fn initFull(allocator: std.mem.Allocator, extents: FuseRange) error{OutOfMemory}!JedecData {
        return JedecData {
            .extents = extents,
            .raw = try std.DynamicBitSetUnmanaged.initFull(allocator, extents.count()),
        };
    }

    pub fn initDiff(allocator: std.mem.Allocator, a: JedecData, b: JedecData) !JedecData {
        std.debug.assert(a.extents.eql(b.extents));

        var result = try a.clone(allocator, a.extents);
        result.raw.toggleSet(b.raw);
        return result;
    }

    pub fn deinit(self: *JedecData) void {
        self.raw.deinit();
        self.extents = FuseRange.initEmpty();
    }

    pub fn clone(self: JedecData, allocator: std.mem.Allocator, range: FuseRange) error{OutOfMemory}!JedecData {
        if (self.extents.eql(range)) {
            return JedecData {
                .extents = self.extents,
                .raw = try self.raw.clone(allocator),
            };
        } else {
            var new = try initEmpty(allocator, range);
            new.copyRange(self, range);
            return new;
        }
    }

    pub fn isSet(self: JedecData, fuse: Fuse) bool {
        std.debug.assert(self.extents.contains(fuse));
        return self.raw.isSet(fuse.toOffset(self));
    }

    pub fn get(self: JedecData, fuse: Fuse) u1 {
        std.debug.assert(self.extents.contains(fuse));
        return @boolToInt(self.raw.isSet(fuse.toOffset(self)));
    }

    pub fn put(self: *JedecData, fuse: Fuse, val: u1) void {
        std.debug.assert(self.extents.contains(fuse));
        self.raw.setValue(fuse.toOffset(self), val != 0);
    }

    pub fn putRange(self: *JedecData, range: FuseRange, val: u1) void {
        std.debug.assert(self.extents.containsRange(range));
        var iter = range.iterator();
        while (iter.next()) |fuse| {
            self.put(fuse, val);
        }
    }

    pub fn copyRange(self: *JedecData, other: JedecData, range: FuseRange) void {
        std.debug.assert(self.extents.containsRange(range));
        std.debug.assert(other.extents.containsRange(range));

        var iter = range.iterator();
        while (iter.next()) |fuse| {
            self.put(fuse, other.get(fuse));
        }
    }

    pub fn unionAll(self: *JedecData, other: JedecData) void {
        self.unionRange(other, other.extents);
    }

    pub fn unionDiff(self: *JedecData, a: JedecData, b: JedecData) void {
        std.debug.assert(a.extents.eql(b.extents));
        if (self.extents.eql(a.extents)) {
            const MaskInt = @TypeOf(self.raw.masks[0]);
            const num_masks = (self.raw.bit_length + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);
            for (self.raw.masks[0..num_masks]) |*mask, i| {
                mask.* |= a.raw.masks[i] ^ b.raw.masks[i];
            }
        } else {
            std.debug.assert(self.extents.containsRange(a.extents));
            var iter = a.extents.iterator();
            while (iter.next()) |fuse| {
                if (0 != (a.get(fuse) ^ b.get(fuse))) {
                    self.put(fuse, 1);
                }
            }
        }
    }

    pub fn unionRange(self: JedecData, other: JedecData, range: FuseRange) void {
        if (self.extents.eql(range) and other.extents.eql(range)) {
            self.raw.setUnion(other.raw);
        } else {
            std.debug.assert(self.getRange().containsRange(range));
            std.debug.assert(other.getRange().containsRange(range));
            var iter = range.iterator();
            while (iter.next()) |fuse| {
                if (other.isSet(fuse)) {
                    self.put(fuse, 1);
                }
            }
        }
    }

    pub fn countSet(self: JedecData) usize {
        return self.raw.count();
    }

    pub fn countUnset(self: JedecData) usize {
        return self.extents.count() - self.raw.count();
    }

    pub fn countSetInRange(self: JedecData, range: FuseRange) usize {
        std.debug.assert(self.extents.containsRange(range));
        var iter = range.iterator();
        var count: usize = 0;
        while (iter.next()) |fuse| {
            if (self.isSet(fuse)) {
                count += 1;
            }
        }
        return count;
    }

    pub fn countUnsetInRange(self: JedecData, range: FuseRange) usize {
        std.debug.assert(self.extents.containsRange(range));
        var iter = range.iterator();
        var count: usize = 0;
        while (iter.next()) |fuse| {
            if (!self.isSet(fuse)) {
                count += 1;
            }
        }
        return count;
    }

    pub fn iterator(self: JedecData, comptime options: std.bit_set.IteratorOptions) Iterator(options) {
        return .{
            .raw = self.raw.iterator(options),
            .extents = self.extents,
        };
    }

    pub fn Iterator(comptime options: std.bit_set.IteratorOptions) type {
        return struct {
            raw: std.DynamicBitSetUnmanaged.Iterator(options),
            extents: FuseRange,

            const Self = @This();

            pub fn next(self: *Self) ?Fuse {
                if (self.raw.next()) |offset| {
                    return Fuse.fromOffset(offset, self.extents);
                } else {
                    return null;
                }
            }
        };
    }

};

pub const JedecFile = struct {
    data: JedecData,
    usercode: ?u32 = null,
    security: ?u1 = null,
    pin_count: ?usize = null,
};
