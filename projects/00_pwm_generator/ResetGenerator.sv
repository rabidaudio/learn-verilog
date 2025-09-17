`pragma once

/**
 * This utility module will emit a reset signal shortly after power-up.
 * It takes advantage of the iCE40's initial / reset capabilities on
 * power-up.
 */
module ResetGenerator (
    input clk,
    output logic reset
);
    logic [15:0] reset_counter;
    initial reset_counter = 0;
    initial reset = 0;

    always_ff @(posedge clk) begin
        if (reset_counter != '1) begin
            reset_counter <= reset_counter + 1;
        end else begin
            reset <= 1;
        end
    end
endmodule
