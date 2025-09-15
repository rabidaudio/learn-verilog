`timescale 1ns/10ps

/**
 * Design a module which takes in an array of NUM_INPUTS 8-bit inputs.
 * The input indexed by 'addr' should be routed to the output.
 *
 * Your solution should consist of a single always_comb block.
 *
 * Note: $clog2() is a synthesis-time function that takes the ceiling of the log2 of a
 * number. It's useful for computing the width needed to represent a signal.
 */
module parameterizable_multiplexer #(
    parameter NUM_INPUTS = 8
)  (
    // array of signals to route to the output
    input [7:0] din [NUM_INPUTS],

    // which input signal should be sent to the output?
    input [$clog2(NUM_INPUTS)-1:0] addr,

    // output data
    output logic [7:0] dout
);

    always_comb dout = din[addr];

endmodule
