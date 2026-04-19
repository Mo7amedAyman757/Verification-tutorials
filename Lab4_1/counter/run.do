vlib work
vlog *v  +cover
vsim -voptargs=+acc counter_top -cover
add wave *
coverage save counter_top.ucdb -onexit
run -all
vcover report counter_top.ucdb -details -annotate -all -output coverage_rpt.txt