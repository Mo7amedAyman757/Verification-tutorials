vlib work
vlog my_pkg.sv Image.sv  +cover 
vsim -voptargs=+acc work.Image -cover
coverage save Image.ucdb -onexit
run -all
quit -sim
vcover report Image.ucdb -details -annotate -all -output coverage_rpt.txt