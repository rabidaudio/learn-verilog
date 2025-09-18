# UART

This project has 3 steps:

 - Implement the `uart_tx` module in `uart.sv` and transmit a couple characters.
 - Implement the `uart_rx` module in `uart.sv`. Verify that you're receiving characters by echoing them back.
 - Do something interesting with the received characters. Options include:
     - Waiting for a user to enter a pin number. Once the user has entered the pin and pressed 'enter', print a secret message or turn on the LED.
     - Echo characters back with some sort of modification.
     - Take the previous LED breathing project and allow the user to change the rate by entering a fixed-length hex number.
