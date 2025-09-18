`timescale 1ns/100ps
`include "top.sv"

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

    logic [2:0] t_led;
    top #(
        .CLOCK_SPEED(1024),
        .RESET_AFTER(1)
    ) dut (
        .clk(t_clk),
        .led_rgb_o(t_led)
    );

endmodule
