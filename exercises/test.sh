#!/bin/bash
iverilog -g2012 -o test.vvp tb.sv top.sv
./test.vvp
