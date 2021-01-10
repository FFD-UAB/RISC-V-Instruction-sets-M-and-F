// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

//`include"testbench.v"

module tb_csr();

	tb TB();
	
	initial begin 

		//$dumpfile("vcd/riscV.vcd");
		//$dumpvars(0, TB.top_CoreMem_inst);

		
		
		TB.pc = 32'b0;
    TB.top_CoreMem_inst.mem_instr_inst.initializeinstrMem;

		// Initialize registers
		TB.clk = 1'b0;
		TB.rst_n = 1'b0;
		#100
		
		// Load memory
		//$readmemb("data/instrramMem_b.mem", TB.top_CoreMem_inst.mem_instr_inst.mem, 0, 3);
		$readmemh("../data/dataMem_h.mem", TB.top_CoreMem_inst.mem_data_inst.mem, 0, 3);
		
		TB.test_csr1;
    TB.waitNclockCycles(16);
	$finish;
end

endmodule   