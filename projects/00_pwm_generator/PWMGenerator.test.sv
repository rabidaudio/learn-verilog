`include "PWMGenerator.sv"

module PWMGenerator_TestSweep (
    input t_clk
);
    localparam WIDTH = 8;

    logic t_reset;
    logic t_update_parameters;
    logic [WIDTH-1:0] t_pwm_period;
    logic [WIDTH-1:0] t_pwm_duty_cycle;
    logic t_pwm;
    logic t_period_start;

    PWMGenerator #(.WIDTH(WIDTH)) dut (
        .clk(t_clk),
        .reset(t_reset),
        .update_parameters(t_update_parameters),
        .pwm_period(t_pwm_period),
        .pwm_duty_cycle(t_pwm_duty_cycle),
        .pwm(t_pwm),
        .period_start(t_period_start)
    );

    // this test goes through 4 cycles of each duty cycle at
    // a constant period, switching duty cycle at a random point
    // within the last cycle.
    // it sums the amount of time the output is high and
    // asserts that this matches the given duty cycle.
    initial begin : test_pwm_generator
        int period;

        period = (1 << (WIDTH-2))-1;

        // trigger reset
        @(posedge t_clk);
        t_reset <= 1;
        @(posedge t_clk);
        t_reset <= 0;
        @(posedge t_clk);

        // configure
        t_pwm_period <= period;
        t_pwm_duty_cycle <= 0;
        t_update_parameters <= 1;
        @(posedge t_clk);
        t_update_parameters <= 0;
        repeat(period) @(posedge t_clk);
        repeat(period-1) @(posedge t_clk);

        for (int d = 1; d <= period; d++) begin : sweep
            int iterations;
            int high_count;
            int period_count;

            iterations = 4;
            high_count = 0;
            period_count = 0;
            for (int c = iterations; c-- > 0;) begin
                int switch_after;

                switch_after = $urandom_range(period-1);
                for (int t = 0; t < period; t++) begin
                    @(posedge t_clk);

                    t_pwm_period = period;
                    t_pwm_duty_cycle <= d;
                    if (t_pwm) high_count = high_count + 1;
                    if (t_period_start) period_count = period_count + 1;

                    if (c == 0 && t == switch_after) t_update_parameters <= 1;
                    else t_update_parameters <= 0;
                end
            end
            if (high_count != iterations*(d-1))
                $error("test failed: duty=%d, expected %d cycles high but was %d",
                    d-1, iterations*(d-1), high_count);
            if (period_count != iterations)
                $error("test failed: duty=%d, expected %d period starts but was %d",
                    d-1, iterations, period_count);
        end
    end

endmodule

// TODO test defaults
// TODO test change on start
// TODO test change on end
