All resource usage estimations are provided by Quartus II 13.1 Web 
Edition when putting the model EP3C16F484C6N from the Cyclone III 
family as target platform. The resource usage of every design will 
change depending on the target FPGA platform is synthesizing to.

The RTL mapping is provided by Quartus Prime 15.1 Lite Edition, as
the 13.1 version doesn't compress multiple wires into busses. The 
target platform for the RTL mapping shouldn't matter, as it's just 
a netlist representation generated from the Verilog design previous 
to synthesization, but in any case, the target platform for only 
RTL mapping has been the model 5CGTFD5F5M11C7 from the Cyclone V 
family.

Read "MULDIV performance.txt" for an extended look over the performance 
of the different DIV designs, MUL multifunction IPs and its maximum 
operating frequency estimation at the DE0 FPGA board platform using 
Quartus II 13.1.