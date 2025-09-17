#/usr/bin/env sh
set -e -x
iverilog -g2012 -o test.vvp main.test.sv
./test.vvp
