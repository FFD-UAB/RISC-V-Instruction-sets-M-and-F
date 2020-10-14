// Telecommunications Master Dissertation - Francis Fuentes 10-10-2020
// Divider testbench between synthesizable HW model and Gold/reference model based on restoring design.

`timescale 1ns/1ns

module testDIV();
reg [31:0] A;	// Dividend. A = B*q + r
reg [31:0] B;	// Divisor.
reg clk;	// Clock signal.
reg rst;	// Reset signal at low.
reg unsignLow;	// Signed inputs flag when high.
reg [5:0] count;// Iteration counter
integer i;	// Loop variable used to limit the number of test values.

wire [31:0] qG;	// Quotient result of the reference model.
wire [31:0] rG;	// Remainder result of the reference model.
wire [31:0] q;	// Quotient result of the synthesizable model.
wire [31:0] r;	// Remainder result of the synthesizable model.


// Load synthesizable model.
DIVrest DIVrest(.a_in(A),
	.b_in(B),
	.unsignLow(unsignLow),
	.count(count),
	.clk(clk),
	.rstlow(rst),
	.q_out(q),
	.r_out(r));

// Load reference model.
DIVrestGold DIVrestGold(.a(A), .b(B), .unsignLow(unsignLow), .q(qG), .r(rG));


// *********************
// ** Testbench logic **
// *********************
//

// Fix the simulation clock frequency at 10 MHz (100 ns).
always #50 clk = !clk;

initial
begin
// Initialization of the clock, reset, counter and signed indicator signals.
clk <= 1'b0;
rst <= 1'b1;
count <= 6'b0;
unsignLow = 1'b0;

unsignLow <= 1'b1;	// Uncoment for signed test or comment for unsigned test.


// *************************
// ** Specific value test **
// *************************
//
A <= 32'h88000000;	// Specific dividend value.
B <= 32'h11000000;	// Specific divisor value.

// Tempo management using the counter register for the synthesizable model.
for(count = 0; count<32;)
	@(posedge clk)  count = count + 1;
@(posedge clk) count <= 5'b0;

// Check if synthesizable and reference model differ results.
if (qG != q) $display("Error quotient qG = %h and q = %h, initial values are A = %h and B = %h at %0t ns", qG, q, A, B, $realtime);
if (rG != r) $display("Error remainder rG = %h and r = %h, initial values are A = %h and B = %h, at %0t ns", rG, r, A, B, $realtime);


// ***********************
// ** Random value test **
// ***********************
//
for(i=0; i<200; i = i+1)
begin


A = (unsignLow ? ($unsigned($random))%4294967295  // unsigned(2^32 - 1) random dividend.
	       : ($random)%4294967295);		  // signed(2^32 - 1) random dividend.
B = (unsignLow ? ($unsigned($random))%4294967295  // unsigned(2^32 - 1) random divisor.
	       : ($random)%4294967295);		  // signed(2^32 - 1) random divisor.

// Tempo management using the counter register for the synthesizable model.
for(count = 0; count<32;)
	@(posedge clk)  count = count + 1;
@(posedge clk) count <= 5'b0;

// Check if synthesizable and reference model differ results.
if (qG != q) $display("Error quotient qG = %h and q = %h, initial values are A = %h and B = %h at %0t ns", qG, q, A, B, $realtime);
if (rG != r) $display("Error remainder rG = %h and r = %h, initial values are A = %h and B = %h, at %0t ns", rG, r, A, B, $realtime);

end

#200 $stop;	// Finish testbench simulation.
end

endmodule