## Generated SDC file "DIVrest32u.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

## DATE    "Wed Jun 02 19:59:36 2021"

##
## DEVICE  "EP3C16F484C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 1.000 -waveform { 0.000 0.500 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_gnt_i}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rdata_i[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_rvalid_i}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_rdata_i[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rst_n}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_addr_o[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_be_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_be_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_be_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_be_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_req_o}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wdata_o[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {data_wr_o}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {flush_inst_o}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {instruction_addr_o[11]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

