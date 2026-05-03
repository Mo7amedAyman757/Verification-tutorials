vsim work.FIFO_top -coverage -voptargs="+acc=mnpr"

# Add everything safely
add wave /FIFO_top/fifo_vif/*
add wave -r /FIFO_top/dut/*

run -all