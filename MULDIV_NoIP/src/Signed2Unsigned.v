// Telecommunications Master Dissertation - Francis Fuentes 23-10-2020
//*******************************
//** Signed to Unsigned module **
//*******************************
// Signed-to-Unsigned (input).
// Change to positive only if negative.

module Signed2Unsigned(a_signed, a_unsigned);
input  [31:0] a_signed;
output [31:0] a_unsigned;

assign a_unsigned = (a_signed[31] ? (1 + ~a_signed) 
                                  : a_signed);

endmodule