// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

//`include"testbench.v"

module arithmeticologic_test();

 tb TB();
 initial begin 

  TB.pc = 32'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;

// Initialize registers
  TB.clk = 1'b0;
  TB.rst_n = 1'b0;
  #100
		
// Load memory
//  $readmemb("data/programMem_b.mem", TB.top_inst.mem_prog_inst.progArray, 0, 3);
//  $readmemh("../data/dataMem_h.mem", TB.top_inst.data_mem.sp_ram_i.mem, 0, 3);
		
  TB.test_mul;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_mulh;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_mulhsu;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_mulhu;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_div;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_divu;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_rem;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_remu;
  #100
  TB.rst_n = 1'b0;
  TB.top_inst.mem_prog_inst.initializeProgMem;
  #100

  TB.test_oncecycle_divrem;

  #1000
  $stop;
end

endmodule   