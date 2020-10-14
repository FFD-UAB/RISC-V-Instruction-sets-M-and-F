// Telecommunications Master Dissertation - Francis Fuentes 11-10-2020
// Testbench for the positive integer Normalization circuit. Doesn't require gold model as
// is simple to see that is working properly.

`timescale 1ns/1ns

module NormTB();
reg  [31:0] A;
wire [31:0] B;
wire [4:0]  LShift;
reg start;
reg clk;
reg rst;
reg  [5:0]  i;

wire busy;

// NormP32 NormP32(.a(A), .b(B), .leftSh(LShift), .start(start), .clk(clk), .rstlow(rst), .busy(busy));
Normal32u Normal32u(.a(A), .b(B), .leftSh(LShift));

always #50 clk = !clk;

initial
begin
clk <= 1'b0;
rst <= 1'b1;
start <= 0'b0;

A <= 32'h0;

#50 rst <= 1'b0;
#50 rst <= 1'b1;
#75 start <= 1'b1;
#100 start <= 1'b0;

A <= 32'h1;

#700

for(i = 0; i<30; i = i+1)
begin
A <= (A << 1);
start <= 1'b1;
#100 start <= 1'b0;

// wait (!busy);	//Used for sequential test.
if(!B[31]) $display("Found 0X..X at time %0t", $realtime);

end
#200 $stop;
end

endmodule
