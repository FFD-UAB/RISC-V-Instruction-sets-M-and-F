
`ifndef _DEFINES_H_
`define _DEFINES_H_

// Parameters
`define DATA_WIDTH 32
`define REG_DATA_WIDTH 32   // Word Width
`define REG_ADDR_WIDTH 5   // Address With
`define REG_DEPTH 1 << `REG_ADDR_WIDTH  // Total number of positions (32)


`define MEM_DATA_WIDTH 32   // Word Width
`define MEM_ADDR_INSTR_WIDTH 12   // Address Width for the core
`define MEM_ADDR_DATA_WIDTH 8    // Address Width for the core

`define MEM_TRANSFER_WIDTH 4  // Mask to store word, halfword or byte


// Instrucitions types

// OPCODES
`define OPCODE_U_LUI          7'b0110111
`define OPCODE_U_AUIPC        7'b0010111
`define OPCODE_J_JAL          7'b1101111
`define OPCODE_I_JALR         7'b1100111
`define OPCODE_B_BRANCH       7'b1100011
`define OPCODE_I_LOAD         7'b0000011  //
`define OPCODE_S_STORE        7'b0100011  //
`define OPCODE_I_IMM          7'b0010011
`define OPCODE_R_ALU          7'b0110011  // PROV NAME
`define OPCODE_I_FENCE        7'b0001111  //
`define OPCODE_I_SYSTEM       7'b1110011


// FUNCT3
//  I_JARL
`define FUNCT3_JARL            3'b000

//  B_BRANCH
`define FUNCT3_BEQ             3'b000
`define FUNCT3_BNE             3'b001
`define FUNCT3_BLT             3'b100
`define FUNCT3_BGE             3'b101
`define FUNCT3_BLTU            3'b110
`define FUNCT3_BGEU            3'b111

// I_LOAD
`define FUNCT3_LB              3'b000
`define FUNCT3_LH              3'b001
`define FUNCT3_LW              3'b010
`define FUNCT3_LBU             3'b100
`define FUNCT3_LHU             3'b101

//  S_STORES
`define FUNCT3_SB              3'b000
`define FUNCT3_SH              3'b001
`define FUNCT3_SW              3'b010

//  I_IMM
`define FUNCT3_ADDI            3'b000
`define FUNCT3_SLTI            3'b010
`define FUNCT3_SLTIU           3'b011
`define FUNCT3_XORI            3'b100
`define FUNCT3_ORI             3'b110
`define FUNCT3_ANDI            3'b111
`define FUNCT3_SLLI            3'b001
`define FUNCT3_SRLI_SRAI       3'b101

//  R_ALU
`define FUNCT3_ADD_SUB         3'b000
`define FUNCT3_SLL             3'b001
`define FUNCT3_SLT             3'b010
`define FUNCT3_SLTU            3'b011
`define FUNCT3_XOR             3'b100
`define FUNCT3_SRL_SRA         3'b101
`define FUNCT3_OR              3'b110
`define FUNCT3_AND             3'b111

//  R_ALU_M
`define FUNCT3_MUL             3'b000
`define FUNCT3_MULH            3'b001
`define FUNCT3_MULHSU          3'b010
`define FUNCT3_MULHU           3'b011
`define FUNCT3_DIV             3'b100
`define FUNCT3_DIVU            3'b101
`define FUNCT3_REM             3'b110
`define FUNCT3_REMU            3'b111

//  I_FENCE
`define FUNCT3_FENCE           3'b000
`define FUNCT3_FENCEI          3'b001

//  I_SYSTEM
`define FUNCT3_ECALL_EBREAK    3'b000
`define FUNCT3_CSRRW           3'b001
`define FUNCT3_CSRRS           3'b010
`define FUNCT3_CSRRC           3'b011
`define FUNCT3_CSRRWI          3'b101
`define FUNCT3_CSRRSI          3'b110
`define FUNCT3_CSRRCI          3'b111


// FUNCT7
//  I_IMM
`define FUNCT7_SRLI        7'b0000000
`define FUNCT7_SRAI        7'b0100000

//  R_ALU
`define FUNCT7_ADD         7'b0000000
`define FUNCT7_SUB         7'b0100000
`define FUNCT7_SRL         7'b0000000
`define FUNCT7_SRA         7'b0100000
`define FUNCT7_MULDIV      7'b0000001

// I_SYSTEM
`define IMM_ECALL          12'b000000000000
`define IMM_EBREAK         12'b000000000001

// ALU_OPERATIONS
`define ALU_OP_WIDTH      5

// {funct7[0], funct7[5], funct3};
`define ALU_OP_ADD        5'b00000        
`define ALU_OP_SUB        5'b01000
`define ALU_OP_SLL        5'b00001
`define ALU_OP_SLT        5'b00010
`define ALU_OP_SLTU       5'b00011
`define ALU_OP_XOR        5'b00100
`define ALU_OP_SRL        5'b00101
`define ALU_OP_SRA        5'b01101
`define ALU_OP_OR         5'b00110
`define ALU_OP_AND        5'b00111
`define ALU_OP_MUL        5'b10000  // Instruction set M -> ALU_OP[4] = 1;
`define ALU_OP_MULH       5'b10001  // Then, it can be used as start_M signal.
`define ALU_OP_MULHSU     5'b10010
`define ALU_OP_MULHU      5'b10011
`define ALU_OP_DIV        5'b10100
`define ALU_OP_DIVU       5'b10101
`define ALU_OP_REM        5'b10110
`define ALU_OP_REMU       5'b10111

// LOAD_OPERATIONS
`define LOAD_OP_WIDTH     3

`define LOAD_LB           0
`define LOAD_LH           1
`define LOAD_LW           2
`define LOAD_LBU          3
`define LOAD_LHU          4

// STORE_OPERATIONS
`define STORE_OP_WIDTH    2

`define STORE_SB          0
`define STORE_SH          1
`define STORE_SW          2

// BR_OPERATIONS
`define BR_OP_WIDTH          3

`define BR_NOOP              0
`define BR_EQ                1
`define BR_NE                2
`define BR_LT                3
`define BR_LTU               4
`define BR_GE                5
`define BR_GEU               6

// Data origins 
`define DATA_ORIGIN_WIDTH    2

`define REGS                 0
`define RS2IMM_RS1           1
`define RS2IMM_RS1PC         2
//`define UNUSED               3

// CSR
`define CSR_OP_WIDTH         2
`define CSR_ADDR_WIDTH       12
`define CSR_DATA_WIDTH       32
`define CSR_XLEN             64
`define CSR_IMM_WIDTH        5

`define CSRRW                1
`define CSRRS                2
`define CSRRC                3
`define CSRRWI               4
`define CSRRSI               5
`define CSRRCI               6
`define CYCLE_ADDR           12'hC00
`define CYCLEH_ADDR          12'hC80
`define TIME_ADDR            12'hC01
`define TIMEH_ADDR           12'hC81
`define INSTRET_ADDR         12'hC02
`define INSTRETH_ADDR        12'hC82
`define USTATUS_ADDR         12'h0
 
`endif