`timescale 1ns/10ps
`include "top.sv"

module tb;
    ////////////////////////////////////////////////////////////////
    // Generate 100MHz clk.
    localparam realtime PERIOD = 10;
    logic clk = 0;
    always #(PERIOD/2) clk <= ~clk;

    ////////////////////////////////////////////////////////////////
    // instantiate DUT and related signals.
    logic reset;
    logic signal, debounced_signal;
    localparam logic [15:0] MIN_PULSE_WIDTH = 16'd100;
    button_debouncer dut (
        .clk, .reset, .signal, .min_pulse_width(MIN_PULSE_WIDTH), .debounced_signal
    );

    ////////////////////////////////////////////////////////////////
    // main entry point for testbench execution
    logic golden_signal, error = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $timeformat(-9, 2, " ns", 20);

        reset <= 1;
        signal <= 0;
        repeat(2) @(posedge clk);
        reset <= 0;
        repeat(2 * MIN_PULSE_WIDTH) @(posedge clk);

        for (int i = 0; i < 100; i++) begin
            // bouncy portion
            int num_bounces, bounce_len;

            golden_signal = ~signal;
            num_bounces = 2 * $urandom_range(10, 0) + 1;
            for (int j = 0; j < num_bounces; j++) begin
                bounce_len = $urandom_range(20, 1);
                signal <= ~signal;

                if (j > 1 && golden_signal != debounced_signal) begin
                    $error("test failed [%d, %d]. Expected %d but was %d", i, j, golden_signal, debounced_signal);
                    error = 1;
                end

                repeat(bounce_len) @(posedge clk);
            end

            repeat(MIN_PULSE_WIDTH * 4) begin
                @(posedge clk);
                if (golden_signal != debounced_signal) begin
                    $error("test failed. Expected %d but was %d", golden_signal, debounced_signal);
                    error = 1;
                end
            end
        end
        repeat(MIN_PULSE_WIDTH * 4) @(posedge clk);

        if (!error) $display("test passed!");
        $finish;
    end
endmodule
