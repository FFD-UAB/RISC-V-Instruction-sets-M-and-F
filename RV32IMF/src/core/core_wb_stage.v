`timescale 1ns/1ps
`include "../defines.vh"

module core_wb_stage
       (
        w_is_load_store_i,
        w_regfile_rd_i,
        w_data_rdata_i,
        w_LOAD_op_i,
        reg_file_rd_o
        );

 input  wire                           w_is_load_store_i;
 input  wire [`DATA_WIDTH-1:0]         w_regfile_rd_i;
 input  wire [`DATA_WIDTH-1:0]         w_data_rdata_i;
 input  wire [2:0]                     w_LOAD_op_i;
 output wire [`DATA_WIDTH-1:0]         reg_file_rd_o;
 reg [`DATA_WIDTH-1:0]                 int_data_rdata_t;
 
 assign reg_file_rd_o = (w_is_load_store_i === 1'b0) ? w_regfile_rd_i : int_data_rdata_t;  // mux at the end

 //LOAD logic
 always @ *
  case(w_LOAD_op_i)
   `LOAD_LB:  int_data_rdata_t = { {(`DATA_WIDTH - 8) {w_data_rdata_i[7]}}, w_data_rdata_i[7:0] };     // Load 8-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd
   `LOAD_LH:  int_data_rdata_t = { {(`DATA_WIDTH - 16) {w_data_rdata_i[15]}}, w_data_rdata_i[15:0] };  // Load 16-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd
   `LOAD_LW:  int_data_rdata_t = w_data_rdata_i;                                                    // Load 32-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd
   `LOAD_LBU: int_data_rdata_t = { {(`DATA_WIDTH - 8) {1'b0}}, w_data_rdata_i[7:0] };                  // Load 8-bit value from addr in rs1 plus the 12-bit signed immediate and place zero-extended result into rd
   `LOAD_LHU: int_data_rdata_t = { {(`DATA_WIDTH - 16) {1'b0}}, w_data_rdata_i[15:0] };                // Load 16-bit value from addr in rs1 plus the 12-bit signed immediate and place zero-extended result into rd
     default: int_data_rdata_t = {`DATA_WIDTH{1'b0}};
  endcase


endmodule