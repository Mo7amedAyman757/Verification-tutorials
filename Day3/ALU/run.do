vlib work
vlog testing_pkg.sv alu.sv alu_tb.sv  +cover 
vsim -voptargs=+acc work.alu_tb -cover
add wave *
coverage save alu_tb.ucdb -onexit
run -all
vcover report alu_tb.ucdb -details -annotate -all -output coverage_rpt.txt