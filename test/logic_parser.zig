test "lexer basics" {
    const tokens, const offsets = try lp.lexer.lex(std.testing.allocator, "abc + 123 & asdf[4:] ; I'm a teapot");
    defer std.testing.allocator.free(tokens);
    defer std.testing.allocator.free(offsets);

    try std.testing.expectEqualSlices(lp.lexer.Token, &.{
        .id, .sum, .literal, .product, .id, .begin_extract, .literal, .range, .end_extract, .eof,
    }, tokens);
    try std.testing.expectEqualSlices(u32, &.{
        0, 4, 6, 10, 12, 16, 17, 18, 19, 35,
    }, offsets);
}

test "lexer subexpr and concat" {
    const tokens, const offsets = try lp.lexer.lex(std.testing.allocator,
        \\  abc[>0 1 2]
        \\  {a<b     <   c}
        \\  (x + (y)) & z
        \\== != asdf #123
        \\ @asdf
    );
    defer std.testing.allocator.free(tokens);
    defer std.testing.allocator.free(offsets);

    try std.testing.expectEqualSlices(lp.lexer.Token, &.{
        .id, .begin_extract, .big_endian, .literal, .literal, .literal, .end_extract,
        .begin_concat, .id, .little_endian, .id, .little_endian, .id, .end_concat,
        .begin_subexpr, .id, .sum, .begin_subexpr, .id, .end_subexpr, .end_subexpr, .product, .id,
        .equals, .not_equals, .id, .literal,
        .builtin, .eof,
    }, tokens);
    try std.testing.expectEqualSlices(u32, &.{
        2, 5, 6, 7, 9, 11, 12, 16, 17, 18, 19, 25, 29, 30, 34, 35, 37, 39, 40, 41, 42, 44, 46, 49, 52, 54, 59, 65, 70
    }, offsets);
}

test "literal values" {
    try test_literal("10", 10, 4);
    try test_literal("'10", 10, 4);
    try test_literal("d1234", 0b10011010010, 11);
    try test_literal("1", 1, 1);
    try test_literal("0", 0, 1);
    try test_literal("'0", 0, 1);
    try test_literal("0'0", 0, 1);
    try test_literal("0x1ff", 0x1ff, 12);
    try test_literal("x1ff", 0x1ff, 12);
    try test_literal("X1_f__f___", 0x1ff, 12);
    try test_literal("#100", 0x100, 12);
    try test_literal("hff", 0xff, 8);
    try test_literal("0b1010101000111", 0b1010101000111, 13);
    try test_literal("0b0_10101__01000111", 0b1010101000111, 14);
    try test_literal("B00001010101000111", 0b1010101000111, 17);
    try test_literal("0O101010", 0o101010, 18);
    try test_literal("O0000101010", 0o101010, 30);
    try test_literal("32'10", 10, 32);
    try test_literal("d3'x7", 0x7, 3);
    try test_literal("0d3'x7", 0x7, 3);
    try test_literal("0#3'x7", 0x7, 3);
    try test_literal("0x3'x7", 0x7, 3);
    try test_literal("0h3'x7", 0x7, 3);
    try test_literal("0o3'x7", 0x7, 3);
    try test_literal("0b_11_'x7", 0x7, 3);
    try test_literal("4'-1", 0b1111, 4);
    try test_literal("20'x-12345", 0xEDCBB, 20);
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("0b11'x7'"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("''"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("'"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("asdf"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("'asdf"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse(""));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("_0x7"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("'_0x7"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("-'0"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("-"));
    try std.testing.expectError(error.InvalidCharacter, lp.Literal.parse("-1'0"));
    try std.testing.expectError(error.Overflow, lp.Literal.parse("7'xff"));
    try std.testing.expectError(error.Overflow, lp.Literal.parse("16'-123456"));
    try std.testing.expectError(error.Overflow, lp.Literal.parse("100000'0"));
    try std.testing.expectError(error.Overflow, lp.Literal.parse("d1000000000000000000000000000"));
}

fn test_literal(str: []const u8, value: u64, bits: u6) !void {
    const lit = try lp.Literal.parse(str);
    try std.testing.expectEqual(value, lit.value);
    try std.testing.expectEqual(bits, lit.max_bit_index + 1);
}

test "parsing" {
    const Device = lc4k.LC4032ZC_TQFP48.Device;
    const names = Device.get_names();

    try test_parse(Device, names, "pin_33",
        \\0-6 bus_ref (1b) < io_B10
        \\
    );

    try test_parse(Device, names, "clk0 | clk1",
        \\0-11 binary_sum:
        \\   [0] 0-4 signal (1b) clk0
        \\   [1] 7-11 signal (1b) clk1
        \\
    );
    try test_parse(Device, names, "~(clk0 + clk1) & ~!io_B0 * io_B1 ^ io_A13",
        \\0-41 binary_xor:
        \\   [0] 0-32 product:
        \\      [0] 0-14 complement: 1-14 subexpr: 2-13 binary_sum:
        \\         [0] 2-6 signal (1b) clk0
        \\         [1] 9-13 signal (1b) clk1
        \\      [1] 17-24 complement: 18-24 complement: 19-24 signal (1b) io_B0
        \\      [2] 27-32 signal (1b) io_B1
        \\   [1] 35-41 signal (1b) io_A13
        \\
    );

    try test_parse(Device, names, "io_A0 + io_A1 | io_A2 ^ io_A3 ^ io_A4 | io_A5 + io_A6 ^ io_A7",
        \\0-61 binary_xor:
        \\   [0] 0-53 sum:
        \\      [0] 0-37 xor:
        \\         [0] 0-21 sum:
        \\            [0] 0-5 signal (1b) io_A0
        \\            [1] 8-13 signal (1b) io_A1
        \\            [2] 16-21 signal (1b) io_A2
        \\         [1] 24-29 signal (1b) io_A3
        \\         [2] 32-37 signal (1b) io_A4
        \\      [1] 40-45 signal (1b) io_A5
        \\      [2] 48-53 signal (1b) io_A6
        \\   [1] 56-61 signal (1b) io_A7
        \\
    );

    try test_parse(Device, names, "io_A0 == io_A1 & io_A2 != io_A3 & 'x1234",
        \\0-40 product:
        \\   [0] 0-14 equals:
        \\      [0] 0-5 signal (1b) io_A0
        \\      [1] 9-14 signal (1b) io_A1
        \\   [1] 17-31 not_equals:
        \\      [0] 17-22 signal (1b) io_A2
        \\      [1] 26-31 signal (1b) io_A3
        \\   [2] 34-40 literal (16b) 0b1001000110100
        \\
    );

    try test_parse(Device, names, "&pin_3 | |pin_4",
        \\0-15 binary_sum:
        \\   [0] 0-6 unary_product: 1-6 bus_ref (1b) < io_A6
        \\   [1] 9-15 unary_sum: 10-15 bus_ref (1b) < io_A7
        \\
    );

    try test_parse(Device, names, "~&pin_3 | *+^~pin_4",
        \\0-19 binary_sum:
        \\   [0] 0-7 complement: 1-7 unary_product: 2-7 bus_ref (1b) < io_A6
        \\   [1] 10-19 unary_product: 11-19 unary_sum: 12-19 unary_xor: 13-19 complement: 14-19 bus_ref (1b) < io_A7
        \\
    );

    try test_parse(Device, names, "{~pin_3 pin_4}",
        \\0-14 binary_concat_be:
        \\   [0] 1-7 complement: 2-7 bus_ref (1b) < io_A6
        \\   [1] 8-13 bus_ref (1b) < io_A7
        \\
    );

    try test_parse(Device, names, "{>~pin_3 pin_4 pin_8}",
        \\0-21 concat_be:
        \\   [0] 2-8 complement: 3-8 bus_ref (1b) < io_A6
        \\   [1] 9-14 bus_ref (1b) < io_A7
        \\   [2] 15-20 bus_ref (1b) < io_A9
        \\
    );

    try test_parse(Device, names, "{ <<<<<~pin_3<<<<<<pin_4<<}",
        \\0-27 binary_concat_le:
        \\   [0] 7-13 complement: 8-13 bus_ref (1b) < io_A6
        \\   [1] 19-24 bus_ref (1b) < io_A7
        \\
    );

    try test_parse(Device, names, "{~pin_3<pin_4<io_A7}",
        \\0-20 concat_le:
        \\   [0] 1-7 complement: 2-7 bus_ref (1b) < io_A6
        \\   [1] 8-13 bus_ref (1b) < io_A7
        \\   [2] 14-19 signal (1b) io_A7
        \\
    );

    try test_parse(Device, names, "pin_3[0]",
        \\0-8 extract:
        \\   [0] 0-5 bus_ref (1b) < io_A6
        \\   [1] 6-7 literal (6b) 0b0
        \\
    );

    try test_parse(Device, names, "{ pin_3[<0:7] pin_4[1] pin_4[>1>2 3>>>4:3>] }",
        \\0-45 concat_be:
        \\   [0] 2-13 extract_le:
        \\      [0] 2-7 bus_ref (1b) < io_A6
        \\      [1] 9-12 bit_range (6b) 0:7
        \\   [1] 14-22 extract:
        \\      [0] 14-19 bus_ref (1b) < io_A7
        \\      [1] 20-21 literal (6b) 0b1
        \\   [2] 23-43 multi_extract_be:
        \\      [0] 23-28 bus_ref (1b) < io_A7
        \\      [1] 30-31 literal (6b) 0b1
        \\      [2] 32-33 literal (6b) 0b10
        \\      [3] 34-35 literal (6b) 0b11
        \\      [4] 38-41 bit_range (6b) 4:3
        \\
    );

    try test_parse(Device, names, "{io_A0 io_A1 io_A2 io_A3}[{clk1 clk0}]",
        \\0-38 mux:
        \\   [0] 0-25 concat_be:
        \\      [0] 1-6 signal (1b) io_A0
        \\      [1] 7-12 signal (1b) io_A1
        \\      [2] 13-18 signal (1b) io_A2
        \\      [3] 19-24 signal (1b) io_A3
        \\   [1] 26-37 binary_concat_be:
        \\      [0] 27-31 signal (1b) clk1
        \\      [1] 32-36 signal (1b) clk0
        \\
    );

    try test_parse(Device, names, "@fb @pad {io_A0 mc_A1}",
        \\0-22 fb_signal: 4-22 pad_signal: 9-22 binary_concat_be:
        \\   [0] 10-15 signal (1b) io_A0
        \\   [1] 16-21 signal (1b) mc_A1
        \\
    );
}

fn test_parse(comptime Device: type, names: *const Device.Names, eqn: []const u8, expected: []const u8) !void {
    var ast = try lp.Ast(Device).parse(std.testing.allocator, names, eqn);
    defer ast.deinit();

    var temp = std.Io.Writer.Allocating.init(std.testing.allocator);
    defer temp.deinit();

    try ast.debug(&temp.writer);
    try std.testing.expectEqualStrings(expected, temp.written());
}

test "typechecking" {
    const Device = lc4k.LC4128ZC_csBGA132.Device;
    var names: Device.Names = .init(std.testing.allocator);
    defer names.deinit();
    try names.add_names(struct {
        pub const A = [_]Device.Signal {
            .mc_A0,
            .mc_A1,
            .mc_A2,
            .mc_A3,
        };
        pub const B = [_]Device.Signal {
            .mc_B0,
            .mc_B1,
            .mc_B2,
            .mc_B3,
        };
    }, .{});

    try test_bit_widths(Device, &names, "~(A)",
        \\0-4 complement (4b): 1-4 subexpr (4b): 2-3 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\
    );

    try test_bit_widths(Device, &names, "&A",
        \\0-2 unary_product (1b): 1-2 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\
    );

    try test_bit_widths(Device, &names, "+A",
        \\0-2 unary_sum (1b): 1-2 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\
    );

    try test_bit_widths(Device, &names, "^A",
        \\0-2 unary_xor (1b): 1-2 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\
    );

    try test_bit_widths(Device, &names, "A == B",
        \\0-6 equals (1b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 5-6 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A != B",
        \\0-6 not_equals (1b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 5-6 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A | B",
        \\0-5 binary_sum (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A * B",
        \\0-5 binary_product (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A ^ B",
        \\0-5 binary_xor (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A | B | B",
        \\0-9 sum (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\   [2] 8-9 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A * B & B",
        \\0-9 product (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\   [2] 8-9 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A ^ B ^ B",
        \\0-9 xor (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\   [2] 8-9 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "{A B}",
        \\0-5 binary_concat_be (8b):
        \\   [0] 1-2 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 3-4 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\
    );

    try test_bit_widths(Device, &names, "A[2]",
        \\0-4 extract (1b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-3 literal (6b) 0b10
        \\
    );

    try test_bit_widths(Device, &names, "A[2:1]",
        \\0-6 extract (2b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-5 bit_range (6b) 2:1
        \\
    );

    try test_bit_widths(Device, &names, "A[2:]",
        \\0-5 extract (3b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-4 bit_range (6b) 2:null
        \\
    );

    try test_bit_widths(Device, &names, "A[:1]",
        \\0-5 extract (3b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-4 bit_range (6b) null:1
        \\
    );

    try test_bit_widths(Device, &names, "A[:]",
        \\0-4 extract (4b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-3 bit_range (6b) null:null
        \\
    );

    try test_bit_widths(Device, &names, "{<A B A B[0]}",
        \\0-13 concat_le (13b):
        \\   [0] 2-3 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 4-5 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\   [2] 6-7 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [3] 8-12 extract (1b):
        \\      [0] 8-9 bus_ref (4b) < mc_B0 mc_B1 mc_B2 mc_B3
        \\      [1] 10-11 literal (6b) 0b0
        \\
    );

    try test_bit_widths(Device, &names, "A[0 1 2 3 3 3>]",
        \\0-15 multi_extract_be (6b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-3 literal (6b) 0b0
        \\   [2] 4-5 literal (6b) 0b1
        \\   [3] 6-7 literal (6b) 0b10
        \\   [4] 8-9 literal (6b) 0b11
        \\   [5] 10-11 literal (6b) 0b11
        \\   [6] 12-13 literal (6b) 0b11
        \\
    );

    try test_bit_widths(Device, &names, "A[>2:2:]",
        \\0-8 multi_extract_be (5b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 3-6 bit_range (6b) 2:2
        \\   [2] 6-7 bit_range (6b) null:null
        \\
    );

    try test_bit_widths(Device, &names, "A[{clk1 clk0}]",
        \\0-14 mux (1b):
        \\   [0] 0-1 bus_ref (4b) < mc_A0 mc_A1 mc_A2 mc_A3
        \\   [1] 2-13 binary_concat_be (2b):
        \\      [0] 3-7 signal (1b) clk1
        \\      [1] 8-12 signal (1b) clk0
        \\
    );

    try test_bit_widths(Device, &names, "@fb @pad {io_A0 mc_A1}",
        \\0-22 fb_signal (2b): 4-22 pad_signal (2b): 9-22 binary_concat_be (2b):
        \\   [0] 10-15 signal (1b) io_A0
        \\   [1] 16-21 signal (1b) mc_A1
        \\
    );
}

fn test_bit_widths(comptime Device: type, names: *const Device.Names, eqn: []const u8, expected: []const u8) !void {
    var ast = try lp.Ast(Device).parse(std.testing.allocator, names, eqn);
    defer ast.deinit();

    _ = try ast.infer_and_check_max_bit(.{});

    var temp = std.Io.Writer.Allocating.init(std.testing.allocator);
    defer temp.deinit();

    try ast.debug(&temp.writer);
    try std.testing.expectEqualStrings(expected, temp.written());
}

test "build IR" {
    const Device = lc4k.LC4064ZE_TQFP100.Device;
    var names: Device.Names = .init(std.testing.allocator);
    defer names.deinit();
    try names.add_names(struct {
        pub const A = [_]Device.Signal {
            .mc_A0,
            .mc_A1,
            .mc_A2,
            .mc_A3,
        };
        pub const B = [_]Device.Signal {
            .mc_B0,
            .mc_B1,
            .mc_B2,
            .mc_B3,
        };
    }, .{});

    try test_build_ir(Device, &names, "~(A)", 0, null, "complement: signal 74\n");
    try test_build_ir(Device, &names, "~(A)", 1, null, "complement: signal 75\n");
    try test_build_ir(Device, &names, "~(A)", 2, null, "complement: signal 76\n");
    try test_build_ir(Device, &names, "~(A)", 3, null, "complement: signal 77\n");
    try test_build_ir(Device, &names, "~(B)", 0, null, "complement: signal 90\n");
    try test_build_ir(Device, &names, "~(B)", 1, null, "complement: signal 91\n");
    try test_build_ir(Device, &names, "~(B)", 2, null, "complement: signal 92\n");
    try test_build_ir(Device, &names, "~(B)", 3, null, "complement: signal 93\n");
    try test_build_ir(Device, &names, "A[3]", 0, null, "signal 77\n");
    try test_build_ir(Device, &names, "{ io_A0 io_A1 }", 0, null, "signal 11\n");
    try test_build_ir(Device, &names, "{ io_A0 io_A1 }", 1, null, "signal 10\n");
    try test_build_ir(Device, &names, "{< io_A0 io_A1 }", 0, null, "signal 10\n");
    try test_build_ir(Device, &names, "{< io_A0 io_A1 }", 1, null, "signal 11\n");

    try test_build_ir(Device, &names, "io_A0 + io_A1 * io_A2 ^ io_A3 & io_A4 | io_A5", 0, null,
        \\sum:
        \\   [0] xor:
        \\      [0] sum:
        \\         [0] signal 10
        \\         [1] product:
        \\            [0] signal 11
        \\            [1] signal 12
        \\      [1] product:
        \\         [0] signal 13
        \\         [1] signal 14
        \\   [1] signal 15
        \\
    );

    try test_build_ir(Device, &names, "io_A0 + io_A1 | io_A2 ^ io_A3 ^ io_A4 | io_A5 + io_A6 ^ io_A7", 0, null,
        \\xor:
        \\   [0] sum:
        \\      [0] xor:
        \\         [0] sum:
        \\            [0] signal 10
        \\            [1] signal 11
        \\            [2] signal 12
        \\         [1] signal 13
        \\         [2] signal 14
        \\      [1] signal 15
        \\      [2] signal 16
        \\   [1] signal 17
        \\
    );

    try test_build_ir(Device, &names, "|A[1:]", 0, null,
        \\sum:
        \\   [0] signal 74
        \\   [1] signal 75
        \\
    );
    
    try test_build_ir(Device, &names, "&A", 0, null,
        \\product:
        \\   [0] signal 74
        \\   [1] signal 75
        \\   [2] signal 76
        \\   [3] signal 77
        \\
    );

    try test_build_ir(Device, &names, "|{A A A}", 0, null,
        \\sum:
        \\   [0] signal 74
        \\   [1] signal 75
        \\   [2] signal 76
        \\   [3] signal 77
        \\
    );

    try test_build_ir(Device, &names, "^{<A B}[<2 5:3]", 0, null,
        \\xor:
        \\   [0] signal 76
        \\   [1] signal 91
        \\   [2] signal 90
        \\   [3] signal 77
        \\
    );

    try test_build_ir(Device, &names, "^{B A}[3:5>2]", 0, null,
        \\xor:
        \\   [0] signal 76
        \\   [1] signal 91
        \\   [2] signal 90
        \\   [3] signal 77
        \\
    );

    try test_build_ir(Device, &names, "^{B A}[5:3 2]", 0, null,
        \\xor:
        \\   [0] signal 76
        \\   [1] signal 77
        \\   [2] signal 90
        \\   [3] signal 91
        \\
    );

    try test_build_ir(Device, &names, "~1", 0, .{}, "zero\n");
    try test_build_ir(Device, &names, "~0", 0, .{}, "one\n");
    try test_build_ir(Device, &names, "~~1", 0, .{}, "one\n");

    try test_build_ir(Device, &names, "io_A0 & 0", 0, .{}, "zero\n");
    try test_build_ir(Device, &names, "io_A0 & 1", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "0 & io_A0", 0, .{}, "zero\n");
    try test_build_ir(Device, &names, "1 & io_A0", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "~io_A0 & io_A0", 0, .{}, "zero\n");
    try test_build_ir(Device, &names, "io_A0 & ~io_A0", 0, .{}, "zero\n");
    try test_build_ir(Device, &names, "io_A0 & (io_A0|io_A1)", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "(io_A0|io_A1) & io_A0", 0, .{}, "signal 10\n");

    try test_build_ir(Device, &names, "io_A0 | 0", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "io_A0 | 1", 0, .{}, "one\n");
    try test_build_ir(Device, &names, "0 | io_A0", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "1 | io_A0", 0, .{}, "one\n");
    try test_build_ir(Device, &names, "~io_A0 | io_A0", 0, .{}, "one\n");
    try test_build_ir(Device, &names, "io_A0 | ~io_A0", 0, .{}, "one\n");
    try test_build_ir(Device, &names, "io_A0 | (io_A0 & io_A1)", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "(io_A0 & io_A1) | io_A0", 0, .{}, "signal 10\n");

    try test_build_ir(Device, &names, "~(A | B)", 0, .{},
        \\product:
        \\   [0] complement: signal 74
        \\   [1] complement: signal 90
        \\
    );

    try test_build_ir(Device, &names, "~(A & B)", 0, .{},
        \\sum:
        \\   [0] complement: signal 74
        \\   [1] complement: signal 90
        \\
    );

    try test_build_ir(Device, &names, "io_A0 & (io_A1|io_A2)", 0, .{},
        \\sum:
        \\   [0] product:
        \\      [0] signal 10
        \\      [1] signal 12
        \\   [1] product:
        \\      [0] signal 10
        \\      [1] signal 11
        \\
    );
    try test_build_ir(Device, &names, "(io_A1|io_A2) & io_A0", 0, .{},
        \\sum:
        \\   [0] product:
        \\      [0] signal 12
        \\      [1] signal 10
        \\   [1] product:
        \\      [0] signal 11
        \\      [1] signal 10
        \\
    );

    try test_build_ir(Device, &names, "A == #5", 0, .{},
        \\product:
        \\   [0] signal 74
        \\   [1] signal 76
        \\   [2] complement: signal 75
        \\   [3] complement: signal 77
        \\
    );

    try test_build_ir(Device, &names, "io_A0 | io_A1 & io_A2 ^ io_A3 & io_A4 | io_A5", 0, .{},
        \\sum:
        \\   [0] signal 15
        \\   [1] product:
        \\      [0] signal 11
        \\      [1] signal 12
        \\      [2] complement: signal 13
        \\   [2] product:
        \\      [0] signal 11
        \\      [1] signal 12
        \\      [2] complement: signal 14
        \\   [3] product:
        \\      [0] signal 10
        \\      [1] complement: signal 13
        \\   [4] product:
        \\      [0] signal 10
        \\      [1] complement: signal 14
        \\   [5] product:
        \\      [0] signal 13
        \\      [1] signal 14
        \\      [2] complement: signal 10
        \\      [3] complement: signal 12
        \\   [6] product:
        \\      [0] signal 13
        \\      [1] signal 14
        \\      [2] complement: signal 10
        \\      [3] complement: signal 11
        \\
    );

    try test_build_ir(Device, &names, "io_A0 + io_A1 | io_A2 ^ io_A3 ^ io_A4 | io_A5 + io_A6 ^ io_A7", 0, .{ .max_xor_depth = 1 },
        \\xor:
        \\   [0] signal 17
        \\   [1] sum:
        \\      [0] signal 15
        \\      [1] signal 16
        \\      [2] product:
        \\         [0] signal 13
        \\         [1] complement: signal 14
        \\         [2] complement: signal 12
        \\         [3] complement: signal 11
        \\         [4] complement: signal 10
        \\      [3] product:
        \\         [0] signal 10
        \\         [1] complement: signal 14
        \\         [2] complement: signal 13
        \\      [4] product:
        \\         [0] signal 11
        \\         [1] complement: signal 14
        \\         [2] complement: signal 13
        \\      [5] product:
        \\         [0] signal 12
        \\         [1] complement: signal 14
        \\         [2] complement: signal 13
        \\      [6] product:
        \\         [0] signal 14
        \\         [1] complement: signal 13
        \\         [2] complement: signal 12
        \\         [3] complement: signal 11
        \\         [4] complement: signal 10
        \\      [7] product:
        \\         [0] signal 12
        \\         [1] signal 13
        \\         [2] signal 14
        \\      [8] product:
        \\         [0] signal 11
        \\         [1] signal 13
        \\         [2] signal 14
        \\      [9] product:
        \\         [0] signal 10
        \\         [1] signal 13
        \\         [2] signal 14
        \\
    );

    try test_build_ir(Device, &names, "(io_A0|io_A1) * (clk0|clk1|clk2|clk3)", 0, .{},
        \\sum:
        \\   [0] product:
        \\      [0] signal 11
        \\      [1] signal 3
        \\   [1] product:
        \\      [0] signal 11
        \\      [1] signal 2
        \\   [2] product:
        \\      [0] signal 11
        \\      [1] signal 1
        \\   [3] product:
        \\      [0] signal 11
        \\      [1] signal 0
        \\   [4] product:
        \\      [0] signal 10
        \\      [1] signal 3
        \\   [5] product:
        \\      [0] signal 10
        \\      [1] signal 2
        \\   [6] product:
        \\      [0] signal 10
        \\      [1] signal 1
        \\   [7] product:
        \\      [0] signal 10
        \\      [1] signal 0
        \\
    );

    try test_build_ir(Device, &names, "~((io_A0|io_A1) * (clk0|clk1|clk2|clk3))", 0, .{},
        \\sum:
        \\   [0] product:
        \\      [0] complement: signal 10
        \\      [1] complement: signal 11
        \\   [1] product:
        \\      [0] complement: signal 3
        \\      [1] complement: signal 2
        \\      [2] complement: signal 1
        \\      [3] complement: signal 0
        \\
    );

    try test_build_ir(Device, &names, "A[{clk1 clk0}]", 0, .{},
        \\sum:
        \\   [0] product:
        \\      [0] complement: signal 0
        \\      [1] complement: signal 1
        \\      [2] signal 74
        \\   [1] product:
        \\      [0] signal 0
        \\      [1] complement: signal 1
        \\      [2] signal 75
        \\   [2] product:
        \\      [0] complement: signal 0
        \\      [1] signal 1
        \\      [2] signal 76
        \\   [3] product:
        \\      [0] signal 0
        \\      [1] signal 1
        \\      [2] signal 77
        \\
    );

    try test_build_ir(Device, &names, "@pad {io_A0 mc_A0}", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "@pad {io_A0 mc_A0}", 1, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "@fb {io_A0 mc_A0}", 0, .{}, "signal 74\n");
    try test_build_ir(Device, &names, "@fb {io_A0 mc_A0}", 1, .{}, "signal 74\n");
    try test_build_ir(Device, &names, "@pad @fb {io_A0 mc_A0}", 0, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "@pad @fb {io_A0 mc_A0}", 1, .{}, "signal 10\n");
    try test_build_ir(Device, &names, "@fb @pad {io_A0 mc_A0}", 0, .{}, "signal 74\n");
    try test_build_ir(Device, &names, "@fb @pad {io_A0 mc_A0}", 1, .{}, "signal 74\n");
}

fn test_build_ir(comptime Device: type, names: *const Device.Names, eqn: []const u8, bit: u6, normalize: ?lp.IR_Data.Normalize_Options, expected: []const u8) !void {
    var ast = try lp.Ast(Device).parse(std.testing.allocator, names, eqn);
    defer ast.deinit();

    _ = try ast.infer_and_check_max_bit(.{});

    var ir_data = try lp.IR_Data.init(std.testing.allocator);
    defer ir_data.deinit();

    var ir_id = try ast.build_ir(&ir_data, bit);

    if (normalize) |options| {
        ir_id = try ir_data.normalize(ir_id, options);
    }

    var temp = std.Io.Writer.Allocating.init(std.testing.allocator);
    defer temp.deinit();

    try ir_data.debug(ir_id, 0, false, &temp.writer);
    try std.testing.expectEqualStrings(expected, temp.written());
}

test "Logic_Parser" {
    const Device = lc4k.LC4064ZE_TQFP100.Device;
    const Signal = Device.Signal;
    var names: Device.Names = .init(std.testing.allocator);
    defer names.deinit();
    const buses = struct {
        pub const A = [_]Device.Signal {
            .mc_A0,
            .mc_A1,
            .mc_A2,
            .mc_A3,
        };
        pub const B = [_]Device.Signal {
            .mc_B0,
            .mc_B1,
            .mc_B2,
            .mc_B3,
        };
    };
    try names.add_names(buses, .{});

    var arena: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer arena.deinit();

    var parser: Device.Logic_Parser = .{
        .gpa = std.testing.allocator,
        .arena = arena.allocator(),
        .names = &names,
    };

    const pt = try parser.pt("clk0 & clk1 & &~A", .{});
    try std.testing.expectEqualDeep(comptime buses.A[3].when_low().pt()
        .and_factor(buses.A[2].when_low())
        .and_factor(buses.A[1].when_low())
        .and_factor(buses.A[0].when_low())
        .and_factor(Signal.clk1.when_high())
        .and_factor(Signal.clk0.when_high())
        , pt);

    const sum = try parser.sum("clk0 | clk1 | &~A", .{});
    try std.testing.expectEqualDeep(comptime &.{
        Signal.clk0.when_high().pt(),
        Signal.clk1.when_high().pt(),
        buses.A[3].when_low().pt().and_factor(buses.A[2].when_low()).and_factor(buses.A[1].when_low()).and_factor(buses.A[0].when_low()),
    }, sum);

    const xor = try parser.logic("clk0 ^ clk1 & clk2", .{});
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum_xor_pt0 = .{
        .pt0 = Signal.clk0.when_high().pt(),
        .sum = &.{ Signal.clk2.when_high().pt().and_factor(Signal.clk1.when_high()) },
        .polarity = .positive,
    }}, xor);

    const xor_inverted = try parser.logic("clk0 ^ (clk1 | clk2)", .{});
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum_xor_pt0 = .{
        .pt0 = Signal.clk0.when_high().pt(),
        .sum = &.{ Signal.clk1.when_low().pt().and_factor(Signal.clk2.when_low()) },
        .polarity = .negative,
    }}, xor_inverted);

    const ptp = try parser.pt_with_polarity("clk0 | clk1 | clk2", .{});
    try std.testing.expectEqualDeep(comptime lc4k.Product_Term_With_Polarity(Signal) {
        .pt = Signal.clk0.when_low().pt().and_factor(Signal.clk1.when_low()).and_factor(Signal.clk2.when_low()),
        .polarity = .negative,
    }, ptp);

    const sum2 = try parser.sum(
        \\   ~clk0 & ~clk1 & ~clk2
        \\ | ~clk0 & ~clk1 & clk2
        \\ | ~clk0 & clk1 & ~clk2
        \\ | clk0 & ~clk1 & clk2
        \\ | clk0 & clk1 & ~clk2
        \\ | clk0 & clk1 & clk2
        , .{});
    try std.testing.expectEqualDeep(comptime &.{
        Signal.clk2.when_low().pt().and_factor(Signal.clk1.when_low()).and_factor(Signal.clk0.when_low()),
        Signal.clk2.when_high().pt().and_factor(Signal.clk1.when_low()).and_factor(Signal.clk0.when_low()),
        Signal.clk2.when_low().pt().and_factor(Signal.clk1.when_high()).and_factor(Signal.clk0.when_low()),
        Signal.clk2.when_high().pt().and_factor(Signal.clk1.when_low()).and_factor(Signal.clk0.when_high()),
        Signal.clk2.when_low().pt().and_factor(Signal.clk1.when_high()).and_factor(Signal.clk0.when_high()),
        Signal.clk2.when_high().pt().and_factor(Signal.clk1.when_high()).and_factor(Signal.clk0.when_high()),
    }, sum2);

    const sum2opt = try parser.sum(
        \\   ~clk0 & ~clk1 & ~clk2
        \\ | ~clk0 & ~clk1 &  clk2
        \\ | ~clk0 &  clk1 & ~clk2
        \\ |  clk0 & ~clk1 &  clk2
        \\ |  clk0 &  clk1 & ~clk2
        \\ |  clk0 &  clk1 &  clk2
        , .{ .optimize = true });
    try std.testing.expectEqualDeep(comptime &.{
        Signal.clk1.when_low().pt().and_factor(Signal.clk0.when_low()),
        Signal.clk2.when_high().pt().and_factor(Signal.clk0.when_high()),
        Signal.clk2.when_low().pt().and_factor(Signal.clk1.when_high()),
    }, sum2opt);

    const sp = try parser.sum_with_polarity(
        \\   ~clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 &  clk3
        \\ |  clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 &  clk1 &  clk2 &  clk3
        , .{ .optimize = false, .dont_care = 
        \\    clk0 & ~clk1 & ~clk2 &  clk3
        \\ |  clk0 &  clk1 &  clk2 & ~clk3
        });
    try std.testing.expectEqualDeep(comptime lc4k.Sum_With_Polarity(Signal) {
        .sum = &.{
            Signal.clk1.when_low().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk3.when_high().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk2.when_high().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk3.when_high().pt().and_factor(Signal.clk2.when_low()),
            Signal.clk3.when_low().pt().and_factor(Signal.clk2.when_high()).and_factor(Signal.clk1.when_high()),
        },
        .polarity = .negative,
    }, sp);

    const logic2 = try parser.logic(
        \\   ~clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 &  clk3
        \\ |  clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 &  clk1 &  clk2 &  clk3
        , .{ .optimize = false, .dont_care = 
        \\    clk0 & ~clk1 & ~clk2 &  clk3
        \\ |  clk0 &  clk1 &  clk2 & ~clk3
        });
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum = .{
        .sum = &.{
            Signal.clk1.when_low().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk3.when_high().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk2.when_high().pt().and_factor(Signal.clk0.when_low()),
            Signal.clk3.when_high().pt().and_factor(Signal.clk2.when_low()),
            Signal.clk3.when_low().pt().and_factor(Signal.clk2.when_high()).and_factor(Signal.clk1.when_high()),
        },
        .polarity = .negative,
    }}, logic2);

    const logic2opt = try parser.logic(
        \\   ~clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 & ~clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 & ~clk3
        \\ |  clk0 & ~clk1 &  clk2 &  clk3
        \\ |  clk0 &  clk1 & ~clk2 & ~clk3
        \\ |  clk0 &  clk1 &  clk2 &  clk3
        , .{ .optimize = true, .dont_care = 
        \\    clk0 & ~clk1 & ~clk2 &  clk3
        \\ |  clk0 &  clk1 &  clk2 & ~clk3
        });
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum = .{
        .sum = &.{
            Signal.clk2.when_high().pt().and_factor(Signal.clk0.when_high()),
            Signal.clk3.when_low().pt().and_factor(Signal.clk2.when_low()).and_factor(Signal.clk1.when_high()),
            Signal.clk3.when_low().pt().and_factor(Signal.clk0.when_high()), // this is a non-essential prime implicant
        },
        .polarity = .positive,
    }}, logic2opt);

    const logic2opt2 = try parser.logic(
        \\~(~clk1 & ~clk0 | clk2 & ~clk0 | clk3 & ~clk0 | clk3 & ~clk2 | ~clk3 & clk2 & clk1)
        , .{ .optimize = true, .dont_care = 
        \\    clk0 & ~clk1 & ~clk2 &  clk3
        \\ |  clk0 &  clk1 &  clk2 & ~clk3
        });
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum = .{
        .sum = &.{
            Signal.clk0.when_high().pt().and_factor(Signal.clk1.when_low()), // this is the other non-essential prime implicant that wasn't used in logic2opt
            Signal.clk3.when_low().pt().and_factor(Signal.clk2.when_low()).and_factor(Signal.clk1.when_high()),
            Signal.clk2.when_high().pt().and_factor(Signal.clk0.when_high()),
        },
        .polarity = .positive,
    }}, logic2opt2);


    const name_overrides = try parser.logic(
        \\asdf | &some_bus
        , .{
            .optimize = true,
            .asdf = Signal.io_A0,
            .some_bus = @as([]const Signal, &.{ .io_A1, .io_A2 }),
        });
    try std.testing.expectEqualDeep(comptime lc4k.Macrocell_Logic(Signal) { .sum = .{
        .sum = &.{
            Signal.io_A0.when_high().pt(),
            Signal.io_A2.when_high().pt().and_factor(Signal.io_A1.when_high()),
        },
        .polarity = .positive,
    }}, name_overrides);

}

const lp = lc4k.logic_parser;
const lc4k = @import("lc4k");
const std = @import("std");
