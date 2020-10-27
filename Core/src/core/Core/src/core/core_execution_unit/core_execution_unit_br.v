// Branching moduele
`timescale 1ns/1ps

module 	br 
      #(parameter BR_OP_WIDTH = 2,
        parameter DATA_WIDTH = 32)
       (
        BR_op_i,
        alu_d,
        old_pc_i,
        new_pc_i,
        new_pc_o,
        is_conditional_i,
        ALU_zero_i
        );

 input wire [BR_OP_WIDTH-1:0]          BR_op_i;
 input wire [DATA_WIDTH-1:0]           alu_d;
 input wire [DATA_WIDTH-1:0]           old_pc_i;
 output wire [DATA_WIDTH-1:0]          new_pc_o;
 input wire [DATA_WIDTH-1:0]           new_pc_i;
 input wire                            is_conditional_i;
 input wire                            ALU_zero_i;

 reg [DATA_WIDTH-1:0]                  offset;

 assign new_pc_o = (is_conditional_i === 1'b0)? alu_d: offset;

 always @* begin
  case (BR_op_i)
   `BR_EQ: offset = (ALU_zero_i === 1'd1)? new_pc_i: {{DATA_WIDTH-3{1'b0}},1'b0,2'b00};
   `BR_NE: offset = (ALU_zero_i === 1'd0)? new_pc_i: {{DATA_WIDTH-3{1'b0}},1'b0,2'b00};
   `BR_LT: offset = (ALU_zero_i === 1'd0)? new_pc_i: {{DATA_WIDTH-3{1'b0}},1'b0,2'b00};
   `BR_GE: offset = (ALU_zero_i === 1'd1)? new_pc_i: {{DATA_WIDTH-3{1'b0}},1'b0,2'b00};
  endcase
 end

endmodule