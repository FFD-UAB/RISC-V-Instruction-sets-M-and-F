// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module sp_ram
  #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 256
  )(
    // Clock and Reset
    input  logic                    clk,
    input  logic                    rstn_i, //FFD added
    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i
  );

  localparam words = NUM_WORDS/(DATA_WIDTH/8);

  reg [DATA_WIDTH/8-1:0][7:0] mem[words];
  logic [DATA_WIDTH/8-1:0][7:0] wdata;
  logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr;

  integer i;
  integer j; //FFD added


  assign addr = addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];


  always @(posedge clk or negedge rstn_i) //FFD added or negedge rstn_i
  if (!rstn_i) for (i=0; i < 96; i++) for (j=0; j<4; j++) mem[i][j] <= {8{1'b0}}; //FFD added
  else begin //FFD added else
    if (en_i && we_i)
    begin
      for (i = 0; i < DATA_WIDTH/8; i++) begin
        if (be_i[i])
          mem[addr][i] <= wdata[i];
      end
    end

    rdata_o <= mem[addr];
  end

  genvar w;
  generate for(w = 0; w < DATA_WIDTH/8; w++)
    begin
      assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
    end
  endgenerate

/* // Initialized not required because the rst implementation FFD added
  initial
   begin
     mem[0] = 0;
     mem[4] = 0;
     mem[8] = 0;
     mem[12] = 0;
     mem[16] = 0;
     mem[20] = 0;
     mem[24] = 0;
     mem[28] = 0;
     mem[32] = 0;
     mem[36] = 0;
     mem[40] = 0;
     mem[44] = 0;
     mem[48] = 0;
     mem[52] = 0;
     mem[56] = 0;
     mem[60] = 0;
     mem[64] = 0;
     mem[68] = 0;
     mem[72] = 0;
     mem[76] = 0;
     mem[80] = 0;
     mem[84] = 0;
     mem[88] = 0;
     mem[92] = 0;
   end */

endmodule
