onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/rst_n
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/clk
add wave -noupdate /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regFile
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_we_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_raddr_rs1_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_raddr_rs2_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_waddr_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_data_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_rs1_o
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/core_inst/id_stage_inst/reg_file_inst/regfile_rs2_o
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/ADDR_WIDTH
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/DATA_WIDTH
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/NUM_WORDS
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/words
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/clk
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/en_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/addr_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/wdata_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/rdata_o
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/we_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/be_i
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/wdata
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/addr
add wave -noupdate -radix hexadecimal /load_store_test/TB/top_inst/data_mem/sp_ram_i/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2035020 ps} 0}
configure wave -namecolwidth 476
configure wave -valuecolwidth 104
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {4988550 ps}
