`timescale 1ns/1ps
`include "../defines.vh"

module core_mem_stage 
       (
        rst_n,
        clk,
        m_regfile_waddr_i,
        m_regfile_rd_i,
        m_regfile_wr_i,
        m_data_addr_i,
        m_data_wr_i,
        m_data_rd_i,
        m_data_write_transfer_i,
        w_regfile_waddr_o,
        w_regfile_rd_o,
        w_regfile_wr_o,
        w_data_rdata_o,
        data_wr_o,
        data_addr_o,
        data_rdata_i,
        data_wdata_o,
        data_write_transfer_o,
        data_req_o,  
        data_gnt_i,   
        data_rvalid_i,
        m_is_load_store_i,
        w_is_load_store_o,
        m_LOAD_op_i,
        w_LOAD_op_o,
        stall_general_i
        );

 input  wire                           clk;
 input  wire                           rst_n;

 input  wire [4:0]                     m_regfile_waddr_i;
 output reg  [4:0]                     w_regfile_waddr_o;
 input  wire [`DATA_WIDTH-1:0]         m_regfile_rd_i;
 output reg  [`DATA_WIDTH-1:0]         w_regfile_rd_o;
 input  wire                           m_regfile_wr_i;
 output reg                            w_regfile_wr_o;
 input  wire                           m_data_wr_i;
 input  wire                           m_data_rd_i;
 input  wire [`DATA_WIDTH-1:0]         m_data_addr_i;
 input  wire [`MEM_TRANSFER_WIDTH-1:0] m_data_write_transfer_i;
 output wire                           data_wr_o;
 output wire [`MEM_ADDR_WIDTH-1:0]     data_addr_o;
 input  wire [`DATA_WIDTH-1:0]         data_rdata_i;
 output wire [`DATA_WIDTH-1:0]         w_data_rdata_o;
 output wire [`DATA_WIDTH-1:0]         data_wdata_o;
 output wire [`MEM_TRANSFER_WIDTH-1:0] data_write_transfer_o;
 output wire                           data_req_o;  
 input  wire                           data_gnt_i;
 input  wire                           data_rvalid_i;
 input  wire                           m_is_load_store_i;
 output reg                            w_is_load_store_o;
 input  wire [2:0]                     m_LOAD_op_i;
 output reg  [2:0]                     w_LOAD_op_o;
 input  wire                           stall_general_i;

 reg [1:0]                             state;
 reg [1:0]                             nextState;
 reg                                   stall_o;

 localparam IDLE = 0;
 localparam READ = 1;
 localparam WRITE = 2;
 
 assign data_addr_o = m_data_addr_i[`MEM_ADDR_WIDTH-1:0];
 assign data_wdata_o = m_regfile_rd_i;
 assign data_wr_o = m_data_wr_i;
 assign data_write_transfer_o = m_data_write_transfer_i;
 assign w_data_rdata_o = data_rdata_i;
 assign data_req_o = m_data_wr_i | m_data_rd_i;       

 always@(posedge clk or negedge rst_n)
  if (!rst_n) state <= IDLE;
  else state <= nextState; 
    
 always @(*)
  case (state)
   IDLE: if (m_data_rd_i && data_gnt_i) nextState = READ;
         else if (m_data_wr_i && data_gnt_i) nextState = WRITE;
              else nextState = IDLE; 
   READ: if (data_rvalid_i) 
          begin
           if (m_data_rd_i) nextState = READ; //Capture data. Several continous readings. 
           else nextState = IDLE; //Capture data. Last reading.
          end
         else nextState = READ;
   WRITE: if (m_data_wr_i && data_gnt_i) nextState = WRITE; //Write data. Several writings.
          else nextState = IDLE; 
   default: nextState = IDLE;
   endcase
    
/*  It's not used, so 
 always @(*)
  case (state)
   IDLE: if (m_data_rd_i) stall_o = 1'b1; //stall the pipeline
         else if (m_data_wr_i && (!data_gnt_i)) stall_o = 1'b1; //stall the pipeline
              else stall_o = 1'b0;//Not to stall the pipeline
   READ: if (data_rvalid_i) stall_o = 1'b0; //capture data. Not stall the pipeine so a new instruction can be executed 
         else stall_o = 1'b1; //continue stalling the pipeline
   WRITE: if (m_data_wr_i && data_gnt_i) stall_o = 1'b0; //Write new data. Not stall
          else stall_o = 1'b0; //No more consequtive writtings. Not stall.
  endcase
*/
    //Registered PC for pipeline
 always@(posedge clk or negedge rst_n)
  if (!rst_n) 
   begin
    w_regfile_waddr_o <= {`REG_ADDR_WIDTH{1'b0}};
    w_regfile_rd_o <= {`DATA_WIDTH{1'b0}};
    w_regfile_wr_o <= 1'b0;
    w_is_load_store_o <= 1'b0;
    w_LOAD_op_o <= {`LOAD_OP_WIDTH{1'b0}};
   end
  else if(!stall_general_i)
   begin
    w_regfile_waddr_o <= m_regfile_waddr_i;
    w_regfile_rd_o <= m_regfile_rd_i;
    w_regfile_wr_o <= m_regfile_wr_i;
    w_is_load_store_o <= m_is_load_store_i;
    w_LOAD_op_o <= m_LOAD_op_i;
   end
         
endmodule