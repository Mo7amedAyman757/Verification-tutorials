vlib work
vlog *v  +cover
vsim -voptargs=+acc adder_top -cover
add wave *
coverage save adder_top.ucdb -onexit
run -all
vcover report adder_top.ucdb -details -annotate -all -output coverage_rpt.txt