`timescale 1ns/1ps


`ifdef CUSTOM_DEFINE
    `include "../src/defines.vh"
`endif

// Module Declaration
module progMem
	`ifdef CUSTOM_DEFINE
		#(parameter ADDR_WIDTH = `MEM_ADDR_WIDTH,
        parameter DATA_WIDTH = `MEM_DATA_WIDTH,
        parameter MEM_DEPTH = `MEM_DEPTH) 
	`else
		#(parameter ADDR_WIDTH = 10,
        parameter DATA_WIDTH = 32,
        parameter MEM_DEPTH = 1024) 
	`endif
	(
        rst_n		,  // Reset Neg
        clk,             // Clk
        addr		,  // Address
        data_out	   // Output Data
    );

	
	// Inputs
	input wire rst_n; 
	input wire clk;
	
	input wire[ADDR_WIDTH-1:0]	addr;
	
	// Outputs
	output reg [DATA_WIDTH-1:0] data_out;
	
	// Internal
	reg [DATA_WIDTH-1:0] progArray[0:MEM_DEPTH-1];
	//reg [DATA_WIDTH-1:0] data_out ;  // Quartus
	
	// Code
	
	// Tristate output
	//assign data_out = (cs && oe && !we) ? data_out : MEM_DATA_WIDTH'bz;
	

	// Read Operation (we = 0, oe = 1, cs = 1)
	always @ (posedge clk)
	begin : MEM_READ
		// Async Reset
		if ( !rst_n ) begin
      data_out = {25'b0, 7'b0010011};
		end 
		else begin  // output enable logic supressed
			data_out = progArray[addr >> 2];
		end
	end

 task initializeProgMem;
  integer j;
  begin	
   for (j=0; j < MEM_DEPTH; j=j+1) begin
				progArray[j] <= 0; //reset array
			end
	end
 endtask

 task loadProgram;
  begin	
   // Load memory
	 //$readmemb("../../data/programMem_b.mem", progArray, 0, 10);
	 $readmemh("../../data/programMem_h.mem", progArray, 0, 24);
	 //$readmemh("../../data/programMem_h_complete.mem", progArray, 0, 342);
	end
 endtask

 initial
  begin
    data_out = {25'b0, 7'b0010011};
  end			
endmodule
	
	
	
 