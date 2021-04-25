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

## DATE    "Sat Apr 10 13:46:40 2021"

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

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {a_in[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {b_in[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[32]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[33]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[34]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[35]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[36]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[37]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[38]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[39]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[40]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[41]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[42]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[43]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[44]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[45]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[46]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[47]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[48]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[49]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[50]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[51]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[52]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[53]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[54]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[55]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[56]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[57]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[58]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[59]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[60]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[61]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[62]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {c_out[63]}]


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

