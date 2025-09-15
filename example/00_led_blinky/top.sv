// The backtick in SystemVerilog is like the '#' in C / C++. It denotes a "compiler" directive.
// The timescale directive tells the simulator what timescale should be used in the simulation.
// The first number before the slash gives the length of delays; for instance with 500ns/10ns,
// writing #5 would give you a (5 * 500ns = 2,500ns) delay.
// The second number gives the granularity of the simulation.
`timescale 1ns/10ps

/**
 * This module blinks an LED.
 * It starts out blinking slowly, but as time passes, it blinks it faster and faster.
 *
 * Once the blink gets too fast, it resets.
 */
module led_blinker (
    input clk,
    output logic led
);
    // localparams are like 'const' variables in C.
    localparam logic [31:0] LED_PERIOD_INITIAL_VALUE = 32'd2_000_000;
    localparam logic [31:0] LED_PERIOD_FINAL_VALUE = 32'd200_000;
    localparam logic [7:0] LED_PERIOD_DECREMENT_PERIOD = 8'd20;

    // Every time led_counter reaches led_period, we toggle the LED.
    // We speed the blinking up by decrementing led_period every LED_PERIOD_DECREMENT_PERIOD clock
    // cycles.
    logic [31:0] led_counter;
    logic [31:0] led_period;
    logic [7:0] led_period_decrement_counter;
    always_ff @(posedge clk) begin
        if (led_counter >= led_period) begin
            led_counter <= 0;
            led <= ~led;
        end
        else led_counter <= led_counter + 1;

        if (led_period_decrement_counter == LED_PERIOD_DECREMENT_PERIOD) begin
            led_period_decrement_counter <= 0;
            led_period <= led_period - 1;
        end else begin
            led_period_decrement_counter <= led_period_decrement_counter + 1;
        end

        if (led_period <= LED_PERIOD_FINAL_VALUE) led_period <= LED_PERIOD_INITIAL_VALUE;
    end

    // The synthesizer lets us specify a starting value for the registers using the 'initial'
    // keyword. In a more sophisticated design,
    initial led = 0;
    initial led_counter = 0;
    initial led_period = LED_PERIOD_INITIAL_VALUE;
    initial led_period_decrement_counter = 0;
endmodule
