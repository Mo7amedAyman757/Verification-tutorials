vlib work

vlog -sv +define+SIM +cover=bcesf -f src_files.list

vsim work.FIFO_top -voptargs=+acc -classdebug -uvmcontrol=all +UVM_TESTNAME=FIFO_test -coverage

add wave /FIFO_top/dut/*
add wave /FIFO_top/dut/assert__Reset_Behavior \
         /FIFO_top/dut/assert__Write_Acknowledge \
         /FIFO_top/dut/assert__overflow_detection \
         /FIFO_top/dut/assert__underflow_detection \
         /FIFO_top/dut/assert__Full_Flag \
         /FIFO_top/dut/assert__Empty_Flag \
         /FIFO_top/dut/assert__AlmostFull_Flag \
         /FIFO_top/dut/assert__AlmostEmpty_Flag \
         /FIFO_top/dut/assert__WrPtr_Wraparound \
         /FIFO_top/dut/assert__RdPtr_Wraparound \
         /FIFO_top/dut/assert__Ptr_Threshold
run -all

coverage save FIFO_coverage.ucdb

vcover report FIFO_coverage.ucdb -details -annotate -all -output coverage_rpt.txt 