vlib work
vlog ALU_pkg.sv ALU.v ALU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit
run -all
vcover report ALU_tb.ucdb -details -annotate -all -output coverage_rpt.txt