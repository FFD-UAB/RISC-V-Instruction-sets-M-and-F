//`default_nettype none
`timescale 1ns/1ps
`include "../defines.vh"

module exe_stage
       (
        clk,
        rst_n,
        e_ALU_op_i,
        e_STORE_op_i,
        e_LOAD_op_i,
        m_LOAD_op_o,
        e_data_origin_i,
        e_regfile_rs1_i,  // rs1
        e_regfile_rs2_i,  // rs2
        e_regfile_raddr_rs1_i,
        e_regfile_raddr_rs2_i,
        e_regfile_waddr_i,
        e_regfile_wr_i,
        e_imm_val_i,  // in use to store a value and add the immidiate value
        m_regfile_waddr_o,
        m_regfile_rd_o,
        m_regfile_wr_o,
        e_data_rd_i,
        m_data_rd_o,
        e_is_load_store_i,
        m_is_load_store_o,
        m_data_addr_o,
        e_pc4_i,
        e_brj_pc_i,
        e_data_wr_i,
        e_data_write_transfer_i,
        m_data_wr_o,
        m_data_write_transfer_o,
        e_data_target_i,
        d_alu_busy_o,
        alu_o,
        stall_general_i
        );

 input  wire                           clk;
 input  wire                           rst_n;
 input  wire [`ALU_OP_WIDTH-1:0]       e_ALU_op_i;
 input  wire [1:0]                     e_STORE_op_i;
 input  wire [2:0]                     e_LOAD_op_i;
 input  wire [`DATA_ORIGIN_WIDTH-1:0]  e_data_origin_i;
 input  wire [`DATA_WIDTH-1:0]         e_regfile_rs1_i;
 input  wire [`DATA_WIDTH-1:0]         e_regfile_rs2_i;
 input  wire [`DATA_WIDTH-1:0]         e_imm_val_i;
 input  wire [4:0]                     e_regfile_waddr_i;
 input  wire [4:0]                     e_regfile_raddr_rs1_i;
 input  wire [4:0]                     e_regfile_raddr_rs2_i;  
 input  wire [`DATA_WIDTH-1:0]         e_pc4_i;
 input  wire [`DATA_WIDTH-1:0]         e_brj_pc_i;
 input  wire                           e_regfile_wr_i;
 input  wire                           e_is_load_store_i;
 input  wire                           e_data_wr_i;
 input  wire                           e_data_rd_i;
 input  wire [`MEM_TRANSFER_WIDTH-1:0] e_data_write_transfer_i;
 output reg                            m_regfile_wr_o;
 output reg                            m_is_load_store_o;
 output reg  [4:0]                     m_regfile_waddr_o;
 output reg  [`DATA_WIDTH-1:0]         m_regfile_rd_o;
 output reg  [`DATA_WIDTH-1:0]         m_data_addr_o;
 output reg                            m_data_wr_o;
 output reg                            m_data_rd_o;
 output reg  [`MEM_TRANSFER_WIDTH-1:0] m_data_write_transfer_o;
 output reg  [2:0]                     m_LOAD_op_o;
 input  wire [1:0]                     e_data_target_i;
 output wire [`DATA_WIDTH-1:0]         alu_o;
 output wire                           d_alu_busy_o;    // Not a reg because is a flag.
 input  wire                           stall_general_i; // Here could be used "d_alu_busy_o", but stall_general_i is a general case.

 wire                                  ALU_zero_t;
 wire [`DATA_WIDTH-1:0]                op1_ALU;
 wire [`DATA_WIDTH-1:0]                op2_ALU;
 reg  [`DATA_WIDTH-1:0]                reg_file_rd;
 reg  [`DATA_WIDTH-1:0]                data_wdata;
 wire [`DATA_WIDTH-1:0]                alu_I; // Different ALU outputs,
 wire [`DATA_WIDTH-1:0]                alu_M; // RV32I and RV32M.


 //Logic for ALU operand selection   
 assign op1_ALU = e_regfile_rs1_i;
 assign op2_ALU = (e_data_origin_i[0] ? e_imm_val_i : e_regfile_rs2_i);

 always @*
  case (e_data_target_i)
   2'd0: reg_file_rd = alu_o;
   2'd1: reg_file_rd = data_wdata;
   2'd2: reg_file_rd = {`DATA_WIDTH{1'b0}};
   2'd3: reg_file_rd = (e_data_origin_i[1] ? e_pc4_i : e_brj_pc_i);
  endcase    

 // Start signal controlled to avoid repeating the same multi-cycle operation.
 wire   ctrlStart;
 reg    finish_mco;

 always@(posedge clk or negedge rst_n)
  if (!rst_n) finish_mco <= 1'b0;
  else finish_mco <= d_alu_busy_o;

 assign ctrlStart = e_ALU_op_i[4] & !finish_mco;

 // Output selection. Check if the operation is from the instruction set M.
 assign alu_o   = (e_ALU_op_i[4] ? alu_M : alu_I);

  // ALU Module that implements the ALU operations of the 32I Base Instruction Set
  alu ALU (
         .ALU_op_i                     (e_ALU_op_i[3:0]    ),
         .s1_i                         (op1_ALU            ),
         .s2_i                         (op2_ALU            ),
         .result_o                     (alu_I              ),
         .zero_o                       (ALU_zero_t         )
          );

  // ALU Module that implements the ALU operations of the 32M Standard Extension Instruction Set
  MULDIV ALU_M (
         .rs1_i                        (op1_ALU            ),
         .rs2_i                        (op2_ALU            ),
         .funct3_i                     (e_ALU_op_i[2:0]    ),
         .start_i                      (ctrlStart          ), // Start operation of this module.
         .clk                          (clk                ),
         .rstLow                       (rst_n              ),
         .c_o                          (alu_M              ),
         .busy_o                       (d_alu_busy_o       )
          );



 //STORE logic
 always @(e_regfile_rs2_i or e_STORE_op_i) 
  case(e_STORE_op_i)
   `STORE_SB:  data_wdata = {{`DATA_WIDTH - 8 {1'b0}}, e_regfile_rs2_i[7:0] };    // sb "Store 8-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate"
   `STORE_SH:  data_wdata = {{`DATA_WIDTH - 16 {1'b0}}, e_regfile_rs2_i[15:0] };  // sh "Store 16-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate"
   `STORE_SW:  data_wdata = e_regfile_rs2_i;                                      // sw "Store 32-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate"
     default:  data_wdata = {`DATA_WIDTH{1'b0}};
  endcase
  
//Registered outputs to be passed to the next pipeline stage
 always@(posedge clk or negedge rst_n)
  if (!rst_n) 
   begin 
    m_regfile_waddr_o <= {`REG_ADDR_WIDTH{1'b0}};  //{{MEM_ADDR_WIDTH-2{1'b1}}, 2'b00};
    m_regfile_rd_o <= {`DATA_WIDTH{1'b0}};
    m_regfile_wr_o <= 1'b0;
    m_data_wr_o <= 1'b0;
    m_data_rd_o <= 1'b0;
    m_data_addr_o <= {`DATA_WIDTH{1'b0}};
    m_data_write_transfer_o <= {`MEM_TRANSFER_WIDTH{1'b0}};
    m_is_load_store_o <= 1'b0;
    m_LOAD_op_o <= {`LOAD_OP_WIDTH{1'b0}};
   end
  else if(!stall_general_i)
   begin
    m_regfile_waddr_o <= e_regfile_waddr_i;
    m_regfile_rd_o <= reg_file_rd;
    m_regfile_wr_o <= e_regfile_wr_i;
    m_data_wr_o <= e_data_wr_i;
    m_data_rd_o <= e_data_rd_i;
    m_data_addr_o <= alu_o;
    m_data_write_transfer_o <= e_data_write_transfer_i;
    m_is_load_store_o <= e_is_load_store_i;
    m_LOAD_op_o <= e_LOAD_op_i;
   end
    
endmodule