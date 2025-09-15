`timescale 1ns/10ps

/**
 * This module should count the positive and negative edges of the incoming signal and output the
 * accumulated value on "posedge_count" and "negedge_count". To pass the test, you should update
 * the value of posedge_count the clock cycle AFTER the signal actually transitions, e.g.
 *          _   _   _
 * clk     | |_| |_| |_|
 *             _________
 * signal _____|
 *
 * poscnt  0   0   1   1
 *
 * You do not need to handle overflow on the counts.
 *
 * You can assume that the incoming signal is synchronous with the provided clock signal;
 * it will only toggle on the rising edge of the incoming clock. It will not toggle more than once
 * per clock signal.
 *
 * Restrictions:
 *   - For this exercise, you may ONLY use @(posedge clk). You MAY NOT write @(posedge sig) or
 *     @(negedge sig). Trigging at an edge other than a clock edge might feel clever but it almost
 *     always leads to massive headaches.
 */
module edge_counter #(
    parameter WIDTH=32
)  (
    input clk,
    input reset,

    // signal whose edges are to be counted
    input signal,

    // How many positive and negative edges have we counted since the last reset?
    output logic [WIDTH-1:0] posedge_count,
    output logic [WIDTH-1:0] negedge_count
);

endmodule
