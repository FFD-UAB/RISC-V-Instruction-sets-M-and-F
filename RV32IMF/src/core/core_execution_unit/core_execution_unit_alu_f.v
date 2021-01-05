// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision ALU able to implement the FADD/FSUB, 
// FMUL/FDIV, FSQRT and FMIN-MAX operations. It also includes the ability of 
// performing floating-point fused multiply-add instructions F[N]MADD/F[N]MSUB
// when using a R4-type instruction format. (OBVIOUSLY NOT FINISHED, only FADD/FSUB)

`include "../../defines.vh"

module FPU_S(rs1_i, rs2_i, rs3_i, funct5_i, frm_i, start_i, clk, rstLow, c_o, fflags_o, busy_o);
// Input operands and control signals;
input wire [31:0] rs1_i;
input wire [31:0] rs2_i;
input wire [31:0] rs3_i;

input wire  [4:0] funct5_i; // Operation selector.
input wire  [2:0] frm_i;    // Rounding mode bits from the FCSR or instruction.
input wire        start_i;
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

output reg  [31:0] c_o;
output wire  [4:0] fflags_o; // Exception flags.
output wire        busy_o;   // Multi-cycle operation ongoing.
reg                NV, DZ, OF, UF, NX; // iNValid operation, Divide by Zero, OverFlow,
assign fflags_o = {NV, DZ, OF, UF, NX};// UnderFlow, iNeXact.
assign busy_o = 1'b0; // For future multi-cycle operations support.

wire [31:0] FAddSub_res;
wire [31:0] FMUL_res;
wire [31:0] FDIV_res;
wire  [4:0] FAddSub_fflags;
wire  [4:0] FMUL_fflags;
wire  [4:0] FDIV_fflags;


ADDSUB_FPs ADDSUBs(
         .rs1_i     ( rs1_i          ), 
         .rs2_i     ( rs2_i          ),
         .SUBflag_i ( funct5_i[0]    ), 
         .frm_i     ( frm_i          ), 
         .c_o       ( FAddSub_res    ), 
         .fflags_o  ( FAddSub_fflags )
         );

// For future implementation
assign FMUL_res = 32'b0;
assign FDIV_res = 32'b0;
assign FMUL_fflags = 5'b0;
assign FDIV_fflags = 5'b0;


// Special input cases flags
wire ZRS1;   // Zero RS1
wire ZRS2;   // Zero RS2
wire ZRS3;   // Zero RS3
wire NaNRS1; // NaN RS1
wire NaNRS2; // NaN RS2
wire NaNRS3; // NaN RS3
wire InfRS1; // Infinity RS1
wire InfRS2; // Infinity RS2
wire InfRS3; // Infinity RS3
wire FFexpRS1;
wire FFexpRS2;
wire FFexpRS3;
wire anythingMRS1;
wire anythingMRS2;
wire anythingMRS3;

assign FFexpRS1     = rs1_e == 8'hFF;
assign FFexpRS2     = rs2_e == 8'hFF;
assign FFexpRS3     = rs3_e == 8'hFF;
assign anythingMRS1 = |rs1_m;
assign anythingMRS2 = |rs2_m;
assign anythingMRS3 = |rs3_m;

assign ZRS1   = {rs1_e, rs1_m} == 31'b0;  
assign ZRS2   = {rs2_e, rs2_m} == 31'b0;
assign ZRS3   = {rs3_e, rs3_m} == 31'b0;
assign NaNRS1 = FFexpRS1 & anythingMRS1;
assign NaNRS2 = FFexpRS2 & anythingMRS2;
assign NaNRS3 = FFexpRS3 & anythingMRS3;
assign InfRS1 = FFexpRS1 & !anythingMRS1;
assign InfRS2 = FFexpRS2 & !anythingMRS2;
assign InfRS3 = FFexpRS3 & !anythingMRS3;


wire RS12NaN;   // RS1 and RS2 NaN.
wire RS12PNInf; // RS1 and RS2 infinite with different sign.
wire RS12ZInf;  // RS1 and RS2 contain zero and infinite.
wire RS12Z;     // RS1 and RS2 are zero.
wire RS12Inf;   // RS1 and RS2 are infinite.
wire RS12Sign;  // RS1 and RS2 signed multiplied/divided.

assign RS12NaN   = NaNRS1 | NaNRS2;
assign RS12PNInf = InfRS1 & InfRS2 & (rs1_s != rs2_s);
assign RS12ZInf  = (ZRS1 & InfRS2) | (ZRS2 & InfRS1);
assign RS12Z     = ZRS1 & ZRS2;
assign RS12Inf   = InfRS1 & InfRS2;
assign RS12Sign  = rs1_s ^ rs2_s;


always @(*) begin
c_o <= 32'b0;
{NV, DZ, OF, UF, NX} <= 5'b0;

case(funct5_i)
 `ALU_OP_FADD, `ALU_OP_FSUB:
 begin
  if(RS12NaN | RS12PNInf) begin
   c_o <= 32'h7FC00000;
   NV  <= 1'b1;
  end else if(InfRS1 | InfRS2)
   c_o <= InfRS1 ? rs1_i : rs2_i; // In my opinion, the NX flag should be raised,
  else begin                      // but the IEEE Std 754 doesn't specify as it is.
   c_o <= FAddSub_res;
   {NV, DZ, OF, UF, NX} <= FAddSub_fflags;
 end end
 
 `ALU_OP_FMUL:
 begin
  if(RS12NaN | RS12ZInf) begin
   c_o <= 32'h7FC00000; // NaN
   NV  <= 1'b1;
  end else if(InfRS1 | InfRS2)
   c_o <= {RS12Sign, 31'h7F800000}; // Inf with proper sign.
  else begin
   c_o <= FMUL_res;
   {NV, DZ, OF, UF, NX} <= FMUL_fflags;
 end end
 
 `ALU_OP_FDIV:
 begin
  if(RS12NaN | RS12Z | RS12Inf) begin
   c_o <= 32'h7FC00000; // NaN
   NV  <= 1'b1;
  end else if(InfRS1 | InfRS2 | ZRS1 | ZRS2) begin
   c_o <= {RS12Sign, InfRS1 | ZRS2 ? 31'h7F800000 : 31'b0};
   DZ  <= ZRS2;
  end else begin
   c_o <= FDIV_res;
   {NV, DZ, OF, UF, NX} <= FDIV_fflags;
 end end
 
 default: ; //default required by Quartus II 13.1

endcase
end

endmodule