`timescale 1ns/100ps
`include "top.test.sv"
`include "ResetGenerator.sv"
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

    logic t_reset;
    ResetGenerator #(.AFTER(1)) reset (.clk(t_clk), .reset(t_reset));

    PWMGenerator_Tests tests_pwm(t_clk, t_reset);
    Top_Test tests_top(t_clk);
endmodule
