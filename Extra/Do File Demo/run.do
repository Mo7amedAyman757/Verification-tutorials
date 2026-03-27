vlib work
vlog N_bit_HalfAdder.v N_bit_ALU.v N_bit_ALU_tb.v
vsim -voptargs=+acc work.N_bit_ALU_tb
add wave *
#do wave.do
run -all
#quit -sim