`pragma once

/**
* GoldenMonitor is a test utility for comparing
* a generated signal to a golden signal, with
* an optional delay (in clock cycles).
*/
module GoldenMonitor #(
    // the bit width of both inputs
    parameter WIDTH=1,
    // how many clock cycles to delay golden to match signal
    parameter DELAY=0,
    // a number of clock cycles to compare for
    parameter UNTIL=(1 << 64)
) (
    input clk,
    input enable,
    input [(WIDTH-1):0] golden,
    input [(WIDTH-1):0] signal
);

    logic [(WIDTH-1):0] delay_line [$];

    initial begin
        logic [(WIDTH-1):0] compare;

        for (int i = 0; i < DELAY; i++) begin
            @(posedge clk);
            delay_line.push_front(golden);
        end
        
        for (int i = 0; i < UNTIL; i++) begin
            compare = delay_line.pop_back();
            @(posedge clk);
            delay_line.push_front(golden);
            if (enable && signal != compare)
                $error("monitor failed. expected %h but was %h", compare, signal);
        end
    end
endmodule
