`timescale 1ns/10ps

/**
 * In this exercise you'll drive an array of LEDs so that a horizontal bouncing bar is visualized.
 * The bar, a row of contiguous lit LEDs, should start moving leftward until it reaches the far
 * side of the display, then on the next clock cycle it should turn around and come back to the
 * start, bouncing forever.
 *
 * For instance, if we have 6 leds and 3 of them are lit, the bouncing bar should look like this
 *
 *    ***---
 *    -***--
 *    --***-
 *    ---***
 *    --***-
 *    -***--
 *  etc...
 *
 * where '*' denotes a lit led and '-' denotes a dimmed led.
 *
 * Your module outputs LED signals through a single bit vector.
 *
 * Each clock cycle that 'advance' is high, the LED animation should be advanced by one step.
 *
 * The number of output LEDs and the width of the illuminated bar are both parameterizable, but
 * you can assume that LIT_WIDTH will always be <= OUTPUT_WIDTH.
 *
 * If the parameter LATE_TURNAROUND is set, then the bar should continue moving even after it hits
 * the edge of the screen. It should only turn around when a single LED is left illuminated.
 * E.g.
 *       LATE_TURNAROUND = 0            LATE_TURNAROUND = 1
 *
 *            ***---                         ***---
 *            -***--                         -***--
 *            --***-                         --***-
 *            ---***                         ---***
 *            --***-                         ----**
 *            -***--                         -----*
 *            ***---                         ----**
 *            -***--                         ---***
 *            --***-                         --***-
 *            ---***                         -***--
 *            --***-                         ***---
 *            -***--                         **----
 *     etc...
 */
module led_scanner_bar #(
    // How many LED outputs will your module have?
    parameter OUTPUT_WIDTH = 8,

    // How many LEDs will be lit at once?
    parameter LIT_WIDTH = 3,

    // Should the lit LED bar turn around as soon as it hits the edge, or should it go until
    // it's almost off-screen (a single illuminated LED remains).
    parameter OUTPUT_OVERLAP = 0
)  (
    input clk,
    input reset,

    input advance,

    output [OUTPUT_WIDTH-1:0] screen
);

endmodule
