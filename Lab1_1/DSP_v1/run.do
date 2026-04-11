vlib work
vlog DSP_1.v DSP_tb.sv  +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit
run -all
coverage exclude -du DSP -togglenode S2_A