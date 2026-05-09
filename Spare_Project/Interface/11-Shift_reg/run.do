vlib work
vmap work work

vlog -sv +cover shift_reg.v
vlog -sv +cover shiftreg_pkg.sv
vlog -sv +cover shiftreg_if.sv
vlog -sv +cover shiftreg_sva.sv
vlog -sv +cover shiftreg_monitor.sv
vlog -sv +cover shiftreg_tb.sv
vlog -sv +cover shiftreg_top.sv

vsim -coverage -voptargs=+acc work.shiftreg_top

add wave /shiftreg_top/dut/shift_sva_inst/assert__reset_check
add wave /shiftreg_top/dut/shift_sva_inst/assert__rotate_left_check
add wave /shiftreg_top/dut/shift_sva_inst/assert__rotate_right_check
add wave /shiftreg_top/dut/shift_sva_inst/assert__shift_left_check
add wave /shiftreg_top/dut/shift_sva_inst/assert__shift_right_check

run -all

coverage save shiftreg.ucdb
vcover report shiftreg.ucdb -details -annotate -all -output coverage_rpt.txt
