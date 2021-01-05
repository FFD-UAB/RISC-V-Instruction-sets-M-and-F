`timescale 1ns/1ps
`include "../../defines.vh"

module reg_file_f
        (
        clk,
        regfile_we_i,
        regfile_raddr_rs1_i,
        regfile_raddr_rs2_i,
        regfile_raddr_rs3_i,
        regfile_waddr_i,
        regfile_data_i,
        regfile_rs1_o,
        regfile_rs2_o,
        regfile_rs3_o,
        rst_n
        );
        // input wires
 input  wire                           rst_n;                   // Reset Neg
 input  wire                           clk;                     // Clock
 input  wire                           regfile_we_i;            // Write Enable
 input  wire [4:0]                     regfile_raddr_rs1_i;     // Read address of r1
 input  wire [4:0]                     regfile_raddr_rs2_i;     // Read address of r2
 input  wire [4:0]                     regfile_raddr_rs3_i;     // Read address of r3
 input  wire [4:0]                     regfile_waddr_i;         // Write address
 input  wire [`DATA_WIDTH-1:0]         regfile_data_i;          // Data to write
 // Outputs
 output wire [`DATA_WIDTH-1:0]         regfile_rs1_o;           // R1
 output wire [`DATA_WIDTH-1:0]         regfile_rs2_o;           // R2
 output wire [`DATA_WIDTH-1:0]         regfile_rs3_o;           // R3
 // Internal
 reg [`DATA_WIDTH-1:0]                 regFile_F[0:31];
 //integer j;
 // Code
 always @ (posedge clk or negedge rst_n)
  if ( !rst_n ) 
   begin
    regFile_F[0]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[1]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[2]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[3]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[4]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[5]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[6]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[7]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[8]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[9]  <= {`DATA_WIDTH{1'b0}};
    regFile_F[10] <= {`DATA_WIDTH{1'b0}};
    regFile_F[11] <= {`DATA_WIDTH{1'b0}};
    regFile_F[12] <= {`DATA_WIDTH{1'b0}};
    regFile_F[13] <= {`DATA_WIDTH{1'b0}};
    regFile_F[14] <= {`DATA_WIDTH{1'b0}};
    regFile_F[15] <= {`DATA_WIDTH{1'b0}};
    regFile_F[16] <= {`DATA_WIDTH{1'b0}};
    regFile_F[17] <= {`DATA_WIDTH{1'b0}};
    regFile_F[18] <= {`DATA_WIDTH{1'b0}};
    regFile_F[19] <= {`DATA_WIDTH{1'b0}};
    regFile_F[20] <= {`DATA_WIDTH{1'b0}};
    regFile_F[21] <= {`DATA_WIDTH{1'b0}};
    regFile_F[22] <= {`DATA_WIDTH{1'b0}};
    regFile_F[23] <= {`DATA_WIDTH{1'b0}};
    regFile_F[24] <= {`DATA_WIDTH{1'b0}};
    regFile_F[25] <= {`DATA_WIDTH{1'b0}};
    regFile_F[26] <= {`DATA_WIDTH{1'b0}};
    regFile_F[27] <= {`DATA_WIDTH{1'b0}};
    regFile_F[28] <= {`DATA_WIDTH{1'b0}};
    regFile_F[29] <= {`DATA_WIDTH{1'b0}};
    regFile_F[30] <= {`DATA_WIDTH{1'b0}};
    regFile_F[31] <= {`DATA_WIDTH{1'b0}};
//    for (j=0; j < 32; j=j+1)
//     regFile_F[j] <= {`DATA_WIDTH{1'b0}}; //reset array
   end 
                // Write Operation (regfile_we_i = 1, cs = 1)
  else if ( regfile_we_i ) regFile_F[regfile_waddr_i] <= regfile_data_i;

 assign regfile_rs1_o = regFile_F[regfile_raddr_rs1_i];
 assign regfile_rs2_o = regFile_F[regfile_raddr_rs2_i];
 assign regfile_rs3_o = regFile_F[regfile_raddr_rs3_i];
 
endmodule 