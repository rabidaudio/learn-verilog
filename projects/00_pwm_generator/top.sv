`include "ResetGenerator.sv"
`include "PWMGenerator.sv"
`include "BrightnessStepper.sv"

typedef enum { RISING_GREEN=0, FALLING_RED = 1, RISING_BLUE = 2, FALLING_GREEN = 3, RISING_RED =4, FALLING_BLUE=5 } hue_state_e;

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
    parameter IDLE_TIME = 512
    // TODO: max brightness
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
    localparam CLOCK_PERIOD = LED_PERIOD / IDLE_TIME; // 46875
    localparam WIDTH = $clog2(CLOCK_PERIOD)+1;

    // buffers for each color
    logic red;
    logic green;
    logic blue;

    // the value to set to the current led
    logic result;

    // state machine for hue
    hue_state_e hue_state;

    // brightness params
    logic update_brightness;
    logic [WIDTH-1:0] brightness;
    logic generator_period_end;
    logic stepper_period_end;

    PWMGenerator #(
        .INITIAL_PERIOD(CLOCK_PERIOD),
        .INITIAL_DUTY(0)
    ) generator (
        .clk(clk),
        .reset(reset),
        .update_parameters(update_brightness),
        .pwm_duty_cycle(brightness),
        .period_end(generator_period_end),
        .pwm(result)
    );

    BrightnessStepper #(
        .IDLE_TIME(IDLE_TIME),
        .PEAK_BRIGHTNESS(CLOCK_PERIOD)
    ) stepper (
        .clk(clk),
        .reset(reset),
        .period_end(stepper_period_end),
        .brightness(brightness)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            update_brightness <= 0;
            red <= 0;
            green <= 0;
            blue <= 0;
            hue_state <= FALLING_BLUE;
        end else begin
            case (hue_state)
                RISING_GREEN: begin
                    red <= 1;
                    green <= result;
                    blue <= 0;
                end

                FALLING_RED: begin
                    red <= result;
                    green <= 1;
                    blue <= 0;
                end
                
                RISING_BLUE: begin
                    red <= 0;
                    green <= 1;
                    blue <= result;
                end

                FALLING_GREEN: begin
                    red <= 0;
                    green <= result;
                    blue <= 1;
                end

                RISING_RED: begin
                    red <= result;
                    green <= 0;
                    blue <= 1;
                end

                FALLING_BLUE: begin
                    red <= 1;
                    green <= 0;
                    blue <= result;
                end
            endcase

            update_brightness <= generator_period_end;

            if (stepper_period_end) hue_state <= (hue_state == FALLING_BLUE ? RISING_GREEN : hue_state+1);
        end
    end

    always_comb led_rgb_o = { ~blue, ~green, ~red }; // active low

endmodule
