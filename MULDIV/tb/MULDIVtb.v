// Telecommunications Master Dissertation - Francis Fuentes 10-10-2020
// Divider testbench between synthesizable HW model and Gold/reference model based on restoring design.

`timescale 1ns/1ns

module MULDIVtest();
reg [31:0] A;	// Dividend. A = B*q + r
reg [31:0] B;	// Divisor.
reg clk;	// Clock signal.
reg rstLow;	// Reset signal at low.
reg  [2:0] funct3; // Signal to command specific type MULDIV operation.
reg start;	// Start operation flag (load input operands).
integer i;	// Loop variable used to limit the number of test values.
integer j;

wire [31:0] Cg;	// Result of the reference model.
wire [31:0] C;	// Result of the synthesizable model.
wire busy;	// Operation ongoing flag.

// MULDIV type of operation.
parameter  MUL = 3'h0, // SxS 32LSB
	  MULH = 3'h1, // SxS 32MSB
	MULHSU = 3'h2, // SxU (rs1 x rs2) 32MSB
	 MULHU = 3'h3, // UxU 32MSB
	   DIV = 3'h4, // S/S quotient
	  DIVU = 3'h5, // U/U quotient
	   REM = 3'h6, // S/S remainder
	  REMU = 3'h7; // U/U remainder


// Load HW synthesizable model.
MULDIV MULDIV(.rs1(A),
	.rs2(B),
	.funct3(funct3),
	.start(start),
	.clk(clk),
	.rstLow(rstLow),
	.c_out(C),
	.busy(busy));

// Load reference model.
MULDIVgold MULDIVref(.a(A), 
		.b(B), 
		.funct3(funct3), 
		.c(Cg));


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
start <= 1'b0;
rstLow <= 1'b1;
funct3 <= 3'b0;
A <= 32'h0;
B <= 32'h0;

#25 rstLow <= 1'b0;
@(posedge clk) #25 rstLow <= 1'b1;

// *************************
// ** Specific value test **
// *************************
//
A = 32'd7;	// Specific dividend value.
B = -32'd2;	// Specific divisor value.
//B <=  32'h0;		// Uncomment to perform DIV by 0 test.
//A <=  32'h80000000;	// Uncomment to perform DIV overflow test.
//B <=  32'h00000001;	// Uncomment to perform DIV overflow test.
@(posedge clk) ;

for(i = 0; i < 8; i = i+1)
begin
 #25 funct3 <= i; 	// Comment to test one-cycle remainder.
// #25 funct3 <= 1+2*i; // Uncomment to test one-cycle remainder.
 start <= 1'b1;
 @(posedge clk) ;
 #25 start <= 1'b0;

// CheckMessage(C, Cg, clk, busy);
// Check if synthesizable and reference model differ results.
 @(posedge clk) if(busy) 	// If the operation is a division, the busy flag will go high, so wait to finish.
	begin 			// If is not a division (or it is but is a special case), busy shouldn't rise.
	 @(negedge busy); 
	 @(posedge clk); 	// Always leave a clock cycle to check the results.
	end
 #25;
 if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);

end

#200 $stop;	// Finish specific value testbench simulation.



// ***********************
// ** Random value test **
// ***********************
//
@(posedge clk) ;

for(i = 0; i < 1; i = i+1) // Change to perform many more random tests.
begin
 A <= ($random)%2147483648;
 B <= ($random)%2147483648;

 for(j = 0; j < 8; j = j + 1) // Do not touch. Possible limit should be 7 because of funct3.
 begin
  #25 funct3 <= j;
  start <= 1'b1;
  @(posedge clk) ;
  #25 start <= 1'b0;

// CheckMessage(C, Cg, clk, busy);
// Check if synthesizable and reference model differ results.
  @(posedge clk) if(busy) 	// If the operation is a division, the busy flag will go high, so wait to finish.
	begin 			// If is not a division (or it is but is a special case), busy shouldn't rise.
	 @(negedge busy); 
	 @(posedge clk); 	// Always leave a clock cycle to check the results.
	end
  #25;
  if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
 end
end

#200 $stop;	// Finish testbench simulation.
end

endmodule