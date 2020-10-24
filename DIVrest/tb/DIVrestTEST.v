// Telecommunications Master Dissertation - Francis Fuentes 10-10-2020
// Divider testbench between synthesizable HW model and Gold/reference model based on restoring design.

`timescale 1ns/1ns

module testDIV();
reg [31:0] A;	// Dividend. A = B*q + r
reg [31:0] B;	// Divisor.
reg clk;	// Clock signal.
reg rstLow;	// Reset signal at low.
reg unsignLow;	// Signed inputs flag when high.
reg start;	// Start operation flag (load input operands).
integer i;	// Loop variable used to limit the number of test values.

wire [31:0] qG;	// Quotient result of the reference model.
wire [31:0] rG;	// Remainder result of the reference model.
wire [31:0] q;	// Quotient result of the synthesizable model.
wire [31:0] r;	// Remainder result of the synthesizable model.
wire busy;	// Operation ongoing flag.


// Load synthesizable model.
/*DIVnewt32 DIVnewt32(.a_in(A),
	.b_in(B),
	.unsignLow(unsignLow),
	.start(start),
	.busy(busy),
	.clk(clk),
	.rstlow(rst),
	.q_out(q),
	.r_out(r)); */

qsDIVrest32u DIV(.a_in(A),
	.b_in(B),
	.start_in(start),
	.clk(clk),
	.rstLow(rstLow),
	.q_out(q),
	.r_out(r),
	.busy(busy));


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
rstLow <= 1'b1;
unsignLow = 1'b0;

//unsignLow <= 1'b1;	// Uncoment for signed test or comment for unsigned test.


// *************************
// ** Specific value test **
// *************************
//
A <= 32'h80000001;	// Specific dividend value.
B <= 32'h00000002;	// Specific divisor value.

#50 rstLow <= 1'b0;
@(posedge clk) rstLow <= 1'b1;

#25 start <= 1'b1;
@(posedge clk) ;
#25 start <= 1'b0;

// Check if synthesizable and reference model differ results.
@(negedge busy) #25;
if (qG != q) $display("Error quotient qG = %h and q = %h, initial values are A = %h and B = %h at %0t ns", qG, q, A, B, $realtime);
if (rG != r) $display("Error remainder rG = %h and r = %h, initial values are A = %h and B = %h, at %0t ns", rG, r, A, B, $realtime);
@(posedge clk) ;

// ***********************
// ** Random value test **
// ***********************
//
for(i=0; i<80; i = i+1)
begin
 #25;
 A = (unsignLow ? ($unsigned($random))%4294967295  // unsigned(2^32 - 1) random dividend.
	        : ($random)%4294967295);	   // signed(2^32 - 1) random dividend.
 B = (unsignLow ? ($unsigned($random))%4294967295  // unsigned(2^32 - 1) random divisor.
	        : ($random)%4294967295);	   // signed(2^32 - 1) random divisor.


 start <= 1'b1;
 @(posedge clk) ;
 #25 start <= 1'b0;

 // Check if synthesizable and reference model differ results.
 @(posedge clk) if (busy) @(negedge busy);
 #25;
 if (qG != q) $display("Error quotient qG = %h and q = %h, initial values are A = %h and B = %h at %0t ns", qG, q, A, B, $realtime);
 if (rG != r) $display("Error remainder rG = %h and r = %h, initial values are A = %h and B = %h, at %0t ns", rG, r, A, B, $realtime);
 @(posedge clk) ;
end

#200 $stop;	// Finish testbench simulation.
end

endmodule