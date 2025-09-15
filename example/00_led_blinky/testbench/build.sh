#!/bin/bash

# Run this script to use iverilog to produce an executable that will simulate your design
#     -g2012 tells iverilog to interpret the file as SystemVerilog, not regular Verilog.
#     -o tells iverilog what to name the output file.
#     Aside from that, we list the files in the order that we want them to be read in.
iverilog -g2012 ./top_tb.sv ../top.sv -o test.vvp

# Run the executable produced by iverilog.
# This actually runs the simulation and produces
./test.vvp

echo "Now run"
echo "    gtkwave results.vcd"
echo "to see the results of your simulation."
