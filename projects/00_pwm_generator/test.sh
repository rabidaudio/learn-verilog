#!/bin/zsh
set -e -x
iverilog -g2012 -o test.vvp testbench.sv
./test.vvp
