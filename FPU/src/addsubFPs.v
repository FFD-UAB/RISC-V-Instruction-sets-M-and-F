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

`include "defines.vh"

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


// Step 1: Exponent alignment
// Given that both operands may have different exponents, at the addition or subtraction 
// operation, the highest exponent is prevails, so the lowest one must modify its
// mantissa in order to elevate the exponent to match the highest exponent, taking
// into account the hidden [1.] of the FP mantissa format and the rounding bits.

wire [35:0] rs1; // aligned operands
wire [35:0] rs2; // aligned operands
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

alignFPs align(
     .a_align_i    ( rs1_i ), 
     .b_align_i    ( rs2_i ), 
     .a_aligned_o  ( rs1   ), 
     .b_aligned_o  ( rs2   )
     );


// Step 2: Operation
// The FP format doesn't play with 2'C negative numbers but uses a magnitude format
// as the mantissa and a sign bit, so in order to properly perform subtractions, it's 
// necessary to find which aligned mantissa is the biggest to perform BIG - little.
// In this way, the result is always correct in magnitude and the bit sign can be 
// obtained from the sign bit which one was bigger. This design detail can have a special 
// behaviour where in the case of both operands having the same magnitude but different 
// bit sign, the result may be +0 or -0 depending on which one is rs1_i or rs2_i. This is
// managed at the rounding step.

wire        res_s;
wire  [7:0] res_e;
wire [27:0] res_m; // 1 overflow mantissa + 1 [1.] + 23 mantissa + 3 rounding bits
wire [27:0] a_m; // a >= b between rs1 and rs2 mantissas
wire [27:0] b_m; // a >= b between rs1 and rs2 mantissas
wire        rs1mGErs2m; //rs1 mantissa greater than or equal to rs2 mantissa
wire        add1Exponent; // Increment exponent once if is overflow or [1.] depending on exponent.

assign rs1mGErs2m = rs1_m >= rs2_m;
assign a_m = {1'b0,  rs1mGErs2m ? rs1_m : rs2_m};
assign b_m = {1'b0, !rs1mGErs2m ? rs1_m : rs2_m};
assign res_m = (rs1_s == rs2_s) ? a_m + b_m  // Same sign -> add mantissas
                                : a_m - b_m; // Diff sign -> high - low mantissa
assign res_e = rs1_e; // rs1_e should be equal to rs2_e
assign res_s = rs1mGErs2m ? rs1_s : rs2_s;


// Step 3: Post-operation alignment
// Both addition or subtraction operations may have moved the '1' MSB of the mantissa,
// so it's required to perform a re-alignment and add or subtract it to the exponent.
// Also, the guard bit position of the rounding bits is updated with the OR of the 
// previous guard and sticky bits.

wire [26:0] prePostalign_m; // 1 overflow mantissa + 1 [1.] + 23 mantissa + 2 rounding bits
wire  [4:0] MSBOneBitPosition; // Highest '1' bit on the resulted mantissa.
assign prePostalign_m = {res_m[27:2], |res_m[1:0]};

HighestLeftBit28u HLB28u({1'b0, prePostalign_m}, MSBOneBitPosition);

wire        Postalign_s;
wire  [8:0] Postalign_e; // 1 overflow exponent + 8 exponent bits
wire [24:0] Postalign_m; // 23 mantissa + 2 rounding bits
wire  [7:0] shifts;
wire  [7:0] Lshifts;
wire        zeroMantissa; // Flag of 0 mantissa.
wire        notEnoughExponent; // FP value goes subnormal.

assign Postalign_s = res_s;
assign zeroMantissa = res_m == 28'b0;
assign shifts = 8'd25 - MSBOneBitPosition;
assign notEnoughExponent = shifts > res_e;
assign Lshifts = notEnoughExponent ? res_e : shifts;
assign Postalign_e = zeroMantissa ? 9'b0 : 
                     prePostalign_m[26] ? res_e + 8'b1
                                        : res_e - Lshifts + (res_e == 8'b0 & prePostalign_m[25]);
assign Postalign_m = prePostalign_m[26] ? {prePostalign_m[25:2], |prePostalign_m[1:0]}
                     : prePostalign_m << ((Postalign_e == 9'b0 & Lshifts != 8'b0) ? Lshifts - 8'b1
                                                                                    : Lshifts);


// Step 4: Rounding
// Because of the rounding modes and the absolute magnitude mantissa, there's always two possible 
// outcomes. For ease, let's first compute both of them, that includes the possibility of overflowing 
// the mantissa (adding 1 to the exponent) because of the rounding.

wire        zero0;     // Zero value flags of both possible outcomes to put correct zero sign.
wire [22:0] Round_m0;  // 23 mantissa bits   Normal output
wire [22:0] Round_m1;  // 23 mantissa bits   Output +1
wire [23:0] Round_m1t; // 1 overflow mantissa + 23 mantissa bits
wire [22:0] Round_m1tt;// 23 mantissa bits
wire  [8:0] Round_e0;  // 1 OF/UF exponent + 8 exponent bits 
wire  [8:0] Round_e1;  // 1 OF/UF exponent + 8 exponent bits
wire        subNres;   // Subnormal result (exponent = 0)
assign subNres    = !(|Postalign_e);
assign Round_m0   = Postalign_m[24:2];
assign Round_e0   = Postalign_e;
assign Round_m1t  = Postalign_m[24:2] + 2'b1;
assign Round_m1   = subNres ? Round_m1t[22:0] // At subnormal value, only push if '1' MSB is at [1.]
                            : Round_m1t[23] ? Round_m1t[22:0] : Round_m1t[23:1];
assign Round_e1   = Postalign_e + Round_m1t[23];
// Because when the hidden [1.] bit must be generated if the exponent is raised from 0 to 1 by the
// rounding, an extra left-shift must be done at the mantissa if it's the case.
//assign Round_m1  = Round_m1tt << (Round_e0 == 9'b0)&(Round_e1 == 9'b1);

// IEEE 754 indicates that when 0 result, sign is positive in all cases but RDN.
// Only checking Round_0 because Round_1 would never be 0.
assign zero0 = {Round_e0, Round_m0} == 32'b0;


// Extra assignment just for clearer code
wire last;  // Last bit mantissa before rounding
wire guard; // "guard" rounding bit
wire round; // "round" rounding bit
assign last  = Postalign_m[2];
assign guard = Postalign_m[1];
assign round = Postalign_m[0];

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
    if(&{last, guard} | &{guard, round})
    begin
      postRound_s = Postalign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : Postalign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

  `FRM_RTZ: begin // Round Towards Zero
    postRound_s = zero0 ? 1'b0 : Postalign_s;
    postRound_m = Round_m0;
    postRound_e = Round_e0;
  end

  `FRM_RDN: begin // Round DowN (towards neg infinity)
    if(Postalign_s & (guard | round))
    begin
      postRound_s = Postalign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b1 : Postalign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end
      
  `FRM_RUP: begin // Round UP (towards pos infinity)
    if(!Postalign_s & (guard | round))
    begin
      postRound_s = Postalign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : Postalign_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

 `FRM_RMM: begin // Round to Nearest, ties to Max Magnitude
    if(guard)
    begin
      postRound_s = Postalign_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : Postalign_s;
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
assign UF = (postRound_e == 9'h0) & !(|postRound_m); // subnormal value (0 exponent), but not 0.
assign NX = guard | round | OF;


// Output management
always @(*)
begin
  if(NV) begin // Quiet NaN when invalid operation
    c_s = 1'b0;
    c_e = 8'hFF;
    c_m = 23'h400000;
  end else if(OF) begin // Inf
    c_s = postRound_s;
    c_e = 8'hFF;
    c_m = 23'b0;
  end else begin 
    c_s = postRound_s;
    c_e = postRound_e[7:0];
    c_m = postRound_m;
  end
end

endmodule