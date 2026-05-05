vlib work
vlog +cover=bcesf -f src_files.list
vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all +UVM_TESTNAME=ALSU_test -coverage
add wave /ALSU_top/DUT/*
#add wave /ALSU_top/ALSU_sva_inst/assert_reset /ALSU_top/ALSU_sva_inst/assert_invalid_led /ALSU_top/ALSU_sva_inst/assert_invalid_out 
run -all
add wave /ALSU_top/ALSU_sva_inst/assert_reset /ALSU_top/ALSU_sva_inst/assert_invalid_led /ALSU_top/ALSU_sva_inst/assert_invalid_out
coverage save ALSU.ucdb
vcover report ALSU.ucdb -details -annotate -all -output coverage_rpt.txt 
