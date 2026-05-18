vdel -all -lib work
vlib work

vlog -cover bcesft -f src_files.list

vsim -voptargs=+acc work.dff_top -classdebug -uvmcontrol=all +UVM_TESTNAME=dff_test -coverage

run -all

coverage save dff.ucdb
vsim -viewcov dff.ucdb
vcover report dff.ucdb -details -annotate -all -output coverage_rpt.txt