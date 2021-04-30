// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module sp_ram_instr
  #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 256
  )(
    // Clock and Reset
    input  logic                    clk,
    input  logic                    rstn_i,
    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i
  );

  localparam words = NUM_WORDS/(DATA_WIDTH/8);

  logic [DATA_WIDTH/8-1:0][7:0] mem_instr[words];
  logic [DATA_WIDTH/8-1:0][7:0] wdata;
  logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr;

  integer i;
  assign addr = addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];


  always @(posedge clk)
    begin
     if (en_i && we_i)
     begin
//      for (i = 0; i < DATA_WIDTH/8; i++) begin  // Commented because fitter tool is incapable
//        if (be_i[i])                            // of using M9K modules in this way. The following
//          mem_instr[addr][i] <= wdata[i];             // part does the same but is not parametrizable and
//      end                                       // is capable of using M9K Cyclone III modules.
      if(be_i[0]) mem_instr[addr][0] <= wdata[0];
      if(be_i[1]) mem_instr[addr][1] <= wdata[1];
      if(be_i[2]) mem_instr[addr][2] <= wdata[2];
      if(be_i[3]) mem_instr[addr][3] <= wdata[3];
     end
     rdata_o <= mem_instr[addr];
    end

  genvar w;
  generate for(w = 0; w < DATA_WIDTH/8; w++)
    begin: data_array1
      assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
    end
  endgenerate

  initial
  begin
  //for (i = 0; i < words; i++) // Used at simulation. Gives problems at Quartus II 13.1
  //mem_instr[i] = {{DATA_WIDTH-7{1'b0}}, 7'b0010011};
  //$readmemh("../data/programMem_h.mem", mem_instr); // This is synthesable by Intel support
  end

endmodule
