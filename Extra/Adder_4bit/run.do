vlib work
vlog Adder_4bit.v Adder_4bit_tb.sv  +cover -covercells
vsim -voptargs=+acc work.Adder_4bit_tb -cover
add wave *
coverage save Adder_4bit_tb.ucdb -onexit
run -all
coverage exclude -du full_adder -togglenode rst