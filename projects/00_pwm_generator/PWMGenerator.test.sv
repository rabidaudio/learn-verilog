`include "PWMGenerator.sv"

module Test_PWMGenerator (
    input t_clk
);
    localparam WIDTH = 4;

    logic t_reset;
    logic t_update_parameters;
    logic [WIDTH-1:0] t_pwm_period;
    logic [WIDTH-1:0] t_pwm_duty_cycle;
    logic t_pwm;

    PWMGenerator #(.WIDTH(WIDTH)) dut (
        .clk(t_clk),
        .reset(t_reset),
        .update_parameters(t_update_parameters),
        .pwm_period(t_pwm_period),
        .pwm_duty_cycle(t_pwm_duty_cycle),
        .pwm(t_pwm)
    );

    // this test will go through 4 cycles of each duty cycle
    // for each power of 2 pwm from 1 to max, switching period
    // and duty cycle at a random point within the last cycle.
    // it will sum the amount of time the output is high and
    // assert that this matches the given duty cycle.
    initial begin : test_pwm_generator
        @(posedge t_clk);
        t_reset <= 1;
        @(posedge t_clk);
        t_reset <= 0;

        repeat($clog2(WIDTH)/2) @(posedge t_clk); // wait for one full default cycle
        
        t_pwm_period <= 0;
        t_pwm_duty_cycle <= 0;
        t_update_parameters <= 1;
        @(posedge t_clk);

        for (int p = 1; p < (1 << WIDTH); p = (p << 1)) begin
            for (int d = 0; d < p; d++) begin
                int switch_after;
                int count;

                switch_after = $urandom_range(d);
                for (int c = 0; c < 4; c++) begin
                    t_update_parameters <= 0;
                    t_pwm_period <= p;
                    t_pwm_duty_cycle <= d;
                    if (c == 3 && d == switch_after) t_update_parameters <= 1;
                    if (t_pwm) count = count + 1;
                    
                    @(posedge t_clk);
                end
                if (count != 4*d)
                    $error("test failed: pwm=%d, duty=%d. expected %d cycles high but was %d",
                        p, d, 4*d, count);
            end
        end
    end

endmodule
