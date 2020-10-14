// Telecommunications Master Dissertation - Francis Fuentes 11-10-2020
// Normalize circuit for positive integers.
// Maximum number of clock cycles it takes is 6 for worst case scenario (a = 0..01),
// and minimum is 1 clock cycle (a = 0 or a = 1X..X).

module NormP32(a, b, leftSh, start, clk, rstlow, busy);

input 	   [31:0] a;		// Integer to normalize.
output reg [31:0] b;
output reg [4:0]  leftSh;	// Number of LeftShifts performed to normulize.
input		  start;	// Initialization signal, must last only one posedge clk.
input		  clk;		// Clock signal.
input		  rstlow;	// Reset signal at low.
output reg	  busy;		// Signal that goes low when the operation is done.


always @(posedge clk or negedge rstlow)
begin
// Module initialization.
if(!rstlow) begin
	b  <= 32'b0;
	leftSh <= 5'b0;
	busy   <= 1'b0;
end else if(start) begin
	b  <= a;
	leftSh <= 5'b0;
	busy   <= 1'b1;
end else

// 0-value input verification and finish operation.
if(b == 32'b0) 	busy <= 0'b0;
else begin	busy <= !b[31];

// LeftShifts by 16, 8, 4, 2 or 1 each clock cycle.
if(b[31] == 1'b0)
	if(|b[31:16] == 1'b0) begin
		b = b << 16;
		leftSh <= 5'd16;
	end else 
	if(|b[31:24] == 1'b0) begin
		b = b << 8;
		leftSh <= leftSh + 5'd8;
	end else
	if(|b[31:28] == 1'b0) begin
		b = b << 4;
		leftSh <= leftSh + 5'd4;
	end else
	if(|b[31:30] == 1'b0) begin
		b = b << 2;
		leftSh <= leftSh + 5'd2;
	end else
	if(b[31] == 1'b0) begin
		b = b << 1;
		leftSh <= leftSh + 5'b1;
	end
end
end


endmodule