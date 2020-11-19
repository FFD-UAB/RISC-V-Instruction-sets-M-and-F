`timescale 1ns/1ps
`include "../src/defines.vh"

module top
	(
        clk,
        rst_n
    );

    localparam AXI_ADDR_WIDTH       = 32;
    localparam AXI_DATA_WIDTH       = 32;
    localparam AXI_ID_MASTER_WIDTH  = 10;
    localparam AXI_ID_SLAVE_WIDTH   = 10;
    localparam AXI_USER_WIDTH       = 0;
    localparam DATA_RAM_SIZE        = 32768; // in bytes
    localparam INSTR_RAM_SIZE       = 32768; // in bytes
    localparam INSTR_ADDR_WIDTH     = $clog2(INSTR_RAM_SIZE)+1; // to make space for the boot rom
    localparam DATA_ADDR_WIDTH      = $clog2(DATA_RAM_SIZE);
    localparam AXI_B_WIDTH          = $clog2(AXI_DATA_WIDTH/8); // AXI "Byte" width
    

    input 	wire clk;
    input 	wire rst_n;

    wire mem_wr;
    wire [`MEM_ADDR_WIDTH-1 : 0] mem_addr;
    wire [`REG_DATA_WIDTH-1 : 0] val_mem_data_write;
    wire [`REG_DATA_WIDTH-1 : 0] val_mem_data_read;

    wire [`MEM_ADDR_WIDTH-1 : 0] instruction_addr;
    wire [`REG_DATA_WIDTH-1 : 0] instruction_rdata;

    wire  [`MEM_TRANSFER_WIDTH-1:0] write_transfer;

    wire req_mem_data_t;
    wire gnt_mem_data_t;
    wire data_rvalid_t;
    wire flush_inst_t;

  wire         core_instr_req;
  wire         core_instr_gnt;
  wire         core_instr_rvalid;
  wire [`MEM_ADDR_WIDTH-1:0]  core_instr_addr;
  wire [31:0]  core_instr_rdata;

  wire         core_data_req;
  wire         core_data_gnt;
  wire         core_data_rvalid;
  wire [31:0]  core_data_addr;
  wire         core_data_we;
  wire [3:0]   core_data_be;
  wire [31:0]  core_data_rdata;
  wire [31:0]  core_data_wdata;


  // signals to/from instr mem
  wire                        instr_mem_en;
  wire [INSTR_ADDR_WIDTH-1:0] instr_mem_addr;
  wire                        instr_mem_we;
  wire [AXI_DATA_WIDTH/8-1:0] instr_mem_be;
  wire [AXI_DATA_WIDTH-1:0]   instr_mem_rdata;
  wire [AXI_DATA_WIDTH-1:0]   instr_mem_wdata;

  // signals to/from core2axi
  wire         core_axi_req;
  wire         core_axi_gnt;
  wire         core_axi_rvalid;
  wire [INSTR_ADDR_WIDTH-1:0]  core_axi_addr;
  wire         core_axi_we;
  wire [AXI_DATA_WIDTH/8-1:0]   core_axi_be;
  wire [AXI_DATA_WIDTH-1:0]  core_axi_rdata;
  wire [AXI_DATA_WIDTH-1:0]  core_axi_wdata;

// signals to/from AXI instr
  wire                        axi_instr_req;
  wire [INSTR_ADDR_WIDTH-1:0] axi_instr_addr;
  wire                        axi_instr_we;
  wire [AXI_DATA_WIDTH/8-1:0] axi_instr_be;
  wire [AXI_DATA_WIDTH-1:0]   axi_instr_rdata;
  wire [AXI_DATA_WIDTH-1:0]   axi_instr_wdata;

// signals to/from data mem
  wire                        data_mem_en;
  wire [DATA_ADDR_WIDTH-1:0]  data_mem_addr;
  wire                        data_mem_we;
  wire [AXI_DATA_WIDTH/8-1:0] data_mem_be;
  wire [AXI_DATA_WIDTH-1:0]   data_mem_rdata;
  wire [AXI_DATA_WIDTH-1:0]   data_mem_wdata;
  
core core_inst(
        .clk                  (clk),
        .rst_n                (rst_n),
        .data_wr_o            (core_data_we),
        .data_addr_o          (core_data_addr),
        .data_rdata_i         (core_data_rdata),
        .data_wdata_o         (core_data_wdata),
        .data_req_o           (core_data_req),    // Request to make actiopn
        .data_gnt_i           (core_data_gnt),    // Action Granted 
        .data_rvalid_i        (core_data_rvalid), // Valid when write is ok
        .instruction_addr_o   (core_instr_addr),
        .instruction_rdata_i  (core_instr_rdata),
        .data_write_transfer_o(write_transfer),
        .flush_inst_o         (flush_inst_t)
    );


/* progMem mem_prog_inst (
        .rst_n (flush_inst_t),         // Reset Neg
        .clk (clk),                    // Clk
        .addr (instruction_addr),      // Address
        .data_out (instruction_rdata)  // Output Data
    );*/

 
instr_ram_wrap
  #(
    .RAM_SIZE   ( INSTR_RAM_SIZE ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  instr_mem
  (
    .clk         ( clk             ),
    .rst_n       ( rst_n           ),
    .en_i        ( instr_mem_en    ),
    .addr_i      ( instr_mem_addr  ),
    .wdata_i     ( instr_mem_wdata ),
    .rdata_o     ( instr_mem_rdata ),
    .we_i        ( instr_mem_we    ),
    .be_i        ( instr_mem_be    ),
    .bypass_en_i ( 1'b0            )
  );

/*  axi_mem_if_SP_wrap
  #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH         ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH         ),
    .AXI_ID_WIDTH    ( AXI_ID_SLAVE_WIDTH     ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH         ),
    .MEM_ADDR_WIDTH  ( INSTR_ADDR_WIDTH       )
  )
  instr_mem_axi_if
  (
    .clk         ( clk               ),
    .rst_n       ( rst_n             ),
    .test_en_i   ( 1'b0              ),

    .mem_req_o   ( axi_instr_req     ),
    .mem_addr_o  ( axi_instr_addr    ),
    .mem_we_o    ( axi_instr_we      ),
    .mem_be_o    ( axi_instr_be      ),
    .mem_rdata_i ( axi_instr_rdata   ),
    .mem_wdata_o ( axi_instr_wdata   ),

    .slave       ( 1'b0              )
  );*/



  ram_mux
  #(
    .ADDR_WIDTH ( INSTR_ADDR_WIDTH ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH   ),
    .IN1_WIDTH  ( AXI_DATA_WIDTH   ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH   )
  )
  instr_ram_mux_i
  (
    .clk            ( clk               ),
    .rst_n          ( rst_n             ),

    .port0_req_i    ( 1'b0              ),
    .port0_gnt_o    (                   ),
    .port0_rvalid_o (                   ),
    .port0_addr_i   ( {INSTR_ADDR_WIDTH{1'b0}}),
    .port0_we_i     ( 1'b0      ),
    .port0_be_i     ( {(AXI_DATA_WIDTH/8){1'b0}}            ),
    .port0_rdata_o  ( ),
    .port0_wdata_i  ( {AXI_DATA_WIDTH{1'b0}}                ),

    .port1_req_i    ( core_instr_req    ),
    .port1_gnt_o    ( core_instr_gnt    ),
    .port1_rvalid_o ( core_instr_rvalid ),
    .port1_addr_i   ( {{(INSTR_ADDR_WIDTH - `MEM_ADDR_WIDTH){1'b0}}, core_instr_addr}),
    .port1_we_i     ( 1'b0              ),
    .port1_be_i     ( {(AXI_DATA_WIDTH/8){1'b0}}            ),
    .port1_rdata_o  ( core_instr_rdata  ),
    .port1_wdata_i  ( 0                 ),

    .ram_en_o       ( instr_mem_en      ),
    .ram_addr_o     ( instr_mem_addr    ),
    .ram_we_o       ( instr_mem_we      ),
    .ram_be_o       ( instr_mem_be      ),
    .ram_rdata_i    ( instr_mem_rdata   ),
    .ram_wdata_o    ( instr_mem_wdata   )
  );

 assign core_instr_req = 1'b1;

  //----------------------------------------------------------------------------//
  // Data RAM
  //----------------------------------------------------------------------------//
  sp_ram_wrap
  #(
    .RAM_SIZE   ( DATA_RAM_SIZE  ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  data_mem
  (
    .clk          ( clk            ),
    .rstn_i       ( rst_n          ),
    .en_i         ( data_mem_en    ),
    .addr_i       ( data_mem_addr  ),
    .wdata_i      ( data_mem_wdata ),
    .rdata_o      ( data_mem_rdata ),
    .we_i         ( data_mem_we    ),
    .be_i         ( data_mem_be    ),
    .bypass_en_i  ( 1'b0     )
  );

 /* axi_mem_if_SP_wrap
  #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH    ( AXI_ID_SLAVE_WIDTH ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH     ),
    .MEM_ADDR_WIDTH  ( DATA_ADDR_WIDTH    )
  )
  data_mem_axi_if
  (
    .clk         ( clk               ),
    .rst_n       ( rst_n             ),
    .test_en_i   ( testmode_i        ),

    .mem_req_o   ( axi_mem_req       ),
    .mem_addr_o  ( axi_mem_addr      ),
    .mem_we_o    ( axi_mem_we        ),
    .mem_be_o    ( axi_mem_be        ),
    .mem_rdata_i ( axi_mem_rdata     ),
    .mem_wdata_o ( axi_mem_wdata     ),

    .slave       ( data_slave        )
  );*/


  ram_mux
  #(
    .ADDR_WIDTH ( DATA_ADDR_WIDTH ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH  ),
    .IN1_WIDTH  ( 32              ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH  )
  )
  data_ram_mux_i
  (
    .clk            ( clk              ),
    .rst_n          ( rst_n            ),

    .port0_req_i    ( 1'b0      ),
    .port0_gnt_o    (                  ),
    .port0_rvalid_o (                  ),
    .port0_addr_i   ( ),
    .port0_we_i     ( 1'b0       ),
    .port0_be_i     ( 4'b0       ),
    .port0_rdata_o  (     ),
    .port0_wdata_i  (     ),

    .port1_req_i    ( core_data_req    ),
    .port1_gnt_o    ( core_data_gnt    ),
    .port1_rvalid_o ( core_data_rvalid ),
    .port1_addr_i   ( {5'h0, core_data_addr[9:0]} ),
    .port1_we_i     ( core_data_we     ),
    .port1_be_i     ( 4'b1111     ),
    .port1_rdata_o  ( core_data_rdata  ),
    .port1_wdata_i  ( core_data_wdata  ),

    .ram_en_o       ( data_mem_en      ),
    .ram_addr_o     ( data_mem_addr    ),
    .ram_we_o       ( data_mem_we      ),
    .ram_be_o       ( data_mem_be      ),
    .ram_rdata_i    ( data_mem_rdata   ),
    .ram_wdata_o    ( data_mem_wdata   )
  );


endmodule