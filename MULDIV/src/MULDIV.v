// Telecommunications Master Dissertation - Francis Fuentes 16-10-2020
// MULDIV HW block implementing instruction set M.
// Is expected that the core does polling on the busy flag to know if
// the operation is done.

module MULDIV(rs1, rs2, funct3, start, clk, rstLow, c_out, busy);
input [31:0] rs1;    	// Multiplicand or dividend.
input [31:0] rs2;    	// Multiplier or divisor.
input  [2:0] funct3; 	// DIVMUL type funct3 selector.
input start;		// Start flag for DIV module (multiple-cycle execution).
input clk;		// Clock signal.
input rstLow;		// Reset at low control signal.

output reg [31:0] c_out; 	// 32-bit output result.
output busy;		// Busy flag for DIV module (multiple-cycle execution),
			// high when operating, low when ready for next operation.

wire start_div;		// Execute a division operation using DIVrest32u model.
wire [31:0] a;		// Unsigned multiplicand/dividend input.
wire [31:0] b;		// Unsigned multiplier/divisor input.
wire [31:0] q;		// Quotient result from DIV module.
wire [31:0] r;		// Remainder result from DIV module.
wire [63:0] c_mul;	// Multiplication result from MUL module.

// MULDIV type of operation.
parameter  MUL = 3'h0, // SxS 32LSB
	  MULH = 3'h1, // SxS 32MSB
	MULHSU = 3'h2, // SxU (rs1 x rs2) 32MSB
	 MULHU = 3'h3, // UxU 32MSB
	   DIV = 3'h4, // S/S quotient
	  DIVU = 3'h5, // U/U quotient
	   REM = 3'h6, // S/S remainder
	  REMU = 3'h7; // U/U remainder

DIVrest32u DIVmod(.a_in(a),
	.b_in(b),
	.start(start_div),
	.clk(clk),
	.rstLow(rstLow),
	.q_out(q),
	.r_out(r),
	.busy(busy));

MULgold MULmod(.a_in(a),
	.b_in(b),
	.c_out(c_mul));

//***********************
//** Flags and results **
//***********************
// This section groups flags, indicators and resultsused repeatedly, in order
// to synthesize them only once to lower the resource usage count.

// Special cases flags for division operation.
wire div0;  // Flag of division by 0.
wire divOF; // Flag of division overflow only at signed operation.

assign div0 = !(rs2[0] || |rs2[31:1]);	// div0 high when Divisor == 0.
	// divOF high when DIV overflow (dividend = -2^31 and divisor = -1,
	// because quotient would be 2^31, overflow value in 32signed).
assign divOF = (rs1[31] & !(|rs1[30:0])) & (rs2[0] & !(|rs2[31:1]));


// Special cases flag for multiplication sign solution.
wire differentInpSign;	// High when both inputs have differnt sign.
assign differentInpSign =  rs1[31] ^ rs2[31];


// All possible signed MUL solutions.
wire [63:0] sign_c_mul;	// MUL output, but negative 2'complement.
wire [63:0] result_S_c_mul; // Signed multiplication solution.
wire [63:0] result_SU_c_mul; // Signed RS1 x Unsigned RS2 = Signed SU_c_mul

assign sign_c_mul = 1 + ~c_mul; // 2'complement is bit-by-bit negative +1.
assign result_S_c_mul = (differentInpSign ? sign_c_mul : c_mul);
assign result_SU_c_mul = (rs1[31] ? sign_c_mul : c_mul);

// All possible signed DIV solutions.
wire [31:0] q_signed; // Negative only if inputs have different sign.
wire [31:0] r_signed; // Negative only if dividend is negative.
assign q_signed = (differentInpSign ? (32'b1 + ~q)
				    : q);
assign r_signed = (rs1[31] ? (32'b1 + ~r) // Possible overflow if remainder
			   : r);	  // is 0 and the dividend is negative.


//*********************************************
//** Remainder one-cycle and DIV start logic **
//*********************************************
// If previous division asks quotient, the remainder is also generated, so if the operands have not 
// changed and maintains the same type signed/unsigned, deliver the remainder in one-cycle.

reg [31:0] A_prev;
reg [31:0] B_prev;
reg  [2:0] funct3_prev;
wire oneCycleRemainder;

// Load previous operands and function type.
always @(posedge clk or negedge rstLow)
 if (!rstLow) A_prev <= 32'b0;
 else A_prev <= rs1;

always @(posedge clk or negedge rstLow)
 if (!rstLow) B_prev <= 32'b0;
 else B_prev <= rs2;

always @(posedge clk or negedge rstLow)
 if (!rstLow) funct3_prev <= 3'b0;			// Only remember function if there isn't a remainder
 else if (!oneCycleRemainder) funct3_prev <= funct3; 	// to load after.

// Flag only high when asking remainder of a division operation previously done for the quotient.
assign oneCycleRemainder = ( // First check if appropiated funct3 types.
	((funct3 == REMU) && (funct3_prev == DIVU)) || 
	((funct3 == REM) && (funct3_prev == DIV)) // Second, check if operands haven't changed.
			   ) && (A_prev == rs1) && (B_prev == rs2);

// Start the DIV module only if is a division operation that doesn't fall in a special case
// (check div0 always, but only divOF if its a signed operation (DIV and REM), that is !funct3[0]).
// Also, if the previous operation was a quotient request with the same operands, don't trigger startDIV.
assign start_div = (funct3[2] &&!(div0 || (divOF && !funct3[0])) && !oneCycleRemainder ? start : 1'b0);



//**************************************
//** Input signed/unsigned management **
//**************************************
// Unsign the input for the DIV and MUL modules if the inputs are signed.
// The instruction set M standard fixes what funct3 input values are signed.

// RS1 signed when 000, 001, 010, 100, 110, aka, !(c(a+b)). func3 = 4*a+2*b+c.
assign a = (!(funct3[0] && |funct3[2:1]) ? Signed2Unsigned(rs1)
					 : rs1);

// RS2 signed when 000, 001, 100, 110, aka, !((!a+c)(a+b)). func3 = 4*a+2*b+c.
assign b = (!((!funct3[2] || funct3[0]) && |funct3[2:1]) ? Signed2Unsigned(rs2)
							 : rs2);



//************************************************
//** Output signed/unsigned and type management **
//************************************************
// Manage what the output is depending over funct3.
// Reset signal takes priority to output 0.
always @(*)
 if (!rstLow) c_out <= 32'b0;
 else case (funct3)
	// MUL outputs.
	MUL:    c_out <= result_S_c_mul[31:0];
	MULH:   c_out <= result_S_c_mul[63:32]; 
	MULHSU: c_out <= result_SU_c_mul[63:32]; // RS1 signed, SxU=S
	MULHU:  c_out <= c_mul[63:32];

	// DIV outputs.
	DIV:    c_out <= (div0 ? 32'hFFFFFFFF	// Divisor == 0 -> q = -1
				        : (divOF ? rs1	// Overflow -> q = h8000 0000
					             : q_signed
				   ));
	DIVU:   c_out <= (div0 ? 32'hFFFFFFFF	// Divisor == 0 -> q = 2^32 - 1
				           : q);
	REM:    c_out <= (div0 ? rs1		// Divisor == 0 -> r = dividend.
				           : (divOF ? 32'b0	// Overflow -> r = 0.
					                : r_signed
				));
	REMU:   c_out <= (div0 ? rs1	// Divisor == 0 -> r = dividend
				           : r);
 endcase


//*********************************
//** Signed to Unsigned function **
//*********************************
// Signed-to-Unsigned (input).
// Change to positive unsigned only if negative and signed.
function [31:0] Signed2Unsigned;
input  [31:0] a_signed;

Signed2Unsigned = (a_signed[31] ? (1 + ~a_signed) 
				: a_signed);
endfunction

endmodule