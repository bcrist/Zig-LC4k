row: usize,
col: usize,

const Fuse = @This();
const Fuse_Range = @import("Fuse_Range.zig");

pub fn init(row: usize, col: usize) Fuse {
    return .{ .row = row, .col = col };
}

pub fn from_offset(offset: usize, device_or_jedec: anytype) Fuse {
    const r = Fuse_Range.init(device_or_jedec);
    const width = r.width();
    const row = offset / width;
    const col = (offset - row * width);
    return .{
        .row = r.min.row + row,
        .col = r.min.col + col,
    };
}

pub fn to_offset(self: Fuse, device_or_jedec: anytype) usize {
    const r = Fuse_Range.init(device_or_jedec);
    const row = self.row - r.min.row;
    const col = self.col - r.min.col;
    return row * r.width() + col;
}

pub fn range(self: Fuse) Fuse_Range {
    return Fuse_Range.init(self);
}

pub fn eql(self: Fuse, other: Fuse) bool {
    return self.row == other.row and self.col == other.col;
}