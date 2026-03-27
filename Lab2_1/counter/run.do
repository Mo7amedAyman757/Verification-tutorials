vlib work
vlog  counter.v counter_pkg.sv counter_tb.sv  +cover
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter_tb.ucdb -onexit
run -all
vcover report counter_tb.ucdb -details -annotate -all -output coverage_rpt.txt