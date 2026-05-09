vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrolall -cover
add wave /top/ALSU_if/* /top/shift_regif/*
coverage save ALSU.ucdb -onexit
run -all  
coverage exclude -du ALSU -togglenode cin_reg
