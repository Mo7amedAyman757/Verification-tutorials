vlib work
vlog ALSU.v ALSU_pkg.sv ALSU_tb.sv  +cover 
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit
run -all
coverage exclude -src ALSU.v -line 117 -code s
coverage exclude -src ALSU.v -line 117 -code b
coverage exclude -du ALSU -togglenode cin_reg
vcover report ALSU_tb.ucdb -details -annotate -all -output coverage_rpt.txt