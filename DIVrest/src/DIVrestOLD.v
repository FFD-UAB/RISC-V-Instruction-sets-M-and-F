// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider HW model following a restoring design (32 clk cycles).

module DIVrest(a_in, b_in, unsignLow, count, start, busy, clk, rstlow, q_out, r_out);
input		[31:0] a_in; 	// Dividend.
input		[31:0] b_in; 	// Divisor.
input		unsignLow;	// Indicator signal of unsigned inputs when low.
input		[5:0] count;	// Iteration loop counter.
input		start;		// Start operation flag (take operands).
input		clk;		// Clock signal.
input 		rstlow;		// Reset signal at low.

output		[31:0] q_out;	// Quotient output.
output		[31:0] r_out;	// Remainder output.
output reg	busy;		// Busy flag. Lowered when ready to new operation.

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
//wire 		[31:0] q = {reg_q[30:0], !res[32]};
//wire		[31:0] r = (res[32] ? {reg_r[30:0], reg_q[31]}
//				    : res[31:0]);
wire q = reg_q;
wire r = reg_r;

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
//always @(posedge clk or negedge rstlow)
//begin

// The priority signal precedence is rst > busy > start. The operation will not restart
// when a start signal is raised until the ongoing operation is finished.
always @(posedge clk or negedge rstlow)
// Update reg_b with divisor b only when starting a operation (count = 0 -> |count).
reg_b <= (rstlow & (|count) ? reg_b : b	// Reg no necessary if input divisor b is guaranteed 
	 );				// to maintain its value. We don't take it as granted.

always @(posedge clk or negedge rstlow)
reg_q <= (!rstlow ? 32'b0 // rst: Load 0.
		  : (busy ? {reg_q[30:0], !res[32]} // Loop: Load next shift.
			  : (start ? a // Prep: Load dividend a (new operation).
				   : reg_q // Fin: Maintain value until next operation (start = 1).
	 )));

always @(posedge clk or negedge rstlow)
reg_r <= (!rstlow ? 32'b0 // rst: Load 0.
		  : (busy ? (res[32] ? {reg_r[30:0], reg_q[31]} // Loop: LShift if subtraction res
				     : res[31:0])	        // is neg, load res if pos.
			  : (start ? 32'b0 // Prep: Load 0 (new operation);
				   : reg_r // Fin: Maintain value until next operation (start = 1).
	 )));

always @(posedge clk or negedge rstlow)
busy <= (!rstlow ? 1'b0 
		 : (start ? 1'b0
			  : (count < 6'd31 ? 1'b1 
					   : 1'b0
	))); // Loop only when count < 32 in order to do 32 iterations. 

//end
endmodule