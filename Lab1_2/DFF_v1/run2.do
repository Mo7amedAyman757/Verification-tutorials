vlib work
vlog dff.v dff_tb2.sv  +cover -covercells
vsim -voptargs=+acc work.dff_tb2 -cover
add wave *
coverage save dff_tb2.ucdb -onexit
run -all
coverage exclude -du dff_tb2 -togglenode rst