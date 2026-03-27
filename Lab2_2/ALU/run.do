vlib work
vlog ALU.v ALU_pkg.sv ALU_tb.sv  +cover 
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit
run -all
coverage exclude -src ALU.v -line 26 -code s
coverage exclude -src ALU.v -line 26 -code b
vcover report ALU_tb.ucdb -details -annotate -all -output coverage_rpt.txt