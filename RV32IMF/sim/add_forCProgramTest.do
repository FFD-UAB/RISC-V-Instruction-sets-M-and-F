onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_instrMem/clk
add wave -noupdate /tb_instrMem/rst_n
add wave -noupdate /tb_instrMem/CoreMem/instr_mem/sp_ram_wrap_instr_i/sp_ram_instr_i/mem_instr
add wave -noupdate -expand /tb_instrMem/CoreMem/data_mem/sp_ram_data_i/mem_data
add wave -noupdate /tb_instrMem/CoreMem/core_inst/if_stage_inst/pc
add wave -noupdate /tb_instrMem/CoreMem/core_inst/if_stage_inst/d_instruction_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate /tb_instrMem/CoreMem/data_mem/addr_i
add wave -noupdate /tb_instrMem/CoreMem/data_mem/we_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/mem_stage_inst/m_regfile_wr_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/alu_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/m_data_wr_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/m_regfile_rd_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/e_data_target_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/data_wdata
add wave -noupdate /tb_instrMem/CoreMem/core_inst/exe_stage_inst/e_regfile_rs2_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/data_wr_t
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/e_regfile_rs2_t
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/w_regfile_rd_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/m_regfile_rd_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/alu_i
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/e_regfile_wr_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/control_unit_inst/regfile_wr
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/control_unit_inst/opcode
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/stall_general_o
add wave -noupdate /tb_instrMem/CoreMem/core_inst/id_stage_inst/stall_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1440228 ps} 0}
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
WaveRestoreZoom {1301467 ps} {2403967 ps}
