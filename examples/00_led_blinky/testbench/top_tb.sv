`timescale 1ns/500ps

module main;
    // Generate a clock signal for our test module.
    logic clk;
    initial begin
        clk <= 0;
        forever begin #10; clk <= ~clk; end
    end

    // Instantiate the module we want to test plus signals connected to it.
    // The term 'dut' stands for "Device Under Test". It's a common piece of SV jargon.
    logic led;
    led_blinker dut (.clk(clk), .led(led));

    // Entry point for the simulation.
    // The simulator executes all 'initial' blocks starting at the same time. You can think of each
    // one like a thread of execution in a multithreaded program.
    initial begin
        // Tell the simulator to dump all digital signals into the simulation to a ".vcd" file
        // called "results.vcd". VCD files can be viewed by a waveform viewer like GTKWave.
        $dumpfile("results.vcd");
        $dumpvars(0, main);

        // $display() in systemverilog is like printf in C.
        $display("This simulation might take a long time... we need to simulate a lot of clock ");
        $display("cycles to see the LED blink.");
        $display("This also means that results.vcd will be very big.");
        $display("");

        // For this simulation, we just wait for a long time.
        for (int i = 0; i < 20; i++) begin
            #10000000;
            $display("Executing %5.1f%%...", 100.0 * real'(i) / real'(20));
        end

        // Tell the simulator that we're done. The simulator won't exit until it sees a $finish.
        // Without this it would run forever.
        $finish;
    end

endmodule
