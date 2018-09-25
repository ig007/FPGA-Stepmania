onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/clk
add wave -noupdate /DE1_SoC_testbench/reset
add wave -noupdate /DE1_SoC_testbench/key0
add wave -noupdate /DE1_SoC_testbench/key1
add wave -noupdate /DE1_SoC_testbench/key2
add wave -noupdate /DE1_SoC_testbench/key3
add wave -noupdate /DE1_SoC_testbench/hex2
add wave -noupdate /DE1_SoC_testbench/hex1
add wave -noupdate /DE1_SoC_testbench/hex0
add wave -noupdate /DE1_SoC_testbench/red_driver
add wave -noupdate /DE1_SoC_testbench/green_driver
add wave -noupdate /DE1_SoC_testbench/row_sink
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40 ps} 0}
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
configure wave -gridperiod 300
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3 ps} {67 ps}
