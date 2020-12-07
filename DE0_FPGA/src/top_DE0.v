// --------------------------------------------------------------------
// Copyright (c) 2009 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:    DE0 Button Debounce
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Ver:| Author : Allen Wang  | Mod. Date : 2010/07/27 | Changes Made:
// --------------------------------------------------------------------

//`timescale 1ns/1ps
`include "../src/top_CoreMem.v"
`include "../src/DE0/button_debouncer.v"
//`include "../src/DE0/PLL.v"
`include "../src/DE0/SEG7_LUT.v"

module top_DE0
    (
        ////////////////////    Clock Input         ////////////////////     
        CLOCK_50,                        // 50 MHz
        CLOCK_50_2,                      // 50 MHz
        ////////////////////    Push Button        ////////////////////
        ORG_BUTTON,                      // Pushbutton[2:0]
        ////////////////////    DPDT Switch        ////////////////////
        SW,                              // Toggle Switch[9:0]
        ////////////////////    7-SEG Dispaly    ////////////////////
        HEX0_D,                          // Seven Segment Digit 0
        HEX0_DP,                         // Seven Segment Digit DP 0
        HEX1_D,                          // Seven Segment Digit 1
        HEX1_DP,                         // Seven Segment Digit DP 1
        HEX2_D,                          // Seven Segment Digit 2
        HEX2_DP,                         // Seven Segment Digit DP 2
        HEX3_D,                          // Seven Segment Digit 3
        HEX3_DP,                         // Seven Segment Digit DP 3
        ////////////////////////    LED        ////////////////////////
        LEDG,                            // LED Green[9:0]
        ////////////////////////    UART    ////////////////////////
        UART_TXD,                        // UART Transmitter
        UART_RXD,                        // UART Receiver
        UART_CTS,                        // UART Clear To Send
        UART_RTS,                        // UART Request To Send
        /////////////////////    SDRAM Interface        ////////////////
        DRAM_DQ,                         // SDRAM Data bus 16 Bits
        DRAM_ADDR,                       // SDRAM Address bus 13 Bits
        DRAM_LDQM,                       // SDRAM Low-byte Data Mask 
        DRAM_UDQM,                       // SDRAM High-byte Data Mask
        DRAM_WE_N,                       // SDRAM Write Enable
        DRAM_CAS_N,                      // SDRAM Column Address Strobe
        DRAM_RAS_N,                      // SDRAM Row Address Strobe
        DRAM_CS_N,                       // SDRAM Chip Select
        DRAM_BA_0,                       // SDRAM Bank Address 0
        DRAM_BA_1,                       // SDRAM Bank Address 1
        DRAM_CLK,                        // SDRAM Clock
        DRAM_CKE,                        // SDRAM Clock Enable
        ////////////////////    Flash Interface        ////////////////
        FL_DQ,                           // FLASH Data bus 15 Bits
        FL_DQ15_AM1,                     // FLASH Data bus Bit 15 or Address A-1
        FL_ADDR,                         // FLASH Address bus 22 Bits
        FL_WE_N,                         // FLASH Write Enable
        FL_RST_N,                        // FLASH Reset
        FL_OE_N,                         // FLASH Output Enable
        FL_CE_N,                         // FLASH Chip Enable
        FL_WP_N,                         // FLASH Hardware Write Protect
        FL_BYTE_N,                       // FLASH Selects 8/16-bit mode
        FL_RY,                           // FLASH Ready/Busy
        ////////////////////    LCD Module 16X2        ////////////////
        LCD_BLON,                        // LCD Back Light ON/OFF
        LCD_RW,                          // LCD Read/Write Select, 0 = Write, 1 = Read
        LCD_EN,                          // LCD Enable
        LCD_RS,                          // LCD Command/Data Select, 0 = Command, 1 = Data
        LCD_DATA,                        // LCD Data bus 8 bits
        ////////////////////    SD_Card Interface    ////////////////
        SD_DAT0,                         // SD Card Data 0
        SD_DAT3,                         // SD Card Data 3
        SD_CMD,                          // SD Card Command Signal
        SD_CLK,                          // SD Card Clock
        SD_WP_N,                         // SD Card Write Protect
        ////////////////////    PS2        ////////////////////////////
        PS2_KBDAT,                       // PS2 Keyboard Data
        PS2_KBCLK,                       // PS2 Keyboard Clock
        PS2_MSDAT,                       // PS2 Mouse Data
        PS2_MSCLK,                       // PS2 Mouse Clock
        ////////////////////    VGA        ////////////////////////////
        //VGA_HS,                        // VGA H_SYNC
        //VGA_VS,                        // VGA V_SYNC
        //VGA_R,                         // VGA Red[3:0]
        //VGA_G,                         // VGA Green[3:0]
        //VGA_B,                         // VGA Blue[3:0]
        ////////////////////    GPIO    ////////////////////////////
        GPIO0_CLKIN,                     // GPIO Connection 0 Clock In Bus
        GPIO0_CLKOUT,                    // GPIO Connection 0 Clock Out Bus
        GPIO0_D,                         // GPIO Connection 0 Data Bus
        GPIO1_CLKIN,                     // GPIO Connection 1 Clock In Bus
        GPIO1_CLKOUT,                    // GPIO Connection 1 Clock Out Bus
        GPIO1_D,                         // GPIO Connection 1 Data Bus
        ////////////////////    Debug I/O to make it synthesize everything
        //axi_instr_req,
        axi_instr_we,
        axi_instr_addr,
        axi_instr_wdata,
        //axi_data_req,
        axi_data_we,
        axi_data_addr,
        axi_data_wdata
    );


////////////////////////    Clock Input         ////////////////////////
input         CLOCK_50;                  // 50 MHz
input         CLOCK_50_2;                // 50 MHz
////////////////////////    Push Button        ////////////////////////
input   [2:0] ORG_BUTTON;                // Pushbutton[2:0]
////////////////////////    DPDT Switch        ////////////////////////
input   [9:0] SW;                        // Toggle Switch[9:0]
////////////////////////    7-SEG Dispaly    ////////////////////////
output  [6:0] HEX0_D;                    // Seven Segment Digit 0
output        HEX0_DP;                   // Seven Segment Digit DP 0
output  [6:0] HEX1_D;                    // Seven Segment Digit 1
output        HEX1_DP;                   // Seven Segment Digit DP 1
output  [6:0] HEX2_D;                    // Seven Segment Digit 2
output        HEX2_DP;                   // Seven Segment Digit DP 2
output  [6:0] HEX3_D;                    // Seven Segment Digit 3
output        HEX3_DP;                   // Seven Segment Digit DP 3
////////////////////////////    LED        ////////////////////////////
output reg [9:0] LEDG;                   // LED Green[9:0]
////////////////////////////    UART    ////////////////////////////
output        UART_TXD;                  // UART Transmitter
input         UART_RXD;                  // UART Receiver
output        UART_CTS;                  // UART Clear To Send
input         UART_RTS;                  // UART Request To Send
///////////////////////        SDRAM Interface    ////////////////////////
inout  [15:0] DRAM_DQ;                   // SDRAM Data bus 16 Bits
output [12:0] DRAM_ADDR;                 // SDRAM Address bus 13 Bits
output        DRAM_LDQM;                 // SDRAM Low-byte Data Mask
output        DRAM_UDQM;                 // SDRAM High-byte Data Mask
output        DRAM_WE_N;                 // SDRAM Write Enable
output        DRAM_CAS_N;                // SDRAM Column Address Strobe
output        DRAM_RAS_N;                // SDRAM Row Address Strobe
output        DRAM_CS_N;                 // SDRAM Chip Select
output        DRAM_BA_0;                 // SDRAM Bank Address 0
output        DRAM_BA_1;                 // SDRAM Bank Address 1
output        DRAM_CLK;                  // SDRAM Clock
output        DRAM_CKE;                  // SDRAM Clock Enable
////////////////////////    Flash Interface    ////////////////////////
inout  [14:0] FL_DQ;                     // FLASH Data bus 15 Bits
inout         FL_DQ15_AM1;               // FLASH Data bus Bit 15 or Address A-1
output [21:0] FL_ADDR;                   // FLASH Address bus 22 Bits
output        FL_WE_N;                   // FLASH Write Enable
output        FL_RST_N;                  // FLASH Reset
output        FL_OE_N;                   // FLASH Output Enable
output        FL_CE_N;                   // FLASH Chip Enable
output        FL_WP_N;                   // FLASH Hardware Write Protect
output        FL_BYTE_N;                 // FLASH Selects 8/16-bit mode
input         FL_RY;                     // FLASH Ready/Busy
////////////////////    LCD Module 16X2    ////////////////////////////
inout   [7:0] LCD_DATA;                  // LCD Data bus 8 bits
output        LCD_BLON;                  // LCD Back Light ON/OFF
output        LCD_RW;                    // LCD Read/Write Select, 0 = Write, 1 = Read
output        LCD_EN;                    // LCD Enable
output        LCD_RS;                    // LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////    SD Card Interface    ////////////////////////
inout         SD_DAT0;                   // SD Card Data 0
inout         SD_DAT3;                   // SD Card Data 3
inout         SD_CMD;                    // SD Card Command Signal
output        SD_CLK;                    // SD Card Clock
input         SD_WP_N;                   // SD Card Write Protect
////////////////////////    PS2        ////////////////////////////////
inout         PS2_KBDAT;                 // PS2 Keyboard Data
inout         PS2_KBCLK;                 // PS2 Keyboard Clock
inout         PS2_MSDAT;                 // PS2 Mouse Data
inout         PS2_MSCLK;                 // PS2 Mouse Clock
////////////////////////    VGA        ////////////////////////////////
//output        VGA_HS;                    // VGA H_SYNC
//output        VGA_VS;                    // VGA V_SYNC
//output  [3:0] VGA_R;                     // VGA Red[3:0]
//output  [3:0] VGA_G;                     // VGA Green[3:0]
//output  [3:0] VGA_B;                     // VGA Blue[3:0]
////////////////////////    GPIO    ////////////////////////////////
input   [1:0] GPIO0_CLKIN;               // GPIO Connection 0 Clock In Bus
output  [1:0] GPIO0_CLKOUT;              // GPIO Connection 0 Clock Out Bus
inout  [31:0] GPIO0_D;                   // GPIO Connection 0 Data Bus
input   [1:0] GPIO1_CLKIN;               // GPIO Connection 1 Clock In Bus
output  [1:0] GPIO1_CLKOUT;              // GPIO Connection 1 Clock Out Bus
inout  [31:0] GPIO1_D;                   // GPIO Connection 1 Data Bus




//==================================================================
//  REG/WIRE declarations
//==================================================================
wire    [2:0]    ORG_BUTTON;                 // Button 

wire            reset_n;                // Reset
wire            BUTTON[0:2];        // Button after debounce

wire            counter_1;              // Counter for Button[1]
wire            counter_2;              // Counter for Button[2]
wire    [3:0]   iDIG_0;                    // 7SEG 0 
wire    [3:0]   iDIG_1;                 // 7SEG 1
wire    [3:0]   iDIG_2;
wire    [3:0]   iDIG_3;

reg               out_BUTTON_1;           // Button1 Register output
reg               out_BUTTON_2;           // Button2 Register output

reg             virtual_clk;       // Virtual clock to slow the processor
wire            clock_to_core;
wire            PLL_1MHzclock;

reg [21:0] count_reg;
reg out_10hz = 0;
//==================================================================
//  Structural coding
//==================================================================

PLL PLL_instance(
    .inclk0(CLOCK_50),
    .c0(PLL_1MHzclock));


// This is BUTTON[0] Debounce Circuit //
button_debouncer    button_debouncer_inst0(
    .clk     (PLL_1MHzclock),
    .rst_n   (1'b1),
    .data_in (ORG_BUTTON[0]),
    .data_out(BUTTON[0])            
    );
    
// This is BUTTON[1] Debounce Circuit //
button_debouncer    button_debouncer_inst1(
    .clk     (PLL_1MHzclock),
    .rst_n   (1'b1),
    .data_in (ORG_BUTTON[1]),
    .data_out(BUTTON[1])            
    );
    
// This is BUTTON[2] Debounce Circuit //
button_debouncer    button_debouncer_inst2(
    .clk     (PLL_1MHzclock),
    .rst_n   (1'b1),
    .data_in (ORG_BUTTON[2]),
    .data_out(BUTTON[2])            
    );

// This is SEG0 Display//
SEG7_LUT    SEG0(
                 .oSEG   (HEX0_D),
                 .oSEG_DP(),
                 .iDIG   (iDIG_0)
                 );
                 
// This is SEG1 Display//
SEG7_LUT    SEG1(
                 .oSEG   (HEX1_D),
                 .oSEG_DP(),
                 .iDIG   (iDIG_1)
                 );
                 
// This is SEG2 Display//
SEG7_LUT    SEG2(
                 .oSEG   (HEX2_D),
                 .oSEG_DP(),
                 .iDIG   (iDIG_2)
                 );
                 
// This is SEG3 Display//                 
SEG7_LUT    SEG3(
                 .oSEG   (HEX3_D),
                 .oSEG_DP(),
                 .iDIG   (iDIG_3)
                  );    



`ifdef CUSTOM_DEFINE
        parameter ADDR_WIDTH = `MEM_ADDR_WIDTH;
        parameter DATA_WIDTH = `REG_DATA_WIDTH;
        parameter TRANSFER_WIDTH = `MEM_TRANSFER_WIDTH;
`else
        parameter ADDR_WIDTH = 10;
        parameter DATA_WIDTH = 32;
        parameter TRANSFER_WIDTH = 4;
`endif

    wire                    axi_instr_req;
    input wire                    axi_instr_we;
    input wire [15 : 0]           axi_instr_addr;
    input wire [DATA_WIDTH-1 : 0] axi_instr_wdata;
    wire                    axi_data_req;
    input wire                    axi_data_we;
    input wire [15 : 0]           axi_data_addr;
    input wire [DATA_WIDTH-1 : 0] axi_data_wdata;


    wire [ADDR_WIDTH-1 : 0] core_instr_addr;
    wire [DATA_WIDTH-1 : 0] core_instr_rdata;
    wire                    core_data_we;
    wire [ADDR_WIDTH-1 : 0] core_data_addr;
    wire [DATA_WIDTH-1 : 0] core_data_wdata;


top_CoreMem CoreMem_inst(
        .clk              ( clock_to_core ),
        .rst_n            ( reset_n       ),

        // AXI to instr mem
        .axi_instr_req    ( axi_instr_req          ),
        .axi_instr_addr   ( axi_instr_addr         ), // 1+ because it has a boot memory
        .axi_instr_we     ( axi_instr_we           ),
        .axi_instr_be     ( {TRANSFER_WIDTH{1'b1}} ),
        .axi_instr_wdata  ( axi_instr_wdata        ),
        // instr mem to AXI
        .axi_instr_gnt    (  ),  
        .axi_instr_rvalid (  ),
        .axi_instr_rdata  (  ),

        // AXI to data mem
        .axi_data_req     ( axi_data_req           ),
        .axi_data_addr    ( axi_data_addr          ),
        .axi_data_we      ( axi_data_we            ),
        .axi_data_be      ( {TRANSFER_WIDTH{1'b1}} ),
        .axi_data_wdata   ( axi_data_wdata         ),
        // data mem to AXI
        .axi_data_gnt     (  ),
        .axi_data_rvalid  (  ),
        .axi_data_rdata   (  ),

        // AXI to core UNUSED ATM
        .core_axi_req     ( 1'b0                   ),
        .core_axi_addr    ( {ADDR_WIDTH{1'b0}}     ),
        .core_axi_we      ( 1'b0                   ),
        .core_axi_be      ( {TRANSFER_WIDTH{1'b1}} ),
        .core_axi_wdata   ( {DATA_WIDTH{1'b0}}     ),
        // core to AXI
        .core_axi_gnt     (  ),
        .core_axi_rvalid  (  ),
        .core_axi_rdata   (  ),
        // core interaction with instr/data memories
        .core_instr_addr  ( core_instr_addr  ),  // PC
        .core_instr_rdata ( core_instr_rdata ),  // instruction at core's input
        .core_data_addr   ( core_data_addr   ),  // address that is pointing in the data memory
        .core_data_wdata  ( core_data_wdata  ),  // what is the core writing in the data memory
        .core_data_we     ( core_data_we     )
    );

/////////////////////////////////////////////
//   Physical DE0 board interactivity      //
/////////////////////////////////////////////

assign iDIG_0    = core_instr_addr[3:0];
assign iDIG_1    = core_instr_addr[6:4];
assign iDIG_2    = core_instr_rdata[27:24];
assign iDIG_3    = core_instr_rdata[31:28];
assign reset_n   = BUTTON[0];  
assign axi_instr_req = SW[9];                   
assign axi_data_req = SW[9];
//assign counter_1 = ((BUTTON[1] == 0) && (out_BUTTON_1 == 1)) ?1:0;
//assign counter_2 = ((BUTTON[2] == 0) && (out_BUTTON_2 == 1)) ?1:0;
assign HEX0_DP = !clock_to_core;
//assign HEX1_DP = (core_data_addr == 9'h014 && we_mem_data)? 1'b0:1'b1;
//assign HEX2_DP = !we_mem_data;
//assign HEX3_DP = !write_transfer[0];
assign clock_to_core = SW[0] ?  (SW[1] ? out_10hz : PLL_1MHzclock) : virtual_clk;  // SW[0] ? CLOCK_50:PLL_1MHzclock;  //
//assign LEDG[0] = ((core_data_addr == 9'h014))? 1:0;


//====================================================================
// After debounce output with register
//====================================================================
always @ (posedge PLL_1MHzclock )
    begin
        out_BUTTON_1 <= BUTTON[1];
        out_BUTTON_2 <= BUTTON[2];
    end

    
always @ ( out_BUTTON_2 )
    begin
        if (out_BUTTON_2 == 1'b1) virtual_clk = 1'b0;
        else virtual_clk = 1'b1;
    end
//====================================================================
// Display process
//====================================================================
// GPIO
always @(posedge PLL_1MHzclock or negedge reset_n)
  begin
  if (!reset_n) LEDG <= 10'd0;
  else if (core_data_addr == 7'h14 && core_data_we) begin
    LEDG <= core_data_wdata[9:0];
  end
end

// generate 100 Hz from 50 MHz


always @(posedge PLL_1MHzclock or negedge reset_n) begin
    if (!reset_n) begin
        count_reg <= 0;
        out_10hz <= 0;
    end else begin
        if (count_reg < 599999) begin
            count_reg <= count_reg + 2'b1;
        end else begin
            count_reg <= 0;
            out_10hz <= ~out_10hz;
        end
    end
end

endmodule