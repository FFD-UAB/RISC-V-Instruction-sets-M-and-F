`timescale 1ns/1ps
`include "../src/defines.vh"

module reg_file
        (
        clk,
        regfile_we_i,
        regfile_raddr_rs1_i,
        regfile_raddr_rs2_i,
        regfile_waddr_i,
        regfile_data_i,
        regfile_rs1_o,
        regfile_rs2_o,
        rst_n
        );
        // input wires
 input  wire                           rst_n;                   // Reset Neg
 input  wire                           clk;                     // Clock
 input  wire                           regfile_we_i;            // Write Enable
 input  wire [4:0]                     regfile_raddr_rs1_i;     // Read address of r1
 input  wire [4:0]                     regfile_raddr_rs2_i;     // Read address of r2
 input  wire [4:0]                     regfile_waddr_i;         // Write address
 input  wire [`DATA_WIDTH-1:0]         regfile_data_i;          // Data to write
 // Outputs
 output wire [`DATA_WIDTH-1:0]         regfile_rs1_o;           // R1
 output wire [`DATA_WIDTH-1:0]         regfile_rs2_o;           // R2
 // Internal
 reg [`DATA_WIDTH-1:0]                 regFile[0:31];
 integer j;
 // Code
 always @ (posedge clk or negedge rst_n)
  if ( !rst_n ) 
   begin
    for (j=0; j < 32; j=j+1)
     regFile[j] <= {`DATA_WIDTH{1'b0}}; //reset array
   end 
                // Write Operation (regfile_we_i = 1, cs = 1)
  else if ( regfile_we_i && (regfile_waddr_i != 5'h0)) regFile[regfile_waddr_i] <= regfile_data_i;

 assign regfile_rs1_o = (regfile_raddr_rs1_i == 5'h0 ? {`DATA_WIDTH{1'b0}} : regFile[regfile_raddr_rs1_i]);
 assign regfile_rs2_o = (regfile_raddr_rs2_i == 5'h0 ? {`DATA_WIDTH{1'b0}} : regFile[regfile_raddr_rs2_i]);
 
endmodule 