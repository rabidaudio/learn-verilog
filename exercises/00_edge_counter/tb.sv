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
    logic signal;
    logic [31:0] posedge_count, negedge_count;
    edge_counter dut (
        .clk, .reset, .signal, .posedge_count, .negedge_count
    );


    ////////////////////////////////////////////////////////////////
    // main entry point for testbench execution
    int golden_posedge_count, golden_negedge_count, error = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $timeformat(-9, 2, " ns", 20);
        signal <= 0;

        // Repeat "reset and count edges" test procedure a few times.
        for (int i = 0; i < 5; i++) begin
            // Reset test counters and hold the system in reset for a few clock cycles.
            @(posedge clk);
            golden_posedge_count <= 0;
            golden_negedge_count <= 0;
            reset <= 1;
            @(posedge clk); @(posedge clk);
            reset <= 0;

            // toggle signal randomly
            for (int j = 0; j < 1000; j++) begin
                @(posedge clk)
                if ($urandom_range(10) == 0) begin
                    if (signal) golden_negedge_count <= golden_negedge_count + 1;
                    if (!signal) golden_posedge_count <= golden_posedge_count + 1;
                    signal <= ~signal;
                end
            end
        end

        if (!error) $display("test passed!");

        $finish;
    end

    ////////////////////////////////////////////////////////////////
    // "scoreboard" task that checks the actual dut value vs the expected value
    // We need to delay the expected values by 1 cycle.
    int gpc_prev, npc_prev;
    initial begin
        @(posedge clk);
        forever begin
            @(posedge clk);
            gpc_prev <= golden_posedge_count;
            npc_prev <= golden_negedge_count;

            #(PERIOD/10);
            if ((gpc_prev !== posedge_count) || (npc_prev !== negedge_count)) begin
                if (!error) begin
                    $display("test failed at time %t.", $time);
                    $display("Expected counts %4d and %4d. Got counts %4d and %4d",
                        gpc_prev, npc_prev, posedge_count, negedge_count);
                end
                error <= 1;
            end
        end
    end

endmodule
