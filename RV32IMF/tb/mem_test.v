`timescale 1ns/1ps

// Test used to load RISC-V hex .mem programs into the instrMem and execute them.
// It allows to automatically stop after 20 clock cycles and stop again if the 
// program returns to 0x0 position memory, which the C2RISCV compiler does.

module tb_instrMem();

 reg clk;
 reg rst_n;
 reg [31:0] start_instr_address;

 always #50 clk = !clk;

 top_CoreMem CoreMem(
       .clk    ( clk   ),
       .rst_n  ( rst_n ),
       .axi_instr_req  (1'b0),
       .axi_data_req   (1'b0)
       );

 initial begin 
   //TB.top_CoreMem_inst.mem_instr_inst.initializeinstrMem;

   // Initialize registers
   start_instr_address = 32'h0;
   clk = 1'b0;
   rst_n = 1'b1;
   $readmemh("../data/programMem_h.mem", CoreMem.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr);

   #100
   rst_n = 1'b0;
   #100
   rst_n = 1'b1;
   CoreMem.core_inst.if_stage_inst.pc = start_instr_address;

   #2000 $stop;

   while(1) @(CoreMem.core_inst.if_stage_inst.pc) if(CoreMem.core_inst.if_stage_inst.pc == 0) $stop;
   
 end

endmodule 