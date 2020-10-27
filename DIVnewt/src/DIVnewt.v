// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider HW model following a restoring design.

module DIVnewt32(a_in, b_in, unsignLow, start, clk, rstlow, q_out, r_out, busy);
// Input operands & control signals.
input	[31:0] a_in; 	// Dividend
input	[31:0] b_in; 	// Divisor
input	unsignLow;	// Indicator signal of unsigned inputs when low.
input	start;		// Start operation flag.
input	clk;		// Clock signal
input 	rstlow;		// Reset signal at low

// Output results, debug counter & busy flag.
output		[31:0] q_out;	// Quotient result.
output		[31:0] r_out;	// Remainder result.
output reg	       busy;	// Ongoing operation flag (results when goes low).

// Intern registers.
reg	[31:0] reg_a;	// Dividend register.
reg	[31:0] reg_b;	// Divisor register.
reg	[33:0] reg_x;	// Seed | divisor inverse register.
reg	[33:0] reg_y;	// Product result | temp register;

reg	 [5:0] itCount;	// Iteration counter.
reg	 [1:0] opCount;	// Operation stage counter.

reg	 [4:0] leftShift; // Number of left-shifts performed to normalize the divisor.
reg	       unsign;	  // Register used to save if the input operands were signed.
reg	 [1:0] inpSigns;  // Contains {a[31], b[31]} signs when started the operation.

// Internal control signals.
reg	init;		// Initialize control signal (counters, registers, etc).
reg	enCounter;	// Enable counter control signal.
reg	compQ;		// Compute quotient after finding 1/b.
reg	compR;		// Compute remainder after finding quotient.




// *************************
// ** Combinational logic **
// *************************

// Internal signals.
wire	[31:0] a_unsign; // Dividend unsigned.
wire	[31:0] b_unsign; // Divisor unsigned.
wire	[31:0] a_norm; // Dividend normalized.
wire	[31:0] b_norm;
wire 	 [4:0] leftSh; // Number of leftShifts performed to normalize unsigned divisor.
wire	[67:0] prodRes;// Product result.

// Always have unsigneds prepared in case of start operation. Use usignLow input flag.
assign a_unsign = Sign2Unsign(a_in, unsignLow);
assign b_unsign = Sign2Unsign(b_in, unsignLow);


// Always compute the divisor input in case of start operation. Save leftSh in seq logic.
Normalize32u Normalize32u(.a(a_unsign), .b(a_norm), .leftSh(leftSh));
assign b_norm = b_unsign << leftSh;	// TEMPORAL

// Depending on what stage the operation is, the MUL module has different inputs.
assign prodRes = (compR ? reg_x[31:0] * reg_b
			: (compQ ? reg_a * reg_x
				 : (opCount == 2'd2 ? reg_x * reg_y
						    : reg_x * reg_b
)));

// Unsigned-to-Signed (output) if required (unsignLow = 1).
// The quotient is only negative if the inputs have different sign.
assign	q_out = (unsignLow & (^inpSigns) ? (1 + ~reg_x[31:0])
				  	 : reg_x[31:0]);

// The remainder is only negative if the input dividend is.
assign	r_out = (unsignLow & inpSigns[1] ? (1 + ~reg_a)
					 : reg_a);


// *************************
// ** State machine logic **
// *************************
	// State machine registers & parameter values.
reg 		[2:0] State;
parameter	[2:0] Prep = 3'd0, Loop = 3'd1, Post1 = 3'd2, Post2 = 3'd3, Finish = 3'd4;


	// Synchronous state machine with asynchronous low reset (actual 
	// register rst using Prep phase occurs in next posedge clk).
always @(posedge clk or negedge rstlow)
 if (!rstlow) State <= Prep;
 else if ((itCount == 6'd7) & (opCount == 2'd0)) State <= Prep;
      else if ((itCount == 6'd6) & (opCount == 2'd1)) State <= Finish;
	   else if ((itCount == 6'd5) & (opCount == 2'd1)) State <= Post2;
		else if ((itCount == 6'd4) & (opCount == 2'd2)) State <= Post1;
	  	     else if (start) State <= Loop;

	// State machine.
always @(*)
case(State)
	/*Prep*/ default: begin	  // Preparation | Idle phase:
		busy = 1'b0;	  // Load input operands and
		init = 1'b1;      // prepare for start signal
		enCounter = 1'b0; // to operate.
		compQ = 1'b0;
		compR = 1'b0;
	      end

	Loop: begin		  // Loop | Operation phase:
		busy = 1'b1;      // Enable iteration counter 
		init = 1'b0;      // & at each iteration,
		enCounter = 1'b1; // perform the required ops.
		compQ = 1'b0;
		compR = 1'b0;
	      end

	Post1: begin
		busy = 1'b1;
		init = 1'b0;
		enCounter = 1'b1;
		compQ = 1'b1;
		compR = 1'b0;
	      end

	Post2: begin
		busy = 1'b1;
		init = 1'b0;
		enCounter = 1'b1;
		compQ = 1'b0;
		compR = 1'b1;
	      end

	Finish: begin		    // Finish phase:
	        busy = 1'b0; 	    // Stop operating & wait
	        init = 1'b0; 	    // for 1 clock cycle to 
	        enCounter  = 1'b1;  // deliver the results.
		compQ = 1'b0;
		compR = 1'b0;
	       end		    // Next, return to Prep phase.
endcase


// **********************
// ** Sequential logic **
// **********************

// Counter registers.
always @(posedge clk or negedge rstlow)
 if (!rstlow) itCount <= 6'b0;
 else if (init) itCount <= 6'b0;
      else if ((compQ | compR) & (opCount == 2'd1)) itCount <= itCount + 2'b1;
	   else if (opCount == 2'd2) itCount <= itCount + 2'b1;

always @(posedge clk or negedge rstlow)
 if (!rstlow) opCount <= 2'b0;
 else if (init) opCount <= 2'b0;
      else if ((compQ | compR) & (opCount == 2'd1)) opCount <= 2'b0;
	   else if (opCount == 2'd2) opCount <= 2'b0;
		else if (enCounter) opCount <= opCount + 2'b1;

// Value registers.
always @(posedge clk or negedge rstlow)
 if (!rstlow) reg_a <= 32'b0;
 else if (init) reg_a <= a_norm;
      else if (compR & (opCount == 2'b1)) reg_a <= reg_a - reg_b;

always @(posedge clk or negedge rstlow)
 if (!rstlow) reg_b <= 32'b0;
 else if (init) reg_b <= b_norm;
      else if (compR & (opCount == 2'b0)) reg_b <= prodRes[31:0];

always @(posedge clk or negedge rstlow)
 if (!rstlow) reg_x <= 32'b0;
 else if (init) reg_x <=  34'h180000000; //{1'b0, ROM(b_norm[30:26]), 24'b0};
      else if (compQ & (opCount == 2'b1)) reg_x <= reg_x[33:2] + |reg_x[1:0];
	   else if (compQ & (opCount == 2'b0)) reg_x <= prodRes[64:31] >> (leftShift); // De-normalize quotient.
		else if ((!compQ & !compR) & opCount == 2'd2) reg_x <= prodRes[66:33];

always @(posedge clk or negedge rstlow)
 if (!rstlow) reg_y <= 32'b0;
 else if (init) reg_y <= 32'b0;
      else if ((!compQ & !compR) & (opCount == 2'b0)) reg_y <= prodRes[64:31];
	   else if ((!compQ & !compR) & (opCount == 2'b1)) reg_y <= 1 + ~reg_y;

// Control operand registers.
always @(posedge clk or negedge rstlow)
 if (!rstlow) leftShift <= 5'b0;
 else if (init) leftShift <= leftSh;

always @(posedge clk or negedge rstlow)
 if (!rstlow) unsign <= 1'b0;
 else if (init) unsign <= unsignLow;

always @(posedge clk or negedge rstlow)
 if (!rstlow) inpSigns <= 2'b0;
 else if (init) inpSigns <= {a_in[31], b_in[31]};


// *****************************
// ** Signed to Unsigned task **
// *****************************
function [31:0] Sign2Unsign;
input  [31:0] a_signed;
input 	      unsginLow;

Sign2Unsign = (unsignLow & a_signed[31] ? (1 + ~a_signed) 
					: a_signed);
endfunction



// ********************
// ** Normalize task **
// ********************
/*task Normalize32u;

input  [31:0] a;
output [31:0] a_norm;
output  [4:0] leftSh;

begin
// If "a" 16MSB has a one, leftSh[4] <= 0;
 leftSh[4] = ~|a[31:16];

// If leftSh[4] == 0, search in the 8MSB, if not, search 8MSB at a[15:0].
 leftSh[3] = (!leftSh[4] ? ~|a[31:24] 
			     : ~|a[15:8]);
// Following the same procedure, section the operand "a" to find the highest '1'.
 leftSh[2] = (!leftSh[4] 
			? (!leftSh[3] 
				? ~|a[31:28] 
				: ~|a[23:20]) 
			: (!leftSh[3] 
				? ~|a[15:12] 
				: ~|a[7:4])
		  );

 leftSh[1] = (!leftSh[4] 
			? (!leftSh[3] 
				? (!leftSh[2] 
					? ~|a[31:30]
					: ~|a[27:26]) 
				: (!leftSh[2] 
					? ~|a[23:22]
					: ~|a[19:18])
			  )
			: (!leftSh[3] 
				? (!leftSh[2] 
					? ~|a[15:14]
					: ~|a[11:10]) 
				: (!leftSh[2] 
					? ~|a[7:6]
					: ~|a[3:2])
			  )
		  );

 leftSh[0] = (!leftSh[4] 
			? (!leftSh[3] 
				? (!leftSh[2] 
					? (!leftSh[1]
						? !a[31]
						: !a[29])
					: (!leftSh[1]
						? !a[27]
						: !a[25])
				  ) 
				: (!leftSh[2] 
					? (!leftSh[1]
						? !a[23]
						: !a[21])
					: (!leftSh[1]
						? !a[19]
						: !a[17])
				  )
			  )
			: (!leftSh[3] 
				? (!leftSh[2] 
					? (!leftSh[1]
						? !a[15]
						: !a[13])
					: (!leftSh[1]
						? !a[11]
						: !a[9])
				  ) 
				: (!leftSh[2] 
					? (!leftSh[1]
						? !a[7]
						: !a[5])
					: (!leftSh[1]
						? !a[3]
						: !a[1])
				  )
			  )
		  );

// Shift the input operand #leftSh times to normalize it.
 a_norm = a << leftSh;
end
endtask
*/

// ***************
// ** ROM table **
// ***************
function [7:0] ROM;
input [3:0] MSBdiv;
 case(MSBdiv)
 4'h0: ROM = 8'hFF;	4'h1: ROM = 8'hDF;	4'h2: ROM = 8'hC3;	4'h3: ROM = 8'hAA;
 4'h4: ROM = 8'h93;	4'h5: ROM = 8'h7F;	4'h6: ROM = 8'h6D;	4'h7: ROM = 8'h5C;
 4'h8: ROM = 8'h4D;	4'h9: ROM = 8'h3F;	4'hA: ROM = 8'h33;	4'hB: ROM = 8'h27;
 4'hC: ROM = 8'h1C;	4'hD: ROM = 8'h12;	4'hE: ROM = 8'h08;	4'hF: ROM = 8'h00;
 endcase
endfunction

endmodule