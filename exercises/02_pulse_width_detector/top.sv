`timescale 1ns/10ps

/**
 * This module should count the width of a pulse in clock cycles.
 *
 * The cycle after the falling edge of each pulse, the 'pulse_width_detector' module should strobe
 * 'output_valid' high for a single clock cycle and present the width of the detected pulse in
 * clock cycles.
 *
 * You can assume that the input signal will always be synchronous with the input clock. It will
 * only change on the rising edge of the input clock.
 */
module pulse_width_detector (
    input clk,
    input reset,

    // signal whose pulse width is to be counted.
    input signal,

    // this signal should be strobed high for a single clock cycle when a pulse has finished to
    // indicate that a valid output count is on 'pulse_width'
    output logic output_valid,
    output logic [15:0] pulse_width
);

endmodule
