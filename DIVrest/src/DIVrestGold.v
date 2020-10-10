// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider gold (reference) model following a restoring design.

module DIVrestGold(a, b, q, r);
input 		[31:0] a; 	// Dividend
input 		[31:0] b; 	// Divisor

output reg	[31:0] q;	// Quotient
output reg	[31:0] r;	// Remainder

always @(*)
begin
	q = (a/b);
	r = (a - (q*b));
end
endmodule