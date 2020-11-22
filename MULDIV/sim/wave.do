onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testMULDIV/MULDIV/DIVmod/clk
add wave -noupdate /testMULDIV/MULDIV/DIVmod/start_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/a_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/b_in
add wave -noupdate /testMULDIV/MULDIV/DIVmod/busy
add wave -noupdate /testMULDIV/MULDIV/DIVmod/reg_q
add wave -noupdate /testMULDIV/MULDIV/DIVmod/reg_r
add wave -noupdate /testMULDIV/MULDIV/DIVmod/res
add wave -noupdate /testMULDIV/MULDIV/DIVmod/pushedDividend
add wave -noupdate /testMULDIV/MULDIV/DIVmod/a_LeftBitPosition
add wave -noupdate /testMULDIV/MULDIV/DIVmod/b_LeftBitPosition
add wave -noupdate /testMULDIV/MULDIV/DIVmod/LeftShifts
add wave -noupdate /testMULDIV/MULDIV/DIVmod/count
add wave -noupdate /testMULDIV/MULDIV/DIVmod/init
add wave -noupdate /testMULDIV/MULDIV/DIVmod/State
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1838 ns} 0}
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
WaveRestoreZoom {1225 ns} {2225 ns}
