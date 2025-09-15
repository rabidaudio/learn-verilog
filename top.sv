`timescale 1ns/10ps

/**
 * build.sh
 *     iverilog -g2012 top.sv -o top
 *     ./top
 *
 * To view the results of your simulation
 *     gtkwave results.vcd
 */
module top (
    input clk,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] result
);
    always_ff @(posedge clk) begin
        result <= a + b;
        if (a == 8'hff) result <= result;
        else if (a == 8'hfe) result <= -b;
    end
endmodule


module bitsum (
    input clk,
    input [7:0] a,
    output logic [7:0] result
);
    always_ff @(posedge clk) begin
        logic [7:0] bitcount;
        bitcount = 0;
        for (int i = 0; i < 8; i++) begin
            bitcount += a[i];
        end

        result <= bitcount;
    end
endmodule


module counter(input clk,
    input reset,
    input increment,
    output logic [15:0] total
);

    always_ff @(posedge clk) begin
        total <= total;
        if (increment) total <= total + 1;
        if (reset) total <= 0;
    end

endmodule // counter




module main;
    // drive clock signal
    logic clk;

    initial begin
        clk = 0;
        while (1) begin
            #10;
            clk <= !clk;
        end
    end

    logic reset;
    logic increment;
    logic [15:0] total;

    counter test_counter(.clk(clk), .reset(reset), .increment(increment), .total(total));

    initial begin
        $dumpfile("results.vcd");
        $dumpvars(0, main);
        for (int i = 0; i < 10000; i++) begin
            @(posedge clk);
            increment <= 0;
            reset <= 0;
            if (i % 3 == 0) begin
                increment <= 1;
            end

            if (i % 500 == 0) begin
                reset <= 1;
            end
        end
        $finish;
    end
endmodule
