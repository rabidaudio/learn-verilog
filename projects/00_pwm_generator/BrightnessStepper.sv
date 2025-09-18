`ifndef _BrightnessStepper_
`define _BrightnessStepper_

/**
 * BrightnessStepper counts brightness up from 0 to PEAK,
 * then back down to 0, every `STEPS` clock cycles.
 */
module BrightnessStepper #(
    parameter STEPS = 1024,
    parameter PEAK = 255
) (
    input clk,
    input reset,
    output logic [($clog2(PEAK)-1):0] brightness
);

    // counts down to zero to inc/dec brightness
    logic [($clog2(STEPS-1)-1):0] step;
    // wether is brightness counting up or down
    logic rising;

    always_ff @(posedge clk) begin
        if (reset) begin
            step <= STEPS-1;
            rising <= 1;
            brightness <= 0;
        end else begin
            if (step == 0) begin
                step <= STEPS - 1;
                brightness <= rising ? brightness + 1 : brightness - 1;
                if (brightness == PEAK || brightness == 0) begin
                    rising <= ~rising;
                end
            end else step <= step - 1;
        end
    end
endmodule

`endif // _BrightnessStepper_
