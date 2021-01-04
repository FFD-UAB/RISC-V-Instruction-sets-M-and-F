// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision ADD/SUB operation module.
// The FFLAGS that this module is able to update are NV, OF, UF and NX,
// which occurs when an invalid FRM value is at the input, when the result 
// is over infinity FP value or under 0 FP value (looking at the resulting 
// exponent), and when the result is inaccurate, that may be because OF,
// UF or rounding. The only time that a NaN is put at the output is when 
// and NV flag is raised. Other special input cases (NaN, infinity) must be 
// managed at the outside of this module (like when a NaN is at the input).
// This is done because most of the logic is the same for many arithmetic 
// instructions (F.ADD, F.SUB, F.MUL, F.DIV, etc).

`include "../../../defines.vh"

module ADDSUB_FPs(rs1_i, rs2_i, SUBflag_i, frm_i, c_o, fflags_o);
// Input operands and control signals;
input wire [31:0] rs1_i;
input wire [31:0] rs2_i;
input wire        SUBflag_i; // Subtract signal operation.
input wire  [2:0] frm_i;  // Rounding mode bits from the FCSR for dynamic rounding operation.

output wire [31:0] c_o;
reg                c_s;  // Output sign bit.
reg          [7:0] c_e;  // Output exponent byte.
reg         [22:0] c_m;  // Output mantissa bits.
assign c_o = {c_s, c_e, c_m};

output wire  [4:0] fflags_o; // Exception flags.
wire               NV, DZ, OF, UF, NX; // iNValid operation, Divide by Zero, OverFlow,
assign fflags_o = {NV, DZ, OF, UF, NX};// UnderFlow, iNeXact.

// Floating Rounding Mode bits
/*  FRM_RNE = 3'b000; // Round to Nearest, ties to Even
  FRM_RTZ = 3'b001; // Rounds towards Zero
  FRM_RDN = 3'b010; // Rounds Down (towards -inf)
  FRM_RUP = 3'b011; // Rounds Up (towards +inf)
  FRM_RMM = 3'b100; // Round to Nearest, ties to Max Magnitude */


// Step 1: Exponent allignment
// Given that both operands may have different exponents, at the addition or subtraction 
// operation, the highest exponent is prevails, so the lowest one must modify its
// mantissa in order to elevate the exponent to match the highest exponent, taking
// into account the hidden [1.] of the FP mantissa format and the rounding bits.

wire [35:0] rs1; // Alligned operands
wire [35:0] rs2; // Alligned operands
wire        rs1_s; // 1 sign bit
wire  [7:0] rs1_e; // 8 esponent bits
wire [26:0] rs1_m; // 1 [1.], 23 mantissa + 3 rounding bits
wire        rs2_s; // 1 sign bit
wire  [7:0] rs2_e; // 8 esponent bits
wire [26:0] rs2_m; // 1 [1.], 23 mantissa + 3 rounding bits
assign rs1_s = rs1[35];
assign rs1_e = rs1[34:27];
assign rs1_m = rs1[26:0];
assign rs2_s = rs2[35]^SUBflag_i; // FP doesn't use 2'C for negatives
assign rs2_e = rs2[34:27];
assign rs2_m = rs2[26:0];

allignFPs allign(
     .a_allign_i    ( rs1_i ), 
     .b_allign_i    ( rs2_i ), 
     .a_alligned_o  ( rs1   ), 
     .b_alligned_o  ( rs2   )
     );


// Step 2: Operation
// The FP format doesn't play with 2'C negative numbers but uses a magnitude format
// as the mantissa and a sign bit, so in order to properly perform subtractions, it's 
// necessary to find which alligned mantissa is the biggest to perform BIG - little.
// In this way, the result is always correct in magnitude and the bit sign can be 
// obtained from the sign bit which one was bigger. This design detail can have a special 
// behaviour where in the case of both operands having the same magnitude but different 
// bit sign, the result may be +0 or -0 depending on which one is rs1_i or rs2_i. In the 
// absence of specific information about how the FPU should react in this situation, it has 
// been left to always get the rs1 bit sign for this specific case.

wire        res_s;
wire  [7:0] res_e;
wire [27:0] res_m; // 1 overflow mantissa + 1 [1.] + 23 mantissa + 3 rounding bits
wire [27:0] a_m; // a >= b between rs1 and rs2 mantissas
wire [27:0] b_m; // a >= b between rs1 and rs2 mantissas
wire        rs1mGErs2m; //rs1 mantissa greater than or equal to rs2 mantissa
wire        add1Exponent; // Increment exponent once if is overflow or [1.] depending on exponent.

assign rs1mGTrs2m = rs1_m >= rs2_m;
assign a_m = {1'b0,  rs1mGTrs2m ? rs1_m : rs2_m};
assign b_m = {1'b0, !rs1mGTrs2m ? rs1_m : rs2_m};
assign res_m = (rs1_s == rs2_s) ? a_m + b_m  // Same sign -> add mantissas
                                : a_m - b_m; // Diff sign -> high - low mantissa
assign add1Exponent = (rs1_e == 8'b0 ? res_m[26] : res_m[27]);
assign res_e = rs1_e + add1Exponent; // rs1_e should be equal to rs2_e
assign res_s = rs1mGTrs2m ? rs1_s : rs2_s;


// Step 3: Post-operation allignment
// Both addition or subtraction operations may have moved the '1' MSB of the mantissa,
// so it's required to perform a re-allignment and add or subtract it to the exponent.
// Also, the guard bit position of the rounding bits is updated with the OR of the 
// previous guard and sticky bits.

wire [26:0] prePostAllign_m; // 1 overflow mantissa + 1 [1.] + 23 mantissa + 2 rounding bits
wire  [4:0] MSBOneBitPosition; // Highest '1' bit on the resulted mantissa.
assign prePostAllign_m = {res_m[27:2], |res_m[1:0]};

HighestLeftBit28u HLB28u({1'b0, prePostAllign_m}, MSBOneBitPosition);

wire  [8:0] PostAllign_e; // 1 overflow exponent + 8 exponent bits
wire        PostAllign_s;
wire  [8:0] shifts;
wire        zeroMantissa; // Flag of 0 mantissa.
assign zeroMantissa = res_m == 28'b0;
assign shifts = add1Exponent | res_e == 8'b0 ? 9'b0
                                             : MSBOneBitPosition - 9'd25;
assign PostAllign_e = zeroMantissa ? 9'b0 : res_e + shifts;
assign PostAllign_s = res_s;

// In the case where the exponent = 0, the hidden [1.] is not existent, so if the addition
// rises the exponent, an extra left-shift must be performed at the mantissa to implement 
// the [1.] bit onwards. The contrary should occur if the exponent was 1 and now is 0 because
// of a subtraction operation.

wire [24:0] PostAllign_m;    // 23 mantissa + 2 rounding bits
assign PostAllign_m = (add1Exponent & !(rs1_e == 8'b0) ? prePostAllign_m[25:1] 
                                    : prePostAllign_m) << shifts;


// Step 4: Rounding
// Because of the rounding modes and the absolute magnitude mantissa, there's always two possible 
// outcomes. For ease, let's first compute both of them, that includes the possibility of overflowing 
// the mantissa (adding 1 to the exponent) because of the rounding.

wire        zero0;     // Zero value flags of both possible outcomes.
wire        zero1;
wire [22:0] Round_m0;  // 23 mantissa bits   Normal output
wire [22:0] Round_m1;  // 23 mantissa bits   Output +1
wire [23:0] Round_m1t; // 1 overflow mantissa + 23 mantissa bits
wire [22:0] Round_m1tt;// 23 mantissa bits
wire  [8:0] Round_e0;  // 1 OF/UF exponent + 8 exponent bits 
wire  [8:0] Round_e1;  // 1 OF/UF exponent + 8 exponent bits
assign Round_m0   = PostAllign_m[24:2];
assign Round_e0   = PostAllign_e;
assign Round_m1t  = {1'b0, PostAllign_m[24:2]} + 2'b1;
assign Round_m1tt = Round_m1t[23] ? Round_m1t[23:1] : Round_m1t[22:0];
assign Round_e1   = PostAllign_e + {1'b0, Round_m1t[23]};
// Because when the hidden [1.] bit must be generated if the exponent is raised from 0 to 1 by the
// rounding, an extra left-shift must be done at the mantissa if it's the case.
assign Round_m1  = Round_m1tt << (Round_e0 == 9'b0)&(Round_e1 == 9'b1);
assign zero0 = {Round_e0, Round_m0} == 31'b0;
assign zero1 = {Round_e1, Round_m1} == 31'b0;


// Extra assignment just for clearer code
wire last;  // Last bit mantissa before rounding
wire guard; // "guard" rounding bit
wire round; // "round" rounding bit
assign last  = PostAllign_m[2];
assign guard = PostAllign_m[1];
assign round = PostAllign_m[0];

reg        postRound_s;
reg  [8:0] postRound_e;
reg [22:0] postRound_m;

always @(*)
begin
 postRound_s = 1'b0;
 postRound_e = 9'hF;
 postRound_m = 23'h400000;

case(frm_i)
 `FRM_RNE: begin // Round to Nearest, ties to Even
    if(|{last & guard, guard & round})
    begin
      postRound_s = zero1 ? 1'b0 : PostAllign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : PostAllign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

  `FRM_RTZ: begin // Round Towards Zero
    postRound_s = zero0 ? 1'b0 : PostAllign_s;
    postRound_m = Round_m0;
    postRound_e = Round_e0;
  end

  `FRM_RDN: begin // Round DowN (towards neg infinity)
    if(PostAllign_s & (guard | round))
    begin
      postRound_s = PostAllign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b1 : PostAllign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end
      
  `FRM_RUP: begin // Round UP (towards pos infinity)
    if(!PostAllign_s & (guard | round))
    begin
      postRound_s = PostAllign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : PostAllign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

 `FRM_RMM: begin // Round to Nearest, ties to Max Magnitude
    if(guard)
    begin
      postRound_s = zero1 ? 1'b0 : PostAllign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : PostAllign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

endcase
end


// FFLAGS management
assign NV = frm_i == 3'b101 | frm_i == 3'b110 | frm_i == 3'b111;
assign DZ = 1'b0;
assign OF = postRound_e == 9'h0FF | postRound_e == 9'h100;
assign UF = postRound_e == 9'h1FF;
assign NX = guard | round | OF | UF;


// Output management
always @(*)
begin
  if(NV) begin // Quiet NaN when invalid operation
    c_s = 1'b0;
    c_e = 8'hFF;
    c_m = 23'h400000;
  end else if(OF | UF) begin 
    c_s = postRound_s;
    c_e = OF ? 8'hFF : 8'b0;
    c_m = 23'b0;
  end else begin 
    c_s = postRound_s;
    c_e = postRound_e[7:0];
    c_m = postRound_m;
  end
end

endmodule