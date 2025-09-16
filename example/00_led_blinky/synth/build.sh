#!/bin/bash

yosys -s synth.yosys
nextpnr-ice40 \
    --up5k --package sg48 \
    --randomize-seed \
    --pcf pins.pcf --json blinky.json \
    --opt-timing --tmg-ripup \
    --asc blinky.asc
icepack blinky.asc blinky.bin
