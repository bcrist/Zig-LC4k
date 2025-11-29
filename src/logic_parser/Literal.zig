value: u64,
max_bit_index: u6,

pub fn parse(text: []const u8) !Literal {
    var signed_value: i64 = undefined;
    var bits: u7 = 0;

    const value_text = if (std.mem.indexOfScalar(u8, text, '\'')) |sigil| t: {
        if (sigil > 0) {
            const base, const remaining = parse_base(text[0..sigil]);
            bits = try std.fmt.parseUnsigned(u6, remaining, base);
        }
        break :t text[sigil + 1 ..];
    } else text;

    const base, const remaining = parse_base(value_text);
    if (bits == 0) {
        const bits_per_digit: u7 = switch (base) {
            16 => 4,
            8 => 3,
            4 => 2,
            2 => 1,
            else => 0,
        };
        if (bits_per_digit > 0) {
            var num_digits: u7 = 0;
            for (remaining) |ch| {
                if (ch != '_') num_digits += 1;
            }
            bits = num_digits * bits_per_digit;
        }
    }

    signed_value = try std.fmt.parseInt(i64, remaining, base);
    var unsigned_value: u64 = @bitCast(signed_value);

    if (bits == 0) {
        bits = @intCast(64 - @clz(unsigned_value));
        if (bits == 0) bits = 1;
    } else {
        const mask = @as(u64, std.math.maxInt(u64)) >> @intCast(@as(u7, 64) - bits);
        var masked_value = unsigned_value & mask;
        if (signed_value < 0) masked_value |= ~mask;
        if (masked_value != unsigned_value) return error.Overflow;
        unsigned_value &= mask;
    }

    return .{
        .value = unsigned_value,
        .max_bit_index = @intCast(bits - 1),
    };
}

fn parse_base(text: []const u8) struct { u8, []const u8 } {
    const text_without_leading_zero = if (text.len > 1 and text[0] == '0') text[1..] else text;
    if (text_without_leading_zero.len == 0) return .{ 10, "" };
    return switch (text_without_leading_zero[0]) {
        'H', 'h', 'X', 'x', '#' => .{ 16, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
        'D', 'd' => .{ 10, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
        'O', 'o' => .{ 8, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
        'B', 'b' => .{ 2, std.mem.trim(u8, text_without_leading_zero[1..], "_") },
        else => .{ 10, std.mem.trim(u8, text_without_leading_zero, "_") },
    };
}

pub fn format(self: Literal, w: *std.io.Writer) !void {
    w.print("{d}'0x{X:0}", .{ self.max_bit_index + 1, self.value });
}

const Literal = @This();
const std = @import("std");
