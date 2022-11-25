# Lattice ispMach4000 CPLD configuration in Zig

A library for creating configuration bitstreams for LC4k CPLDs, using Zig code.  It allows for lower-level control and fewer annoying
abstractions than Verilog/VHDL/ABEL based design toolchains, so you can tell the hardware to do exactly what you want, and get the most
out of these constrained devices.

Uses reverse-engineered fuse maps from the [RE4k](https://github.com/bcrist/re4k) project.

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

LC4256 and larger devices are not supported at this time.  Automotive (LA4xxx) variants likely use
the same fusemaps as their LC counterparts, but that's just conjecture.  Please don't use this
project for any automotive or other safety-critical application.

# TODO
* Bitstream configuration
* Bitstream decompilation
