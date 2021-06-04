// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision ADD/SUB operation module.

`include "../../../defines.vh"

module ADDSUB_FPs(clk, rst_n, busy_i, rs1_i, rs2_i, SUBflag_i, c_o);
// Input operands and control signals;
input wire         clk;
input wire         rst_n;
input wire         busy_i;
input wire  [31:0] rs1_i;
input wire  [31:0] rs2_i;
input wire         SUBflag_i; // Subtract signal operation.

output wire [34:0] c_o;


// Step 1: Exponent alignment
// Given that both operands may have different exponents, at the addition or subtraction 
// operation the highest exponent prevails, so the lowest one must modify its
// mantissa in order to elevate the exponent to match the highest exponent, taking
// into account the hidden [1.] of the FP mantissa format and the rounding bits.

wire [35:0] rs1_align, rs2_align;       // aligned operands
wire        rs1_s, rs2_s; // 1 sign bit
wire  [7:0] rs1_e, rs2_e; // 8 esponent bits
wire [26:0] rs1_m, rs2_m; // 1 [1.], 23 mantissa + 3 rounding bits

alignFPs align(
     .a_align_i    ( rs1_i     ), 
     .b_align_i    ( rs2_i     ), 
     .a_aligned_o  ( rs1_align ), 
     .b_aligned_o  ( rs2_align )
     );

assign rs1_s = rs1_align[35];
assign rs1_e = rs1_align[34:27];
assign rs1_m = rs1_align[26:0];
assign rs2_s = rs2_align[35]^SUBflag_i; // FP doesn't use 2'C for negatives
assign rs2_e = rs2_align[34:27];
assign rs2_m = rs2_align[26:0];


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

  // Output of the step 2 registered to increase frequency of operation.
reg  [36:0] rsO_Reg; // 1 sign + 8 exponent + 1 overflow mantissa + 1 [1.] + 23 mantissa + 3 rounding bits

always@(posedge clk or negedge rst_n)
 if(!rst_n) rsO_Reg = 37'h0;
 else rsO_Reg = {res_s, res_e, res_m};


// Step 3: Post-operation alignment
// Both addition or subtraction operations may have moved the '1' MSB of the mantissa,
// so it's required to perform a re-alignment and add or subtract it to the exponent.
// Also, the guard bit position of the rounding bits is updated with the OR of the 
// previous guard and sticky bits.

wire [26:0] prePostalign_m; // 1 overflow mantissa + 1 [1.] + 23 mantissa + 2 rounding bits
wire  [4:0] MSBOneBitPosition; // Highest '1' bit on the resulted mantissa.
assign prePostalign_m = {rsO_Reg[27:2], |rsO_Reg[1:0]};

HighestLeftBit28u HLB28u({1'b0, prePostalign_m}, MSBOneBitPosition);

wire        Postalign_s;
wire  [8:0] Postalign_e; // 1 overflow exponent + 8 exponent bits
wire [24:0] Postalign_m; // 23 mantissa + 2 rounding bits
wire  [7:0] shifts;
wire  [7:0] Lshifts;
wire        zeroMantissa; // Flag of 0 mantissa.
wire        notEnoughExponent; // FP value goes subnormal.

assign Postalign_s = rsO_Reg[36];
assign zeroMantissa = rsO_Reg[27:0] == 28'b0;
assign shifts = 8'd25 - MSBOneBitPosition;
assign notEnoughExponent = shifts > rsO_Reg[35:28];
assign Lshifts = notEnoughExponent ? rsO_Reg[35:28] : shifts;
assign Postalign_e = zeroMantissa ? 9'b0 : 
                     prePostalign_m[26] ? rsO_Reg[35:28] + 8'b1
                                        : rsO_Reg[35:28] - Lshifts + (rsO_Reg[35:28] == 8'b0 & prePostalign_m[25]);
assign Postalign_m = prePostalign_m[26] ? {prePostalign_m[25:2], |prePostalign_m[1:0]}
                     : prePostalign_m[24:0] << ((Postalign_e == 9'b0 & Lshifts != 8'b0) ? Lshifts - 8'b1
                                                                                        : Lshifts);

assign c_o = {Postalign_s, Postalign_e, Postalign_m}; // 1 + 9 + 25 bits

endmodule