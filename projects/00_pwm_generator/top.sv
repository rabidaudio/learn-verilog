`include "ResetGenerator.sv"
`include "PWMGenerator.sv"
`include "BrightnessStepper.sv"

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
    parameter CLOCK_SPEED = 12*1000*1000, // 12Mhz
    // the period of the timer to use. selected for an integer number < 2^16
    // TODO: compute this?
    parameter STEPS = 512
) (
    input clk,
    output logic [2:0] led_rgb_o
);
    logic reset;
    ResetGenerator #(.AFTER(RESET_DELAY)) system_reset_module (
        .clk(clk),
        .reset(reset)
    );
    // the number of clock cycles to fully brighten/dim the LED
    localparam LED_PERIOD = 2*CLOCK_SPEED; // 2 seconds
    localparam CLOCK_PERIOD = LED_PERIOD / STEPS; // 46875
    localparam WIDTH = $clog2(CLOCK_PERIOD)+1;

    logic red;
    logic green;
    logic blue;

    // brightness params
    logic update_brightness;
    logic [WIDTH-1:0] brightness;
    logic period_end;

    PWMGenerator #(
        .INITIAL_PERIOD(CLOCK_PERIOD),
        .INITIAL_DUTY(0)
    ) red_gen (
        .clk(clk),
        .reset(reset),
        .update_parameters(update_brightness),
        .pwm_duty_cycle(brightness),
        .period_end(period_end),
        .pwm(red)
    );
    // PWMGenerator #(
    //     .INITIAL_PERIOD(CLOCK_PERIOD),
    //     .INITIAL_DUTY(0)
    // ) green_gen (
    //     .clk(clk),
    //     .reset(reset),
    //     .update_parameters(update_brightness),
    //     .pwm_duty_cycle(brightness),
    //     .pwm(green)
    // );
    // PWMGenerator #(
    //     .INITIAL_PERIOD(CLOCK_PERIOD),
    //     .INITIAL_DUTY(0)
    // ) blue_gen (
    //     .clk(clk),
    //     .reset(reset),
    //     .update_parameters(update_brightness),
    //     .pwm_duty_cycle(brightness),
    //     .pwm(blue)
    // );

    // BrightnessStepper #(
    //     .STEPS(LED_PERIOD)
    // ) stepper (
    //     .clk(clk),
    //     .reset(reset),
    //     .brightness(brightness)
    // );

    always_ff @(posedge clk) begin
        if (reset) begin
            update_brightness <= 0;
            led_rgb_o <= 0;

            brightness <= 0;
        end else begin
            led_rgb_o <= {red, green, blue};
            // update_brightness <= period_end;
            
            if (period_end) begin
                brightness <= brightness + 1;
                update_brightness <= period_end;
            end
        end
    end

endmodule
