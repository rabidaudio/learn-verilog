Verification: slang, svlint
Language server: svls
Simulation: iverilog -g2012 
Viewing: scansion
Synth: yosys

other:
verilator


brew install icarus-verilog svlint svls yosis
wget https://web.archive.org/web/20200814033018/http://www.logicpoet.com/releases/scansion/Scansion_1.12.dmg

brew install --HEAD randomplum/gtkwave/gtkwave


-----

# Some SystemVerilog examples

This repo contains a few example SystemVerilog projects that can be loaded onto the Lattice iCE40 FPGA. These files are a great starting point for small - medium sized projects.

#### Requirements
To do projects with this FPGA, you'll need to install...

 * [Icarus Verilog](https://steveicarus.github.io/iverilog/usage/installation.html)
   Icarus Verilog is a Verilog simulator. It has partial support for SystemVerilog.
   You use Icarus Verilog almost like you'd use `gcc`. You pass in a list of verilog files that you want to compile together and it produces a binary which runs all of the initial statements from the files in parallel. See `00 example` for an example invocation of `iverilog`.
 * [GTKWave](https://gtkwave.sourceforge.net/)
   GTKWave is a GUI program that lets you view the outputs of Verilog simulations. You can also use an online webapp (like [surfer](https://app.surfer-project.org/)), but installing GTKWave locally may have better performance.
 * [Yosys](https://yosyshq.net/yosys/download.html)
   Yosys is a fully open-source logic synthesizer. It takes in a bunch of systemverilog files and produces a `json` file describing a logic circuit which can be read by other tools.
 * [NextPnR iCE40]()
See their respective websites for installation instructions.

#### Folders
 * The `exercises` folder contains some classic exercises for you to practice your Verilog digital design fundamentals entirely in simulation. To do these you just need `iverilog` and `gtkwave`.
 * The `example` folder has a couple examples including a basic project template including a simple toplevel design, a testbench, and all the files you need to synthesize a blinky for the iCE40 FPGA.
 * The `projects` folder has some more extended exercises, some of which you can actually put on an FPGA.

#### Exercises
To help you practice your verilog skills, there are a few empty folders that have descriptions for verilog exercises - most of these are in simulation. The exercises will probably take anywhere from 15m - ~4hr. Doing them in order will help you gradually build up your digital design skills to more and more complex designs.
