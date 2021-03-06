// Telecommunications Master Dissertation - Francis Fuentes 8-10-2020
// Divider gold (reference) model following a restoring design.

module DIVrestGold(a, b, unsignLow, q, r);
input 		[31:0] a; 	// Dividend
input 		[31:0] b; 	// Divisor
input		unsignLow;	// Signed when signal is high.

output reg	[31:0] q;	// Quotient
output reg	[31:0] r;	// Remainder

always @(*)
begin
	if(unsignLow) q = ($signed(a)/$signed(b));
	else q = (a/b);

	if(unsignLow) r = ($signed(a) - $signed(q)*$signed(b));
	else r = (a - (q*b));
end
endmodule