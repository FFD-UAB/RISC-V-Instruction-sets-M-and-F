// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider HW model following a restoring design (32 clk cycles).

module DIVrest(a_in, b_in, unsignLow, count, clk, rstlow, q_out, r_out);
input		[31:0] a_in; 	// Dividend.
input		[31:0] b_in; 	// Divisor.
input		unsignLow;	// Indicator signal of unsigned inputs when low.
input		[5:0] count;	// Iteration loop counter.
input		clk;		// Clock signal.
input 		rstlow;		// Reset signal at low.

output		[31:0] q_out;	// Quotient output.
output		[31:0] r_out;	// Remainder output.


reg		[31:0] reg_q;	// Dividend register that ends with the quotient.
reg		[31:0] reg_r;	// Remainder or partial remainder register.
reg		[31:0] reg_b;	// Divisor register.


// *****************************
// ** Restoring divisor logic **
// *****************************
//
		// Subtraction combinational result.
wire		[32:0] res = {reg_r[31:0], reg_q[31]} - {1'b0, reg_b};

		// Output unsigned operands to registers.
wire 		[31:0] q = {reg_q[30:0], !res[32]};
wire		[31:0] r = (res[32] ? {reg_r[30:0], reg_q[31]}
			     : res[31:0]);


// ******************************
// ** Signed management module **
// ******************************
//
		// Signed-to-Unsigned (input) if required (unsignLow = 1).
		// Change to positive unsigned only if negative and signed.
wire		[31:0] a = (unsignLow & a_in[31] ? (1 + ~a_in) 
						 : a_in);
wire		[31:0] b = (unsignLow & b_in[31] ? (1 + ~b_in) 
						 : b_in);

		// Unsigned-to-Signed (output) if required (unsignLow = 1).
		// The quotient is only negative if the inputs have different sign.
assign		q_out = (unsignLow & (a_in[31] ^ b_in[31]) ? (1 + ~q)
					  		   : q);
		// The remainder is only negative if the input dividend is.
assign		r_out = (unsignLow & a_in[31] ? (1 + ~r)
					      : r);


// ****************************************
// ** Restoring divisor sequential logic **
// ****************************************
//
// Preparation phase count = 0; Loop phase 0 < count < 32; Finish phase count > 31.
always @(posedge clk or negedge rstlow)
begin

// Update reg_b with divisor only when starting a operation (count = 0).
reg_b <= (~|count ? b : reg_b);	// Reg no necessary if divisor input is guaranteed 
				// to maintain its value. We don't take it as granted.

// Finish = maintain value. Preparation = load dividend. Loop = q[30:0], !res[32]}.
reg_q <= (count[5] ? reg_q // Fin -> maintain value.
		   : (~|count[4:0] ? a // Prep -> load a (load dividend).
				   : {reg_q[30:0], !res[32]} //LShift and push in.
	 ));

// Finish = maintain value. Preparation = load 0. Loop = load res if res is pos, 
//							 load shift if not.
reg_r <= (count[5] ? reg_r // Fin -> maintain value.
		   : (~|count[4:0] ? 32'b0 // Prep -> reset reg_r (load 0).
				   : (res[32] ? {reg_r[30:0], reg_q[31]} // LShift.
					      : res[31:0])	// Load result.
	 ));
end
endmodule