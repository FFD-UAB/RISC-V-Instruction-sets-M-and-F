// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider HW model following a restoring design.

module DIVrest(a, b, start, clk, rstlow, q, r, busy, count);
input		[31:0] a; 	// Dividend
input		[31:0] b; 	// Divisor
input		start;		// Start signal
input		clk;		// Clock signal
input 		rstlow;		// Reset signal at low

output		[31:0] q;
output		[31:0] r;
output reg	[4:0]  count;	// Iteration counter
output reg	busy;


reg		[31:0] reg_q;	// Dividend register that ends with the quotient
reg		[31:0] reg_r;	// Remainder or partial remainder register
reg		[31:0] reg_b;	// Divisor register

		// Subtraction combinational result
wire		[32:0] res = {reg_r[31:0], reg_q[31]} - {1'b0, reg_b};

		// Output operands assignment to registers
assign 		q = reg_q;
assign		r = reg_r;

		// State machine registers and parameter values.
reg 		[1:0] State, NextState;	// All possible outcomes has to be defined.
parameter	[1:0] Prep = 2'd1, Loop = 2'd2, Finish = 2'd0, FREE = 2'd3;


// Synchronous state machine with asynchronous low reset (actual 
// register rst using Prep phase occurs in next posedge clk).
always @(posedge clk or negedge rstlow)
	if (!rstlow)	State <= Prep;
	else		State <= NextState;

// State machine. 1 clk Prep, 31 clk Loop, 1 clk Finish.
always @(*)
case (State)
	Prep, FREE: 	if(start) 
			NextState <= Loop;
		else	NextState <= Prep;
	Loop: 	if(count >= 5'd31)
			NextState <= Finish;
		else	NextState <= Loop;
	Finish:	NextState <= Prep;
endcase

// Operation execution.
always @(posedge clk or negedge rstlow)
case(State)
	Prep, FREE: begin	// Preparation or Idle phase.
		reg_q <= a;
		reg_b <= b;
		reg_r <= 32'b0;
		count <= 5'b0;
		busy  <= 1'b0;
	      end

	Loop: begin		// Loop or Operation phase.
		busy  <= 1'b1;
		count <= count + 5'b1;
		{reg_r, reg_q} <= (res[32] ?
			{reg_r[30:0], reg_q, !res[32]}	   :
			{res[31:0], reg_q[30:0], !res[32]} );
	      end

	Finish: busy <= 1'b0;	// Finish phase.
endcase
endmodule