// Telecommunications Master Dissertation - Francis Fuentes 10-10-2020
// Divider testbench between HW and Gold based on restoring design.
// Is normal that an error to appear, as the HW model requires to load the initial values once, putting busy on low and therefore triggering
// the false error. The error in question is "Error quotient qG = 00000008 and q = 80000000, initial values are A = 80000000 and B = 10000000"
`timescale 1ns/1ns

module testDIV();
reg [31:0] A;
reg [31:0] B;
reg start;
reg clk;
reg rst;
reg [7:0] i;

wire [31:0] qG;
wire [31:0] rG;
wire [31:0] q;
wire [31:0] r;
wire [4:0] count;
wire busy;


DIVrest DIVrest(.a(A),
	.b(B),
	.start(start),
	.clk(clk),
	.rstlow(rst),
	.q(q),
	.r(r),
	.busy(busy),
	.count(count));

DIVrestGold DIVrestGold(.a(A), .b(B), .q(qG), .r(rG));

always #50 clk = !clk;

	// Check when busy goes low if HW and Golden have the same quotient and remainder results.
always @(negedge busy)
	if(qG != q) $display("Error quotient qG = %h and q = %h, initial values are A = %h and B = %h", qG, q, A, B);
	else if (rG != r) $display("Error remainder rG = %h and r = %h, initial values are A = %h and B = %h", rG, r, A, B);

initial
begin
clk <= 1'b0;
rst <= 1'b1;
start <= 0'b0;

A <= 32'h80000000;
B <= 32'h10000000;

#50 rst <= 1'b0;
#50 rst <= 1'b1;
#75 start <= 1'b1;

#3450

for(i=0; i<255; i = i+1)
begin
A = $unsigned($random)%4294967295;
B = $unsigned($random)%65536;
#3400;
end
#3600 $stop;
end

endmodule