// Telecommunications Master Dissertation - Francis Fuentes 27-05-2021
// Outputs a unsigned number value equals to the first leftmost '1' position of the input value.

module HighestLeftBit48u(a, leftSh);

input	   [47:0] a;      // Input value.
output 	    [5:0] leftSh; // Bit position of the leftmost '1' in unsigned format. [47:0] format.

//       \                                                            a bit position
// leftSh | 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
// bit 0  | AA    BB    CC    DD    EE    FF    GG    HH    II    JJ    KK    LL    MM    NN    OO    PP    QQ    RR    SS    TT    UU    VV    WW    XX
// bit 1  | AA AA       BB BB       CC CC       DD DD       EE EE       FF FF       GG GG       HH HH       II II       JJ JJ       KK KK       LL LL
// bit 2  | AA AA AA AA             BB BB BB BB             CC CC CC CC             DD DD DD DD             EE EE EE EE             FF FF FF FF
// bit 3  | AA AA AA AA AA AA AA AA                         BB BB BB BB BB BB BB BB                         CC CC CC CC CC CC CC CC
// bit 4  |                                                 AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA
// bit 5  | AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA 
//

// Wiring used to lower the resources required at the synthesization.
wire a4746, a4342, a3938, a3534, a3130, a2726, a2322, a1918, a1514, a1110, a0706, a0302;

assign a4746 = |a[47:46];
assign a4342 = |a[43:42];
assign a3938 = |a[39:38];
assign a3534 = |a[35:34];
assign a3130 = |a[31:30];
assign a2726 = |a[27:26];
assign a2322 = |a[23:22];
assign a1918 = |a[19:18];
assign a1514 = |a[15:14];
assign a1110 = |a[11:10];
assign a0706 = |a[7:6];
assign a0302 = |a[3:2];

wire a4744, a3936, a3128, a2320, a1512, a0704;

assign a4744 = a4746 | |a[45:44];
assign a3936 = a3938 | |a[37:36];
assign a3128 = a3130 | |a[29:28];
assign a2320 = a2322 | |a[21:20];
assign a1512 = a1514 | |a[13:12];
assign a0704 = a0706 | |a[5:4];

wire a4740, a3124, a1508;

assign a4740 = a4744 | a4342 | |a[41:40];
assign a3124 = a3128 | a2726 | |a[25:24];
assign a1508 = a1512 | a1110 | |a[9:8];

wire a4732;

assign a4732 = a4740 | a3936 | a3534 | |a[33:32];


assign leftSh[5] = a4732;

assign leftSh[4] = a3124 | a2320 | a1918 | |a[17:16];

assign leftSh[3] = leftSh[5] ? a4740 :
                   leftSh[4] ? a3124 : a1508;

// leftSh | 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
// bit 2  | AA AA AA AA             BB BB BB BB             CC CC CC CC             DD DD DD DD             EE EE EE EE             FF FF FF FF
assign leftSh[2] = leftSh[5] 
                   ? leftSh[3] 
                     ? a4744
                     : a3936
                   : leftSh[4]
                     ? leftSh[3] 
                       ? a3128
                       : a2320
                     : leftSh[3] 
                       ? a1512 
                       : a0704;

// leftSh | 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
// bit 1  | AA AA       BB BB       CC CC       DD DD       EE EE       FF FF       GG GG       HH HH       II II       JJ JJ       KK KK       LL LL
assign leftSh[1] = leftSh[5]
                   ? leftSh[3]
                     ? leftSh[2]
                       ? a4746
                       : a4342
                     : leftSh[2]
                       ? a3938
                       : a3534
                   : leftSh[4] 
                     ? leftSh[3] 
                       ? leftSh[2] 
                         ? a3130
                         : a2726 
                       : leftSh[2] 
                         ? a2322
                         : a1918
                     : leftSh[3] 
                       ? leftSh[2] 
                         ? a1514
                         : a1110
                       : leftSh[2] 
                         ? a0706
                         : a0302;

// leftSh | 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
// bit 0  | AA    BB    CC    DD    EE    FF    GG    HH    II    JJ    KK    LL    MM    NN    OO    PP    QQ    RR    SS    TT    UU    VV    WW    XX
assign leftSh[0] = leftSh[5]
                   ? leftSh[3]
                     ? leftSh[2]
                       ? leftSh[1]
                         ? a[47]
                         : a[45]
                       : leftSh[1]
                         ? a[43]
                         : a[41]
                     : leftSh[2]
                       ? leftSh[1]
                         ? a[39]
                         : a[37]
                       : leftSh[1]
                         ? a[35]
                         : a[33]
                   : leftSh[4]
                     ? leftSh[3]
                       ? leftSh[2]
                         ? leftSh[1]
                           ? a[31]
                           : a[29]
                         : leftSh[1]
                           ? a[27]
                           : a[25]
                       : leftSh[2]
                         ? leftSh[1]
                           ? a[23]
                           : a[21]
                         : leftSh[1]
                           ? a[19]
                           : a[17]
                     : leftSh[3]
                       ? leftSh[2]
                         ? leftSh[1]
                           ? a[15]
                           : a[13]
                         : leftSh[1]
                           ? a[11]
                           : a[9]
                       : leftSh[2]
                         ? leftSh[1]
                           ? a[7]
                           : a[5]
                         : leftSh[1]
                           ? a[3]
                           : a[1];

endmodule