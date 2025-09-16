`timescale 1ns/100ps


/**
 * This utility module will emit a reset signal shortly after power-up.
 * It takes advantage of the iCE40's initial / reset capabilities on
 * power-up.
 */
module reset_generator (
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

/**
 * This module should generate a pwm output signal. The period and duty cycle of the pwm signal
 * should be determined by the input parameters 'pwm_period' and 'pwm_duty_cycle', both measured
 * in clock cycles.
 *
 * The default period and duty cycle should be 256 and 0, respectively on reset.
 */
module pwm_generator #(
    parameter WIDTH=16
)  (
    input clk,
    input reset,

    // Whenever 'update_parameters' is strobed high for a cycle, update the module's period and
    // duty cycle according to the 'pwm_period' and 'pwm_duty_cycle' inputs.
    // Extra credit:
    //     Make sure that updating the parameters at specific times doesn't cause glitching.
    //     For instance, consider the case where we have a period of 256 and a duty cycle of, say,
    //     10. On cycle 11, if we change the duty cycle to 100, we don't want the output to suddenly
    //     go high again until the next cycle.
    //     Likewise consider what would happen if the period is decreased from, say, 256 to 128 on
    //     a cycle count > 128. Will your module handle this correctly?
    input update_parameters,

    // How many clock cycles long should each pwm cycle be?
    input [WIDTH-1:0] pwm_period,

    // For how many clock cycles should the pwm output signal be high?
    // Extra credit:
    //     How many bits are actually needed to store this value? If we have, say, a
    //     16-bit PWM module, is 16 bits enough to store the PWM duty cycle? Why or why not?
    input [WIDTH-1:0] pwm_duty_cycle,

    output logic pwm
);


endmodule // pwm_generator


/**
 * This module should be instantiatable as a top-level module. 'clk' will be a 12MHz clock signal.
 *
 * By using a pwm_generator module to drive the output 'led', this top-level module can brighten
 * and dim an LED - setting the duty_cycle to 0 will shut the LED off, but setting it to the
 * PWM period will turn the LED on max; intermediate values will dim the LED accordingly.
 *
 * The pwm_generator module should use a 'pwm_generator' module to brighten and dim the LED,
 * increasing and decreasing the LED's intensity over a period of 2 seconds. The LED should
 * smoothly go from fully off to fully on and then fully off again in 2 seconds.
 *
 * You should make your own testbench.
 * When testing this module in a testbench, you may want to increase the frequency and use a period
 * of less than 2 seconds. Simulating 2 full seconds will be difficult in a testbench.
 *
 * Once you think your module works, entering the 'synth' folder and running ./build.sh and
 * ./program.sh will deploy your design to an iCESugar board.
 *
 * Hint:
 *   - You should use the provided 'reset_generator' module to provide a reset signal to internally
 *     instantiated modules.
 */
module led_breather (
    input clk,
    output logic led
);
    logic reset;
    reset_generator system_reset_module (
        .clk(clk), .reset(reset);
    );
endmodule
