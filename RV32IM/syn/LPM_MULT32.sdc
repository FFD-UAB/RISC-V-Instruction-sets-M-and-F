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

## DATE    "Thu Dec 31 17:20:07 2020"

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

create_clock -name {clk} -period 5.000 -waveform { 0.000 2.500 } [get_ports {clock0}]


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

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {dataa[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {datab[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[32]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[33]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[34]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[35]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[36]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[37]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[38]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[39]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[40]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[41]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[42]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[43]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[44]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[45]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[46]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[47]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[48]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[49]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[50]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[51]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[52]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[53]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[54]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[55]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[56]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[57]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[58]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[59]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[60]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[61]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[62]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {result[63]}]


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

