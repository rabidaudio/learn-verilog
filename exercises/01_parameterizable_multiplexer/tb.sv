`timescale 1ns/10ps
`include "top.sv"

module tb;
    // instantiate dut
    logic [7:0] din [8];
    logic [2:0] addr;
    logic [7:0] dout;
    parameterizable_multiplexer dut (
        .din, .addr, .dout
    );
    defparam dut.NUM_INPUTS = 8;

    ////////////////////////////////////////////////////////////////
    // main entry point for testbench execution
    int error = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $timeformat(-9, 2, " ns", 20);

        for (int j = 0; j < 8; j++) din[j] = j + 1;

        for (int i = 0; i < 100; i++) begin
            addr <= $urandom;
            #1;
            if (!error && (dout !== din[addr])) begin
                error = 1;
                $display("test failed at time %t.", $time);
                $display("expected dout = %d but got %d.", din[addr], dout);
            end
            #1;
        end
        if (!error) $display("test passed!");
        $finish;
    end
endmodule
