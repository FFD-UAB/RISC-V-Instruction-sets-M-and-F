// Telecommunications Master Dissertation - Francis Fuentes 19-11-2020
// Floating Point 32-bit single precision two operands alignment module.
// This module has two 32-bit FP input operands which aligns them by the 
// highest exponent of both operands, providing also the [1.] bit of the mantissa
// and three rounding bits (guard, round, sticky).

module alignFPs(a_align_i, b_align_i, a_aligned_o, b_aligned_o);
// Input operands (1 sign, 8 exponent, 23 mantissa)
input wire [31:0] a_align_i;
input wire [31:0] b_align_i;

wire        a_align_s;
wire  [7:0] a_align_e;
wire [22:0] a_align_m;
wire        b_align_s;
wire  [7:0] b_align_e;
wire [22:0] b_align_m;

assign a_align_s = a_align_i[31];
assign a_align_e = a_align_i[30:23];
assign a_align_m = a_align_i[22:0];
assign b_align_s = b_align_i[31];
assign b_align_e = b_align_i[30:23];
assign b_align_m = b_align_i[22:0];

// Output operands (1 sign, 8 exponent, 1 [1.], 23 mantissa, 3 rounding)
output wire [35:0] a_aligned_o;
output wire [35:0] b_aligned_o;

wire  [7:0] a_aligned_e;
wire [26:0] a_aligned_m;
wire  [7:0] b_aligned_e;
wire [26:0] b_aligned_m;

assign a_aligned_o = {a_align_s, a_aligned_e, a_aligned_m};
assign b_aligned_o = {b_align_s, b_aligned_e, b_aligned_m};


wire  [8:0] shift;        // Signed number of shifts to perform a respect b.
wire  [7:0] shift_val;    // Unsigned number of shifts.
wire  [7:0] leftShifts;   // Unsigned number of shifts with the subnormal correction.
wire [49:0] val_shifted;  // 1+23+3+23
wire [26:0] val_aligned;  // [1.] +23 mantissa shifted +3 rounding bits (guard, round, sticky)
wire        val_denormBit;// When exp = 0, there is not [1.] hidden bit.
wire        val_denormBit2;
wire        lowerSub;     // The lower operand (low exp) is a subnormal value.

assign shift = a_align_e - {1'b0, b_align_e};
assign shift_val = shift[8] ? (~shift[7:0] + 2'b1) : shift[7:0];
assign val_denormBit  = ( shift[8] ? a_align_e : b_align_e) != 8'b0;
assign val_denormBit2 = (!shift[8] ? a_align_e : b_align_e) != 8'b0;
assign lowerSub = !val_denormBit | !val_denormBit2;
assign leftShifts = shift_val > 8'b0 ? shift_val - lowerSub : 8'b0;
assign val_shifted = {val_denormBit, (shift[8] ? a_align_m : b_align_m), 26'b0} >> leftShifts;
assign val_aligned = {val_shifted[49:24], (leftShifts > 8'd25) | (|val_shifted[23:1])};


assign a_aligned_e = shift[8] ? b_align_e : a_align_e;
assign b_aligned_e = shift[8] ? b_align_e : a_align_e;
assign a_aligned_m = shift[8] ? val_aligned : {val_denormBit2, a_align_m, 3'b0};
assign b_aligned_m = shift[8] ? {val_denormBit2, b_align_m, 3'b0} : val_aligned;

endmodule