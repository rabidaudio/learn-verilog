`include "PWMGenerator.sv"

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
module Main (
    input clk,
    output logic led
);
    logic reset;
    ResetGenerator system_reset_module (
        .clk(clk),
        .reset(reset)
    );
    localparam WIDTH = 16;

    // the number of clock cycles to fully brighten/dim the LED
    localparam LED_PERIOD = 12*1000*1000*2; // 2MHz * 2 seconds
    // the period of the timer to use. selected for an integer number < 2^16
    // TODO: compute this from width?
    localparam CLOCK_PERIOD = LED_PERIOD / 512; // 46875

    logic [$clog2(PERIOD)-1:0] step;
    logic rising;

    logic update_parameters;
    logic [(WIDTH-1):0] pwm_period;
    logic [(WIDTH-1):0] pwm_duty_cycle;
    logic period_start;

    PWMGenerator #(.WIDTH(WIDTH)) pwm (
        .clk(clk),
        .reset(reset),
        .update_parameters(update_parameters),
        .pwm_period(pwm_period),
        .pwm_duty_cycle(pwm_duty_cycle),
        .pwm(led),
        .period_start(period_start),
    );

    always_ff (@posedge clk) begin
        if (reset) begin
            step <= 0;
            rising <= 0;

            pwm_period <= CLOCK_PERIOD;
            pwm_duty_cycle <= 0;
            update_parameters <= 1;
        end else begin
            if (step == 0) rising <= ~rising;
            step <= step + 1;

            update_parameters <= 0;
            if (period_start) begin
                pwm_period <= CLOCK_PERIOD;
                if (rising) pwm_duty_cycle <= pwm_duty_cycle + 1;
                else pwm_duty_cycle <= pwm_duty_cycle - 1;
                update_parameters <= 1;
            end
        end
    end
endmodule
