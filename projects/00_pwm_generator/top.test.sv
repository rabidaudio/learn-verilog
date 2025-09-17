`include "top.sv"

module Top_Test (input t_clk);
    logic [2:0] led;

    top #(.RESET_DELAY(1)) dut (.clk(t_clk), .led_rgb_o(led));

endmodule
