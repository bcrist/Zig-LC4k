# Lattice ispMach4000 CPLD configuration in Zig

A library for creating and manipulating configuration bitstreams for LC4k CPLDs, using Zig code.

This project uses reverse-engineered fuse maps from the [RE4k](https://github.com/bcrist/re4k) project.  When running tests or regenerating the device data files, it's assumed that this repo's checkout will be as a submodule of RE4k's checkout, but otherwise only this repo needs to be checked out.

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

To use this library, import `lc4k` and create an instance of one of the device data structures defined there.  This can be done in two ways:

* Manually initialize the macrocells and other configuration necessary to define your design, using Zig code as a low-level pseudo-HDL.
* Load an existing bitstream/JEDEC file.

Note that this library does not and will not provide support for synthesizing a design from Verilog, VHDL, ABEL, or any other HDL.  In many cases, such workflows don't allow sufficient control over how the limited hardware resources are utilized, and designs that will fit in these devices are generally not complex enough where such an abstracted representation is necessary to understand the design.

Once you have your in-memory representation of the design, you can do a number of things with it:

* Generate an HTML report detailing the design, including timing information.
* Export the design as a JEDEC or SVF file for programming devices.
* (Planned) Export a Verilog model of the design for simulation/validation/etc.
* Write your own Zig code that does whatever you want.

# TODO
* Assembly error reporting
* Error when PT4 is needed for ORM routing, but pt4_oe fuse is not cleared
* Error when there are duplicate sum PTs or they can be simplified
* More examples - 16:1 mux, address decoder, 74x181?
* Rename GRP -> Signal
* Tests
* ease of use: PTs.parse() []PT
* ease of use: helpers to set up common MC configurations?
* How-To in readme
* Verilog export
