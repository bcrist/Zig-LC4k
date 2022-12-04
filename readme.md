# Lattice ispMach4000 CPLD configuration in Zig

A library for creating configuration bitstreams for LC4k CPLDs, using Zig code.  It allows for lower-level control and fewer
abstractions than a Verilog/VHDL/CUPL/ABEL based design toolchain would, so you can tell the hardware to do exactly what you
want, and get the most out of these constrained devices.

This project uses reverse-engineered fuse maps from the [RE4k](https://github.com/bcrist/re4k) project.  When running tests
or regenerating the device data files, it's assumed that this repo's checkout will be as a submodule of RE4k's checkout, but
only this repo needs to be checked out to build CPLD configurations.

## Device List

|            |TQFP44|TQFP48|TQFP100|TQFP128|TQFP144|csBGA56|csBGA64|csBGA132|csBGA144|ucBGA64|ucBGA132|
|:-----------|:----:|:----:|:-----:|:-----:|:-----:|:-----:|:-----:|:------:|:------:|:-----:|:------:|
|LC4032V/B/C | ✔️    | ✔️    |       |       |       |       |       |        |        |       |        |
|LC4032ZC    |      | ✔️    |       |       |       | ✔️     |       |        |        |       |        |
|LC4032ZE    |      | ✔️    |       |       |       |       | ✔️     |        |        |       |        |
|LC4064V/B/C | ✔️    | ✔️    | ✔️     |       |       |       |       |        |        |       |        |
|LC4064ZC    |      | ✔️    | ✔️     |       |       | ✔️     |       | ✔️      |        |       |        |
|LC4064ZE    |      | ✔️    | ✔️     |       |       |       | ✔️     |        | ✔️      | ✔️     |        |
|LC4128V     |      |      | ✔️     | ✔️     | ✔️     |       |       |        |        |       |        |
|LC4128B/C   |      |      | ✔️     | ✔️     |       |       |       |        |        |       |        |
|LC4128ZC    |      |      | ✔️     |       |       |       |       | ✔️      |        |       |        |
|LC4128ZE    |      |      | ✔️     |       | ✔️     |       |       |        | ✔️      |       | ✔️      |

LC4256 and larger devices are not supported at this time.  Automotive (LA4xxx) variants may or may not
use the same fusemaps as their LC counterparts, but please don't use this project for any automotive or
other safety-critical application.

# TODO
* Assembly error reporting
* Tests
* JedecData disassembly
* Report generation from JedecData (Functional & Timing)
* ease of use: PTs.eql, PTs.any?
* ease of use: helpers to set up common MC configurations?
* How-To in readme
* More examples - larson scanner, 16:1 mux, address decoder, adder?