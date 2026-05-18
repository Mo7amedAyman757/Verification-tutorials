vlib work
vlog *v  +cover
vsim -voptargs=+acc dff_top -cover
coverage save dff_top.ucdb -onexit
run -all
vcover report dff_top.ucdb -details -annotate -all -output coverage_rpt.txt