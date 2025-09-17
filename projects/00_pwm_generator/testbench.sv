`timescale 1ns/100ps
`include "PWMGenerator.test.sv"

module testbench;
    localparam realtime PERIOD = 10;
    localparam TEST_CYCLES = 4*16*16*256 + 1000;
    logic t_clk = 0;
    always #(PERIOD/2) t_clk <= ~t_clk;
    initial #(TEST_CYCLES*PERIOD/2) $finish;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end

    PWMGenerator_TestSweep pwm_test_sweep(.t_clk(t_clk));
    // PWMGenerator_TestDefault pwm_test_default(.t_clk(t_clk));

endmodule
