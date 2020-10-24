// Telecommunications Master Dissertation - Francis Fuentes 16-10-2020
// MULDIV HW block implementing instruction set M.
// Is expected that the core does polling on the busy flag to know if
// the operation is done.

module MULDIV(rs1, rs2, funct3, start, clk, rstLow, c_out, busy);
input [31:0] rs1;    	// Multiplicand or dividend.
input [31:0] rs2;    	// Multiplier or divisor.
input  [2:0] funct3; 	// DIVMUL type funct3 selector.
input start;		// Start flag for DIV module (multiple-cycle execution).
input clk;              // Clock signal.
input rstLow;		// Reset at low control signal.

output reg [31:0] c_out;// 32-bit output result.
output busy;		// Busy flag for DIV module (multiple-cycle execution),
			// high when operating, low when ready for next operation.

wire startDIV;		// Execute a division operation using DIVrest32u model.
wire [31:0] a;		// Unsigned multiplicand/dividend input to the operation modules.
wire [31:0] b;		// Unsigned multiplier/divisor input to the operation modules.
wire [31:0] a_unsigned; // Unsigned multiplicand/dividend output of the S2U modules.
wire [31:0] b_unsigned; // Unsigned multiplier/divisor output of the S2U modules.
wire [31:0] q;		// Quotient result from DIV module.
wire [31:0] r;		// Remainder result from DIV module.
wire [63:0] c_mul;	// Multiplication result from MUL module.

// MULDIV type of operation.
parameter  
           MUL = 3'b000, // SxS 32LSB
	  MULH = 3'b001, // SxS 32MSB
	MULHSU = 3'b010, // SxU (rs1 x rs2) 32MSB
	 MULHU = 3'b011, // UxU 32MSB
	   DIV = 3'b100, // S/S quotient
	  DIVU = 3'b101, // U/U quotient
	   REM = 3'b110, // S/S remainder
	  REMU = 3'b111; // U/U remainder

eqsDIVrest32u DIVmod(.a_in(a), // Various options are t, b, qs, eqsDIVrest32u.
	.b_in(b),
	.start_in(startDIV),
	.clk(clk),
	.rstLow(rstLow),
	.q_out(q),
	.r_out(r),
	.busy(busy));

MULgold MULmod(.a_in(a),
	.b_in(b),
	.c_out(c_mul));

Signed2Unsigned S2U1(.a_signed(rs1), .a_unsigned(a_unsigned));

Signed2Unsigned S2U2(.a_signed(rs2), .a_unsigned(b_unsigned));

//***********************
//** Flags and results **
//***********************
// This section groups flags, indicators and resultsused repeatedly, in order
// to synthesize them only once to lower the resource usage count.

// Special cases flags for division operation.
wire div0;  // Flag of division by 0.
wire divOF; // Flag of division overflow only at signed operation.

assign div0 = rs2 == 32'b0; // div0 high when Divisor == 0.
	// divOF high when DIV overflow (dividend = -2^31 and divisor = -1,
	// because quotient would be 2^31, overflow value in 32bit signed).
assign divOF = (rs1 == 32'h80000000) & (rs2 == 32'hFFFFFFFF);


// Special cases flag for multiplication sign solution.
wire differentInpSign;	// High when both inputs have differnt sign.
assign differentInpSign =  rs1[31] ^ rs2[31];


// All possible signed MUL solutions.
wire [63:0] sign_c_mul;	     // MUL output, but negative 2'complement.
wire [63:0] result_S_c_mul;  // Signed multiplication solution.
wire [63:0] result_SU_c_mul; // Signed RS1 x Unsigned RS2 = Signed SU_c_mul

assign sign_c_mul = 1 + ~c_mul; // 2'complement is bit-by-bit negative +1.
assign result_S_c_mul  = (differentInpSign ? sign_c_mul : c_mul);
assign result_SU_c_mul = (rs1[31]          ? sign_c_mul : c_mul);


// All possible signed DIV solutions.
wire [31:0] q_signed; // Negative only if inputs have different sign.
wire [31:0] r_signed; // Negative only if dividend is negative.
assign q_signed = (differentInpSign ? (32'b1 + ~q)
                                    : q);
assign r_signed = (rs1[31] ? (32'b1 + ~r) // Possible overflow if remainder
                           : r);          // is 0 and the dividend is negative.


// All possible DIV and REM solutions.
wire [31:0] q_output; // Solutions used to simplify logic wiring.
wire [31:0] r_output;
assign q_output = (div0 ? 32'hFFFFFFFF // Divisor == 0 -> q = -1
                        : (funct3[0] ? q // DIVU unsigned quotient solution.
                                     : (divOF ? rs1 // Overflow -> q = h8000 0000
                                              : q_signed // DIV signed quotient solution.
                  )));
assign r_output = (div0 ? rs1 // Divisor == 0 -> r = dividend.
                        : (funct3[0] ? r // REMU unsigned remainder solution.
                                     : (divOF ? 32'b0 // Overflow -> r = 0.
                                              : r_signed
                  )));


//*********************************************
//** One-cycle remainder and DIV start logic **
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
 if (!rstLow) funct3_prev <= 3'b0; // Only remember function if there isn't a remainder
 else if (!oneCycleRemainder) funct3_prev <= funct3; // to load after.

// Flag only high when asking remainder of a division operation previously done for the quotient.
// First check if appropiated funct3 types. (DIV with REM and DIVU with REMU, but not between them)
assign oneCycleRemainder = (
 ((funct3 == REMU) & (funct3_prev == DIVU)) | ((funct3 == REM) & (funct3_prev == DIV)) 
                           ) & (A_prev == rs1) & (B_prev == rs2); // Second, check if operands haven't changed.


// Start the DIV module only if is a division operation that doesn't fall in a special case
// (check div0 always, but only divOF if its a signed operation (DIV and REM), that is !funct3[0]).
// Also, if the previous operation was a quotient request with the same operands, don't trigger startDIV.
assign startDIV = (funct3[2] & !(div0 | (divOF & !funct3[0])) & !oneCycleRemainder ? start : 1'b0);



//**************************************
//** Input signed/unsigned management **
//**************************************
// Unsign the input for the DIV and MUL modules if the inputs are signed.
// The instruction set M standard fixes what funct3 input values are signed.

wire signedInputSharedFlag;
assign signedInputSharedFlag = |{(funct3 == MUL),
                               (funct3 == MULH),
                               (funct3 == DIV), 
                               (funct3 == REM)};

// RS1 signed when 000, 001, 010, 100, 110, aka, MUL, MULH, MULHSU, DIV, REM.
assign a = (signedInputSharedFlag | (funct3 == MULHSU)
                                  ? a_unsigned
                                  : rs1);

// RS2 signed when 000, 001, 100, 110, aka, MUL, MULH, DIV, REM.
assign b = (signedInputSharedFlag ? b_unsigned
                                  : rs2);



//************************************************
//** Output signed/unsigned and type management **
//************************************************
// Manage what the output is depending over funct3.
// Reset signal takes priority to output 0.
always @(*)
 case (funct3)
	// MUL outputs.
	MUL:    c_out <= result_S_c_mul[31:0];
	MULH:   c_out <= result_S_c_mul[63:32]; 
	MULHSU: c_out <= result_SU_c_mul[63:32]; // RS1 signed, SxU=S
	MULHU:  c_out <= c_mul[63:32];

	// DIV outputs.
	DIV:    c_out <= q_output;
	DIVU:   c_out <= q_output;
	REM:    c_out <= r_output;
	REMU:   c_out <= r_output;
 endcase

endmodule