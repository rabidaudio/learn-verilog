# Example

A minimal annotated example verilog design for the [iCE Sugar FPGA dev board](https://web.archive.org/web/20230314133315/https://www.tindie.com/products/johnnywu/icesugar-fpga-development-board/) featuring a
Lattice iCE40UP5k FPGA.

## Top-level design
The file containing the actual source code for the digital design demonstrated here is in top.sv in this directory.

## Testbench
Unlike software, which is often debugged by running it on the target hardware, 90+% of digital logic debugging

that includes a toplevel verilog design, a testbench, and a script
to use yosys for synthesizing for the design