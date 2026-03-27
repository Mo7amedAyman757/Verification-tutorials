vlib work
vlog dff.v dff_tb1.sv  +cover -covercells
vsim -voptargs=+acc work.dff_tb1 -cover
add wave *
coverage save dff_tb1.ucdb -onexit
run -all
coverage exclude -du dff_tb1 -togglenode rst