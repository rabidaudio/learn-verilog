`include "BrightnessStepper.sv"

module BrightnessStepper_Test (
    input t_clk,
    input t_reset
);
    localparam STEPS = 16;
    localparam PEAK = 15;

    logic [3:0] t_brightness;

    BrightnessStepper #(
        .STEPS(STEPS),
        .PEAK(PEAK)
    ) dut (
        .clk(t_clk),
        .reset(t_reset),
        .brightness(t_brightness)
    );

    logic [3:0] g_brightness;
    initial begin
        repeat(2) @(posedge t_clk);
        g_brightness <= 0;
        @(posedge t_clk);

        // NOTE: brightness should spend exactly 1 step cycle at each bound (0, xF)
        while (1) begin
            for (int i = 0; i <= PEAK; i++) begin
                g_brightness <= g_brightness + 1;
                repeat (STEPS) @(posedge t_clk);
            end
            for (int i = PEAK; i >= 0; i--) begin
                g_brightness <= g_brightness - 1;
                repeat (STEPS) @(posedge t_clk);
            end
        end
    end
    // GoldenMonitor #(.WIDTH(8), .DELAY(0)) gm_brightness (
    //     .clk(t_clk),
    //     .enable('1),
    //     .golden(g_brightness),
    //     .signal(t_brightness)
    // );

endmodule