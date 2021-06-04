// Telecommunications Master Dissertation - Francis Fuentes 14-05-2021
//
// Rounding module for single-precision floating-point operands.
//
// This module is capable of generating the various floating-point flags, while also 
// output the proper result. That's the reason of the rather strange "preRound" input format.
// The limits of this module input value is that it must fall between zero and a 510 exponent 
// bit overflow. Underflows must be managed previously to the input of this module with the proper 
// value, wheter is zero or a little value (also called denormalized values).
//
// It takes a clock cycle to execute the rounding magic, and the register is at the input, 
// so it can be provided from anywhere on any latency load, but caution on concatenating this
// module with anything else at the output.

`include "../../../defines.vh"

module roundingFPs(clk, rst_n, busy_i, preRound, frm_i, c_o, fflags_o);
input wire         clk;
input wire         rst_n;
input wire         busy_i;
input wire  [34:0] preRound;    // 1 sign + 1 OF exponent + 8 exponent + 23 mantissa + 2 rounding bits
input wire   [2:0] frm_i;       // rounding mode

output wire [31:0] c_o;         // 1 sign + 8 exponent + 27 mantissa bits
output wire  [4:0] fflags_o;    // 5 bits NV, DZ, OV, UF, NX


reg  [34:0] registeredInput;

always@(posedge clk or negedge rst_n)
 if(!rst_n) registeredInput = 35'h0;
 else if(busy_i) registeredInput = preRound;

wire         preRound_s;
wire   [8:0] preRound_e; // 1 overflow exponent + 8 exponent bits
wire  [24:0] preRound_m; // 23 mantissa + 2 rounding bits

assign preRound_s = registeredInput[34];
assign preRound_e = registeredInput[33:25];
assign preRound_m = registeredInput[24:0];

// Step 1: Possible rounding outputs.
// Because of the rounding modes and the absolute magnitude mantissa, there's always two possible 
// outcomes. For ease, let's first compute both of them, that includes the possibility of overflowing 
// the mantissa (adding 1 to the exponent) because of the rounding.

wire [22:0] Round_m0;  // 23 mantissa bits                                       Normal output
wire [22:0] Round_m1;  // 23 mantissa bits                                       Output +1
wire [24:0] Round_m1t; // 1 overflow mantissa + [1.] + 23 mantissa bits          Output +1
wire  [8:0] Round_e0;  // 1 OF exponent + 8 exponent bits                        Normal output
wire  [8:0] Round_e1;  // 1 OF exponent + 8 exponent bits                        Output +1
wire        nzeroExp;  // '0' when 0 exponent.

assign Round_m0   = preRound_m[24:2];
assign Round_e0   = preRound_e;
assign nzeroExp   = |preRound_e;

assign Round_m1t  = {nzeroExp, preRound_m[24:2]} + 2'b1;

assign Round_m1   = Round_m1t[24] ? Round_m1t[23:1] : Round_m1t[22:0];
assign Round_e1   = preRound_e + (Round_m1t[24] | (Round_m1t[23] & !nzeroExp));



// IEEE 754 indicates that when 0 result, sign is positive in all cases but RDN rm.
// Only checking on normal outcome because +1 output will never be 0.
wire   zero0;     // Zero value flag to set correct zero sign for normal outcome.

assign zero0 = !(|{nzeroExp, Round_m0});


// Step 2: Output selection depending on the rounding mode input and rounding bits.
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
// Default output value qNaN.
 postRound_s = 1'b0;
 postRound_e = 9'hFF;
 postRound_m = 23'h400000;

/* Floating Rounding Mode bits
  FRM_RNE = 3'b000; // Round to Nearest, ties to Even
  FRM_RTZ = 3'b001; // Rounds towards Zero
  FRM_RDN = 3'b010; // Rounds Down (towards -inf)
  FRM_RUP = 3'b011; // Rounds Up (towards +inf)
  FRM_RMM = 3'b100; // Round to Nearest, ties to Max Magnitude */

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


// Step 3: FFLAGS and output management. iNValid, Div by Zero, OverFlow, UnderFlow, iNeXact.
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