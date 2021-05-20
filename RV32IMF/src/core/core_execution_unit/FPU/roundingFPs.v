// Telecommunications Master Dissertation - Francis Fuentes 14-05-2021
//
// Rounding module for single-precision floating-point operands.

`include "../../../defines.vh"

module roundingFPs(clk, rst_n, busy, preRound, frm_i, c_o, fflags_o);
input wire         clk;
input wire         rst_n;
input wire         busy;
input wire  [34:0] preRound;
input wire   [2:0] frm_i;       // rounding mode

output wire [31:0] c_o;         // 1 sign + 8 exponent + 27 mantissa bits
output wire  [4:0] fflags_o;    // 5 bits NV, DZ, OV, UF, NX

// Floating Rounding Mode bits
/*  FRM_RNE = 3'b000; // Round to Nearest, ties to Even
  FRM_RTZ = 3'b001; // Rounds towards Zero
  FRM_RDN = 3'b010; // Rounds Down (towards -inf)
  FRM_RUP = 3'b011; // Rounds Up (towards +inf)
  FRM_RMM = 3'b100; // Round to Nearest, ties to Max Magnitude */

reg  [34:0] registeredInput;

always@(posedge clk or negedge rst_n)
 if(!rst_n) registeredInput = 35'h0;
 else if(busy) registeredInput = preRound;

wire         preRound_s;
wire   [8:0] preRound_e; // 1 overflow exponent + 8 exponent bits
wire  [24:0] preRound_m; // 23 mantissa + 2 rounding bits

assign preRound_s = registeredInput[34];
assign preRound_e = registeredInput[33:25];
assign preRound_m = registeredInput[24:0];

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
wire        subNin;   // Subnormal rounding input (exponent = 0)
assign subNin     = !(|preRound_e);
assign Round_m0   = preRound_m[24:2];
assign Round_e0   = preRound_e;
assign Round_m1t  = preRound_m[24:2] + 2'b1;
// Because when the hidden [1.] bit must be generated if the exponent is raised from 0 to 1 by the
// rounding, an extra left-shift must be done at the mantissa if it's the case.
assign Round_m1   = subNin ? Round_m1t[22:0] // At subnormal value, only push if '1' MSB is at [1.]
                           : Round_m1t[23] ? Round_m1t[22:0] : Round_m1t[23:1];
assign Round_e1   = preRound_e + Round_m1t[23];

// IEEE 754 indicates that when 0 result, sign is positive in all cases but RDN rm.
// Only checking Round_0 because Round_1 would never be 0.
assign zero0 = {Round_e0, Round_m0} == 32'b0;


// Extra assignment just for clearer code
wire last;  // Last bit mantissa before rounding
wire guard; // "guard" rounding bit
wire round; // "round" rounding bit
assign last  = preRound_m[2];
assign guard = preRound_m[1];
assign round = preRound_m[0];

reg        postRound_s;
reg  [8:0] postRound_e;
reg [22:0] postRound_m;
reg        c_s;
reg  [7:0] c_e;
reg [22:0] c_m;

always @(*)
begin
 postRound_s = 1'b0;
 postRound_e = 9'hFF;
 postRound_m = 23'h400000;

case(frm_i)
 `FRM_RNE: begin // Round to Nearest, ties to Even
    if(&{last, guard} | &{guard, round})
    begin
      postRound_s = preRound_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : preRound_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

  `FRM_RTZ: begin // Round Towards Zero
    postRound_s = zero0 ? 1'b0 : preRound_s;
    postRound_m = Round_m0;
    postRound_e = Round_e0;
  end

  `FRM_RDN: begin // Round DowN (towards neg infinity)
    if(preRound_s & (guard | round))
    begin
      postRound_s = preRound_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b1 : preRound_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end
      
  `FRM_RUP: begin // Round UP (towards pos infinity)
    if(!preRound_s & (guard | round))
    begin
      postRound_s = preRound_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : preRound_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

 `FRM_RMM: begin // Round to Nearest, ties to Max Magnitude
    if(guard)
    begin
      postRound_s = preRound_s;
      postRound_m = Round_m1;
      postRound_e = Round_e1;
    end else begin
      postRound_s = zero0 ? 1'b0 : preRound_s;
      postRound_m = Round_m0;
      postRound_e = Round_e0;
    end
  end

  default: ; //default required by Quartus II 13.1

endcase
end


// FFLAGS management. iNValid, Div by Zero, OverFlow, UnderFlow, iNeXact.
wire NV, DZ, OF, UF, NX;

assign NV = frm_i == 3'b101 | frm_i == 3'b110 | frm_i == 3'b111; // Invalid rounding modes
assign DZ = 1'b0;
assign OF = postRound_e >= 9'h0FF;
assign UF = (postRound_e == 9'h0) & NX; // subnormal value (0 exponent) and inexact (lower than representable)
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

assign c_o = {c_s, c_e, c_m};
assign fflags_o = {NV, DZ, OF, UF, NX};

endmodule