// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_fcsr();

tb TB();
 
initial begin 	
 TB.pc = 32'b0;
 //TB.top_CoreMem_inst.mem_instr_inst.initializeinstrMem;
 
 // Initialize registers
 TB.clk = 1'b0;
 TB.rst_n = 1'b0;
 #100
 
 // Load memory
 //$readmemb("data/instrramMem_b.mem", TB.top_CoreMem_inst.mem_instr_inst.mem, 0, 3);
 //$readmemh("../data/dataMem_h.mem", TB.top_CoreMem_inst.mem_data_inst.mem, 0, 3);
 
 TB.test_fcsr;
 TB.waitNclockCycles(16);
 $stop;
end

endmodule   