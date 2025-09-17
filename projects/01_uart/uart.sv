`timescale 1ns/10ps

/**
 * This utility module will emit a reset signal shortly after power-up.
 * It takes advantage of the iCE40's initial / reset capabilities on
 * power-up.
 */
module reset_generator (
    input clk_i,
    output logic reset_o
);
    logic [15:0] reset_counter;
    initial reset_counter = 0;
    initial reset_o = 1;

    always_ff @(posedge clk_i) begin
        if (reset_counter != '1) begin
            reset_counter <= reset_counter + 1;
        end else begin
            reset_o <= 0;
        end
    end
endmodule

/**
 * This module should recieve bytes over its input port 'txdata_i' and transmit them over uart
 * port uart_tx_o. The input clock can be assumed to be 12MHz, the CLK_DIVIDER parameter is set
 * to give you a baud rate of 115,200.
 *
 * Note that a byte transmitted over UART actually consists of 10 bits:
 *     a start bit that's always 0      your 8 data bits        a stop bit that's always 1.
 */
module uart_tx #(
    parameter CLK_DIVIDER = 104
)  (
    // input clock, 12MHz.
    input clk_i,
    input reset_i,

    // When txdata_valid_i is strobed high for a single clock cycle, txdata_i is latched into the
    // uart transmitter and transmission begins.
    // If txdata_valid_i is strobed when the uart module is transmitting a character, that character
    // can be ignored.
    input txdata_valid_i,

    // Data to be transmitted when txdata_valid_i is strobed.
    input [7:0] txdata_i,

    // Your uart_tx module should hold this signal high while it's busy transmitting a character.
    output logic uart_busy_o,

    // uart output signal.
    output logic uart_tx_o
);

endmodule


/**
 * This module should recieve uart bytes over 'uart_rx_i'. Once a full byte has been recieved,
 * it should be presented on 'rxdata_o' and 'rxdata_valid_o' should be strobed for a single clock
 * cycle.
 */
module uart_rx #(
    parameter CLK_DIVIDER = 104
)  (
    input clk_i,
    input reset_i,

    // uart input
    input uart_rx_i,

    // Once a full byte has been recieved, this signal should be strobed for a single clock cycle
    // when the valid data is presented on 'rxdata_o'
    output logic rxdata_valid_o,

    // Recieved uart byte going to downstream hardware.
    output logic [7:0] rxdata_o,

    // This optional output can be high whenever the rx module is currently recieving a byte.
    output logic uart_busy_o
);
    // Metastability resolution
    // Don't use uart_rx_i directly. Instead, use uart_rx.
    // Because uart_rx is not synchronous with the FPGA internal clock, it may be metastable.
    // Therefore, we MUST register the input signal at least once or we might have issues.
    logic [1:0] _uart_rx;
    logic uart_rx = _uart_rx[1];
    always_ff @(posedge clk_i) _uart_rx = {_uart_rx[0], uart_rx_i};

endmodule

/**
 * In this toplevel module, instantiate your uart reciever and transmitter and do something
 * interesting with them.
 */
module top (
    input clk_i,

    input uart_rx_i,
    output logic uart_tx_o,

    output logic [2:0] led_rgb_o
);
    logic reset;
    reset_generator reset_generator_inst (
        .clk_i, .reset_o(reset)
    );
endmodule
