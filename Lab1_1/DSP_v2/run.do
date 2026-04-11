vlib work
vlog DSP_pkg.sv DSP.v DSP_tb.sv  +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit
run -all
vcover report DSP_tb.ucdb -details -annotate -all -output coverage_rpt.txt