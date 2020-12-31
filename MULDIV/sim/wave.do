onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testMULDIV/MULDIV/DIVmod/clk
add wave -noupdate /testMULDIV/MULDIV/DIVmod/start_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/a_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/b_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/busy
add wave -noupdate /testMULDIV/MULDIV/DIVmod/reg_q
add wave -noupdate /testMULDIV/MULDIV/DIVmod/reg_r
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/count
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/LeftShifts
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/correctedShifts
add wave -noupdate /testMULDIV/MULDIV/DIVmod/init
add wave -noupdate /testMULDIV/MULDIV/DIVmod/performShift
add wave -noupdate /testMULDIV/MULDIV/DIVmod/finalRes
add wave -noupdate /testMULDIV/MULDIV/DIVmod/res1
add wave -noupdate /testMULDIV/MULDIV/DIVmod/res2
add wave -noupdate /testMULDIV/MULDIV/DIVmod/oneShiftLeft
add wave -noupdate /testMULDIV/MULDIV/DIVmod/outOfBoundsCount
add wave -noupdate /testMULDIV/MULDIV/DIVmod/ZOnLast32bShiftInput
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/a_LeftBitPosition
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/b_LeftBitPosition
add wave -noupdate -radix unsigned /testMULDIV/MULDIV/DIVmod/divisorPosition
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4122 ns} 0}
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
WaveRestoreZoom {6987 ns} {8027 ns}
