vdel -all -lib work
vlib work

vlog -cover bcesft -f src_files.list

vsim -voptargs=+acc work.counter_top -classdebug -uvmcontrol=all +UVM_TESTNAME=counter_test -coverage

run -all

coverage save counter.ucdb
vsim -viewcov counter.ucdb
vcover report counter.ucdb -details -annotate -all -output coverage_rpt.txt