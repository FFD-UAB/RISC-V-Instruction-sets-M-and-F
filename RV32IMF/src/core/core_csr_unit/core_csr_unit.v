`timescale 1ns/1ps
`include "../../defines.vh"

module crs_unit
       (
        rst_n,
        clk,
        csr_waddr_i,
        csr_wdata_i,
        csr_wr_i,
        csr_raddr_i,
        csr_fflags_i,
        csr_rdata_o,
        csr_frm_o
        );

 input wire                            rst_n;
 input wire                            clk;
 input wire [`CSR_ADDR_WIDTH-1:0]      csr_waddr_i;
 input wire                            csr_wr_i;
 input wire [`CSR_DATA_WIDTH-1:0]      csr_wdata_i;
 input wire [`CSR_ADDR_WIDTH-1:0]      csr_raddr_i;
 input wire [4:0]                      csr_fflags_i;
 output reg  [`CSR_DATA_WIDTH-1:0]     csr_rdata_o;
 output wire [2:0]                     csr_frm_o;

 wire [`CSR_XLEN-1:0]                  csr_rdtimer;
 wire [`CSR_XLEN-1:0]                  csr_rdcycle;
 wire [`CSR_XLEN-1:0]                  csr_rdinstret;

 reg [`CSR_DATA_WIDTH-1:0]             csr_fcsr;   // 24 bits reserved, 3 frm, 5 fflags
 reg [`CSR_DATA_WIDTH-1:0]             csr_ustatus;

 timer rdtimer_inst (
        .clk                           (clk                ),
        .rst_n                         (rst_n              ),
        .val_o                         (csr_rdtimer        ),
        .we_i                          (1'b1               )
        );

 counter rdcycle_inst (
        .clk                           (clk                ),
        .inc_i                         (1'b1               ),
        .rst_n                         (rst_n              ),
        .val_o                         (csr_rdcycle        )
         );

 counter rdinstret_inst (
        .clk                           (clk                ),
        .inc_i                         (1'b1               ),
        .rst_n                         (rst_n              ),
        .val_o                         (csr_rdinstret      )
         );
 
 //User status register
 always @(posedge clk or negedge rst_n)
  if (!rst_n) csr_ustatus <= {`CSR_DATA_WIDTH{1'b0}};
  else if ((csr_waddr_i == `USTATUS_ADDR) && csr_wr_i) csr_ustatus <= csr_wdata_i;

 // Floating-point CSR
 always @(posedge clk or negedge rst_n)
  if (!rst_n) csr_fcsr <= {`CSR_DATA_WIDTH{1'b0}};
  else if(csr_wr_i) 
   case(csr_waddr_i)
    `FFLAGS_ADDR   : csr_fcsr[4:0] <= csr_wdata_i[4:0]; // FFLAGS NV, DZ, OF, UF, NX.
    `FRM_ADDR      : csr_fcsr[7:5] <= csr_wdata_i[2:0]; // Rounding mode FRM.
    `FCSR_ADDR     : csr_fcsr[7:0] <= csr_wdata_i[7:0]; // L not implemented = {27'b0, ...}.
    default: csr_fcsr[4:0] <= csr_fflags_i;
   endcase

 assign csr_frm_o = csr_fcsr[7:5];
 
 // CSR read
 always @(*)
  case (csr_raddr_i)
   `CYCLE_ADDR    : csr_rdata_o = csr_rdcycle[`CSR_DATA_WIDTH-1:0];
   `CYCLEH_ADDR   : csr_rdata_o = csr_rdcycle[`CSR_XLEN-1:`CSR_DATA_WIDTH];
   `TIME_ADDR     : csr_rdata_o = csr_rdtimer[`CSR_DATA_WIDTH-1:0];
   `TIMEH_ADDR    : csr_rdata_o = csr_rdtimer[`CSR_XLEN-1:`CSR_DATA_WIDTH];
   `INSTRET_ADDR  : csr_rdata_o = csr_rdinstret[`CSR_DATA_WIDTH-1:0];
   `INSTRETH_ADDR : csr_rdata_o = csr_rdinstret[`CSR_XLEN-1:`CSR_DATA_WIDTH];
   `USTATUS_ADDR  : csr_rdata_o = csr_ustatus;
   `FFLAGS_ADDR   : csr_rdata_o = {{`CSR_DATA_WIDTH-5{1'b0}},  csr_fcsr[4:0] | csr_fflags_i};
   `FRM_ADDR      : csr_rdata_o = {{`CSR_DATA_WIDTH-3{1'b0}},  csr_fcsr[7:5]};
   `FCSR_ADDR     : csr_rdata_o = csr_fcsr;
    default       : csr_rdata_o = {`CSR_DATA_WIDTH{1'b0}};
  endcase
    
endmodule