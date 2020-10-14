// Telecommunications Master Dissertation - Francis Fuentes 12-10-2020
// Normalize combinational circuit for 32-bit unsigned.
// It might be too much for a just combinational and maybe require two register and
// a clock cycle, but this has to be seen at the synthetization phase.
// With an input a = 0, b = 0 and leftSh = h1F.

module Normal32u(a, b, leftSh);

input	   [31:0] a;		// Integer to normalize.
output     [31:0] b;		// Normalized integer.
output 	   [4:0]  leftSh;	// Number of LeftShifts performed to normulize.


// If "a" 16MSB has a one, leftSh[4] <= 0;
assign leftSh[4] = ~|a[31:16];

// If leftSh[4] == 0, search in the 8MSB, if not, search 8MSB at a[15:0]
assign leftSh[3] = (!leftSh[4] ? ~|a[31:24] 
			     : ~|a[15:8]);
// Following the same procedure, section the operand "a" to find the highest '1'
assign leftSh[2] = (!leftSh[4] 
			? (!leftSh[3] 
				? ~|a[31:28] 
				: ~|a[23:20]) 
			: (!leftSh[3] 
				? ~|a[15:12] 
				: ~|a[7:4])
		  );

assign leftSh[1] = (!leftSh[4] 
			? (!leftSh[3] 
				? (!leftSh[2] 
					? ~|a[31:30]
					: ~|a[27:26]) 
				: (!leftSh[2] 
					? ~|a[23:22]
					: ~|a[19:18])
			  )
			: (!leftSh[3] 
				? (!leftSh[2] 
					? ~|a[15:14]
					: ~|a[11:10]) 
				: (!leftSh[2] 
					? ~|a[7:6]
					: ~|a[3:2])
			  )
		  );

assign leftSh[0] = (!leftSh[4] 
			? (!leftSh[3] 
				? (!leftSh[2] 
					? (!leftSh[1]
						? !a[31]
						: !a[29])
					: (!leftSh[1]
						? !a[27]
						: !a[25])
				  ) 
				: (!leftSh[2] 
					? (!leftSh[1]
						? !a[23]
						: !a[21])
					: (!leftSh[1]
						? !a[19]
						: !a[17])
				  )
			  )
			: (!leftSh[3] 
				? (!leftSh[2] 
					? (!leftSh[1]
						? !a[15]
						: !a[13])
					: (!leftSh[1]
						? !a[11]
						: !a[9])
				  ) 
				: (!leftSh[2] 
					? (!leftSh[1]
						? !a[7]
						: !a[5])
					: (!leftSh[1]
						? !a[3]
						: !a[1])
				  )
			  )
		  );

assign b = a << leftSh;

endmodule