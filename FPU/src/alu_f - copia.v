// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision ALU able to implement the FADD/FSUB, 
// FMUL/FDIV, FSQRT and FMIN-MAX operations. It also includes the ability of 
// performing floating-point fused multiply-add instructions F[N]MADD/F[N]MSUB
// when using a R4-type instruction format.

module alu_f(rs1_i, rs2_i, rs3_i, funct7_i, opcode_i, frm_i, clk, rstLow, c_o, fflags_o, busy_o);
// Input operands and control signals;
input wire [31:0] rs1_i;
input wire [31:0] rs2_i;
input wire [31:0] rs3_i;

input wire  [6:0] funct7_i;
input wire  [4:0] opcode_i;
input wire  [2:0] frm_i;  // Rounding mode bits from the FCSR for dynamic rounding operation.
input wire        clk;
input wire        rstLow;

wire              rs1_s;  // rs1 sign bit.
wire        [7:0] rs1_e;  // rs1 exponent byte.
wire       [22:0] rs1_m;  // rs1 mantissa bits.
wire              rs2_s;  // rs2 sign bit.      Not used on FSQRT operation (must be 0 if FSQRT).
wire        [7:0] rs2_e;  // rs2 exponent byte. Not used on FSQRT operation (must be 0 if FSQRT).
wire       [22:0] rs2_m;  // rs2 mantissa bits. Not used on FSQRT operation (must be 0 if FSQRT).
wire              rs3_s;  // rs3 sign bit.      Only used when R4-type instr format. Otherwise must be 0.
wire        [7:0] rs3_e;  // rs3 exponent byte. Only used when R4-type instr format. Otherwise must be 0.
wire       [22:0] rs3_m;  // rs3 mantissa bits. Only used when R4-type instr format. Otherwise must be 0.

assign rs1_s = rs1_i[31];
assign rs1_e = rs1_i[30:23];
assign rs1_m = rs1_i[22:0];
assign rs2_s = rs2_i[31];
assign rs2_e = rs2_i[30:23];
assign rs2_m = rs2_i[22:0];
assign rs3_s = rs3_i[31];
assign rs3_e = rs3_i[30:23];
assign rs3_m = rs3_i[22:0];

output wire [31:0] c_o;
reg                c_s:  // Output sign bit.
reg          [7:0] c_e;  // Output exponent byte.
reg         [22:0] c_m;  // Output mantissa bits.
assign c_o = {c_s, c_e, c_m};

output wire  [4:0] fflags_o; // Exception flags.
reg                NV, DZ, OF, UF, NX; // iNValid operation, Divide by Zero, OverFlow,
assign fflags_o = {NV, DZ, OF, UF, NX};// UnderFlow, iNeXact.

`define FUNCT7_FSUB_S 7'b0000100
`define OP-FP         7'b1010011



case(opcode_i)
 `OP-FP:
   case(funct7_i)
     `FUNCT7_FSUB_S, `FUNCT7_FADD_S:
      begin
       if()
       c_s <= AddSub_res[28];
       c_e <= AddSub_e;
       c_m <= AddSub_shifted;
      end
   endcase
endcase


















endmodule