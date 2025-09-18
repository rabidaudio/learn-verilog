`include "BrightnessStepper.sv"

module BrightnessStepper_Test (
    input t_clk,
    input t_reset
);
    logic [7:0] t_brightness;

    BrightnessStepper #(
        .STEPS(16),
        .WIDTH(8)
    ) dut (
        .clk(t_clk),
        .reset(t_reset),
        .brightness(t_brightness)
    );

    logic [7:0] g_brightness;
    initial begin
        repeat(2) @(posedge t_clk);
        g_brightness <= 0;
        @(posedge t_clk)

        // NOTE: spends exactly 1 cycle at bounds (0, xF)
        while (1) begin
            for (int i = 0; i < 16; i++) begin
                g_brightness <= g_brightness + 1;
                @(posedge t_clk);
            end
            for (int i = 16; i-->0;) begin
                g_brightness <= g_brightness - 1;
                @(posedge t_clk);
            end
        end
    end
    GoldenMonitor #(.WIDTH(8), .DELAY(0)) gm_brightness (
        .clk(t_clk),
        .enable('1),
        .golden(g_brightness),
        .signal(t_brightness)
    );

endmodule