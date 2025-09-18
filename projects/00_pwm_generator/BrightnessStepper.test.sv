`include "BrightnessStepper.sv"

module BrightnessStepper_Test (
    input t_clk,
    input t_reset
);
    localparam IDLE_TIME = 16;
    localparam PEAK_BRIGHTNESS = 15;

    logic [4:0] t_brightness;

    BrightnessStepper #(
        .IDLE_TIME(IDLE_TIME),
        .PEAK_BRIGHTNESS(PEAK_BRIGHTNESS)
    ) dut (
        .clk(t_clk),
        .reset(t_reset),
        .brightness(t_brightness)
    );

    logic [4:0] g_brightness;
    initial begin
        repeat(2) @(posedge t_clk);
        g_brightness <= 0;

        // NOTE: brightness should spend exactly 1 step cycle at each bound (0, xF)
        while (1) begin
            for (int i = 0; i < PEAK_BRIGHTNESS; i++) begin
                repeat (IDLE_TIME) @(posedge t_clk);
                g_brightness <= g_brightness + 1;
            end
            for (int i = PEAK_BRIGHTNESS; i > 0; i--) begin
                repeat (IDLE_TIME) @(posedge t_clk);
                g_brightness <= g_brightness - 1;
            end
        end
    end
    GoldenMonitor #(.WIDTH(5), .DELAY(0)) gm_brightness (
        .clk(t_clk),
        .enable('1),
        .golden(g_brightness),
        .signal(t_brightness)
    );

endmodule
