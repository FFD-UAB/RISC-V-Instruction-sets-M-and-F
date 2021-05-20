// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision ALU able to implement the FADD/FSUB, 
// FMUL/FDIV, FSQRT and FMIN-MAX operations. It also includes the ability of 
// performing floating-point fused multiply-add instructions F[N]MADD/F[N]MSUB
// when using a R4-type instruction format. (WIP, only FADD/FSUB implemented)

`include "../../defines.vh"

module FPU_S(rs1_i, rs2_i, rs3_i, ALUop_i, frm_i, start_i, clk, rst_n, c_o, fflags_o, busy_o);
// Input operands and control signals;
input wire [31:0] rs1_i;
input wire [31:0] rs2_i;
input wire [31:0] rs3_i;

input wire  [5:0] ALUop_i; // Operation selector.
input wire  [2:0] frm_i;    // Rounding mode bits from the FCSR or instruction.
input wire        start_i;
input wire        clk;
input wire        rst_n;

output reg  [31:0] c_o;
output wire  [4:0] fflags_o; // Exception flags.
output reg         busy_o;   // Multi-cycle operation on-going flag.
reg                NV, DZ, OF, UF, NX; // iNValid operation, Divide by Zero, OverFlow,
assign fflags_o = {NV, DZ, OF, UF, NX};// UnderFlow, iNeXact.

reg   [3:0] counter; // multi-cycle operation counter.
wire        local_busy;
reg         busyADDSUB;
reg         busyRound;
wire [34:0] FAddSub_res;
wire [34:0] FMUL_res;
wire [34:0] FDIV_res;
wire  [4:0] FMUL_fflags;
wire  [4:0] FDIV_fflags;
reg  [34:0] preRound;  // 1 sign + 9 exp (1+8) + 25 mantissa (23+2)
wire [31:0] round_res; // 1 sign + 8 exp + 23 mantissa
wire  [4:0] round_flags;


ADDSUB_FPs ADDSUBs(
         .clk       ( clk            ),
         .rst_n     ( rst_n          ),
         .busy      ( busyADDSUB     ),
         .rs1_i     ( rs1_i          ), 
         .rs2_i     ( rs2_i          ),
         .SUBflag_i ( ALUop_i[0]     ), 
         .c_o       ( FAddSub_res    )
         );

roundingFPs roundFP(
         .clk        ( clk           ),
         .rst_n      ( rst_n         ),
         .busy       ( busyRound     ),
         .preRound   ( preRound      ),
         .frm_i      ( frm_i         ),
         .c_o        ( round_res     ),
         .fflags_o   ( round_flags   )
         );

// For future implementation
assign FMUL_res = 32'b0;
assign FDIV_res = 32'b0;
assign FMUL_fflags = 5'b0;
assign FDIV_fflags = 5'b0;


// Input wires. RS2 not used on FSQRT operation (must be 0). RS3 only used when R4-type instr (0 otherwise).
wire              rs1_s, rs2_s, rs3_s;  // sign bit.
wire        [7:0] rs1_e, rs2_e, rs3_e;  // exponent byte.
wire       [22:0] rs1_m, rs2_m, rs3_m;  // mantissa bits.

assign rs1_s = rs1_i[31];
assign rs1_e = rs1_i[30:23];
assign rs1_m = rs1_i[22:0];
assign rs2_s = rs2_i[31];
assign rs2_e = rs2_i[30:23];
assign rs2_m = rs2_i[22:0];
assign rs3_s = rs3_i[31];
assign rs3_e = rs3_i[30:23];
assign rs3_m = rs3_i[22:0];


// Special input cases flags
wire ZRS1, ZRS2, ZRS3;            // Zero RS1, RS2, RS3
wire NaNRS1, NaNRS2, NaNRS3;      // NaN RS1, RS2, RS3
wire InfRS1, InfRS2, InfRS3;      // Infinity RS1, RS2, RS3
wire FFexpRS1, FFexpRS2, FFexpRS3;
wire anythingMRS1, anythingMRS2, anythingMRS3;

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
assign RS12PNInf = InfRS1 & InfRS2 & (rs1_s != (rs2_s^ALUop_i[0])); // Fixed for ADD/SUB op.
assign RS12ZInf  = (ZRS1 & InfRS2) | (ZRS2 & InfRS1);
assign RS12Z     = ZRS1 & ZRS2;
assign RS12Inf   = InfRS1 & InfRS2;
assign RS12Sign  = rs1_s ^ rs2_s;


// Operation selector.
always @(*) begin
c_o = 32'b0;
preRound = 35'b0;
{NV, DZ, OF, UF, NX} = 5'b0;
{busy_o, busyRound, busyADDSUB} = 3'b0;

case(ALUop_i)
 `ALU_OP_FADD, `ALU_OP_FSUB:
 begin
  if(RS12NaN | RS12PNInf) begin // Check NaN input or inf-inf
   c_o = 32'h7FC00000; // qNaN
   NV  = 1'b1;
  end else if(InfRS1 | InfRS2) // Check inf input
   c_o = InfRS1 ? rs1_i : {rs2_s^ALUop_i[0], rs2_i[30:0]};
  else begin
   preRound = FAddSub_res;
   c_o = round_res;
   {NV, DZ, OF, UF, NX} = round_flags;
   {busy_o, busyRound, busyADDSUB} = {3{local_busy}};
 end end
 
 `ALU_OP_FMUL:
 begin
  if(RS12NaN | RS12ZInf) begin
   c_o = 32'h7FC00000; // qNaN
   NV  = 1'b1;
  end else if(InfRS1 | InfRS2)
   c_o = {RS12Sign, 31'h7F800000}; // Inf with proper sign.
  else begin
   preRound = FMUL_res;
   c_o = round_res;
   {NV, DZ, OF, UF, NX} = FMUL_fflags;
 end end
 
 `ALU_OP_FDIV:
 begin
  if(RS12NaN | RS12Z | RS12Inf) begin // Check NaN input, 0 by 0 or both inf inputs
   c_o = 32'h7FC00000; // qNaN
   NV  = 1'b1;
  end else if(InfRS1 | InfRS2 | ZRS1 | ZRS2) begin // Check inf and zero inputs
   c_o = {RS12Sign, InfRS1 | ZRS2 ? 31'h7F800000 : 31'b0}; // inf/x = x/0 = inf
   DZ  = ZRS2;                                             // 0/x = x/inf = 0
  end else begin
   preRound = FDIV_res;
   c_o = round_res;
   {NV, DZ, OF, UF, NX} = FDIV_fflags;
 end end
 
 default: ; //default required by Quartus II 13.1

endcase
end

// Multi-cycle staller. Sets an initial counter value depending on the operation and decreases it every clock cycle.
// To operate in single-cycle mode, do not set a "busy_o = local_busy" on the OP above. For 2 cycle OP, set it but put "counter =  0".
// For higher cycle OP, set a initial counter value of X-2. For example, ADD/SUB OP takes 3 cc, then the counter is initial. with 1.
always@(posedge clk or negedge rst_n)
      if(!rst_n)   counter = 0;
 else if(|counter) counter = counter - 2'b1;
 else if(start_i)  case(ALUop_i)
 `ALU_OP_FADD, `ALU_OP_FSUB: counter = 1; // Total = 3 cc (ALLIGN + ADD/SUB + ROUND).
 default: counter = 0;
 endcase

assign local_busy = (|counter) | start_i;

endmodule