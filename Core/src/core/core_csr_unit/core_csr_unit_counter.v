`timescale 1ns/1ps
`include "../../defines.vh"

module counter (
    clk,
    inc_i,
    rst_n,
    val_o
    );

 input  wire                           clk;
 input  wire                           inc_i;
 input  wire                           rst_n;
 output reg  [`CSR_XLEN-1:0]           val_o;

 always @ (posedge clk or negedge rst_n) 
  begin
   if ( !rst_n ) val_o <= {`CSR_XLEN{1'b0}};
   else if (inc_i) val_o <= val_o + 1;
  end
  
endmodule