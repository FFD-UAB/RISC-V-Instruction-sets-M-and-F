// Telecommunications Master Dissertation - Francis Fuentes 5-11-2020
// Divider HW model following a restoring design for unsigned inputs.
// Normal operation includes maintaining the results until there's a synchronous start pulse signal.
// This skip execution version uses the even quicker start as foundation and applies the same 
// concept, not only at the start of the operation, but also during the operation, meaning that 
// the number of clock cycles saved equals to near the number of 0 the quotient result has.
// For example, with quotient result is 001000101, this saves 1+2+0 clock cycles in the worst case,
// in the best case it saves 2+3+1 clock cycles, all depend if the mid-execution shifting results 
// in a '1' quotient bit added. The shifting is performed after the subtraction operation.

module seDIVrest32u(a_in, b_in, start_in, clk, rstLow, q_out, r_out, busy);
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

// Intern control signals.
reg		 [4:0] count;	// Iteration counter.
reg		 init;			// Initialize control signal (counter, registers, etc).

// Intern results signals.
wire 	[32:0] res; // Combinational subtraction result for next iteration.
wire 	[31:0] resP;// Only positive result
assign         res  = {reg_r[31:0], reg_q[31]} - {1'b0, b_in};
assign         resP = res[32] ? {reg_r[30:0], reg_q[31]} : res[31:0];

// Compute how many left shifts are required to start the division early or during execution.
wire     [4:0] a_LeftBitPosition;
wire     [4:0] b_LeftBitPosition;
wire    [63:0] shiftInput;      // Operand input for the shifting. Dividend on the start, during the operation is
wire    [63:0] pushedDividend;  // Output of the shifting.                           {result, reg q, !sign result}
wire     [4:0] LeftShifts;      // Number of shifts to perform.
wire     [4:0] Shift;           // Shift with OOB logic.
reg      [4:0] divisorPosition; // Bit position of the divisor.
wire           nothingOnRes;
wire           outOfBoundsCount; // When the operation is finishing, if the shift to perform will overflow the iteration count,
                                 // execute normal operation and don't use the shifting mid-operation ability.
wire           oneShiftLeft;

assign oneShiftLeft = count == 5'd31;
assign outOfBoundsCount = ({1'b0, LeftShifts} + count) >= 5'd31;
assign shiftInput = init ? a_in : {resP[31:0], reg_q[30:0], !res[32]};

// Find at what bit position is the first 1 on start (init=1) and during operation (init=0).
HighestLeftBit32u HLB1(.a(init ? a_in : shiftInput[31:0] ), .leftSh(a_LeftBitPosition));
HighestLeftBit32u HLB2(.a(init ? b_in : shiftInput[63:32]), .leftSh(b_LeftBitPosition));


assign nothingOnRes = shiftInput[63:32] == 32'b0;   // If the result is 0, there will be nothing on the remainder to account for the shifting,
assign LeftShifts = init ? ~a_LeftBitPosition + b_LeftBitPosition // so use the bit position of the quotient register if it's 
                         : nothingOnRes ? ~a_LeftBitPosition + divisorPosition // the case.
                                        : b_LeftBitPosition >= divisorPosition ? 5'b0
                                        : ~b_LeftBitPosition + divisorPosition;
assign Shift = outOfBoundsCount ? 5'd30 - count : LeftShifts;
assign pushedDividend = shiftInput << Shift;

// Output and start blocking in special case of dividend < quotient to single-cycle.
wire start;
wire DividendLowerDivisor;

assign  DividendLowerDivisor = a_in < b_in;
assign 	start = (DividendLowerDivisor ? 1'b0  : start_in);
assign 	q_out = (DividendLowerDivisor ? 32'b0 : reg_q);
assign 	r_out = (DividendLowerDivisor ? a_in  : reg_r);


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
		State = (count > 5'd30 ? Finish : Loop);

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
 if (!rstLow) divisorPosition <= 5'b0;
 else if (start_in) divisorPosition <= 5'b0;
      else if (init) divisorPosition <= b_LeftBitPosition;

always @(posedge clk or negedge rstLow)
 if (!rstLow) count <= 5'b0;
 else if (init) count <= Shift; // Load how many cycles have been saved at start.
      else if (busy) count <= count + (oneShiftLeft ? 2'b1
                                      : Shift + 2'b1);
           else count <= 5'b0;

always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_q <= 32'b0;
 else if (init) reg_q <= pushedDividend[31:0]; // Load 32LSB of the pushed dividend.
      else if (busy) reg_q <= oneShiftLeft ? shiftInput[31:0]
                                           : pushedDividend[31:0];

// reg_r operation load depends on the subtraction result sign, if its
// positive (partial remaining > divisor), load result; if neg, left shift.
always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_r <= 32'b0;
 else if (init) reg_r <= pushedDividend[63:32];
      else if (busy) reg_r <= oneShiftLeft ? shiftInput[63:32]
                                           : pushedDividend[63:32];
											 
endmodule