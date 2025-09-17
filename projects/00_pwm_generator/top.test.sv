`include "top.sv"

module Top_Test (input t_clk);
    logic led;

    top #(.RESET_DELAY(1)) dut (.clk(t_clk), .led(led));

endmodule
