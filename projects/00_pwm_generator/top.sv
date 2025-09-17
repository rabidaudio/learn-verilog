`include "ResetGenerator.sv"
`include "PWMGenerator.sv"

/**
 * This module brightens and dims an LED using PWM.
 * It increases and decreases the LED's intensity over a period of 2 seconds. The LED will
 * smoothly go from fully off to fully on and then fully off again in 2 seconds.
 * Incoming `clk` is a 12MHz clock signal.
 * Setting the duty_cycle to 0 will shut the LED off, but setting it to the
 * PWM period will turn the LED on max; intermediate values will dim the LED accordingly.
 */
module top #(
    parameter RESET_DELAY = 'hFFFF,
    parameter CLOCK_SPEED = 12*1000*1000 // 12Mhz
) (
    input clk,
    output logic led
);
    logic reset;
    ResetGenerator #(.AFTER(RESET_DELAY)) system_reset_module (
        .clk(clk),
        .reset(reset)
    );
    // the number of clock cycles to fully brighten/dim the LED
    localparam LED_PERIOD = 2*CLOCK_SPEED; // 2 seconds
    
    // the period of the timer to use. selected for an integer number < 2^16
    // TODO: compute this?
    localparam STEPS = 512;
    localparam CLOCK_PERIOD = LED_PERIOD / STEPS; // 46875

    // counts up for each brightness level
    logic [$clog2(STEPS)-1:0] step;
    // wether we making the LED brighter or dimmer
    logic rising;

    // generator params
    logic update_parameters;
    logic [$clog2(CLOCK_PERIOD):0] pwm_duty_cycle;
    logic period_end;

    PWMGenerator #(
        .INITIAL_PERIOD(CLOCK_PERIOD),
        .INITIAL_DUTY(0)
    ) pwm (
        .clk(clk),
        .reset(reset),
        .update_parameters(update_parameters),
        .pwm_duty_cycle(pwm_duty_cycle),
        .period_end(period_end),
        .pwm(led)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            step <= 0;
            rising <= 0;

            pwm_duty_cycle <= 0;
        end else begin
            if (step == 0) rising <= ~rising;
            step <= step + 1;

            update_parameters <= 0;
            if (period_end) begin
                if (rising) pwm_duty_cycle <= pwm_duty_cycle + 1;
                else pwm_duty_cycle <= pwm_duty_cycle - 1;
                update_parameters <= 1;
            end
        end
    end
endmodule
