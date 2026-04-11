vlib work
vlog DFF_pkg.sv dff.v DFF_tb2.sv  +cover -covercells
vsim -voptargs=+acc work.DFF_tb2 -cover
add wave *
coverage save DFF_tb2.ucdb -onexit
run -all
vcover report DFF_tb2.ucdb -details -annotate -all -output coverage2_rpt.txt