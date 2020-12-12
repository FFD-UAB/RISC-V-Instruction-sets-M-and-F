onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arithmeticologic_test/TB/clk
add wave -noupdate /arithmeticologic_test/TB/rst_n
add wave -noupdate /arithmeticologic_test/TB/instruction
add wave -noupdate /arithmeticologic_test/TB/pc
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/instr_mem/sp_ram_wrap_instr_i/sp_ram_instr_i/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1006481 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5959276 ps}
