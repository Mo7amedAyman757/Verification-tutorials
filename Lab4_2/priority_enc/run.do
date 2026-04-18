vlib work
vlog *v  +cover
vsim -voptargs=+acc enc_top -cover
add wave *
coverage save enc_top.ucdb -onexit
run -all
vcover report enc_top.ucdb -details -annotate -all -output coverage_rpt.txt