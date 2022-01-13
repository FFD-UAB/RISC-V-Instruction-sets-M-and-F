onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/rst_n
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/clk
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/if_stage_inst/pc
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/brj_pc_t
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/brj_t
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/brj_o
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/control_unit_inst/jump
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_pc_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/d_instruction_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/instr_mem/sp_ram_wrap_instr_i/sp_ram_instr_i/mem
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regfile_we_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regfile_waddr_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regfile_data_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/br_inst/imm_val_i
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/br_inst/base_pc
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/br_inst/brj_pc
add wave -noupdate /tb_branch/TB/top_CoreMem_inst/core_inst/id_stage_inst/br_inst/branch_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {589623 ps} 0}
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
WaveRestoreZoom {1821393 ps} {2976393 ps}
