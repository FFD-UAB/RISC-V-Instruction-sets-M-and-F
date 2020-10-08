`timescale 1ns/1ns

module testDIV();
reg [31:0] A;
reg [31:0] B;
reg start;
reg clk;
reg rst;

wire [31:0] q;
wire [31:0] r;
wire [4:0] count;
wire busy;
wire ready;


DIVrest DIVrest(.a(A),
	.b(B),
	.start(start),
	.clk(clk),
	.rstlow(rst),
	.q(q),
	.r(r),
	.busy(busy),
	.ready(ready),
	.count(count));

always #50 clk = !clk;

initial
begin
clk <= 1'b0;
rst <= 1'b0;
start <= 0'b0;

A <= 32'h80000000 + 32'h3;
B <= 32'h10000000;

#50 rst <= 1'b1;
#75 start <= 1'b1;
#200
A <= 32'd500 +32'd3;
B <= 32'd20;
#6400 $stop;
end

endmodule