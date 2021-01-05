onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_FP/TB/clk
add wave -noupdate /tb_FP/TB/rst_n
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/data_mem/sp_ram_data_i/mem_data
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/instr_mem/sp_ram_wrap_instr_i/sp_ram_instr_i/mem_instr
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_pc_i
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_instruction_i
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_f_inst/regFile_F
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/d_fflags_o
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs1_i
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs2_i
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs1_e
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs2_e
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs1_m
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/rs2_m
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/res_s
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/res_e
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/res_m
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/shifts
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/MSBOneBitPosition
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Postalign_e
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Postalign_m
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/last
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/guard
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/round
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Round_e0
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Round_m0
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Round_e1
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Round_m1t
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/ADDSUBs/Round_m1
add wave -noupdate /tb_FP/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ALU_F/c_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1050000 ps} 0}
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
WaveRestoreZoom {2440282 ps} {3293670 ps}
