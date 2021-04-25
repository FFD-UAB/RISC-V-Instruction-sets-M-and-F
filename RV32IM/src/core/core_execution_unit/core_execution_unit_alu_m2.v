// Telecommunications Master Dissertation - Francis Fuentes 16-10-2020
// MULDIV2 HW block implementing instruction set M.
// In comparison with the original MULDIV design, this module uses 
// the ALTMULT_ADD multifunction IP to perform unsigned/signed 
// multiplications, requiring less logic in the multiplication path and 
// thus, has a higher maximum frequency of operation.
// Is expected that the core does polling on the busy flag to know if
// the operation is done.

`include "../../defines.vh"
`include "../../config_core.vh"

module MULDIV2(rs1_i, rs2_i, funct3_i, start_i, clk, rstLow, c_o, busy_o);
input [`DATA_WIDTH-1:0] rs1_i;    	// Multiplicand or dividend.
input [`DATA_WIDTH-1:0] rs2_i;    	// Multiplier or divisor.
input             [2:0] funct3_i;       // DIVMUL type funct3 selector.
input                   start_i;        // Start flag for possible multiple-cycle execution.
input                   clk;            // Clock signal.
input                   rstLow;         // Reset at low control signal.

output reg [`DATA_WIDTH-1:0] c_o;// 32-bit output result.
output busy_o;      // Busy flag for DIV module (multiple-cycle execution),
                    // high when operating, low when ready for next operation.

wire                     startDIV;   // Execute a division operation using DIVrest32u module.
wire                     busy_t;     // Put on high the busy flag on the first cycle to halt the core.
wire   [`DATA_WIDTH-1:0] a;          // Unsigned multiplicand/dividend input to the operation modules.
wire   [`DATA_WIDTH-1:0] b;          // Unsigned multiplier/divisor input to the operation modules.
wire   [`DATA_WIDTH-1:0] a_unsigned; // Unsigned multiplicand/dividend output of the S2U modules.
wire   [`DATA_WIDTH-1:0] b_unsigned; // Unsigned multiplier/divisor output of the S2U modules.
wire   [`DATA_WIDTH-1:0] q;          // Quotient result from DIV module.
wire   [`DATA_WIDTH-1:0] r;          // Remainder result from DIV module.
wire [2*`DATA_WIDTH-1:0] c_mul;      // Multiplication result from MUL module.
wire                     signedInputSharedFlag; // Flags to indicate rs2 signed 
wire                     a_signedInputFlag;     // and rs1 signed inputs.

// MULDIV type of operation.
/*     MUL = 3'b000, // SxS 32LSB
	  MULH = 3'b001, // SxS 32MSB
	MULHSU = 3'b010, // SxU (rs1 x rs2) 32MSB
	 MULHU = 3'b011, // UxU 32MSB
	   DIV = 3'b100, // S/S quotient
	  DIVU = 3'b101, // U/U quotient
	   REM = 3'b110, // S/S remainder
	  REMU = 3'b111; // U/U remainder*/

/////////////////////////////////////////////////////////////////////////////////////
// Module selection for the operations. Select only one divider and one multiplier //
/////////////////////////////////////////////////////////////////////////////////////

  // Unsigned 32bit divider 
`ifdef RV32IM_dseDIVrest32  dseDIVrest32u
`elsif RV32IM_deqsDIVrest32 deqsDIVrest32u
`elsif RV32IM_dDIVrest32    dDIVrest32u
`elsif RV32IM_seDIVrest32   seDIVrest32u
`elsif RV32IM_eqsDIVrest32  eqsDIVrest32u
`elsif RV32IM_qsDIVrest32   qsDIVrest32u
`elsif RV32IM_bDIVrest32    bDIVrest32u
`else  tDIVrest32u
`endif
 DIVmod(
    .a_in     ( a        ),
    .b_in     ( b        ),
    .start_in ( startDIV ),
    .clk      ( clk      ),
    .rstLow   ( rstLow   ),
    .q_out    ( q        ),
    .r_out    ( r        ),
    .busy     ( busy_t   )
    );

 // ALTMULT_ADD module. 
ALTMULT_ADD32 MULmod(
        .clock0  ( clk                   ),
        .dataa_0 ( rs1_i                 ),
        .datab_0 ( rs2_i                 ),
        .signa   ( a_signedInputFlag     ),  // signed at high
        .signb   ( signedInputSharedFlag ),
        .result  ( c_mul                 )
        );

Signed2Unsigned S2U1(.a_signed(rs1_i), .a_unsigned(a_unsigned));
Signed2Unsigned S2U2(.a_signed(rs2_i), .a_unsigned(b_unsigned));

//***********************
//** Flags and results **
//***********************
// This section groups flags, indicators and resultsused repeatedly, in order
// to synthesize them only once to lower the resource usage count.

// Special cases flags for division operation.
wire div0;  // Flag of division by 0.
wire divOF; // Flag of division overflow only at signed operation.

assign div0 = rs2_i == {`DATA_WIDTH{1'b0}}; // div0 high when Divisor == 0.
	// divOF high when DIV overflow (dividend = -2^31 and divisor = -1,
	// because quotient would be 2^31, overflow value in 32bit signed).
assign divOF = (rs1_i == {1'b1, {(`DATA_WIDTH-1){1'b0}}}) & (rs2_i == {`DATA_WIDTH{1'b1}});


// Special cases flag for multiplication sign solution.
wire   differentInpSign; // High when both inputs have differnt sign.
assign differentInpSign =  rs1_i[`DATA_WIDTH-1] ^ rs2_i[`DATA_WIDTH-1];


// All possible signed DIV solutions.
wire [`DATA_WIDTH-1:0] q_signed; // Negative only if inputs have different sign.
wire [`DATA_WIDTH-1:0] r_signed; // Negative only if dividend is negative.
assign q_signed = (differentInpSign ? (2'b1 + ~q)
                                    : q);
assign r_signed = (rs1_i[`DATA_WIDTH-1] ? (2'b1 + ~r) // Possible overflow if remainder
                                        : r);          // is 0 and the dividend is negative.


// All possible DIV and REM solutions.
wire [`DATA_WIDTH-1:0] q_output; // Solutions used to simplify logic wiring.
wire [`DATA_WIDTH-1:0] r_output;
assign q_output = (div0 ? {`DATA_WIDTH{1'b1}} // Divisor == 0 -> q = -1
                        : (funct3_i[0] ? q // DIVU unsigned quotient solution.
                                       : (divOF ? rs1_i // Overflow -> q = h8000 0000
                                                : q_signed // DIV signed quotient solution.
                  )));
assign r_output = (div0 ? rs1_i // Divisor == 0 -> r = dividend.
                        : (funct3_i[0] ? r // REMU unsigned remainder solution.
                                       : (divOF ? {`DATA_WIDTH{1'b0}} // Overflow -> r = 0.
                                                : r_signed
                  )));


//*********************************************
//** One-cycle remainder and DIV start logic **
//*********************************************
// If previous division asks quotient, the remainder is also generated, so if the operands have not 
// changed and maintains the same type signed/unsigned, deliver the remainder in one-cycle.
reg [`DATA_WIDTH-1:0] A_prev;
reg [`DATA_WIDTH-1:0] B_prev;
reg             [2:0] funct3_prev;
wire oneCycleRemainder;

// Load previous operands and function type.
always @(posedge clk or negedge rstLow)
 if (!rstLow) begin
   A_prev <= {`DATA_WIDTH{1'b0}};
   B_prev <= {`DATA_WIDTH{1'b0}};
 end
 else if(startDIV) begin
   A_prev <= rs1_i;
   B_prev <= rs2_i;
 end

always @(posedge clk or negedge rstLow)
 if (!rstLow) funct3_prev <= 3'b0; // Only remember function if there isn't a remainder
 else if (!oneCycleRemainder) funct3_prev <= funct3_i; // to load after.

// Flag only high when asking remainder of a division operation previously done for the quotient.
// First check if appropiated funct3 types. (DIV with REM and DIVU with REMU, but not between them)
assign oneCycleRemainder = (
 ((funct3_i == `FUNCT3_REMU) & (funct3_prev == `FUNCT3_DIVU)) | ((funct3_i == `FUNCT3_REM) & (funct3_prev == `FUNCT3_DIV)) 
                           ) & (A_prev == rs1_i) & (B_prev == rs2_i); // Second, check if operands haven't changed.


// Start the DIV module only if is a division operation that doesn't fall in a special case
// (check div0 always, but only divOF if its a signed operation (DIV and REM), that is !funct3[0]).
// Also, if the previous operation was a quotient request with the same operands, don't trigger startDIV.
reg    oneCycleStartSignal; // Used to only send the start signal one clock cycle pulse.

always @(posedge clk or negedge rstLow)
 if (!rstLow) oneCycleStartSignal <= 1'b0;
 else oneCycleStartSignal <= oneCycleStartSignal ? busy_t : startDIV;

assign startDIV = (funct3_i[2] & !(div0 | (divOF & !funct3_i[0])) & !oneCycleRemainder ? start_i : 1'b0) & !oneCycleStartSignal;
assign busy_o   = (startDIV ? 1'b1 : busy_t);


//**************************************
//** Input signed/unsigned management **
//**************************************
// Unsign the input for the DIV and MUL modules if the inputs are signed.
// The instruction set M standard fixes what funct3 input values are signed.

assign signedInputSharedFlag = |{(funct3_i == `FUNCT3_MUL),
                                 (funct3_i == `FUNCT3_MULH),
                                 (funct3_i == `FUNCT3_DIV), 
                                 (funct3_i == `FUNCT3_REM)};
assign a_signedInputFlag = signedInputSharedFlag | (funct3_i == `FUNCT3_MULHSU);

// RS1 signed when 000, 001, 010, 100, 110, aka, MUL, MULH, MULHSU, DIV, REM.
assign a = (a_signedInputFlag     ? a_unsigned
                                  : rs1_i);

// RS2 signed when 000, 001, 100, 110, aka, MUL, MULH, DIV, REM.
assign b = (signedInputSharedFlag ? b_unsigned
                                  : rs2_i);



//************************************************
//** Output signed/unsigned and type management **
//************************************************
// Manage what the output is depending over funct3.
// Reset signal takes priority to output 0.
always @(*)
 case (funct3_i)
	// MUL outputs.
	`FUNCT3_MUL:    c_o <= c_mul[`DATA_WIDTH-1:0];
	`FUNCT3_MULH:   c_o <= c_mul[2*`DATA_WIDTH-1:`DATA_WIDTH]; 
	`FUNCT3_MULHSU: c_o <= c_mul[2*`DATA_WIDTH-1:`DATA_WIDTH]; // RS1 signed, SxU=S
	`FUNCT3_MULHU:  c_o <= c_mul[2*`DATA_WIDTH-1:`DATA_WIDTH];

	// DIV outputs.
	`FUNCT3_DIV:    c_o <= q_output;
	`FUNCT3_DIVU:   c_o <= q_output;
	`FUNCT3_REM:    c_o <= r_output;
	`FUNCT3_REMU:   c_o <= r_output;
 endcase

endmodule