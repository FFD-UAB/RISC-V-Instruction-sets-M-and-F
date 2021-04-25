transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneiii_ver
vmap cycloneiii_ver ./verilog_libs/cycloneiii_ver
vlog -vlog01compat -work cycloneiii_ver {e:/programas/quartus/altera_lite/13.1/quartus/eda/sim_lib/cycloneiii_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/DE0 {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/DE0/PLL.v}
vlog -vlog01compat -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/lib {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/lib/ALTMULT_ADD32.v}
vlog -vlog01compat -work work +incdir+E:/Programas/Quartus/altera_lite/DE0_FFD/db {E:/Programas/Quartus/altera_lite/DE0_FFD/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/top_DE0.v}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/sp_ram_data.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/ram_mux.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/config.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/boot_code.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/sp_ram_wrap_instr.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/sp_ram_wrap_data.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/sp_ram_instr.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/instr_ram_wrap.sv}
vlog -sv -work work +incdir+E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem {E:/Programas/Quartus/altera_lite/QuartusCode/DE0_FPGA/src/mem/boot_rom_wrap.sv}
vlog -vlog01compat -work work tb_DE0_FFD.v
