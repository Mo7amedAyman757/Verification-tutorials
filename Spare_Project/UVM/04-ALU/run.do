vdel -all -lib work
vlib work

vlog -cover bcesft -f src_files.list

vsim -voptargs=+acc work.ALU_top -classdebug -uvmcontrol=all +UVM_TESTNAME=ALU_test -coverage

run -all

coverage save ALU.ucdb
vsim -viewcov ALU.ucdb
vcover report ALU.ucdb -details -annotate -all -output coverage_rpt.txt