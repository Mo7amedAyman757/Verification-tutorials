vlib work
vlog *v  +cover
vsim -voptargs=+acc priority_enc_top -cover
add wave *
coverage save priority_enc_top.ucdb -onexit
run -all
vcover report priority_enc_top.ucdb -details -annotate -all -output coverage_rpt.txt