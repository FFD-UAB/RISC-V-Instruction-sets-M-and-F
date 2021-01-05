// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_FP();

 tb TB();
 initial begin 
  TB.pc = 32'b0;
  TB.clk = 1'b0;
  TB.rst_n = 1'b0;
  #100
		
// Load memory
//  $readmemb("data/instrramMem_b.mem", TB.top_CoreMem_inst.mem_instr_inst.mem, 0, 3);
  $readmemh("../data/FPdataMem_h.mem", TB.top_CoreMem_inst.data_mem.sp_ram_data_i.mem_data, 0, 3);
		
  TB.test_FP1;
  #100
  TB.rst_n = 1'b0; 
  #100

  #1000
  $stop;
end

endmodule   