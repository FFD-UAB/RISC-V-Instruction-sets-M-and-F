// Telecommunications Master Dissertation - Francis Fuentes 9-11-2020
// Divider HW model following a restoring design for unsigned inputs.
// Normal operation includes maintaining the results until there's a synchronous start pulse signal.
// This double skip execution version mixes the skip execution version with the double, making an
// upgraded version of the deqs without adding too much logic. The only inconvinient is that the 
// loop phase of this model has two subtractor units plus the "skip execution" algorithm (the 
// shifter), which reduces further the maximum frequency of opertation.

module dseDIVrest32u(a_in, b_in, start_in, clk, rstLow, q_out, r_out, busy);
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
reg      [4:0] count;	// Iteration counter.
reg            init;	// Initialize control signal (counter, registers, etc).
wire           oneShiftLeft;

assign oneShiftLeft = count > 6'd30;

// Intern results signals.
wire 	[32:0] res1;	// Combinational subtraction result for next iteration.
wire    [32:0] res2;
wire    [31:0] finalRes;// Returns de correct result depending over the sub modules results.
assign         res1 = {reg_r[31:0], reg_q[31]} - {1'b0, b_in};
  // The second subtract unit takes the first result if it's positive, as the partial remainder
  // has to be descounted by the divisor once. But as the second sub unit works at a lower order,
  // loads it left shifted once.
assign         res2 = res1[32] ? {reg_r[30:0], reg_q[31:30]} - {1'b0, b_in}
                               : {res1[31:0],  reg_q[30]}    - {1'b0, b_in};

  // As there's two subtractor units but the second loads from the first if necessary,
  // here's only needed to apply: (1) if neither of both has a positive result, load next
  // shift; (2) if the second has a positive result (it will get the correct input depending
  // over the first result), load result from the second subtractor; (3) if the second doesn't
  // have a positive but the first does, load the result from the first subtractor.
assign         finalRes = (res2[32] ? (res1[32] ? {reg_r[29:0], reg_q[31:30]} 
                                                : {res1[30:0], reg_q[30]})
                                    : res2[31:0]);

// Compute how many left shifts are required to start the division early or during execution.
wire     [4:0] a_LeftBitPosition;
wire     [4:0] b_LeftBitPosition;
wire    [63:0] shiftInput;      // Operand input for the shifting. Dividend on the start, during the operation is
wire    [63:0] pushedDividend;  // Output of the shifting.                           {result, reg q, !sign result}
wire     [4:0] LeftShifts;      // Number of shifts to perform.
reg      [4:0] divisorPosition; // Bit position of the divisor.
wire           northingOnRes;
wire           outOfBoundsCount; // When the operation is finishing, if the shift to perform will overflow the iteration count,
                                 // execute normal operation and don't use the shifting mid-operation ability.
wire           performShift;

assign outOfBoundsCount = ({1'b0, LeftShifts} + count) >= 5'd30; // Because is double (32-2)
assign performShift = !(res1[32] | res2[32] | outOfBoundsCount);


// Find at what bit position is the first 1 on start (init=1) and during operation (init=0).
HighestLeftBit32u HLB1(.a(init ? a_in : reg_q),    .leftSh(a_LeftBitPosition));
HighestLeftBit32u HLB2(.a(init ? b_in : finalRes), .leftSh(b_LeftBitPosition));


assign northingOnRes = ~|finalRes; // If the result is 0, there will be nothing on the remainder to account for the shifting,
assign LeftShifts = init ? ~a_LeftBitPosition + b_LeftBitPosition // so use the bit position of the quotient register if it's 
                         : (northingOnRes ? ~a_LeftBitPosition + divisorPosition - 3'd2 // the case.
                                          : ~b_LeftBitPosition + divisorPosition);
assign shiftInput = init ? a_in : {finalRes[31:0], reg_q[29:0], !res1[32], !res2[32]}; // Not only dividend, but also
assign pushedDividend = shiftInput << LeftShifts; // as the maximum number of leftshift is 31 if special cases are pre-managed.

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
		State = (count > 6'd29 ? Finish : Loop);

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
 else if (init) count <= LeftShifts; // Load how many cycles have been saved.
      else if (busy) count <= oneShiftLeft ? count + 2'b1 
                                           : count + 3'd2 + (performShift ? LeftShifts : 1'b0);
           else count <= 6'b0;

 // Because the dividend shifts two positions each cycle, the last cycle can overflow
 // the counter (do an extra shift). To avoid that, the control signal oneShiftLeft is used.
always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_q <= 32'b0;
 else if (init) reg_q <= pushedDividend[31:0]; // Load 32LSB of the pushed dividend.
      else if (busy) reg_q <= oneShiftLeft ? {reg_q[30:0], !res1[32]}
                                           : performShift ? pushedDividend[31:0]
                                                          : {reg_q[29:0], !res1[32], !res2[32]};

always @(posedge clk or negedge rstLow)
 if (!rstLow) reg_r <= 32'b0;
 else if (init) reg_r <= pushedDividend[63:32];
      else if (busy) reg_r <= oneShiftLeft ? (res1[32] ? {reg_r[30:0], reg_q[31]}
                                                       : outOfBoundsCount ? res1[31:0]
                                                                          : pushedDividend[63:32])
                                           : performShift ? pushedDividend[63:32]
                                                          : finalRes;

endmodule