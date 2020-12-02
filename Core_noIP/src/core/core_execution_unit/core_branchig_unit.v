`timescale 1ns/1ps
`include "../../defines.vh"

module 	br 
       (
        BR_op_i,
        pc_i,
        imm_val_i,
        brj_pc_o,
        branch_o,
        regfile_rs1_i,
        regfile_rs2_i,
        jalr_i
        );

 input  wire [`BR_OP_WIDTH-1:0]        BR_op_i;
 input  wire [`DATA_WIDTH-1:0]         imm_val_i;
 input  wire [`DATA_WIDTH-1:0]         pc_i;
 output wire [`DATA_WIDTH-1:0]         brj_pc_o;
 input  wire [`DATA_WIDTH-1:0]         regfile_rs1_i;
 input  wire [`DATA_WIDTH-1:0]         regfile_rs2_i;
 output reg                            branch_o;
 
 wire                                  regfile_rs1_iEqualtoRs2;
 wire                                  signedRs1SmallerThanRs2;
 wire                                  unsignedRs1SmallerThanRs2;
 wire        [`DATA_WIDTH-1:0]         brj_pc;
 wire        [`DATA_WIDTH-1:0]         base_pc;
 input wire                            jalr_i;
  
 assign base_pc  = jalr_i ? regfile_rs1_i : pc_i;
 assign brj_pc   = base_pc + imm_val_i; 
 assign brj_pc_o = {brj_pc[`DATA_WIDTH-1:1], (jalr_i ? 1'b0 : brj_pc[0])};
 
 //-----------------Branching logic----------------------------//
 assign signedRs1SmallerThanRs2 = ($signed(regfile_rs1_i) < $signed(regfile_rs2_i));
 //comparator regfile_rs1_i<regfile_rs2_i, unsigned operands
 assign unsignedRs1SmallerThanRs2 = regfile_rs1_i < regfile_rs2_i;
 //comparator regfile_rs1_i == regfile_rs2_i, signed operands
 assign regfile_rs1_iEqualtoRs2 = ($signed(regfile_rs1_i) == $signed(regfile_rs2_i));
 
 always @(*)
  case (BR_op_i)
   `BR_EQ:  branch_o = (regfile_rs1_iEqualtoRs2); //($signed(regfile_rs1_i) == $signed(regfile_rs2_ib));     
   `BR_NE:  branch_o = (!regfile_rs1_iEqualtoRs2); //($signed(regfile_rs1_i) != $signed(regfile_rs2_ib));
   `BR_LT:  branch_o = (signedRs1SmallerThanRs2); //($signed(regfile_rs1_i) < $signed(regfile_rs2_ib));
   `BR_LTU: branch_o = (unsignedRs1SmallerThanRs2); //(regfile_rs1_i < regfile_rs2_ib);
   `BR_GE:  branch_o = (signedRs1SmallerThanRs2); //($signed(regfile_rs1_i) >= $signed(regfile_rs2_ib));
   `BR_GEU: branch_o = (unsignedRs1SmallerThanRs2); //(regfile_rs1_i >= regfile_rs2_i);
   default: branch_o = 1'b0;
  endcase

endmodule