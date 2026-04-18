vlib work
vlog *v  +cover
vsim -voptargs=+acc ALU_top -cover
add wave *
coverage save ALU_top.ucdb -onexit
run -all
coverage exclude -src ALU.sv -line 20 -code b
coverage exclude -src ALU.sv -line 20 -code s
vcover report ALU_top.ucdb -details -annotate -all -output coverage_rpt.txt