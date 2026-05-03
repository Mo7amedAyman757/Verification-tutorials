vdel -all -lib work
vlib work

vlog -cover bcesft -f src_files.list

vsim work.top -coverage -voptargs=+acc -classdebug -uvmcontrol=all

add wave /top/shift_regif/*
run -all

coverage save shift_reg.ucdb
vsim -viewcov shift_reg.ucdb