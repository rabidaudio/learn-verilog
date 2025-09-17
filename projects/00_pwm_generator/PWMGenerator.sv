`pragma once

/**
 * This module should generate a pwm output signal. The period and duty cycle of the pwm signal
 * should be determined by the input parameters 'pwm_period' and 'pwm_duty_cycle', both measured
 * in clock cycles.
 *
 * The default period and duty cycle should be 256 and 0, respectively on reset.
 */
module PWMGenerator #(
    parameter WIDTH=16
)  (
    input clk,
    input reset,

    // Whenever 'update_parameters' is strobed high for a cycle, update the module's period and
    // duty cycle according to the 'pwm_period' and 'pwm_duty_cycle' inputs.
    // Changes will occur on the following cycle.
    input update_parameters,

    // How many clock cycles long should each pwm cycle be?
    input [WIDTH-1:0] pwm_period,

    // For how many clock cycles should the pwm output signal be high?
    // Duty cycles are permitted to be 0% to 100% inclusive, i.e. pwm_duty_cycle=[0, pwm_period].
    input [WIDTH-1:0] pwm_duty_cycle,

    // TODO: use PRS generator instead:
    // https://www.isotel.eu/mixedsim/intro/prssine.html
    output logic pwm,
    // high for one cycle at the start of a new period
    output logic period_start
);
    logic [WIDTH-1:0] next_period;
    // Extra credit:
    //     How many bits are actually needed to store this value? If we have, say, a
    //     16-bit PWM module, is 16 bits enough to store the PWM duty cycle? Why or why not?
    logic [WIDTH-1:0] next_duty_cycle;

    logic [WIDTH-1:0] end_counter;
    logic [WIDTH-1:0] high_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            next_period <= '1 / 2;
            next_duty_cycle <= 0;
            end_counter <= 0;
            high_counter <= 0;
        end else begin
            if (update_parameters) begin
                next_period <= pwm_period;
                next_duty_cycle <= pwm_duty_cycle;
            end
            if (end_counter == 0) begin
                // start a new cycle
                end_counter <= next_period;
                high_counter <= next_duty_cycle;
                period_start <= 1;
            end else begin
                end_counter <= end_counter - 1;
                if (high_counter == 0) begin
                    pwm <= 0;
                end else begin
                    high_counter <= high_counter - 1;
                    pwm <= 1;
                end
                period_start <= 0;
            end
        end
    end
endmodule
