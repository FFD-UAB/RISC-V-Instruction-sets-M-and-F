// Telecommunications Master Dissertation - Francis Fuentes 23-10-2020
// Divider HW model following a restoring design for unsigned inputs.
// Normal operation includes maintaining the results until there's a synchronous start signal.
// This even quicker start version pushes the dividend to the first leftmost '1' bit of the 
// divisor in the remainder register.

module eqsDIVrest32u(a_in, b_in, start_in, clk, rstLow, q_out, r_out, busy);
// Input operands and control signals.
input      [31:0] a_in; // Dividend
input      [31:0] b_in; // Divisor
input      start_in;    // start operation flag.
input      clk;         // Clock signal
input      rstLow;      // Reset signal at low

// Output results and busy flag.
output     [31:0] q_out; // Quotient result.
output     [31:0] r_out; // Remainder result.
output reg busy;         // Ongoing operation flag (results when goes low).

// Intern registers.
reg     [31:0] reg_q;	 // Dividend register that ends with the quotient.
reg     [31:0] reg_r;	 // Remainder or partial remainder register.

// Compute how many left shifts are required to start the division early.
wire     [4:0] a_LeftBitPosition;
wire     [4:0] b_LeftBitPosition;
wire     [4:0] LeftShifts;
wire    [63:0] pushedDividend;

HighestLeftBit32u HLB1(.a(a_in), .leftSh(a_LeftBitPosition));
HighestLeftBit32u HLB2(.a(b_in), .leftSh(b_LeftBitPosition));

assign LeftShifts = ~a_LeftBitPosition + b_LeftBitPosition; // Technically, it shouldn't be possible to overflow,
assign pushedDividend = a_in << LeftShifts; // as the maximum number of leftshift is 31 if special cases are pre-managed.

// Output and start blocking in special case of dividend < quotient to single-cycle.
wire start;
wire DividendLowerDivisor;

assign  DividendLowerDivisor = a_in < b_in;
assign 	start = (DividendLowerDivisor ? 1'b0  : start_in);
assign 	q_out = (DividendLowerDivisor ? 32'b0 : reg_q);
assign 	r_out = (DividendLowerDivisor ? a_in  : reg_r);

// Intern control signals.
reg		 [4:0] count;	// Iteration counter.
reg		 init;			// Initialize control signal (counter, registers, etc).

// Intern results signals.
wire 	[32:0] res;	// Combinational subtraction result for next iteration.
assign         res = {reg_r[31:0], reg_q[31]} - {1'b0, b_in};


// *************************
// ** State machine logic **
// *************************
	// State machine registers and parameter values.
reg 		[1:0] State;
parameter	[1:0] Prep = 2'd0, Loop = 2'd1, Finish = 2'd2, Free = 2'd3;


	// Next state control management.
always @(posedge clk or negedge rstLow)
 if (!rstLow) State <= Finish;
 else case(State) // All possible outcomes must be defined to avoid latches.
 	Prep:     // Load in one cycle the operands and continue to Loop.
		State = Loop;

	Loop:	// Change to Finish when count = 31 or to Prep if is rst.
		State = (&count ? Finish : Loop);

	Finish, Free: //Finish: // Maintain results until rst or next start.
		State = (start ? Prep : Finish);
 endcase


	// State machine control signals output.
always @(State)
 case(State)
	Prep: begin 		// Preparation phase:
		busy = 1'b1;	// Load input operands and
		init = 1'b1;	// to prepare for operation
	      end		// execution.

	Loop: begin		// Loop or Operation phase:
		busy = 1'b1;	// Enable iteration counter 
		init = 1'b0;	// and at each iteration,
	      end	      	// perform the required ops.

	Finish, Free: begin	// Finish or Idle phase:
		busy = 1'b0;	// Stop operating and wait
	   	init = 1'b0; 	// maintaing the results,
	      end	        // until a new operation 
 endcase		        // is requested.


// **********************
// ** Sequential logic **
// **********************

always @(posedge clk or negedge rstLow)
 if (!rstLow) count <= 5'b0;
 else if (init) count <= LeftShifts; // Load how many cycles have been saved.
      else if (busy) count <= count + 5'b1;

always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_q <= 32'b0;
 else if (init) reg_q <= pushedDividend[31:0]; // Load 32LSB of the pushed dividend.
      else if (busy) reg_q <= {reg_q[30:0], !res[32]}; // Load next LShift.

// reg_r operation load depends on the subtraction result sign, if its
// positive (partial remaining > divisor), load result; if neg, left shift.
always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_r <= 32'b0;
 else if (init) reg_r <= pushedDividend[63:32];
      else if (busy) reg_r <= (res[32] ? {reg_r[30:0], reg_q[31]}
                                       : res[31:0]);
											 
endmodule