vdel -all -lib work
vlib work

vlog -cover bcesft -f src_files.list

vsim -voptargs=+acc work.shiftreg_top -classdebug -uvmcontrol=all +UVM_TESTNAME=shiftreg_test -coverage
add wave /shiftreg_top/shiftreg_sva_inst/assert__reset_check 
add wave /shiftreg_top/shiftreg_sva_inst/assert__rotate_left_check
add wave /shiftreg_top/shiftreg_sva_inst/assert__rotate_right_check 
add wave /shiftreg_top/shiftreg_sva_inst/assert__shift_left_check /shiftreg_top/shiftreg_sva_inst/assert__shift_right_check
run -all

coverage save shift_reg.ucdb
vsim -viewcov shift_reg.ucdb
vcover report shift_reg.ucdb -details -annotate -all -output coverage_rpt.txt