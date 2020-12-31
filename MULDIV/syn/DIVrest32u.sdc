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

## DATE    "Thu Dec 31 18:30:21 2020"

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
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rstLow}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {start_in}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {busy}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {q_out[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {r_out[31]}]


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

