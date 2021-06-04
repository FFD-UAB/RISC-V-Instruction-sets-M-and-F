// Telecommunications Master Dissertation - Francis Fuentes 22-05-2021
// Floating Point 32-bit single precision MUL operation module.

`include "../../../defines.vh"

module MUL_FPs(clk, rst_n, busy_i, rs1_i, rs2_i, c_o);
// Input operands and control signals;
input  wire        clk;
input  wire        rst_n;
input  wire        busy_i;
input  wire [31:0] rs1_i;
input  wire [31:0] rs2_i;

output wire [34:0] c_o;


// Step 1: Mantissa multiplication. (First clock cycle)
reg  [47:0] mul_m;   // F * F = E1 -> 24 bits * 24 bits operands = 48 bit operand (XX.XXX...)

always@(posedge clk or negedge rst_n)
 if(!rst_n) mul_m = 48'b0;
 else if(busy_i) mul_m = {|rs1_i[30:23], rs1_i[22:0]} * {|rs2_i[30:23], rs2_i[22:0]};



// Step 2: Exponent addition. (First clock cycle)
reg   [9:0] mul_e; // 1 exponent underflow + 1 exponent overflow + 8 exponent bits

always@(posedge clk or negedge rst_n)
 if(!rst_n) mul_e = 10'h0;
 else if(busy_i) mul_e = rs1_i[30:23] + rs2_i[30:23] - 10'h7F; // -127 because single precision exponent bias.



// Step 3: Exponent update with product mantissa bit position. (Second clock cycle)
wire signed [9:0] u_e;    // 1 exponent underflow + 1 exponent overflow + 8 exponent bits
wire        [5:0] bitP;   // Leftmost high bit position of the product mantissa (unsigned)
wire              lowerUF;// Flag indicating a negative exponent which shift can only result on underflow.
wire       [46:0] u_m;    // 47 mantissa bits (.XXX...)

HighestLeftBit48u HLB48u (mul_m, bitP);

assign u_e = mul_e + bitP - 10'd46;
assign lowerUF = u_e < -46;

assign u_m = mul_m[47] ?  mul_m[46:0] // If exponent is negative, shift a modulus exponent value. Otherwise, shift just the
                       : {mul_m[45:0], 1'b0} << (u_e[9] ? -u_e : 6'd46 - bitP); // necessary to set the proper format (.XXX...).



// Step 4: Mantissa update through shifting and final exponent update. (Second clock cycle)
wire        c_s;   // 1 sign bit
wire  [8:0] c_e;   // 1 exponent overflow + 8 exponent bits
wire [24:0] c_m;   // 23 mantissa + 2 rounding bits
wire        zeroM; // zero mantissa flag -> zero result.

assign zeroM = ~|mul_m;
// Exponent is zero if the result is zero or the exponent is negative but manageable by shifting the mantissa.
assign c_e = |{zeroM, u_e[9]} ? 9'b0
                              : u_e[8:0];
assign c_m = zeroM ? 25'b0
                   : {u_m[46:23], |u_m[22:0]};

assign c_s = rs1_i[31] ^ rs2_i[31]; // Keep computing sign even if it's zero, to preserve correct sign in case where the +1 rounding output is selected.

// In tase of total UF, hijack the output to send a 0 result with high rounding bits, which will make the rounding block to signal UF on the next clock cycle.
assign c_o = lowerUF ? {c_s, 9'b0, 25'b1}
                     : {c_s, c_e, c_m};

endmodule