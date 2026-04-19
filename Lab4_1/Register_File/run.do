vlib work
vlog config_reg_buggy_questa.svp RegisterFile_tb.sv  +cover
vsim -voptargs=+acc work.RegisterFile_tb -cover
add wave *
coverage save RegisterFile_tb.ucdb -onexit
run -all
vcover report RegisterFile_tb.ucdb -details -annotate -all -output coverage_rpt.txt