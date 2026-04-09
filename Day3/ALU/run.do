vlib work
vlog testing_pkg.sv alu.sv ALU_tb.sv  +cover 
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit
run -all
vcover report ALU_tb.ucdb -details -annotate -all -output coverage_rpt.txt