`pragma once

/**
 * This module should generate a pwm output signal. The period and duty cycle of the pwm signal
 * should be determined by the input parameters `pwm_period` and `pwm_duty_cycle`, both measured
 * in clock cycles.
 */
module PWMGenerator #(
    parameter WIDTH=16,
    parameter INITIAL_PERIOD=(1<<WIDTH)-1,
    parameter INITIAL_DUTY=((1<<WIDTH)-1)/2
)  (
    input clk,
    input reset,

    // when pulled high, `pwm_period` and `pwm_duty_cycle` inputs are updated, to be used
    // the following cycle
    input update_parameters,

    // clock cycles+1 for one period
    input [WIDTH-1:0] pwm_period,

    // clock cycles for high value, permitted to be 0% to 100% inclusive, i.e. 0 to `pwm_period`
    input [WIDTH-1:0] pwm_duty_cycle,

    // output signal
    // TODO: use PRS generator instead:
    // https://www.isotel.eu/mixedsim/intro/prssine.html
    output logic pwm,

    // pulled high at the start of a new period
    output logic period_start
);
    // the period to use for the next cycle
    logic [WIDTH-1:0] next_period;

    // the duty cycle for the next cycle
    logic [WIDTH-1:0] next_duty_cycle;

    // counts down to zero to track period
    logic [WIDTH-1:0] period_counter;
    // counts down to zero to track high portion of period
    logic [WIDTH-1:0] high_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            next_period <= INITIAL_PERIOD;
            next_duty_cycle <= INITIAL_DUTY;
            period_counter <= 0;
            high_counter <= 0;
            pwm <= 0;
        end else begin
            if (update_parameters) begin
                next_duty_cycle <= pwm_duty_cycle;
            end

            if (period_counter == 0) period_counter <= next_period;
            else period_counter <= period_counter - 1;

            if (period_counter == 0) period_start <= 1;
            else period_start <= 0;

            if (period_counter == 0)
                high_counter <= (update_parameters ? pwm_duty_cycle : next_duty_cycle);
            else if (high_counter > 0) high_counter <= high_counter - 1;
            else high_counter <= 0;

            pwm <= (high_counter > 0);
        end

        // if (reset) begin
        //     next_period <= (1 << (WIDTH-1)); // half width
        //     next_duty_cycle <= 0;
        //     period_counter <= 0;
        //     high_counter <= 0;
        // end else begin
        //     if (update_parameters) begin
        //         next_period <= pwm_period;
        //         if (pwm_duty_cycle > pwm_period) next_duty_cycle <= pwm_period;
        //         else next_duty_cycle <= pwm_duty_cycle;
        //     end

        //     if (period_counter == 0) begin
        //         // start a new cycle
        //         period_counter <= next_period - 1; // count current cycle
        //         high_counter <= next_duty_cycle;
        //         period_start <= 1;
        //     end else begin
        //         period_counter <= period_counter - 1;
        //         if (high_counter > 0) begin
        //             high_counter <= high_counter - 1;
        //         end
        //         pwm <= (high_counter > 0);
        //         period_start <= 0;
        //     end
        // end
    end
endmodule
