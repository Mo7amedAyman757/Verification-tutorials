vlib work
vlog my_mem.sv mymem_tb.sv  +cover 
vsim -voptargs=+acc work.mymem_tb -cover
add wave *
coverage save mymem_tb.ucdb -onexit
run -all
vcover report mymem_tb.ucdb -details -annotate -all -output coverage_rpt.txt
