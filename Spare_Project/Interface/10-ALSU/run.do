vlib work
vmap work work

vlog -sv +cover ALSU_enum.sv
vlog -sv +cover ALSU.v
vlog -sv +cover ALSU_pkg.sv
vlog -sv +cover ALSU_if.sv
vlog -sv +cover ALSU_sva.sv
vlog -sv +cover ALSU_monitor.sv
vlog -sv +cover ALSU_tb.sv
vlog -sv +cover ALSU_top.sv

vsim -coverage -voptargs=+acc work.ALSU_top
add wave -divider "ALSU Signals"
add wave -position insertpoint  \
sim:/ALSU_top/ALSU_vif/clk \
sim:/ALSU_top/ALSU_vif/rst \
sim:/ALSU_top/ALSU_vif/A \
sim:/ALSU_top/ALSU_vif/B \
sim:/ALSU_top/ALSU_vif/cin \
sim:/ALSU_top/ALSU_vif/opcode \
sim:/ALSU_top/ALSU_vif/serial_in \
sim:/ALSU_top/ALSU_vif/direction \
sim:/ALSU_top/ALSU_vif/bypass_A \
sim:/ALSU_top/ALSU_vif/bypass_B \
sim:/ALSU_top/ALSU_vif/red_op_A \
sim:/ALSU_top/ALSU_vif/red_op_B \

add wave -divider "ALSU registers"
add wave -position insertpoint  \
sim:/ALSU_top/dut/serial_in_reg \
sim:/ALSU_top/dut/red_op_B_reg \
sim:/ALSU_top/dut/red_op_A_reg \
sim:/ALSU_top/dut/opcode_reg \
sim:/ALSU_top/dut/invalid_red_op \
sim:/ALSU_top/dut/invalid_opcode \
sim:/ALSU_top/dut/invalid \
sim:/ALSU_top/dut/direction_reg \
sim:/ALSU_top/dut/cin_reg \
sim:/ALSU_top/dut/bypass_B_reg \
sim:/ALSU_top/dut/bypass_A_reg \
sim:/ALSU_top/dut/B_reg \
sim:/ALSU_top/dut/A_reg

add wave -divider "ALSU output"
add wave -position insertpoint \
sim:/ALSU_top/ALSU_vif/out \
sim:/ALSU_top/ALSU_vif/leds 

add wave -divider "ALSU assertions"
add wave /ALSU_top/dut/ALSU_sva_inst/assert__reset_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__invalid_led_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__invalid_out_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_add_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_mult_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__bypass_A_only_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__bypass_both_A_priority_check
add wave /ALSU_top/dut/ALSU_sva_inst/assert__bypass_B_only_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_or_both_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_or_A_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_or_B_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_or_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_xor_A_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_xor_B_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__red_op_xor_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_shift_left_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_shift_right_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_rotate_left_check 
add wave /ALSU_top/dut/ALSU_sva_inst/assert__opcode_rotate_right_check

run -all

coverage save ALSU.ucdb
vcover report ALSU.ucdb -details -annotate -all -output coverage_rpt.txt
