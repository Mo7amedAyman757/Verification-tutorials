vlib work
vlog DFF_pkg.sv dff.v DFF_tb1.sv  +cover -covercells
vsim -voptargs=+acc work.DFF_tb1 -cover
add wave *
coverage save DFF_tb1.ucdb -onexit
run -all
vcover report DFF_tb1.ucdb -details -annotate -all -output coverage1_rpt.txt