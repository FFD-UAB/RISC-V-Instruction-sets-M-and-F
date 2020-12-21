// Telecommunications Master Dissertation - Francis Fuentes 16-12-2020
// 32-bit FP testbench for F.ADD and F.SUB operations.

`timescale 1ns/1ns
`include "../src/defines.vh"

module tbADDSUB();
reg [31:0] A;     // 32-bit FP value.
reg [31:0] B;     // 32-bit FP value.
reg clk;	      // Clock signal.
reg rstLow;	      // Reset signal at low.
reg SUBflag;      // SUB operation when high. rs1 - rs2
reg  [2:0] frm;   // Floating Rounding Mode.
reg start;

integer i, j;	// Loop variable used to limit the number of test values.
integer k;      // Loop variable used to apply different divisor widths in the random test.
integer seed;   // Random starting seed.
integer totalClockCycles; // How many cycles has taken the random test.


reg  [31:0] Cg;	// Result of the reference model.
wire [31:0] C;	// Result of the synthesizable model.
wire  [4:0] fflags;// FCSR flags.
wire busy;	// Operation ongoing flag.

// Floating Rounding Mode bits
/*         `FRM_RNE = 3'b000, // Round to Nearest, ties to Even
           `FRM_RTZ = 3'b001, // Rounds towards Zero
           `FRM_RDN = 3'b010, // Rounds Down (towards -inf)
           `FRM_RUP = 3'b011, // Rounds Up (towards +inf)
           `FRM_RMM = 3'b100; // Round to Nearest, ties to Max Magnitude */


// Load HW synthesizable model.
ADDSUB_FPs FsADDSUB(
        .rs1_i     ( A       ), 
        .rs2_i     ( B       ), 
        .SUBflag_i ( SUBflag ), 
        .frm_i     ( frm     ), 
        .c_o       ( C       ), 
        .fflags_o  ( fflags  )
        );


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
frm <= 3'b0;
SUBflag <= 1'b0;
A <= 32'h0;
B <= 32'h0;

#25 rstLow <= 1'b0;
@(posedge clk) #25 rstLow <= 1'b1;

// *************************
// ** Specific value test **
// *************************
//
A = 32'h0;
B = 32'h0;
Cg = 32'h0;
@(posedge clk) ;

 start <= 1'b1;
 @(posedge clk) ;
 #25 start <= 1'b0;

// Subnormal operation test (input exponents = 0)

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00200000;
B = 32'h0;
Cg = 32'h00200000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00200000;
B = 32'h00200000;
Cg = 32'h00400000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00200000;
B = 32'h00400000;
Cg = 32'h00600000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00400000;
B = 32'h00200000;
Cg = 32'h00600000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00400000;
B = 32'h00400000;
Cg = 32'h00800000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

// Floating point test (input exponents != 0)

A = 32'h00800000;
B = 32'h00800000;
Cg = 32'h01000000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h00808000;
B = 32'h00804000;
Cg = 32'h01006000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h12345678;
B = 32'h87654321;
Cg = 32'h12345674;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

A = 32'h08010000;
B = 32'h88000000;
Cg = 32'h04800000;
@(posedge clk) #50;

if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#100;

/////////////////////////////////////////
// Rounding modes, Inf and fflags test //
/////////////////////////////////////////

frm <= 3'b0; // Round to Nearest, ties to Even
A = 32'h7f7fffff;
B = 32'h737fffff;  // 0|111 rounding bits respect A
Cg = 32'h7f800000; // Inf

#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'd3; // Round to +Inf
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'd1; // Round to Zero
A = 32'h7f7fffff;
B = 32'h737fffff;  // 0|111 rounding bits respect A
Cg = 32'h7f7fffff; // at +1 to +Inf

#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'd2; // Round to -Inf
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'b0; // Round to Nearest, ties to Even
A = 32'hff7fffff; // at -1 of -Inf
B = 32'hf2000000; // -0|001 at the rounding bits respect A
Cg = 32'hff7fffff; // at -1 of -Inf because frm
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'b1; // Round to Zero
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'd3; // Round to +Inf
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

frm <= 3'd2; // Round to -Inf
Cg = 32'hff800000; // -Inf because frm
#50;
if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
#50;

#100 $stop;

/*

// ***********************
// ** Random value test **
// ***********************
//
for(k = 31; k != 0; k = k-1)
begin
totalClockCycles = 0;
seed = 11037;
@(posedge clk) ;


for(i = 0; i < 10; i = i+1) // Change to perform many more random tests.
begin
 A <= ($random(seed))%2**31; // This command outputs a signed value below the %value in abs.
 B <= ($random(seed))%2**k;


 for(j = 0; j < 8; j = j + 1) // (j = 0; j < 8; j = j + 1) to test every funct3 type.
 begin
  #25 funct3 <= j;
//  #25 funct3 <= 4+2*j;      // Comment line above and uncomment this one to test oneCycleRemainder system. Also, adjust j in the for to j<2.
  start <= 1'b1;
  @(posedge clk);
  #25 start <= 1'b0;
  #25;

  // Count one more even if the division operation was a "dividend < divisor" case (no busy flag).
  if(busy) while(busy) @(posedge clk) totalClockCycles = totalClockCycles + 1;
  else totalClockCycles = totalClockCycles + 1;

  @(posedge clk); // Always leave a clock cycle to check the results.
  #25;
  // Check if synthesizable and reference model differ results.
  if (Cg != C) $display("Error Cg = %h and C = %h, initial values are A = %h and B = %h at %0t ns", Cg, C, A, B, $realtime);
 end
end

//$display("FINISH: This model has taken %d clock cycles to finish the %d divisor width random test", totalClockCycles, k+1);
$display("%d     %d", totalClockCycles, k+1);
end

#100 $stop;	// Finish testbench simulation.
*/
end

endmodule