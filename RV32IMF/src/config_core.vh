// Telecommunications Master Dissertation - Francis Fuentes 18-12-2020

// Configuration file to select what modules to use at the core.
// Check each specific file to find more information about each module in addition to the information
// listed at the "Resource usage and RTL mapping" folder which contains useful information like resource
// usage and maximum operating frequency at the synthesis on the DE0 FPGA platform (Cyclone III) of the 
// designed modules.

`ifndef _CONFIG_CORE_H_
`define _CONFIG_CORE_H_

//////////////////////////////////////
// Instruction Set M module options //
//////////////////////////////////////

  // Select a single MULDIV (MUL) module (by default selects MULDIV with no IP MUL module):
`define RV32IM_noIP    // Uses MULgold as multiplier module (MULDIV). It may not be supported by specific FPGA HW resources.
//`define RV32IM_MULDIV  // Uses LPM_MULT32 as multiplier module (MULDIV).
//`define RV32IM_MULDIV2 // Uses ALTMULT_ADD32 as multiplier module (MULDIV2).

  // Select just one DIV module (by default selects tDIVrest32u):
//`define RV32IM_tDIVrest32
//`define RV32IM_bDIVrest32
//`define RV32IM_qsDIVrest32
//`define RV32IM_eqsDIVrest32
//`define RV32IM_seDIVrest32
`define RV32IM_dDIVrest32
//`define RV32IM_deqsDIVrest32
//`define RV32IM_dseDIVrest32

 
`endif