onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fcsr/TB/rst_n
add wave -noupdate /tb_fcsr/TB/clk
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/instr_mem/sp_ram_wrap_instr_i/sp_ram_instr_i/mem_instr
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/data_mem/sp_ram_data_i/mem_data
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/if_stage_inst/instruction_rdata_i
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate -radix binary /tb_fcsr/TB/top_CoreMem_inst/core_inst/id_stage_inst/crs_unit_inst/csr_fflags_i
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/id_stage_inst/crs_unit_inst/csr_frm_o
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/e_ALU_op_i
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/e_frm_i
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/ctrlStartF
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/op1_ALU
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/op2_ALU
add wave -noupdate /tb_fcsr/TB/top_CoreMem_inst/core_inst/exe_stage_inst/alu_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {517469 ps} 0}
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
WaveRestoreZoom {0 ps} {1444276 ps}
