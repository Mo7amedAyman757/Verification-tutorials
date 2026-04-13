vlib work
vlog  adder_pkg.sv adder.v  adder_tb.sv  +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit
run -all
vcover report adder_tb.ucdb -details -annotate -all -output coverage_rpt.txt