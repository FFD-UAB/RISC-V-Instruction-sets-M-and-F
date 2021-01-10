onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/rst_n
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/clk
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/instr_mem/sp_ram_wrap_i/sp_ram_i/mem
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_busy_alu_i
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/stall_t
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/if_stage_inst/stall_reg
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_M/DIVmod/init
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_M/startDIV
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_M/oneCycleStartSignal
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/e_regfile_rs1_o
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/e_regfile_rs2_o
add wave -noupdate -radix decimal /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/if_stage_inst/pc
add wave -noupdate -radix decimal /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/if_stage_inst/pc4
add wave -noupdate /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_instruction_i
add wave -noupdate -radix binary /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/id_stage_inst/e_ALU_op_o
add wave -noupdate -radix decimal /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/if_stage_inst/d_pc_o
add wave -noupdate -radix decimal /arithmeticologic_test/TB/top_CoreMem_inst/core_inst/if_stage_inst/d_pc4_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4847386 ps} 0}
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
WaveRestoreZoom {20061041 ps} {21777201 ps}
