`timescale 1ns/10ps

/**
 * Debounce the input button. The output should be as low-latency as possible. As soon as the input
 * changes, the output should change on the following clock cycle as long as the signal isn't
 * bouncing.
 *
 * If the button is in a stable state (the button has been stable for longer than
 * 'min_pulse_width' clocks), then the output should switch right after the input switches (i.e.
 * the next clock cycle after the input changes).
 * If the button is currently bouncing, then the output should remain stable.
 * An input is considered stable once 'min_pulse_width' clocks has passed.
 *
 * A new value can be programmed for 'min_pulse_width' directly by setting the 'min_pulse_width'
 * input. This value may be kept at a constant by the instantiating hardware or can be changed
 * at any time.
 */
module button_debouncer (
    input clk,
    input reset,

    // signal whose edges are to be counted
    input signal,

    // what should the minimum pulse width be?
    input [15:0] min_pulse_width,

    // How many positive and negative edges have we counted since the last reset?
    output logic debounced_signal
);

endmodule
