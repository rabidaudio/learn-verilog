`timescale 1ns/10ps

/**
 * This exercise is the same as edge_counter, except you should output your result *as soon* as
 * 'signal' changes.
 *
 * If you have a hard time understanding why your test is failing, open gtkwave and compare
 * 'golden_posedge_count' and 'golden_negedge_count' with 'posedge_count' and 'negedge_count'.
 *
 * Hints:
 *   - you'll have to use combinational logic for your output.
 *   - if something is assigned to anywhere in an always_comb block, it must be assigned to in
 *     every possible "execution path". For instance
 *         always_comb begin if (x == 2) a = 3; end
 *     is not allowed. 'a' is only assigned when x is 2, whereas
 *         always_comb begin if (x == 2) a = 3; a = 2; end   // put on one line for brevity
 *     is ok because a is assigned a value no matter what.
 */
module edge_counter #(
    parameter WIDTH=32
)  (
    input clk,
    input reset,

    // signal whose edges are to be counted
    input signal,

    // How many positive and negative edges have we counted since the last reset?
    output logic [WIDTH-1:0] posedge_count,
    output logic [WIDTH-1:0] negedge_count
);

    logic prev;

    always_comb begin
        if (reset) begin
            posedge_count = 0;
            negedge_count = 0;
            prev = signal;
        end else begin
            posedge_count = posedge_count;
            negedge_count = negedge_count;

            if (prev != signal) begin
                if (signal) posedge_count = posedge_count + 1;
                else negedge_count = negedge_count + 1;
            end
            prev = signal;
        end
    end

endmodule
