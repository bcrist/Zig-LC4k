const std = @import("std");
const jedec = @import("jedec.zig");
const common = @import("common.zig");

const Fuse = jedec.Fuse;
const FuseRange = jedec.FuseRange;
const JedecData = jedec.JedecData;
const JedecFile = jedec.JedecFile;

const JedecCommand = enum {
    qty_pins,
    qty_fuses,
    note,
    security,
    default,
    location,
    hex,
    usercode,
    checksum,
};

const JedecField = struct {
    cmd: JedecCommand,
    extra: []const u8,
};

const JedecFieldIterator = struct {
    remaining: []const u8,

    fn next(self: *JedecFieldIterator) !?JedecField {
        while (std.mem.indexOf(u8, self.remaining, "*")) |end| {
            const cmd = std.mem.trimLeft(u8, self.remaining[0..end], " \t\r\n");
            self.remaining = self.remaining[end + 1 ..];
            if (cmd.len == 0) {
                try std.io.getStdErr().writer().writeAll("Ignoring empty field\n");
            } else switch (cmd[0]) {
                'Q' => {
                    if (cmd.len >= 2) {
                        switch (cmd[1]) {
                            'F' => return JedecField { .cmd = .qty_fuses, .extra = cmd[2..] },
                            'P' => return JedecField { .cmd = .qty_pins, .extra = cmd[2..] },
                            else => {} // fall through
                        }
                    }
                    try std.io.getStdErr().writer().print("Ignoring unsupported field: {s}\n", .{ cmd });
                },
                'N' => return JedecField { .cmd = .note, .extra = cmd[1..] },
                'G' => return JedecField { .cmd = .security, .extra = cmd[1..] },
                'F' => return JedecField { .cmd = .default, .extra = cmd[1..] },
                'L' => return JedecField { .cmd = .location, .extra = cmd[1..] },
                'K' => return JedecField { .cmd = .hex, .extra = cmd[1..] },
                'U' => return JedecField { .cmd = .usercode, .extra = cmd[1..] },
                'C' => return JedecField { .cmd = .checksum, .extra = cmd[1..] },
                else => {
                    try std.io.getStdErr().writer().print("Ignoring unsupported field: {s}\n", .{ cmd });
                },
            }
        }
        return null;
    }
};


pub fn parse(allocator: std.mem.Allocator, width: usize, height: ?usize, text: []const u8) !JedecFile {
    var pin_count: ?usize = null;
    var usercode: ?u32 = null;
    var security: ?u1 = null;
    var default: ?u1 = null;
    var fuse_checksum: ?u16 = null;
    var actual_height: ?usize = height;

    var data: ?JedecData = null;

    const start_of_fields = 1 + (std.mem.indexOf(u8, text, "*") orelse return error.MalformedJedecFile);

    var iter = JedecFieldIterator {
        .remaining = text[start_of_fields..],
    };

    while (try iter.next()) |field| {
        switch (field.cmd) {
            .qty_fuses => {
                const qf = std.fmt.parseUnsigned(u32, field.extra, 10) catch return error.MalformedJedecFile;
                if (actual_height) |h| {
                    const expected = h * width;
                    if (qf != expected) {
                        try std.io.getStdErr().writer().print("Expected fuse count to be exactly {}, but found {}\n", .{ expected, qf });
                        return error.IncorrectFuseCount;
                    }
                } else {
                    const h = qf / width;
                    if (h * width != qf) {
                        try std.io.getStdErr().writer().print("Expected fuse count to be a multiple of {}, but found {}\n", .{ width, qf });
                        return error.IncorrectFuseCount;
                    }
                    actual_height = h;
                }
            },
            .qty_pins => if (pin_count) |_| {
                return error.MalformedJedecFile;
            } else {
                pin_count = std.fmt.parseUnsigned(u16, field.extra, 10) catch return error.MalformedJedecFile;
            },
            .checksum => if (fuse_checksum) |_| {
                return error.MalformedJedecFile;
            } else {
                fuse_checksum = std.fmt.parseUnsigned(u16, field.extra, 16) catch return error.MalformedJedecFile;
            },
            .security => if (security) |_| {
                return error.MalformedJedecFile;
            } else {
                security = std.fmt.parseUnsigned(u1, field.extra, 10) catch return error.MalformedJedecFile;
            },
            .default => if (default) |_| {
                return error.MalformedJedecFile;
            } else {
                default = std.fmt.parseUnsigned(u1, field.extra, 10) catch return error.MalformedJedecFile;
            },
            .usercode => if (usercode) |_| {
                return error.MalformedJedecFile;
            } else {
                usercode = std.fmt.parseUnsigned(u32, field.extra, 2) catch return error.MalformedJedecFile;
            },
            .location, .hex => {
                var end_of_digits: usize = 0;
                while (end_of_digits < field.extra.len) : (end_of_digits += 1) {
                    var c = field.extra[end_of_digits];
                    if (c < '0' or c > '9') break;
                }

                const location_str = field.extra[0..end_of_digits];
                const data_str = field.extra[end_of_digits..];
                const starting_fuse = std.fmt.parseUnsigned(u32, location_str, 10) catch return error.MalformedJedecFile;
                if (data == null) {
                    if (actual_height) |h| {
                        data = try JedecData.init(allocator, FuseRange.init(width, h), default orelse 1);
                    } else {
                        try std.io.getStdErr().writer().writeAll("Expected QF command before L or K command\n");
                        return error.MalformedJedecFile;
                    }
                }
                switch (field.cmd) {
                    .location => try parseBinaryString(&data.?, starting_fuse, data_str),
                    .hex => try parseHexString(&data.?, starting_fuse, data_str),
                    else => unreachable,
                }
            },
            .note => {}, // ignore comment
        }
    }

    if (iter.remaining[0] == 3 and iter.remaining.len >= 5) {
        // check final file checksum
        const found_checksum = std.fmt.parseUnsigned(u16, iter.remaining[1..5], 16) catch return error.MalformedJedecFile;
        var computed_checksum: u16 = 0;
        for (text[0..text.len-iter.remaining.len]) |byte| {
            computed_checksum += byte;
        }

        if (found_checksum != computed_checksum) {
            try std.io.getStdErr().writer().print("File checksum mismatch; file specifies {X:0>4} but computed {X:0>4}\n", .{ found_checksum, computed_checksum });
            return error.CorruptedJedecFile;
        }
    }

    if (data) |s| {
        if (fuse_checksum) |found_checksum| {
            var computed_checksum = checksum(s);
            if (found_checksum != computed_checksum) {
                try std.io.getStdErr().writer().print("Fuse checksum mismatch; file specifies {X:0>4} but computed {X:0>4}\n", .{ found_checksum, computed_checksum });
                return error.CorruptedJedecFile;
            }
        }

        return .{
            .data = s,
            .security = security,
            .usercode = usercode,
            .pin_count = pin_count,
        };
    } else {
        try std.io.getStdErr().writer().writeAll("Expected at least one L or K command\n");
        return error.MalformedJedecFile;
    }
}

fn parseBinaryString(data: *JedecData, starting_fuse: usize, text: []const u8) !void {
    const len = data.extents.count();
    var i: usize = starting_fuse;
    for (text) |c| {
        switch (c) {
            '0', '1' => {
                if (i >= len) {
                    return error.InvalidFuse;
                }
                data.raw.setValue(i, c == '1');
                i += 1;
            },
            '\r', '\n', '\t', ' ' => {},
            else => {
                return error.InvalidData;
            },
        }
    }
}

fn parseHexString(data: *JedecData, starting_fuse: usize, text: []const u8) !void {
    const len = data.extents.count();
    var i: usize = starting_fuse;
    for (text) |c| {
        const val: ?u4 = switch (c) {
            '0'...'9' => @intCast(u4, c - '0'),
            'A'...'F' => @intCast(u4, c - 'A' + 0xA),
            'a'...'f' => @intCast(u4, c - 'a' + 0xA),
            '\r', '\n', '\t', ' ' => null,
            else => return error.InvalidData,
        };
        if (val) |v| {
            if (i >= len) {
                return error.InvalidFuse;
            }
            data.raw.setValue(i, 0 != (v & 0x8));
            i += 1; if (i < len) data.raw.setValue(i, 0 != (v & 0x4));
            i += 1; if (i < len) data.raw.setValue(i, 0 != (v & 0x2));
            i += 1; if (i < len) data.raw.setValue(i, 0 != (v & 0x1));
            i += 1;
        }
    }
}

pub const WriteOptions = struct {
    compact: bool = false,
    zero_char: u8 = '0',
    one_char: u8 = '1',
    line_ending: []const u8 = "\n",
    notes: []const u8 = "",
};

pub fn write(device_type: common.DeviceType, allocator: std.mem.Allocator, f: JedecFile, writer: anytype, options: WriteOptions) !void {
    var w = @import("checksum_writer.zig").checksumWriter(u16, allocator, writer);

    try w.writeByte(0x2); // STX
    try w.print("{s} configuration generated by https://github.com/bcrist/Zig-LC4k *{s}", .{ @tagName(device_type), options.line_ending });

    if (options.notes.len > 0) {
        var iter = std.mem.split(u8, options.notes, "\n*");
        while (iter.next()) |l| {
            var line = l;
            if (std.mem.endsWith(u8, line, "\r")) {
                line = line[0..line.len - 1];
            }
            try w.print("NOTE {s}*{s}", .{ line, options.line_ending });
        }
    }

    if (f.pin_count) |qp| {
        try w.print("QP{}*{s}", .{ qp, options.line_ending });
    }

    try w.print("QF{}*{s}", .{ f.data.extents.count(), options.line_ending });

    if (f.security) |g| {
        try w.print("G{}*{s}", .{ g, options.line_ending });
    }

    if (options.compact) {
        const len = f.data.extents.count();
        const num_set = f.data.raw.count();
        var default: u1 = undefined;
        var default_hex: u8 = undefined;
        if (num_set * 2 < len) {
            default = 0;
            default_hex = '0';
        } else {
            default = 1;
            default_hex = 'F';
        }

        try w.print("F{}*", .{ default });

        var unwritten_defaults: usize = 8888;
        var fuse: usize = 0;
        while (fuse < len) : (fuse += 4) {
            const b0: u4 = @boolToInt(f.data.raw.isSet(fuse + 0));
            const b1: u4 = if (fuse + 1 < len) @boolToInt(f.data.raw.isSet(fuse + 1)) else default;
            const b2: u4 = if (fuse + 2 < len) @boolToInt(f.data.raw.isSet(fuse + 2)) else default;
            const b3: u4 = if (fuse + 3 < len) @boolToInt(f.data.raw.isSet(fuse + 3)) else default;

            const val: u8 = 8*b0 + 4*b1 + 2*b2 + b3;
            const hex = if (val < 0xA) '0' + val else 'A' + val - 0xA;

            if (hex == default_hex) {
                unwritten_defaults += 1;
            } else if (unwritten_defaults > 7) {
                try w.print("{s}K{} {}", .{ options.line_ending, fuse, hex });
                unwritten_defaults = 0;
            } else if (unwritten_defaults > 0) {
                try w.writeByteNTimes(default_hex, unwritten_defaults);
                try w.writeByte(hex);
                unwritten_defaults = 0;
            } else {
                try w.writeByte(hex);
            }
        }
        try w.writeAll(options.line_ending);
    } else {
        try w.print("F0*{s}L0{s}", .{ options.line_ending, options.line_ending });
        var fuse: usize = 0;
        var row: u16 = 0;
        const width = f.data.extents.width();
        const height = f.data.extents.height();
        while (row < height) : (row += 1) {
            var col: u16 = 0;
            while (col < width) : (col += 1) {
                if (f.data.raw.isSet(fuse)) {
                    try w.writeByte(options.one_char);
                } else {
                    try w.writeByte(options.zero_char);
                }
                fuse += 1;
            }
            try w.writeAll(options.line_ending);
        }
    }
    try w.print("*{s}", .{options.line_ending});

    const fuse_checksum = checksum(f.data);
    try w.print("C{X:0>4}*{s}", .{ fuse_checksum, options.line_ending });

    if (f.usercode) |u| {
        try w.print("U{b:0>32}*{s}", .{ u, options.line_ending });
    }

    try w.writeByte(0x3); // ETX
    try writer.print("{X:0>4}{s}", .{ w.checksum, options.line_ending });
}

pub fn checksum(data: JedecData) u16 {
    var sum: u16 = 0;

    const MaskInt = std.DynamicBitSetUnmanaged.MaskInt;
    var masks: []MaskInt = undefined;
    masks.ptr = data.raw.masks;
    masks.len = (data.raw.bit_length + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);

    for (masks) |mask| {
        var x = mask;
        comptime var i = 0;
        inline while (i < @sizeOf(MaskInt)) : (i += 1) {
            sum +%= @truncate(u8, x);
            x = x >> 8;
        }
    }

    return sum;
}
