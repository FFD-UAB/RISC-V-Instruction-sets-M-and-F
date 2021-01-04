`timescale 1ns/1ps
`include "../../defines.vh"

module timer (
    clk,
    rst_n,
    val_o,
    we_i
    );

 input  wire                           clk;
 input  wire                           rst_n;
 input  wire                           we_i;
 output reg  [`CSR_XLEN-1:0]           val_o;

 always @ (posedge clk or negedge rst_n)
  if ( !rst_n ) val_o <= {`CSR_XLEN{1'b0}};
  else if (we_i) val_o <= val_o + 1;

endmodule