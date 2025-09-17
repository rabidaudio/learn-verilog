`ifndef _BrightnessStepper_
`define _BrightnessStepper_

module BrightnessStepper #(
    parameter STEPS = 1024,
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    output logic [WIDTH-1:0] brightness
);

    logic [($clog2(STEPS)-1):0] step;
    logic rising;

    always_ff @(posedge clk) begin
        if (reset) begin
            step <= STEPS-1;
            rising <= 1;
            brightness <= 0;
        end else begin
            brightness <= rising ? brightness + 1 : brightness - 1;

            if (step == 0) begin
                rising <= ~rising;
                step <= STEPS - 1;
            end else step <= step - 1;
        end
    end
endmodule

`endif // _BrightnessStepper_
