`timescale 1ns/1ps
`include "../../defines.vh"

module alu(
        input  wire             [3:0]   ALU_op_i,
        input  wire [`DATA_WIDTH-1:0]   s1_i,
        input  wire [`DATA_WIDTH-1:0]   s2_i,
        output reg  [`DATA_WIDTH-1:0]   result_o,
        output wire zero_o
        );
        
        wire [4:0]                     shift = s2_i[4:0];
        
        assign zero_o = (result_o == {`DATA_WIDTH{1'b0}}) ? 1'b1 : 1'b0;
        
        always @ *
         case(ALU_op_i)
          `ALU_OP_ADD  :  result_o = s1_i + s2_i;               // Add s2_i to s1_i and place the result into d
          `ALU_OP_SUB  :  result_o = s1_i - s2_i;               // Subtract s2_i from s1_i and place the result into d
          `ALU_OP_SLL  :  result_o = s1_i << shift;             // Shift s1_i left by the by the lower 5 bits in s2_i and place the result into d
          `ALU_OP_SLT  :  result_o = $signed(s1_i) < $signed(s2_i) ? {{`DATA_WIDTH-1{1'b0}},1'b1} : 0;	// Set d to 1 if s1_i is less than s2_i, otherwise set d to 0 (signed)
          `ALU_OP_SLTU :  result_o = s1_i < s2_i ? {{`DATA_WIDTH-1{1'b0}},1'b1} : 0;			  // Set d to 1 if s1_i is less than s2_i, otherwise set d to 0 (unsigned)
          `ALU_OP_XOR  :  result_o = s1_i ^ s2_i;               // Set d to the bitwise XOR of s1_i and s2_i
          `ALU_OP_SRL  :  result_o = s1_i >> shift;             // Shift s1_i right by the by the lower 5 bits in s2_i and place the result into d
          `ALU_OP_SRA  :  result_o = $signed(s1_i) >>> shift;// Shift s1_i right by the by the lower 5 bits in s2_i and place the result into d while retaining the sign
          `ALU_OP_OR   :  result_o = s1_i | s2_i;               // Set d to the bitwise OR of s1_i and s2_i
          `ALU_OP_AND  :  result_o = s1_i & s2_i;               // Set d to the bitwise AND of s1_i and s2_i
          default      :  result_o = {`DATA_WIDTH{1'b0}};
         endcase
endmodule