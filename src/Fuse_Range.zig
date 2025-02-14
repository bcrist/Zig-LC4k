min: Fuse,
max: Fuse,

pub fn init_empty() Fuse_Range {
    return .{
        .min = Fuse.init(1, 1),
        .max = Fuse.init(0, 0),
    };
}

pub fn init(what: anytype) Fuse_Range {
    const T = @TypeOf(what);
    return switch (T) {
        std.builtin.Type => what.jedec_dimensions,
        device.Type => what.get().jedec_dimensions,
        Fuse => .{ .min = what, .max = what },
        Fuse_Range => what,
        JEDEC_Data => what.extents,
        else => switch (@typeInfo(T)) {
            .pointer => |ptr_info| if (ptr_info.size == .one) switch (ptr_info.child) {
                device.Type => what.get().jedec_dimensions,
                Fuse => .{ .min = what.*, .max = what.* },
                Fuse_Range => what.*,
                JEDEC_Data => what.extents,
                else => @compileError("Invalid pointer type: " ++ @typeName(T)),
            } else @compileError("Expected a single pointer, not " ++ @typeName(T)),
            else => @compileError("Expected Device_Type, Device_Type.get(), Fuse_Range, JEDEC_Data, or a pointer to such.  Found: " ++ @typeName(T)),
        },
    };
}

pub fn init_from_dimensions(w: usize, h: usize) Fuse_Range {
    if (w == 0 or h == 0) {
        return init_empty();
    }
    return .{
        .min = Fuse.init(0, 0),
        .max = Fuse.init(h - 1, w - 1),
    };
}

pub fn between(a: Fuse, b: Fuse) Fuse_Range {
    return .{
        .min = Fuse.init(@min(a.row, b.row), @min(a.col, b.col)),
        .max = Fuse.init(@max(a.row, b.row), @max(a.col, b.col)),
    };
}

pub fn intersection(a: Fuse_Range, b: Fuse_Range) Fuse_Range {
    return .{
        .min = Fuse.init(@max(a.min.row, b.min.row), @max(a.min.col, b.min.col)),
        .max = Fuse.init(@min(a.max.row, b.max.row), @min(a.max.col, b.max.col)),
    };
}

pub fn expand_to_contain(self: Fuse_Range, fuse: Fuse) Fuse_Range {
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

pub fn contains(self: Fuse_Range, fuse: Fuse) bool {
    return fuse.row >= self.min.row and fuse.row <= self.max.row
        and fuse.col >= self.min.col and fuse.col <= self.max.col;
}

pub fn contains_range(self: Fuse_Range, other: Fuse_Range) bool {
    return other.isEmpty() or self.contains(other.min) and self.contains(other.max);
}

pub fn width(self: Fuse_Range) usize {
    if (self.max.col >= self.min.col) {
        return self.max.col - self.min.col + 1;
    } else {
        return 0;
    }
}

pub fn height(self: Fuse_Range) usize {
    if (self.max.row >= self.min.row) {
        return self.max.row - self.min.row + 1;
    } else {
        return 0;
    }
}

pub fn count(self: Fuse_Range) usize {
    return self.width() * self.height();
}

pub fn isEmpty(self: Fuse_Range) bool {
    return self.max.row < self.min.row or self.max.col < self.min.col;
}

pub fn expand_columns(self: Fuse_Range, num_columns: isize) Fuse_Range {
    if (num_columns < 0) {
        return Fuse_Range.between(
            Fuse.init(self.min.row, self.min.col - @as(usize, @intCast(-num_columns))),
            self.max,
        );
    } else {
        return Fuse_Range.between(
            self.min,
            Fuse.init(self.max.row, self.max.col + @as(usize, @intCast(num_columns))),
        );
    }
}

pub fn expand_rows(self: Fuse_Range, num_rows: isize) Fuse_Range {
    if (num_rows < 0) {
        return Fuse_Range.between(
            Fuse.init(self.min.row - @as(usize, @intCast(-num_rows)), self.min.col),
            self.max,
        );
    } else {
        return Fuse_Range.between(
            self.min,
            Fuse.init(self.max.row + @as(usize, @intCast(num_rows)), self.max.col),
        );
    }
}

pub fn sub_columns(self: Fuse_Range, col_offset: usize, num_cols: usize) Fuse_Range {
    const col = self.min.col + col_offset;
    std.debug.assert(col + num_cols - 1 <= self.max.col);
    return Fuse_Range.between(
        Fuse.init(self.min.row, col),
        Fuse.init(self.max.row, col + num_cols - 1),
    );
}

pub fn sub_rows(self: Fuse_Range, row_offset: usize, num_rows: usize) Fuse_Range {
    const row = self.min.row + row_offset;
    std.debug.assert(row + num_rows - 1 <= self.max.row);
    return Fuse_Range.between(
        Fuse.init(row, self.min.col),
        Fuse.init(row + num_rows - 1, self.max.col),
    );
}

pub fn at(self: Fuse_Range, row_offset: usize, col_offset: usize) Fuse {
    const row = self.min.row + row_offset;
    const col = self.min.col + col_offset;
    std.debug.assert(row <= self.max.row);
    std.debug.assert(col <= self.max.col);
    return Fuse.init(row, col);
}

pub fn iterator(self: Fuse_Range) Iterator {
    return .{ .range = self, .next_fuse = self.min };
}

pub const Iterator = struct {
    range: Fuse_Range,
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

pub fn eql(self: Fuse_Range, other: Fuse_Range) bool {
    return self.isEmpty() and other.isEmpty()
        or self.min.eql(other.min) and self.max.eql(other.max);
}

const Fuse_Range = @This();

const Fuse = @import("Fuse.zig");
const JEDEC_Data = @import("JEDEC_Data.zig");
const device = @import("device.zig");
const std = @import("std");
