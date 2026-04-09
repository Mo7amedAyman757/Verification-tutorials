onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /N_bit_ALU_tb/in1
add wave -noupdate -radix binary /N_bit_ALU_tb/in2
add wave -noupdate -color Magenta -radix binary /N_bit_ALU_tb/op
add wave -noupdate -radix binary /N_bit_ALU_tb/uut/uut/A
add wave -noupdate -radix unsigned /N_bit_ALU_tb/err_count
add wave -noupdate -divider Inputs
add wave -noupdate -radix unsigned /N_bit_ALU_tb/corr_count
add wave -noupdate /N_bit_ALU_tb/uut/SUM
add wave -noupdate /N_bit_ALU_tb/uut/uut/A
add wave -noupdate -color Magenta -radix binary /N_bit_ALU_tb/final
add wave -noupdate /N_bit_ALU_tb/uut/rslt
add wave -noupdate -color Magenta -radix binary /N_bit_ALU_tb/expected
add wave -noupdate -color Magenta -radix binary /N_bit_ALU_tb/uut/uut/B
add wave -noupdate -radix binary /N_bit_ALU_tb/uut/uut/C
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {107 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {525 ns}
