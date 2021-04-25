// Telecommunications Master Dissertation - Francis Fuentes 12-10-2020
// Outputs a unsigned number value equals to the first leftmost '1' position of the input value.


module HighestLeftBit32u(a, leftSh);

input	   [31:0] a;		// Input value.
output 	    [4:0] leftSh;	// Bit position of the leftmost '1' in unsigned format. [31:0] format.

// Wiring used to lower the resources required at the synthesization.
wire a3130, a2726, a2322, a1918, a1514, a1110, a0706, a0302;

assign a3130 = |a[31:30];
assign a2726 = |a[27:26];
assign a2322 = |a[23:22];
assign a1918 = |a[19:18];
assign a1514 = |a[15:14];
assign a1110 = |a[11:10];
assign a0706 = |a[7:6];
assign a0302 = |a[3:2];

wire a3128, a2320, a1512, a0704;

assign a3128 = a3130 | |a[29:28];
assign a2320 = a2322 | |a[21:20];
assign a1512 = a1514 | |a[13:12];
assign a0704 = a0706 | |a[5:4];

wire a3124, a1508;

assign a3124 = a3128 | |a[27:24];
assign a1508 = a1512 | |a[11:8];


// If "a" 16MSB has a one, leftSh[4] <= 0;
assign leftSh[4] = a3124 | a2320 | a1918 | |a[17:16];

// If leftSh[4] == 0, search in the 8MSB, if not, search 8MSB at a[15:0]
assign leftSh[3] = (leftSh[4] ? a3124
                          : a1508);

// Following the same procedure, section the operand "a" to find the highest '1'
assign leftSh[2] = (leftSh[4] 
                     ? (leftSh[3] 
                           ? a3128
                           : a2320) 
                     : (leftSh[3] 
                           ? a1512 
                           : a0704)
		  );

assign leftSh[1] = (leftSh[4] 
                     ? (leftSh[3] 
                           ? (leftSh[2] 
                                 ? a3130
                                 : a2726) 
                           : (leftSh[2] 
                                 ? a2322
                                 : a1918)
                       )
                     : (leftSh[3] 
                           ? (leftSh[2] 
                                 ? a1514
                                 : a1110) 
                           : (leftSh[2] 
                                 ? a0706
                                 : a0302)
                       )
		  );

assign leftSh[0] = (leftSh[4] 
                     ? (leftSh[3] 
                           ? (leftSh[2] 
                                 ? (leftSh[1]
                                       ? a[31]
                                       : a[29])
                                 : (leftSh[1]
                                       ? a[27]
                                       : a[25])
                             ) 
                           : (leftSh[2] 
                                 ? (leftSh[1]
                                       ? a[23]
                                       : a[21])
                                 : (leftSh[1]
                                       ? a[19]
                                       : a[17])
                             )
                       )
                     : (leftSh[3] 
                           ? (leftSh[2] 
                                 ? (leftSh[1]
                                       ? a[15]
                                       : a[13])
                                 : (leftSh[1]
                                       ? a[11]
                                       : a[9])
                                  ) 
                           : (leftSh[2] 
                                 ? (leftSh[1]
                                       ? a[7]
                                       : a[5])
                                 : (leftSh[1]
                                       ? a[3]
                                       : a[1])
                                  )
                          )
		  );

endmodule