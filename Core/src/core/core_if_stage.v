`timescale 1ns/1ps
`include "../src/defines.vh"


// Module Declaration
module if_stage 
    (
    clk,                               //Clock.
    brj_i,                             //Branch/jump control signal. Active high.
    brj_pc_i,                          //New address for branch/jump instructions.
    d_instruction_o,                   //Registered fetched instruction.
    d_pc_o,                            //Address of the fetched instruction. 
    d_pc4_o,                           //Address of the next instruction to fetch.
    flush_inst_o,
    instruction_addr_o,                //Address of instruction to fetch. To memory.
    instruction_rdata_i,               //Fetched instruction. From memory.
    rst_n,                             //Reset. Asynchronous active low.
    stall_i
    );

    input  wire                        rst_n;
    input  wire                        clk;
    input  wire                        brj_i;
    input  wire [`DATA_WIDTH-1:0]      brj_pc_i;
    input  wire [`DATA_WIDTH-1:0]      instruction_rdata_i;
    output wire [`MEM_ADDR_WIDTH-1:0]  instruction_addr_o;
    output wire [`DATA_WIDTH-1:0]      d_instruction_o;
    output reg  [`DATA_WIDTH-1:0]      d_pc_o;
    output reg  [`DATA_WIDTH-1:0]      d_pc4_o;
    input  wire stall_i;
    output wire flush_inst_o;
                
    wire [`DATA_WIDTH-1:0]             pc4;
    reg  [`DATA_WIDTH-1:0]             pc;
    reg  [`DATA_WIDTH-1:0]             dd_instruction;
    
    assign instruction_addr_o = pc[`MEM_ADDR_WIDTH-1:0];

    assign pc4 = pc + {{`DATA_WIDTH-3{1'b0}},3'd4};

    assign flush_inst_o = !brj_i;
    
    always@(posedge clk or negedge rst_n)
     if (!rst_n) pc <= {`DATA_WIDTH{1'b0}};
     else if (!stall_i) begin
                 if (brj_i === 1'b1) pc <= brj_pc_i;
                 else pc <= pc4;
              end
              
    //Registered instruction and PC for pipeline
    always@(posedge clk or negedge rst_n)
     if (!rst_n) begin
                  d_pc_o <= {`DATA_WIDTH{1'b0}};
                  d_pc4_o <= {`DATA_WIDTH{1'b0}};
                 end
     else if (!stall_i) begin
            d_pc_o <= pc;
            d_pc4_o <= pc4;
           end
           
    //The output of the program memory is registered!
    reg d_stall;  
    always @(posedge clk or negedge rst_n)
     if (!rst_n) begin
                  d_stall <= 1'b0;
                 end
     else begin
            d_stall <= stall_i;
           end 
 
     always @(posedge clk or negedge rst_n)
     if (!rst_n) begin
                  dd_instruction <= {25'b0, 7'b0010011}; // If rst, ADDI instruction -> dd_instruction??? Instruction by default? QUESTION
                 end
     else if (!d_stall) begin
            dd_instruction <= instruction_rdata_i;
           end 
                
    assign d_instruction_o = d_stall ? dd_instruction : instruction_rdata_i;//flush_inst ? {25'b0, 7'b0010011} : instruction_rdata_i;

endmodule 