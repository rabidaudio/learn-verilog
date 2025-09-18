`ifndef _BrightnessStepper_
`define _BrightnessStepper_

/**
 * BrightnessStepper counts brightness up from 0 to `PEAK_BRIGHTNESS`,
 * then back down to 0, every `IDLE_TIME` clock cycles.
 */
module BrightnessStepper #(
    parameter IDLE_TIME = 1024,
    parameter PEAK_BRIGHTNESS = 255
) (
    input clk,
    input reset,
    output logic [($clog2(PEAK_BRIGHTNESS)-1):0] brightness
);

    // counts down to zero to inc/dec brightness
    logic [($clog2(IDLE_TIME-1)-1):0] idle_counter;

    // wether brightness is increasing or decreasing
    logic rising;

    always_ff @(posedge clk) begin
        if (reset) begin
            idle_counter <= IDLE_TIME - 1;
            rising <= 1;
            brightness <= 0;
        end else begin
            if (idle_counter == 0) begin
                idle_counter <= IDLE_TIME-1;

                if (brightness == 0) begin
                    rising <= 1;
                    brightness <= 1;
                end else if (brightness == PEAK_BRIGHTNESS) begin
                    rising <= 0;
                    brightness <= PEAK_BRIGHTNESS -1;
                end else begin
                    brightness <= rising ? brightness + 1 : brightness - 1;
                end
            end else begin
                idle_counter <= idle_counter - 1;
            end
        end
    end
endmodule

`endif // _BrightnessStepper_
