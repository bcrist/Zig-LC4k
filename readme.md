# Lattice ispMach4000 CPLD configuration in Zig

A library for creating and manipulating configuration bitstreams for LC4k CPLDs, using Zig code.

This project uses reverse-engineered fuse maps from the [RE4k](https://github.com/bcrist/re4k) project.

## Device List

|            |TQFP44|TQFP48|TQFP100|TQFP128|TQFP144|csBGA56|csBGA64|csBGA132|csBGA144|ucBGA64|ucBGA132|
|:-----------|:----:|:----:|:-----:|:-----:|:-----:|:-----:|:-----:|:------:|:------:|:-----:|:------:|
|LC4032V/B/C | ✔️  | ✔️   |       |       |       |       |       |        |        |       |        |
|LC4032ZC    |      | ✔️   |       |       |       | ✔️   |       |        |        |       |        |
|LC4032ZE    |      | ✔️   |       |       |       |       | ✔️   |        |        |       |        |
|LC4064V/B/C | ✔️  | ✔️   | ✔️    |       |       |       |       |        |        |       |        |
|LC4064ZC    |      | ✔️   | ✔️   |       |       | ✔️    |       | ✔️    |        |       |        |
|LC4064ZE    |      | ✔️   | ✔️   |       |       |       | ✔️    |        | ✔️    | ✔️    |        |
|LC4128V     |      |      | ✔️    | ✔️   | ✔️    |       |       |        |        |       |        |
|LC4128B/C   |      |      | ✔️    | ✔️   |       |       |       |        |        |       |        |
|LC4128ZC    |      |      | ✔️    |       |       |       |       | ✔️    |        |       |        |
|LC4128ZE    |      |      | ✔️    |       | ✔️   |       |       |        | ✔️     |       | ✔️    |

LC4256 and larger devices are not supported at this time.  Automotive (LA4xxx) variants may or may not
use the same fusemaps as their LC counterparts, but please don't use this project for any automotive or
other safety-critical applications.

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
const file_contents = try std.fs.cwd().readFileAlloc(allocator, "path/to/bitstream_file.jed", 1000000);
const bitstream = try lc4k.LC4032ZE_TQFP48.parse_jed(allocator, file_contents);
const results = try lc4k.LC4032ZE_TQFP48.disassemble(allocator, bitstream);
const chip = results.config;
```

Note that this library does not and will not provide support for synthesizing a design from Verilog, VHDL, ABEL, or any other HDL.  It is my opinion that such workflows often don't allow sufficient control over how the limited hardware resources are utilized, and designs that will fit in 32-128 macrocell CPLDs are rarely complex enough where such an abstracted representation is necessary.

Once you have your in-memory representation of the design, you can do a number of things with it:

* Generate an HTML report detailing the design, including timing information.
* Export the design as a JEDEC or SVF file for programming devices.
* (Planned) Export a Verilog model of the design for simulation/validation/etc.
* Write your own Zig code that does whatever you want.

# TODO
* Error when PT4 is needed for ORM routing, but pt4_oe fuse is not cleared
* Error when there are duplicate sum PTs or they can be simplified
* Tests
* ease of use: PTs.parse() []PT
* ease of use: helpers to set up common MC configurations?
* Verilog export
* Logic simulation/verification
* "clocks used" not accounting for BCLKs?