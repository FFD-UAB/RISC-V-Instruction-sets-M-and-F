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

## DATE    "Wed Jul 14 00:00:23 2021"

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

create_clock -name {clk} -period 5.000 -waveform { 0.000 2.500 } [get_ports {clock}]


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

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {clock}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {denom[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {numer[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {quotient[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {remain[31]}]


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

