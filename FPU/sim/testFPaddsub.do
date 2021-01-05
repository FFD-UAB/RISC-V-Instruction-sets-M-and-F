onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbADDSUB/FsADDSUB/rs1_i
add wave -noupdate /tbADDSUB/FsADDSUB/rs2_i
add wave -noupdate /tbADDSUB/FsADDSUB/rs1_e
add wave -noupdate /tbADDSUB/FsADDSUB/rs2_e
add wave -noupdate /tbADDSUB/FsADDSUB/rs1_m
add wave -noupdate /tbADDSUB/FsADDSUB/rs2_m
add wave -noupdate /tbADDSUB/FsADDSUB/res_s
add wave -noupdate /tbADDSUB/FsADDSUB/res_e
add wave -noupdate /tbADDSUB/FsADDSUB/res_m
add wave -noupdate /tbADDSUB/FsADDSUB/shifts
add wave -noupdate /tbADDSUB/FsADDSUB/MSBOneBitPosition
add wave -noupdate /tbADDSUB/FsADDSUB/Postalign_e
add wave -noupdate /tbADDSUB/FsADDSUB/Postalign_m
add wave -noupdate /tbADDSUB/FsADDSUB/last
add wave -noupdate /tbADDSUB/FsADDSUB/guard
add wave -noupdate /tbADDSUB/FsADDSUB/round
add wave -noupdate /tbADDSUB/FsADDSUB/Round_e0
add wave -noupdate /tbADDSUB/FsADDSUB/Round_m0
add wave -noupdate /tbADDSUB/FsADDSUB/Round_e1
add wave -noupdate /tbADDSUB/FsADDSUB/Round_m1t
add wave -noupdate /tbADDSUB/FsADDSUB/Round_m1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {2150 ns} {3150 ns}
