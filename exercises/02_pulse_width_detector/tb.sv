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
    logic output_valid;
    logic [15:0] pulse_width;
    pulse_width_detector dut (
        .clk, .reset, .signal, .output_valid, .pulse_width
    );

    ////////////////////////////////////////////////////////////////
    // monitor task to collect the results from the dut and enforce the output_valid timing
    logic [15:0] dut_results[$];
    logic [15:0] golden_results[$];
    time dut_result_times[$];
    logic _signal [2];
    logic error = 0;
    initial begin
        repeat(3) @(posedge clk);
        forever begin
            @(posedge clk);
            _signal[0] <= signal;
            _signal[1] <= _signal[0];
            if (output_valid) dut_results.push_front(pulse_width);
            if (output_valid) dut_result_times.push_front($time);

            #1;
            if (!error && (!output_valid && (!_signal[0] && _signal[1]))) begin
                $display("Test failed. output_valid is wrong at time %t.", $time);
                error <= 1;
            end
        end
    end

    ////////////////////////////////////////////////////////////////
    // main entry point for testbench execution
    logic [15:0] golden_length = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $timeformat(-9, 2, " ns", 20);
        signal <= 0;
        reset <= 1;
        @(posedge clk); @(posedge clk);
        reset <= 0;
        @(posedge clk); @(posedge clk);

        // Repeat "reset and count edges" test procedure a few times.
        for (int i = 0; i < 2000; i++) begin
            int low_length;
            low_length = $urandom_range(3, 1);
            golden_length = $urandom_range(10, 1);

            signal <= 1;
            repeat (golden_length) @(posedge clk);
            signal <= 0;
            repeat (low_length) @(posedge clk);
            golden_results.push_front(golden_length);
        end

        repeat(20) @(posedge clk);

        if (dut_results.size() != golden_results.size()) begin
            $display("Test failed. dut produced wrong number of results");
            error = 1;
        end

        for (int i = 0; i < dut_results.size(); i++) begin
            if (dut_results[i] !== golden_results[i]) begin
                $display("Test failed. dut produced %3d but expected %3d at time %t.",
                    dut_results[i], golden_results[i], dut_result_times[i]);
                error = 1;
            end
        end

        if (!error) $display("test passed!");

        $finish;
    end


endmodule
