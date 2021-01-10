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

## DATE    "Tue Jan 05 22:51:13 2021"

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

create_clock -name {clk} -period 5.000 -waveform { 0.000 2.500 } 


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

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {SUBflag_i}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {frm_i[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {frm_i[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {frm_i[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs1_i[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rs2_i[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_o[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {fflags_o[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {fflags_o[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {fflags_o[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {fflags_o[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {fflags_o[4]}]


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

