// Telecommunications Master Dissertation - Francis Fuentes 17-10-2020
// MULDIV gold (reference) model.

module MULDIVgold(a, b, funct3, c);
input 	[31:0] a; 	// 
input 	[31:0] b; 	// 
input	 [2:0] funct3;	// 

output 	[31:0] c;	// 

wire f2, f1, f0;
assign f2 = funct3[2];
assign f1 = funct3[1];
assign f0 = funct3[0];

wire [63:0] res;
assign res = outputSel(a, b, funct3);

	// Only when MULH, MULHSU and MULHU, the output is 32MSB
assign c = (!f2 & |{f1, f0} ? res[63:32] : res[31:0]);

function [63:0] outputSel;
 input [31:0] a, b;
 input [2:0] sel;

// By default, Verilog multiplication takes the operands as unsigned,
// but unsigned X signed returns a unsigned value, contrary to the real deal,
// so the unsigned operand has to be taken as signed in the MULSHU.
 case (sel)
// MUL outputs.
  3'h0: outputSel = $signed(a)*$signed(b); 	// MUL LSB signed.
  3'h1: outputSel = $signed(a)*$signed(b);	// MULH MSB signed.
  3'h2: outputSel = $signed(a)*$signed({1'b0, b}); // MULHSU MSB unsigned x signed.
  3'h3: outputSel = a*b; 	// MULHU MSB unsigned.
// DIV outputs.
  3'h4: if(b == 32'b0) outputSel = 32'hFFFFFFFF;
	else outputSel = $signed(a)/$signed(b);	// DIV Quotient signed.
  3'h5: if(b == 32'b0) outputSel = 32'hFFFFFFFF;
	else outputSel = a/b;  // DIVU Quotient unsigned.
  3'h6: if(b == 32'b0) outputSel = a;
	else outputSel = $signed(a) - ($signed(a)/$signed(b))*$signed(b); // REM Remainder signed.
  3'h7: if(b == 32'b0) outputSel = a;
	else outputSel = a - (a/b)*b; 	// REMU Remainder unsigned.
 endcase
endfunction

endmodule