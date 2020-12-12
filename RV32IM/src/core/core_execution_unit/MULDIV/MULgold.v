// Telecommunications Master Dissertation - Francis Fuentes 17-10-2020
// MUL gold (reference) model.

module MULgold(a_in, b_in, c_out);
input [31:0] a_in;
input [31:0] b_in;

output [63:0] c_out;

assign c_out = a_in * b_in;

endmodule