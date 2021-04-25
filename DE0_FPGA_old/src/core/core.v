`timescale 1ns/1ps
`include "../defines.vh"

module core(
        clk,
        rst_n,
        data_addr_o,
        data_gnt_i,   
        data_req_o,  
        data_rdata_i,
        data_rvalid_i,
        data_wdata_o,
        data_be_o,
        data_wr_o,
        instruction_addr_o,
        instruction_rdata_i,
        flush_inst_o
        );

 input wire                            clk;
 input wire                            rst_n;
 output wire [`MEM_ADDR_WIDTH-1:0]     data_addr_o;
 input wire                            data_gnt_i;
 output wire                           data_req_o;  
 input wire  [`DATA_WIDTH-1:0]         data_rdata_i;
 input wire                            data_rvalid_i;
 output wire [`DATA_WIDTH-1:0]         data_wdata_o;
 output wire [`MEM_TRANSFER_WIDTH-1:0] data_be_o;
 output wire                           data_wr_o;
 output wire [`MEM_ADDR_WIDTH-1:0]     instruction_addr_o;
 input wire  [`DATA_WIDTH-1:0]         instruction_rdata_i;
 output wire                           flush_inst_o;

 wire [`DATA_WIDTH-1 : 0]              d_instruction_t;
 wire [`DATA_WIDTH-1:0]                d_pc_t;
 wire [`DATA_WIDTH-1:0]                d_pc4_t;
 wire [`DATA_WIDTH-1:0]                e_pc4_t;
 wire [`DATA_WIDTH-1:0]                e_brj_pc_t;
 wire [`ALU_OP_WIDTH-1:0]              e_ALU_op_t;
 wire [`STORE_OP_WIDTH-1:0]            e_STORE_op_t;
 wire [`LOAD_OP_WIDTH-1:0]             e_LOAD_op_t;
 wire [`LOAD_OP_WIDTH-1:0]             m_LOAD_op_t;
 wire [`LOAD_OP_WIDTH-1:0]             w_LOAD_op_t;
 wire [`DATA_ORIGIN_WIDTH-1:0]         e_data_origin_t;
 wire                                  e_is_load_store_t;
 wire                                  m_is_load_store_t;
 wire                                  w_is_load_store_t;
 wire                                  e_data_wr_t;
 wire                                  e_data_rd_t;
 wire                                  e_regfile_wr_t;
 wire                                  m_regfile_wr_t;
 wire [`MEM_TRANSFER_WIDTH-1:0]        e_data_be_t;
 wire [`MEM_TRANSFER_WIDTH-1:0]        m_data_be_t;
 wire [`REG_ADDR_WIDTH-1:0]            e_regfile_waddr_t;
 wire [`DATA_WIDTH-1:0]                e_imm_val_t;	
 wire [`DATA_WIDTH-1:0]                m_regfile_rd_t;
 wire [`DATA_WIDTH-1:0]                w_data_rdata_t;
 wire [`DATA_WIDTH-1:0]                m_data_addr_t;
 wire                                  m_data_wr_t;
 wire                                  m_data_rd_t;
 wire [`DATA_WIDTH-1:0]                e_regfile_rs1_t;
 wire [`DATA_WIDTH-1:0]                e_regfile_rs2_t;
 wire                                  w_regfile_wr_t;
 wire [`REG_ADDR_WIDTH-1:0]            w_regfile_waddr_t;
 wire [`DATA_WIDTH-1:0]                w_regfile_rd_t;
 wire [`DATA_WIDTH-1:0]                reg_file_rd_t;
 wire [`REG_ADDR_WIDTH-1:0]            m_regfile_waddr_t;
 wire [`REG_ADDR_WIDTH-1:0]            e_regfile_raddr_rs1_t;	
 wire [`REG_ADDR_WIDTH-1:0]            e_regfile_raddr_rs2_t;
 wire [1:0]                            e_data_target_t;
 wire                                  d_alu_busy_t;
 wire                                  stall_t;
 wire                                  stall_general_t;


 wire [`DATA_WIDTH-1:0]                alu_t;
 wire [`DATA_WIDTH-1:0]                brj_pc_t;
 wire                                  brj_t;
                    
 if_stage if_stage_inst(
        .clk                           (clk),
        .rst_n                         (rst_n),
        .brj_i                         (brj_t),
        .brj_pc_i                      (brj_pc_t),
        .d_instruction_o               (d_instruction_t),
        .d_pc_o                        (d_pc_t),
        .d_pc4_o                       (d_pc4_t),
        .instruction_addr_o            (instruction_addr_o),
        .instruction_rdata_i           (instruction_rdata_i),
        .stall_i                       (stall_t),
        .stall_general_i               (stall_general_t),
        .flush_inst_o                  (flush_inst_o)
         );
        
 id_stage id_stage_inst(
        .clk                           (clk),
        .rst_n                         (rst_n),
        .d_instruction_i               (d_instruction_t),
        .e_ALU_op_o                    (e_ALU_op_t),
        .e_STORE_op_o                  (e_STORE_op_t),
        .e_LOAD_op_o                   (e_LOAD_op_t),
        .e_data_origin_o               (e_data_origin_t),
        .e_is_load_store_o             (e_is_load_store_t),  // execution_unit 
        .e_data_wr_o                   (e_data_wr_t),  // data_write
        .e_data_rd_o                   (e_data_rd_t),
        .e_regfile_wr_o                (e_regfile_wr_t),
        .e_regfile_waddr_o             (e_regfile_waddr_t),
        .e_regfile_rs1_o               (e_regfile_rs1_t),
        .e_regfile_rs2_o               (e_regfile_rs2_t),
        .e_regfile_raddr_rs1_o         (e_regfile_raddr_rs1_t),
        .e_regfile_raddr_rs2_o         (e_regfile_raddr_rs2_t),
        .e_imm_val_o                   (e_imm_val_t),  //execution unit imm val rs1
        .e_data_be_o                   (e_data_be_t),
        .w_regfile_wr_i                (w_regfile_wr_t),
        .w_regfile_waddr_i             (w_regfile_waddr_t),
        .w_regfile_rd_i                (reg_file_rd_t),
        .d_pc_i                        (d_pc_t),
        .d_pc4_i                       (d_pc4_t),
        .e_pc4_o                       (e_pc4_t),
        .e_brj_pc_o                    (e_brj_pc_t),
        .e_data_target_o               (e_data_target_t),
        .stall_o                       (stall_t),
        .alu_i                         (alu_t),
        .m_regfile_rd_i                (m_regfile_rd_t),
        .m_data_rd_i                   (m_data_rd_t),
        .m_regfile_waddr_i             (m_regfile_waddr_t),
        .m_is_load_store_i             (m_is_load_store_t),
        .m_regfile_wr_i                (m_regfile_wr_t),
        .brj_pc_o                      (brj_pc_t),
        .brj_o                         (brj_t),
        .d_busy_alu_i                  (d_alu_busy_t),
        .stall_general_o               (stall_general_t)
        );
    
 exe_stage exe_stage_inst(
        .clk                           (clk),
        .rst_n                         (rst_n),
        .e_ALU_op_i                    (e_ALU_op_t),
        .e_STORE_op_i                  (e_STORE_op_t),
        .e_LOAD_op_i                   (e_LOAD_op_t),
        .m_LOAD_op_o                   (m_LOAD_op_t),
        .e_data_origin_i               (e_data_origin_t),
        .e_regfile_rs1_i               (e_regfile_rs1_t),  // rs1
        .e_regfile_rs2_i               (e_regfile_rs2_t),  // rs2
        .e_regfile_raddr_rs1_i         (e_regfile_raddr_rs1_t),
        .e_regfile_raddr_rs2_i         (e_regfile_raddr_rs2_t),
        .e_regfile_wr_i                (e_regfile_wr_t),
        .e_regfile_waddr_i             (e_regfile_waddr_t),
        .m_regfile_waddr_o             (m_regfile_waddr_t),
        .m_regfile_rd_o                (m_regfile_rd_t),
        .m_regfile_wr_o                (m_regfile_wr_t),
        .e_imm_val_i                   (e_imm_val_t),  // in use to store a value and add the immidiate value
        .e_is_load_store_i             (e_is_load_store_t),
        .m_is_load_store_o             (m_is_load_store_t),
        .e_pc4_i                       (e_pc4_t),
        .e_brj_pc_i                    (e_brj_pc_t),
        .m_data_addr_o                 (m_data_addr_t),
        .e_data_wr_i                   (e_data_wr_t),
        .m_data_wr_o                   (m_data_wr_t),
        .e_data_rd_i                   (e_data_rd_t),
        .m_data_rd_o                   (m_data_rd_t),
        .e_data_be_i                   (e_data_be_t),
        .m_data_be_o                   (m_data_be_t),
        .e_data_target_i               (e_data_target_t),
        .d_alu_busy_o                  (d_alu_busy_t),
        .alu_o                         (alu_t),
        .stall_general_i               (stall_general_t)
        );

core_mem_stage mem_stage_inst(
        .clk                           (clk),
        .rst_n                         (rst_n),
        .m_regfile_waddr_i             (m_regfile_waddr_t),
        .m_regfile_rd_i                (m_regfile_rd_t),
        .m_regfile_wr_i                (m_regfile_wr_t),
        .m_data_addr_i                 (m_data_addr_t),
        .m_data_wr_i                   (m_data_wr_t),
        .m_data_rd_i                   (m_data_rd_t),
        .m_data_be_i                   (m_data_be_t),
        .w_regfile_waddr_o             (w_regfile_waddr_t),
        .w_regfile_rd_o                (w_regfile_rd_t),
        .w_regfile_wr_o                (w_regfile_wr_t),
        .w_data_rdata_o                (w_data_rdata_t),
        .data_wr_o                     (data_wr_o),
        .data_addr_o                   (data_addr_o),
        .data_rdata_i                  (data_rdata_i),
        .data_wdata_o                  (data_wdata_o),
        .data_be_o                     (data_be_o),
        .data_req_o                    (data_req_o),
        .data_gnt_i                    (data_gnt_i),
        .data_rvalid_i                 (data_rvalid_i),
        .m_is_load_store_i             (m_is_load_store_t),
        .w_is_load_store_o             (w_is_load_store_t),
        .m_LOAD_op_i                   (m_LOAD_op_t),
        .w_LOAD_op_o                   (w_LOAD_op_t),
        .stall_general_i               (stall_general_t)
        );

core_wb_stage core_wb_stageinst(
        .w_is_load_store_i             (w_is_load_store_t),
        .w_regfile_rd_i                (w_regfile_rd_t),
        .w_data_rdata_i                (w_data_rdata_t),
        .w_LOAD_op_i                   (w_LOAD_op_t),
        .reg_file_rd_o                 (reg_file_rd_t)
        );

endmodule