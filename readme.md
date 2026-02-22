# Lattice ispMach4000 CPLD configuration in Zig

A library for creating and manipulating configuration bitstreams for LC4k CPLDs, using Zig code.

This project uses reverse-engineered fuse maps from the [RE4k](https://github.com/bcrist/re4k) project.

## Device Support

All LC4032, LC4064, and LC4128 device variants are supported, including -V, -B, -C, -ZC, and -ZE variants.
LC4256 and larger devices are not supported at this time.
Automotive (LA4xxx) variants may or may not use the same fusemaps as their LC counterparts, but please don't use this project for any automotive or other safety-critical applications.

## Usage

Add the library to your project through the Zig package manager:

```
zig fetch --save git+https://github.com/bcrist/zig-lc4k
```

In your `build.zig`, you can then add an import for the `lc4k` module:

```zig
my_exe.root_module.addImport("lc4k", b.dependency("LC4k", .{}).module("lc4k"));
```

## Workflow
To use the library, you first need to construct one of the device configuration structs defined in the `lc4k` module (e.g. `lc4k.LC4032ZE_TQFP48`).  Usually this is done manually, initializing the macrocells and other configuration necessary to define your design, using Zig code as a low-level pseudo-HDL.  Check the examples directory for more details.  You can also load an existing bitstream/JEDEC file, e.g. for reverse engineering:

```zig
const Device = lc4k.LC4032ZE_TQFP48;
const bitstream = try Device.parse_jed_file(io, "path/to/bitstream_file.jed", allocator);
const results = try Device.disassemble(allocator, bitstream);
const chip = results.config;
```

Note that while this library includes a basic expression parser, it does not and will not support synthesizing a design from Verilog, VHDL, ABEL, or any other HDL.  It is my opinion that such workflows often don't allow sufficient control over how the limited hardware resources are utilized, and designs that will fit in 32-128 macrocell CPLDs are rarely complex enough where such an abstracted representation is necessary.

Once you have your in-memory representation of the design, you can do a number of things with it:

* Generate an HTML report detailing the design, including timing information.
* Export the design as a JEDEC or SVF file for programming devices.
* Simulate your design or write tests to verify its functionality.
* Write your own Zig code that does whatever you want.

## Logic Parser
An expression parser is included as a more convenient way to define the logic to assign to a particular macrocell, compared to manually defining product terms with, e.g. `signal.when_high().pt().and_factor(...)` which can quickly become hard to read.  To use the logic parser, you will need three things:
* A general purpose allocator used for temporary data needed while parsing (does not retain any allocations between calls to the parser).
* An arena used to allocate the final results of parsing (arrays of product terms and factors).
* A `*const Names` used to map identifiers within expressions to device signals.
For examples of initializing a parser, check the [examples](https://github.com/bcrist/Zig-LC4k/blob/main/examples/adder/main.zig#L129).

Once you have a parser, there are several ways to parse an expression:
* `Logic_Parser.pt(equation, options)`: Generates a single product term, suitable for assignment to a GLB config's `shared_pt_enable`, etc.
* `Logic_Parser.pt_with_polarity(equation, options)`: Generates a single product term, suitable for assignment to a GLB config's `shared_pt_clock`, etc, where the product term can be inverted to support sum expressions.
* `Logic_Parser.sum(equation, options)`: Generates an array of product terms, for use when you want to process the results more before using them
* `Logic_Parser.sum_with_polarity(equation, options)`: Generates an array of product terms suitable for assignment to `five_pt_fast_bypass`, etc, where the result can be inverted to support product-of-sums expressions.
* `Logic_Parser.logic(equation, options)`: Suitable for assignment to a macrocell config's `logic` field.
* `Logic_Parser.assign_logic(chip, mc_signals, equation, options)`: Unlike all the previous functions, this form allows the final result of the equation to have multiple bits.  Rather than returning the parsed logic, it will automatically assign each bit of the result to the macrocell logic field corresponding to the same bit in the `mc_signals` array.

When the `logic` or `assign_logic` forms are used, it will attempt to use the logic mode which uses the fewest resources:
* If the equation or its complement use only one product term, then `pt0` or `pt0_inverted` will be used so that the macrocell's other PTs can be routed to another cluster.
* If the "top level" operation in the equation is an XOR, and one side of it (or its complement) uses only one PT, then `sum_xor_pt0` or `sum_xor_pt0_inverted` will be used, unless `sum` or `sum_inverted` would use fewer total PTs.
* Otherwise `sum` or `sum_inverted` will be used (whichever uses fewer total PTs).
Note: the `input_buffer` and `sum_xor_input_buffer` modes will never be generated.

### Parser Options
* `Options.max_product_terms`: Allows limiting the number of product terms that can be produced before an error will be generated.  By default, up to 80 PTs can be generated (the maximum that exist in each GLB)
* `Options.optimize`: When enabled, expressions will be optimized using the Quine-McCluskey-Petrick method.  This optimization is exponential in time and space complexity, so it is not enabled by default.  When disabled, expressions will be normalized if they are not in sum-of-products form, and many symbolic simplifications will be performed if possible, but there is no guarantee that the minimum number of product terms will be used.
* `Options.dont_care`: When optimization is enabled, a secondary equation can be provided here to indicate conditions where the result does not matter.  The optimizer may then be able to use fewer product terms.

Options are passed to the the `Logic_Parser` through an `anytype` parameter.  Arbitrary additional names can be defined in this struct and they can be used in the expression as if they had been defined in the `Names` struct.
See the [gray code counter](https://github.com/bcrist/Zig-LC4k/blob/main/examples/gray_code/main.zig#L67) example for a demonstration of this.

### Parser Syntax

```
;;;; Basics ;;;;

; Anything between a semicolon and the next LF (\n) character is considered a comment.

abcd ; Identifiers represent named signals or buses, defined by the Names struct.
a123 ; Identifiers may contain ASCII letters, digits, "_", ".", or "$" but may not start with a digit.

0    ; Literals are numeric constants representing specific bit patterns.
123  ; Decimal literals are considered to have the minimum number of bits required to store their value.
8'0  ; You can specify the number of bits before the literal value by separating them with the
     ; single-quote ('), similar to Verilog.
0xFF ; You can specify hex literals with the "0x" or "0h" prefixes (they are all equivalent).
#FF  ; You can also use the "#" character prefix to indicate a hex literal.
0o77 ; Octal literals can be specified with "0o".
0b11 ; And binary literals with "0b".
'hFF ; Just "h", "x", "o", or "b" works, as long as it's not the very first character of the literal.
     ; All literals must start with a digit, "'", "-", or "#".
8'xF ; Hex/octal/binary literal bits = log2(base) * num_digits, but this can be overridden.

(expr) ; Parentheses can be used to group subexpressions.

;;;; Operations ;;;;
; Listed in order of increasing binding power.

A | B ; Bitwise OR.  A and B must have the same bit width or one of them must have width of 1 bit.
A + B ; Bitwise OR (alternate style)
A ^ B ; Bitwise XOR.  A and B must have the same bit width or one of them must have width of 1 bit.
      ; When mixed, OR and XOR operations are performed from left to right.

A & B ; Bitwise AND.  A and B must have the same bit width or one of them must have width of 1 bit.
A * B ; Bitwise AND (alternate style)

A == B ; Syntactic sugar for &~(A^B).  A and B must have same width; the result will always be 1 bit.
A != B ; Syntactic sugar for |(A^B).  A and B must have same width; the result will always be 1 bit.

~ A    ; Ones' complement.  The result will have the same bit width as A.
! A    ; Ones' complement (alternate style)
| A    ; Condensing OR.  A may have any bit width; the result will always be 1 bit.
+ A    ; Condensing OR (alternate style)
^ A    ; Condensing XOR (even parity generator).  A may have any width; the result will always be 1 bit.
& A    ; Condensing AND.  A may have any bit width; the result will always be 1 bit.
* A    ; Condensing AND (alternate style)
@pad A ; Converts any macrocell feedback signals in A to the corresponding macrocell's I/O pad signal.
@fb A  ; Converts any macrocell I/O signals in A to the corresponding macrocell's feedback signal.

; Extraction operator:
A[0]       ; Extract bit 0.  The LSB has index 0.
A[7 5 3]   ; Extract and concatenate bits 7, 5, and 3.  Bit 3 will be the LSB of the result.
A[3 5 7]   ; Illegal; indices must be listed in big-endian order to avoid accidentally swapping signals.
A[>7 5 3]  ; Same as above; explicitly calls out big-endian ordering of concatenation.
A[7>5>3]   ; Same as above; > can be duplicated and placed anywhere within [ ].
A[<3 5 7]  ; Same as above; using little-endian ordering.
A[<7 5 3]  ; Swapping relative order of bits is allowed when endianness is explicit.
A[7:4]     ; Extract bits 4-7, both endpoints inclusive.  Bit 4 will be the LSB of the result.
A[>7:4]    ; Same as above; explicitly big-endian.
A[<4:7]    ; Same as above; explicitly little-endian.
A[<7:4]    ; Extract bits 4-7, reversed.  Bit 7 will be the LSB and bit 4 the MSB.
A[>4:7]    ; Same as above; using big-endian ordering.
A[4:7]     ; Illegal; endianness must be explicit when extracting a reversed range.
A[:]       ; Endpoints that are omitted are assumed to be either 0 or bits(A)-1.
A[7 3 1:0] ; Individual bits and ranges can be mixed and matched.
A[B]       ; Define a mux by using an identifier instead of a constant.  bits(A) must == 2^bits(B).
A[B C]     ; Illegal; only a single non-constant expression is allowed for muxes.

; Concatenation operator:
{A B}   ; Concatenate A and B.  B[0] will be the LSB of the result.
{>A B}  ; Same as above; explicitly calls out big-endian ordering.
{<A B}  ; Concatenate A and B; little-endian.  A[0] will be the LSB of the result.
{A B C} ; Any number of expressions can be concatenated at once.
```
