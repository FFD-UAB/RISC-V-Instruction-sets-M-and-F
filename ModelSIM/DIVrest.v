// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider gold (reference) model following a restoring design.
//
// This algoritm takes into account that a start signal might be
// high all the time (requesting to do new operation), as this HD
// ignores the start signal until the ongoing operation is finished 
// (busy goes to low), then for the next clock cycle (leaving a 
// timeframe to take the results from the previous operation), 
// rises the signal ready or doesn't and continue with the next
// operands if the start signal is still high. Also, the operands
// A and B are only taken at that same particular moment.

module DIVrest(a,b,start,clk,rstlow,q,r,busy,ready, count);
input		[31:0] a; 	// Dividend
input		[31:0] b; 	// Divisor
input		start;		// Start signal, should be '1' only for one posedge clk
input		clk;		// Clock signal
input 		rstlow;		// Reset signal at low

output		[31:0] q;
output		[31:0] r;
output reg	busy;
output reg	ready;
output reg	[4:0]  count;	// Iteration counter

reg		[31:0] reg_q;	// Dividend register that ends with the quotient
reg		[31:0] reg_r;	// Remainder or partial remainder
reg		[31:0] reg_b;
		// Combinational result of subtraction
wire		[32:0] res = {reg_r[31:0], reg_q[31]} - {1'b0, reg_b};
		// Multiplexors to reg_r and reg_q
wire 		[32:0] MUXa = (start & !busy 	? a 				: {reg_q[30:0], !res[32]});
wire 		[32:0] MUXb = (res[32] 		? {reg_r[30:0], reg_q[31]}	: res[31:0]);

assign 		q = reg_q;
assign		r = reg_r;

always @ (posedge clk or negedge rstlow)
begin
	if (!rstlow) begin
		busy  <= 1'b0;
		ready <= 1'b0;
		count <= 1'b0;
		reg_q <= 1'b0;
		reg_r <= 1'b0;
		reg_b <= 1'b0;
	end else 
	
	if (start & !busy) begin 	// Preparation phase
		reg_b <= b;
		reg_q <= a;
		reg_r <= 32'b0;
		busy  <= 1'b1;
		ready <= 1'b0;
		count <= 5'b0;
	end

	if (busy) begin			//Loop phase
	// Next iteration
		count <= count + 5'b1;

	// Load in dividend register the dividend only at
	// the first iteration (start=1). For other 
	// iterations, << once pushing in not(negative bit
	// of the subtraction result).
		reg_q <= MUXa;
	// If the subtraction results is negative, load
	// in remainder register next shift. If is 
	// positive, load the result.
		reg_r <= MUXb;
		
	//Out of loop
		if (count == 5'd31)	//Finish phase
			busy <= 1'b0;
	end
	
	// In this way, there's a clock cycle free between
	// the busy lowering signal and the rising ready 
	// signal, to leave 1 cycle to take the results.
	if (!busy & !start) begin	//Ready for next operation
		ready <= 1'b1;
		count <= 5'b0;
	end
end
endmodule