`timescale 1ns/10ps


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
    int golden_posedge_count, golden_negedge_count, error = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $timeformat(-9, 2, " ns", 20);

        $display("Sorry, I'm getting a little tired of writing all these testbenches.");
        $display("You'll just have to inspect dump.vcd by hand for correctness on this one.");

        reset <= 1;
        signal <= 0;
        repeat(2) @(posedge clk);
        reset <= 0;
        repeat(2 * MIN_PULSE_WIDTH) @(posedge clk);

        for (int i = 0; i < 100; i++) begin
            // bouncy portion
            int num_bounces, bounce_len;
            num_bounces = 2 * $urandom_range(10, 0) + 1;
            for (int j = 0; j < num_bounces; j++) begin
                bounce_len = $urandom_range(20, 1);
                signal <= ~signal;
                repeat(bounce_len) @(posedge clk);
            end

            repeat(MIN_PULSE_WIDTH * 4) @(posedge clk);
        end
        repeat(MIN_PULSE_WIDTH * 4) @(posedge clk);

        $finish;
    end
endmodule
