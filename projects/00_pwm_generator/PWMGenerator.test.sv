`include "PWMGenerator.sv"
`include "GoldenMonitor.sv"

module PWMGenerator_Tests (
    input t_clk
);
    PWMGenerator_TestDefault test_pwm_default(t_clk);
endmodule


module PWMGenerator_TestDefault (
    input t_clk
);
    localparam WIDTH = 8;
    localparam DEFAULT_PERIOD = 128;

    logic t_reset;
    logic t_pwm;

    PWMGenerator #(.WIDTH(WIDTH)) dut (
        .clk(t_clk),
        .reset(t_reset),
        .update_parameters('0),
        .pwm_period('x),
        .pwm_duty_cycle('x),
        .pwm(t_pwm),
        .period_start(t_period_start)
    );

    logic g_pwm;
    logic g_period_start;

    GoldenMonitor #(.DELAY(1)) gm_pwm(
        .clk(t_clk),
        .enable('1),
        .golden(g_pwm),
        .signal(t_pwm)
    );
    GoldenMonitor gm_p_start(
        .clk(t_clk),
        .enable('1),
        .golden(g_period_start),
        .signal(t_period_start)
    );

    // resets pwm and asserts it's always off
    initial begin : test_pwm_defaults
        // trigger reset
        @(posedge t_clk);
        t_reset <= 1;
        @(posedge t_clk);
        t_reset <= 0;
        @(posedge t_clk);

        while (1) begin
            g_pwm <= 0;
            g_period_start <= 1;
            @(posedge t_clk);
            g_period_start <= 0;
            repeat(DEFAULT_PERIOD-1) @(posedge t_clk);    
        end
    end

endmodule

// module PWMGenerator_TestSweep (
//     input t_clk
// );
//     localparam WIDTH = 8;

//     logic t_reset;
//     logic t_update_parameters;
//     logic [WIDTH-1:0] t_pwm_period;
//     logic [WIDTH-1:0] t_pwm_duty_cycle;
//     logic t_pwm;
//     logic t_period_start;

//     logic g_pwm;
//     logic g_period_start;
//     logic g_period_start_en;

//     GoldenMonitor #(.DELAY(1)) gm_period_start(
//         .clk(t_clk),
//         .enable(g_period_start_en),
//         .golden(g_period_start),
//         .signal(t_period_start)
//     );

//     PWMGenerator #(.WIDTH(WIDTH)) dut (
//         .clk(t_clk),
//         .reset(t_reset),
//         .update_parameters(t_update_parameters),
//         .pwm_period(t_pwm_period),
//         .pwm_duty_cycle(t_pwm_duty_cycle),
//         .pwm(t_pwm),
//         .period_start(t_period_start)
//     );

//     // this test goes through 4 cycles of each duty cycle at
//     // a constant period, switching duty cycle at a random point
//     // within the last cycle.
//     // it sums the amount of time the output is high and
//     // asserts that this matches the given duty cycle.
//     initial begin : test_pwm_generator
//         int period;

//         period = (1 << (WIDTH-2))-1;

//         // trigger reset
//         @(posedge t_clk);
//         t_reset <= 1;
//         @(posedge t_clk);
//         t_reset <= 0;
//         @(posedge t_clk);

//         // configure
//         t_pwm_period <= period;
//         t_pwm_duty_cycle <= 0;
//         t_update_parameters <= 1;
//         @(posedge t_clk);
//         t_update_parameters <= 0;
//         repeat(period) @(posedge t_clk);
//         repeat(period-1) @(posedge t_clk);

//         g_period_start_en <= 1;

//         for (int d = 0; d <= period; d++) begin : sweep
//         // for (int d = 62; d <= period; d++) begin : sweep // STOPSHIP
//             int iterations;
//             int high_count;
//             int period_count;

//             iterations = 1;
//             high_count = 0;
//             period_count = 0;
//             for (int c = iterations; c-- > 0;) begin
//                 int switch_after;

//                 switch_after = $urandom_range(period-1);
//                 for (int t = 0; t < period; t++) begin
//                     @(posedge t_clk);

//                     g_period_start <= (t == 0);
//                     t_pwm_period = period;
//                     t_pwm_duty_cycle <= d + 1; // the next period
//                     if (t_pwm) high_count = high_count + 1;
//                     if (t_period_start) period_count = period_count + 1;

//                     if (c == 0 && t == switch_after) t_update_parameters <= 1;
//                     else t_update_parameters <= 0;
//                 end
//             end
//             if (high_count != iterations*d)
//                 $error("test failed: duty=%d, expected %d cycles high but was %d",
//                     d, iterations*d, high_count);
//         end

//         g_period_start_en <= 0;
//     end

// endmodule

// TODO test defaults
// TODO test change on start
// TODO test change on end

