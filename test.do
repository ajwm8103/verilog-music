# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog music.sv

#load simulation using mux as the top level simulation module
vsim music

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force clk 0,1 18.5185 ns -r 37.037 ns
run 150000000 ns