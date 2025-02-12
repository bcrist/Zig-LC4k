pub const Token = enum (u8) {
    eof,
    invalid,
    literal,
    id,
    builtin,
    product,
    sum,
    xor,
    complement,
    equals,
    not_equals,
    begin_subexpr,
    end_subexpr,
    begin_concat,
    end_concat,
    begin_extract,
    end_extract,
    range,
    big_endian,
    little_endian,
};

pub const Lex_Error = std.mem.Allocator.Error;

pub fn lex(gpa: std.mem.Allocator, equation: []const u8) Lex_Error!struct { []const Token, []const u32 } {
    const Token_Data = struct {
        what: Token,
        where: u32,
    };
    var data: std.MultiArrayList(Token_Data) = .{};
    defer data.deinit(gpa);

    var chi: u32 = 0;
    while (chi < equation.len) {
        const token: Token = switch (equation[chi]) {
            0...' ' => {
                // whitespace
                chi += 1;
                while (chi < equation.len and equation[chi] <= ' ') chi += 1;
                continue;
            },
            ';' => {
                // comment
                chi += 1;
                while (chi < equation.len and equation[chi] != '\n') chi += 1;
                if (chi < equation.len) chi += 1; // skip final \n
                continue;
            },
            '0' ... '9', '\'', '-', '#', => {
                // literal
                try data.append(gpa, .{ .what = .literal, .where = chi });
                chi += 1;
                while (chi < equation.len and is_literal_char(equation[chi])) chi += 1;
                continue;
            },
            'a' ... 'z', 'A' ... 'Z', '_', '.', '$' => {
                // identifier
                try data.append(gpa, .{ .what = .id, .where = chi });
                chi += 1;
                while (chi < equation.len and is_identifier_char(equation[chi])) chi += 1;
                continue;
            },
            '@' => {
                // builtin
                try data.append(gpa, .{ .what = .builtin, .where = chi });
                chi += 1;
                while (chi < equation.len and is_identifier_char(equation[chi])) chi += 1;
                continue;
            },
            '&' => .product,
            '*' => .product,
            '|' => .sum,
            '+' => .sum,
            '^' => .xor,
            '~' => .complement,
            '=' => t: {
                if (chi + 1 < equation.len and equation[chi + 1] == '=') {
                    chi += 1;
                    break :t .equals;
                } else break :t .invalid;
            },
            '!' => t: {
                if (chi + 1 < equation.len and equation[chi + 1] == '=') {
                    chi += 1;
                    break :t .not_equals;
                } else break :t .complement;
            },
            '(' => .begin_subexpr,
            ')' => .end_subexpr,
            '{' => .begin_concat,
            '}' => .end_concat,
            '[' => .begin_extract,
            ']' => .end_extract,
            ':' => .range,
            '>' => .big_endian,
            '<' => .little_endian,
            else => .invalid,
        };
        try data.append(gpa, .{ .what = token, .where = chi });
        chi += 1;
    }

    try data.append(gpa, .{ .what = .eof, .where = chi });

    const tokens = try gpa.dupe(Token, data.items(.what));
    errdefer gpa.free(tokens);

    const offsets = try gpa.dupe(u32, data.items(.where));
    errdefer gpa.free(offsets);

    return .{ tokens, offsets };
}

pub fn token_span(equation: []const u8, start: u32) []const u8 {
    if (start >= equation.len) return "";

    var end = start + 1;

    switch (equation[start]) {
        0...' ' => {
            // whitespace
            while (end < equation.len and equation[end] <= ' ') end += 1;
        },
        ';' => {
            // comment
            while (end < equation.len and equation[end] != '\n') end += 1;
            if (end < equation.len) end += 1; // skip final \n
        },
        '0' ... '9', '\'', '-', '#' => {
            // literal
            while (end < equation.len and is_literal_char(equation[end])) end += 1;
        },
        'a' ... 'z', 'A' ... 'Z', '_', '.', '$', '@' => {
            // identifier or builtin
            while (end < equation.len and is_identifier_char(equation[end])) end += 1;
        },
        '=' => {
            if (start + 1 < equation.len and equation[start + 1] == '=') end += 1;
        },
        '!' => {
            if (start + 1 < equation.len and equation[start + 1] == '=') end += 1;
        },
        else => {},
    }

    return equation[start..end];
}

inline fn is_literal_char(ch: u8) bool {
    return switch (ch) {
        '0' ... '9' => true,
        '\'' => true,
        '_' => true,
        '-' => true,
        'a' ... 'z' => true,
        'A' ... 'Z' => true,
        else => false,
    };
}

inline fn is_identifier_char(ch: u8) bool {
    return switch (ch) {
        '0' ... '9' => true,
        '_', '.', '$' => true,
        'a' ... 'z' => true,
        'A' ... 'Z' => true,
        else => false,
    };
}

const std = @import("std");
