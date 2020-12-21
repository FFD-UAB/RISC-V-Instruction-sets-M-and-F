// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision two operands allignment module.
// This module has two 32-bit FP input operands which alligns them by the 
// highest exponent of both operands, providing also the [1.] bit of the mantissa
// and three rounding bits (guard, round, sticky).

module allignFPs(a_allign_i, b_allign_i, a_alligned_o, b_alligned_o);
// Input operands (1 sign, 8 exponent, 23 mantissa)
input wire [31:0] a_allign_i;
input wire [31:0] b_allign_i;

wire        a_allign_s;
wire  [7:0] a_allign_e;
wire [22:0] a_allign_m;
wire        b_allign_s;
wire  [7:0] b_allign_e;
wire [22:0] b_allign_m;

assign a_allign_s = a_allign_i[31];
assign a_allign_e = a_allign_i[30:23];
assign a_allign_m = a_allign_i[22:0];
assign b_allign_s = b_allign_i[31];
assign b_allign_e = b_allign_i[30:23];
assign b_allign_m = b_allign_i[22:0];

// Output operands (1 sign, 8 exponent, 1 [1.], 23 mantissa, 3 rounding)
output wire [35:0] a_alligned_o;
output wire [35:0] b_alligned_o;

wire  [7:0] a_alligned_e;
wire [26:0] a_alligned_m;
wire  [7:0] b_alligned_e;
wire [26:0] b_alligned_m;

assign a_alligned_o = {a_allign_s, a_alligned_e, a_alligned_m};
assign b_alligned_o = {b_allign_s, b_alligned_e, b_alligned_m};


wire  [8:0] shift;        // Signed number of shifts to perform a respect b.
wire  [7:0] shift_val;    // Unsigned number of shifts.
wire [49:0] val_shifted;  // 1+23+3+23
wire [26:0] val_alligned; // [1.] +23 mantissa shifted +3 rounding bits (guard, round, sticky)
wire        val_denormBit;// When exp = 0, there is not [1.] hidden bit.
wire        val_denormBit2;

assign shift = a_allign_e - {1'b0, b_allign_e};
assign shift_val = shift[8] ? (~shift[7:0] + 2'b1) : shift[7:0];
assign val_denormBit  = ( shift[8] ? a_allign_e : b_allign_e) != 8'b0;
assign val_denormBit2 = (!shift[8] ? a_allign_e : b_allign_e) != 8'b0;
assign val_shifted = {val_denormBit, (shift[8] ? a_allign_m : b_allign_m), 26'b0} >> shift_val;
assign val_alligned = {val_shifted[49:24], (shift_val > 8'd25) | (|val_shifted[23:1])};


assign a_alligned_e = shift[8] ? b_allign_e : a_allign_e;
assign b_alligned_e = shift[8] ? b_allign_e : a_allign_e;
assign a_alligned_m = shift[8] ? val_alligned : {val_denormBit2, a_allign_m, 3'b0};
assign b_alligned_m = shift[8] ? {val_denormBit2, b_allign_m, 3'b0} : val_alligned;

endmodule