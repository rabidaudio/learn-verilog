// A set of test bench utility modules
`pragma once

/**
 * ConstantPWM is a test utility that generates
 * a pwm signal of fixed period and duty cycle.
 */
module ConstantPWM #(
    parameter PERIOD = 'hFF,
    parameter DUTY = 'h7F
) (
    input t_clk,
    input reset,
    output logic pwm
);

    initial begin
        @(posedge reset);
        while (1) begin
            for (int i = 0; i <= PERIOD; i++) begin
                pwm <= (i < DUTY);
                @(posedge t_clk);
            end
        end
    end
endmodule

/**
 * DutyCounter is a test utility which ensures that,
 * over the last WINDOW clock cycles, the number of
 * high cycles == g_duty.
 */
module DutyCounter #(
    parameter WINDOW=2048
) (
    input t_clk,
    input signal,
    input [($clog2(WINDOW)-1):0] g_duty
);
    logic [($clog2(WINDOW)-1):0] sum;
    logic delay_line [$];

    initial begin
        sum <= 0;
        repeat (WINDOW) begin
            @(posedge t_clk);
            delay_line.push_front(signal);
            if (signal) sum++;
        end

        while (1) begin
            @(posedge t_clk);
            delay_line.push_front(signal);
            if (signal) sum++;
            if (delay_line.pop_back()) sum--;

            if (sum != g_duty)
                $error("duty counter failed: expected %d was %d", g_duty, sum);
        end
    end
endmodule

/**
* GoldenMonitor is a test utility for comparing
* a generated signal to a golden signal, with
* an optional delay (in clock cycles).
*/
module GoldenMonitor #(
    // the bit width of both inputs
    parameter WIDTH=1,
    // how many clock cycles to delay golden to match signal
    parameter DELAY=0
) (
    input clk,
    input enable,
    input [(WIDTH-1):0] golden,
    input [(WIDTH-1):0] signal
);

    logic [(WIDTH-1):0] delay_line [$];

    initial begin
        for (int i = 0; i < DELAY; i++) begin
            @(posedge clk);
            delay_line.push_front(golden);
        end
        
        while (1) begin
            if (!DELAY) begin
                @(posedge clk);
                if (enable && signal != golden)
                    $error("monitor failed. expected %h but was %h", golden, signal);
            end else begin
                logic [(WIDTH-1):0] compare;
                
                @(posedge clk);
                delay_line.push_front(golden);
                compare = delay_line.pop_back();
                if (enable && signal != compare)
                    $error("monitor failed. expected %h but was %h", compare, signal);
            end
        end
    end
endmodule
