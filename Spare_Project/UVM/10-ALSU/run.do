vlib work
vlog +cover=bcesft -f src_files.list

vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all +UVM_TESTNAME=ALSU_test -coverage 
add wave -divider "ALSU assertions"
add wave /ALSU_top/ALSU_sva_inst/assert__reset_check 
add wave /ALSU_top/ALSU_sva_inst/assert__invalid_led_check 
add wave /ALSU_top/ALSU_sva_inst/assert__invalid_out_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_add_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_mult_check 
add wave /ALSU_top/ALSU_sva_inst/assert__bypass_A_only_check 
add wave /ALSU_top/ALSU_sva_inst/assert__bypass_both_A_priority_check
add wave /ALSU_top/ALSU_sva_inst/assert__bypass_B_only_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_or_both_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_or_A_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_or_B_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_or_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_xor_A_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_xor_B_check 
add wave /ALSU_top/ALSU_sva_inst/assert__red_op_xor_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_shift_left_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_shift_right_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_rotate_left_check 
add wave /ALSU_top/ALSU_sva_inst/assert__opcode_rotate_right_check

run -all

coverage save ALSU.ucdb
vsim -viewcov ALSU.ucdb
vcover report ALSU.ucdb -details -annotate -all -output coverage_rpt.txt