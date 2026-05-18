vlib work
vlog *v  +cover
vsim -voptargs=+acc counter_top -cover

add wave -position insertpoint  \
sim:/counter_top/counterif/clk \
sim:/counter_top/counterif/rst_n \
sim:/counter_top/counterif/load_n \
sim:/counter_top/counterif/ce \
sim:/counter_top/counterif/up_down \
sim:/counter_top/counterif/data_load \
sim:/counter_top/counterif/count_out \
sim:/counter_top/counterif/zero \
sim:/counter_top/counterif/max_count
add wave /counter_top/dut/counter_sva_inst/a_decrement_assertion /counter_top/dut/counter_sva_inst/a_hold_assertion /counter_top/dut/counter_sva_inst/a_increment_assertion /counter_top/dut/counter_sva_inst/a_load_active_assertion /counter_top/dut/counter_sva_inst/a_max_count_assertion /counter_top/dut/counter_sva_inst/a_reset_assertion /counter_top/dut/counter_sva_inst/a_zero_assertion
coverage save counter_top.ucdb -onexit
run -all
vcover report counter_top.ucdb -details -annotate -all -output coverage_rpt.txt