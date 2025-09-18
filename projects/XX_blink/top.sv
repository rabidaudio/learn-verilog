`include "../00_pwm_generator/ResetGenerator.sv"

module top #(
    parameter CLOCK_SPEED = 12*1000*1000, // 12MHz
    parameter RESET_AFTER = 'hFFFF
) (
    input clk,
    output logic [2:0] led_rgb_o
);

    logic reset;
    ResetGenerator #(.AFTER(RESET_AFTER)) system_reset_module (
        .clk(clk),
        .reset(reset)
    );

    logic [$clog2(CLOCK_SPEED):0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            led_rgb_o <= '1;
            counter <= 0;
        end else begin
            if (counter == 0) begin 
                led_rgb_o[0] <= ~led_rgb_o[0];
                counter <= CLOCK_SPEED;
            end else counter <= counter - 1;
        end
    end

endmodule
