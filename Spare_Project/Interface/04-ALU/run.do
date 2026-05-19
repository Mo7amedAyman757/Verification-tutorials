vlib work
vlog *v  +cover
vsim -voptargs=+acc ALU_top -cover
coverage save ALU_top.ucdb -onexit
run -all
vcover report ALU_top.ucdb -details -annotate -all -output coverage_rpt.txt