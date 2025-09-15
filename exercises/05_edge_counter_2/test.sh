#!/bin/bash
iverilog -g2012 tb.sv top.sv -o test.vvp
./test.vvp
