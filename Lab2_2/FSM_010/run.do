vlib work
vlog FSM_010.v FSM_pkg.sv FSM_010_tb.sv  +cover 
vsim -voptargs=+acc work.FSM_010_tb -cover
add wave *
coverage save FSM_010_tb.ucdb -onexit
run -all
coverage exclude -src FSM_010.v -line 43 -code s
coverage exclude -src FSM_010.v -line 43 -code b
vcover report FSM_010_tb.ucdb -details -annotate -all -output coverage_rpt.txt