vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all
add wave /ALSU_top/DUT/*
add wave /ALSU_top/ALSU_sva_inst/assert_reset /ALSU_top/ALSU_sva_inst/assert_invalid_led /ALSU_top/ALSU_sva_inst/assert_invalid_out 
run -all