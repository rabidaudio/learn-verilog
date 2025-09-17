`include "ResetGenerator.sv"
`include "PWMGenerator.sv"

/**
 * This module brightens and dims an LED using PWM.
 * It increases and decreases the LED's intensity over a period of 2 seconds. The LED will
 * smoothly go from fully off to fully on and then fully off again in 2 seconds.
 * Incoming `clk` is a 12MHz clock signal.
 * etting the duty_cycle to 0 will shut the LED off, but setting it to the
 * PWM period will turn the LED on max; intermediate values will dim the LED accordingly.
 */
module top (
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
    // TODO: compute this from `WIDTH`?
    localparam CLOCK_PERIOD = LED_PERIOD / 512; // 46875

    // counts up for each brightness level
    logic [$clog2(LED_PERIOD)-1:0] step;
    // wether we making the LED brighter or dimmer
    logic rising;

    // generator params
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
