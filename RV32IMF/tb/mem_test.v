`timescale 1ns/1ps


module tb_instrMem();

 reg clk;
 reg rst_n;
 always #50 clk = !clk;

 top_CoreMem CoreMem(
       .clk    ( clk   ),
       .rst_n  ( rst_n )
       );

 initial begin 
   //TB.top_CoreMem_inst.mem_instr_inst.initializeinstrMem;

   // Initialize registers
   clk = 1'b0;
   rst_n = 1'b1;
   //$readmemh("../data/programMem_h.mem", CoreMem.instr_mem.sp_ram_instr_i.mem);
   #100
   rst_n = 1'b0;
   #100
   rst_n = 1'b1;

   #4000 $stop;
   
 end

endmodule 