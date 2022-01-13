// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

//`include"../tb/testbench.v"

module tb_branch();
tb TB();
 initial begin 
//$dumpfile("vcd/riscV.vcd");
//$dumpvars(0, TB.top_CoreMem_inst);

  TB.pc = 32'b0;
// Initialize registers
  TB.clk = 1'b0;
  TB.rst_n = 1'b0;
  #100

// Load memory
//$readmemb("data/instrramMem_b.mem", TB.top_CoreMem_inst.mem_instr_inst.mem, 0, 3);
//$readmemh("data/dataMem_h.mem", TB.top_CoreMem_inst.mem_data_inst.mem, 0, 3/*TB.test_jal;
  TB.test_jal;
  TB.rst_n = 1'b0;
  #100

  TB.test_jalr;
  TB.rst_n = 1'b0;
  #100

  TB.test_beq;
  TB.rst_n = 1'b0;
  #100

  TB.test_lui;
  TB.rst_n = 1'b0;
  #100
	
  TB.test_auipc;
  TB.rst_n = 1'b0;
  #100

  $stop();
end

endmodule   
