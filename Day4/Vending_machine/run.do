vlib work
vlog *v  +cover
vsim -voptargs=+acc vending_machine_top -cover
add wave *
coverage save vending_machine_top.ucdb -onexit
run -all
add wave /vending_machine_top/dut/vending_machine_sva_inst/Dollar_assertion /vending_machine_top/dut/vending_machine_sva_inst/quarter_dispense_assertion /vending_machine_top/dut/vending_machine_sva_inst/quarter_change_assertion