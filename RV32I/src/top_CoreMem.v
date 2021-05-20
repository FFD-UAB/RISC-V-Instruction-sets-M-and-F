//`timescale 1ns/1ps
`include "../src/defines.vh"

module top_CoreMem
	(
        clk,
        rst_n,

        // AXI to instr mem
        axi_instr_req, // Uncomment to use on synthesis
        axi_instr_addr,
        axi_instr_we,
        axi_instr_be,
        axi_instr_wdata,
        // instr mem to AXI
        axi_instr_gnt,
        axi_instr_rvalid,
        axi_instr_rdata,

        // AXI to data mem
        axi_data_req, // Uncomment to use on synthesis
        axi_data_addr,
        axi_data_we,
        axi_data_be,
        axi_data_wdata,
        // data mem to AXI
        axi_data_gnt,
        axi_data_rvalid,
        axi_data_rdata,

        // AXI to core UNUSED ATM
        core_axi_req,
        core_axi_addr,
        core_axi_we,
        core_axi_be,
        core_axi_wdata,
        // core to AXI
        core_axi_gnt,
        core_axi_rvalid,
        core_axi_rdata,
        // core interaction with core memories
        core_instr_addr,  // PC
        core_instr_rdata, // instruction at core's input
        core_data_addr,   // address that is pointing in the data memory
        core_data_wdata,  // what is the core writing in the data memory
        core_data_we      // flag that is writting into the data memory
    );

    localparam AXI_ADDR_WIDTH       = 32;
    localparam AXI_DATA_WIDTH       = 32;
    localparam AXI_ID_MASTER_WIDTH  = 10;
    localparam AXI_ID_SLAVE_WIDTH   = 10;
    localparam AXI_USER_WIDTH       = 0;
    localparam DATA_RAM_SIZE        = 2 ** `MEM_ADDR_DATA_WIDTH ; // in bytes
    localparam INSTR_RAM_SIZE       = 32768; // in bytes
    localparam INSTR_ADDR_WIDTH     = $clog2(INSTR_RAM_SIZE)+1; // to make space for the boot rom
    localparam DATA_ADDR_WIDTH      = `MEM_ADDR_DATA_WIDTH; //$clog2(DATA_RAM_SIZE);
    localparam AXI_B_WIDTH          = $clog2(AXI_DATA_WIDTH/8); // AXI "Byte" width
    
    input 	wire clk;
    input 	wire rst_n;

  // signals AXI to/from instr mem
  input  wire                        axi_instr_req; // Uncomment to use on synthesis
  input  wire [INSTR_ADDR_WIDTH-1:0] axi_instr_addr;
  input  wire                        axi_instr_we;
  input  wire [AXI_DATA_WIDTH/8-1:0] axi_instr_be;
  input  wire [AXI_DATA_WIDTH-1:0]   axi_instr_wdata;
  
  output wire                        axi_instr_gnt;
  output wire                        axi_instr_rvalid;
  output wire [AXI_DATA_WIDTH-1:0]   axi_instr_rdata;
  
  // signals AXI to/from data mem
  input  wire                        axi_data_req; // Uncomment to use on synthesis
  input  wire [DATA_ADDR_WIDTH-1:0]  axi_data_addr;
  input  wire                        axi_data_we;
  input  wire [AXI_DATA_WIDTH/8-1:0] axi_data_be;
  input  wire [AXI_DATA_WIDTH-1:0]   axi_data_wdata;
  
  output wire                        axi_data_gnt;
  output wire                        axi_data_rvalid;
  output wire [AXI_DATA_WIDTH-1:0]   axi_data_rdata;

  // signals to/from core2axi NOT BEING USED AT THE MOMENT
  input  wire                        core_axi_req;
  input  wire [AXI_ADDR_WIDTH-1:0]   core_axi_addr;
  input  wire                        core_axi_we;
  input  wire [AXI_DATA_WIDTH/8-1:0] core_axi_be;
  input  wire [AXI_DATA_WIDTH-1:0]   core_axi_wdata;

  output wire                        core_axi_gnt;
  output wire                        core_axi_rvalid;
  output wire [AXI_DATA_WIDTH-1:0]   core_axi_rdata;
  assign core_axi_gnt = 1'b0;
  assign core_axi_rvalid = 1'b0;
  assign core_axi_rdata = {AXI_DATA_WIDTH{1'b0}};



  // signals core to/from instr mem
  wire                        core_instr_req;
  output wire [`MEM_ADDR_INSTR_WIDTH-1:0]  core_instr_addr;
  wire                        core_instr_we;
  wire [AXI_DATA_WIDTH/8-1:0] core_instr_be;
  wire [`DATA_WIDTH-1:0]      core_instr_wdata;

  wire                        core_instr_gnt;
  wire                        core_instr_rvalid;
  output wire [`DATA_WIDTH-1:0]      core_instr_rdata;

  // signals core to/from data mem
  wire                        core_data_req;
  output wire [`MEM_ADDR_DATA_WIDTH-1:0]  core_data_addr;
  output wire                        core_data_we;
  wire [AXI_DATA_WIDTH/8-1:0] core_data_be;
  output wire [`DATA_WIDTH-1:0]      core_data_wdata;

  wire                        core_data_gnt;
  wire                        core_data_rvalid;
  wire [`DATA_WIDTH-1:0]      core_data_rdata;

  // Core output signals TODO
  wire  [`MEM_TRANSFER_WIDTH-1:0] write_transfer_t;
  wire flush_inst_t;



  // signals MUX to/from instr mem
  wire                        instr_mem_en;
  wire [INSTR_ADDR_WIDTH-1:0] instr_mem_addr;
  wire                        instr_mem_we;
  wire [AXI_DATA_WIDTH/8-1:0] instr_mem_be;
  wire [AXI_DATA_WIDTH-1:0]   instr_mem_wdata;

  wire [AXI_DATA_WIDTH-1:0]   instr_mem_rdata;

  // signals MUX to/from data mem
  wire                        data_mem_en;
  wire [DATA_ADDR_WIDTH-1:0]  data_mem_addr;
  wire                        data_mem_we;
  wire [AXI_DATA_WIDTH/8-1:0] data_mem_be;
  wire [AXI_DATA_WIDTH-1:0]   data_mem_wdata;

  wire [AXI_DATA_WIDTH-1:0]   data_mem_rdata;
  


core core_inst(
        .clk                  (clk),
        .rst_n                (rst_n),
        .data_wr_o            (core_data_we),
        .data_addr_o          (core_data_addr),
        .data_rdata_i         (core_data_rdata),
        .data_wdata_o         (core_data_wdata),
        .data_be_o            (core_data_be),     // Write mask for data mem
        .data_req_o           (core_data_req),    // Request to make action
        .data_gnt_i           (core_data_gnt),    // Action Granted 
        .data_rvalid_i        (core_data_rvalid), // Valid when write is ok
        .instruction_addr_o   (core_instr_addr),
        .instruction_rdata_i  (core_instr_rdata),
        .flush_inst_o         (flush_inst_t)
    );

 // Default configuration for the core to access the instr/data memory
 assign core_instr_req = 1'b1; // Core always wants to have proper access to the instructions he wants (PC address).
 assign core_instr_we = 1'b0;  // Core shouldn't be able to write its instructions... What do you think this is? An AI with free will?... Not yet.
 assign core_instr_be = {(AXI_DATA_WIDTH/8){1'b0}}; // Mask to write in instr mem. 0=Don't write anything.
 assign core_instr_wdata = {AXI_DATA_WIDTH{1'b0}};
/*
 wire axi_instr_req;          // Comment to use on synthesis
 wire axi_data_req;           // Comment to use on synthesis
 assign axi_instr_req = 1'b0; // Comment to use on synthesis
 assign axi_data_req = 1'b0;  // Comment to use on synthesis
*/

  //----------------------------------------------------------------------------//
  // Instruction RAM                                                            //
  //----------------------------------------------------------------------------//

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


  ram_mux // MUX that controls what access the memory, having port0 (external 
  #(      // bus) priority over port1 (core).
    .ADDR_WIDTH ( INSTR_ADDR_WIDTH ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH   ),
    .IN1_WIDTH  ( `DATA_WIDTH      ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH   )
  )
  instr_ram_mux_i
  (
    .clk            ( clk               ),
    .rst_n          ( rst_n             ),

    .port0_req_i    ( axi_instr_req     ), // 1'b0
    .port0_gnt_o    ( axi_instr_gnt     ),
    .port0_rvalid_o ( axi_instr_rvalid  ),
    .port0_addr_i   ( axi_instr_addr    ), //{INSTR_ADDR_WIDTH{1'b0}}
    .port0_we_i     ( axi_instr_we      ), // 1'b0
    .port0_be_i     ( axi_instr_be      ), //{(AXI_DATA_WIDTH/8){1'b0}}
    .port0_rdata_o  ( axi_instr_rdata   ),
    .port0_wdata_i  ( axi_instr_wdata   ), //{AXI_DATA_WIDTH{1'b0}}

    .port1_req_i    ( core_instr_req    ),
    .port1_gnt_o    ( core_instr_gnt    ),
    .port1_rvalid_o ( core_instr_rvalid ),
    .port1_addr_i   ( {{INSTR_ADDR_WIDTH-`MEM_ADDR_INSTR_WIDTH{1'b0}}, core_instr_addr} ),
    .port1_we_i     ( core_instr_we     ),
    .port1_be_i     ( core_instr_be     ),
    .port1_rdata_o  ( core_instr_rdata  ),
    .port1_wdata_i  ( core_instr_wdata  ),

    .ram_en_o       ( instr_mem_en      ),
    .ram_addr_o     ( instr_mem_addr    ),
    .ram_we_o       ( instr_mem_we      ),
    .ram_be_o       ( instr_mem_be      ),
    .ram_rdata_i    ( instr_mem_rdata   ),
    .ram_wdata_o    ( instr_mem_wdata   )
  );


  //----------------------------------------------------------------------------//
  // Data RAM                                                                   //
  //----------------------------------------------------------------------------//
  sp_ram_wrap_data
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
    .bypass_en_i  ( 1'b0           )
  );


  ram_mux
  #(
    .ADDR_WIDTH ( DATA_ADDR_WIDTH  ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH   ),
    .IN1_WIDTH  ( `DATA_WIDTH      ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH   )
  )
  data_ram_mux_i
  (
    .clk            ( clk              ),
    .rst_n          ( rst_n            ),

    .port0_req_i    ( axi_data_req     ), // 1'b0
    .port0_gnt_o    ( axi_data_gnt     ),
    .port0_rvalid_o ( axi_data_rvalid  ),
    .port0_addr_i   ( axi_data_addr    ), //{INSTR_ADDR_WIDTH{1'b0}}
    .port0_we_i     ( axi_data_we      ), // 1'b0
    .port0_be_i     ( axi_data_be      ), //{(AXI_DATA_WIDTH/8){1'b0}}
    .port0_rdata_o  ( axi_data_rdata   ),
    .port0_wdata_i  ( axi_data_wdata   ), //{AXI_DATA_WIDTH{1'b0}}

    .port1_req_i    ( core_data_req    ),
    .port1_gnt_o    ( core_data_gnt    ),
    .port1_rvalid_o ( core_data_rvalid ),
    .port1_addr_i   ( {{DATA_ADDR_WIDTH-`MEM_ADDR_DATA_WIDTH{1'b0}}, core_data_addr} ),
    .port1_we_i     ( core_data_we     ),
    .port1_be_i     ( core_data_be     ),
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