// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`include "../src/defines.vh"

module tb();
reg clk;
reg rst_n;

reg [31:0] instruction;
reg [31:0] pc;
reg [31:0] rd;
reg [31:0] expectedResult;

top_CoreMem top_CoreMem_inst(
            .clk            (clk),
            .rst_n          (rst_n)
            );

always #50 clk = !clk;

//*********************************
//** Instruction set RV32I Tests **
//********************************* 

task waitNclockCycles;
  input [31:0] waitNclockClocks;
  integer waitClocks;
  begin
    for (waitClocks=0; waitClocks < waitNclockClocks; waitClocks = waitClocks + 1)
    @(posedge clk)
    #1;
  end
endtask

task test_andi;
  begin
    $display("ANDI Test");
    pc = 32'b0;
    rstProgMem();
    //encodeLW(5'h0, 5'h3, 12'h1);
    //encodeAndi(5'h3, 5'h4, 12'hFFF);
    encodeAddi(5'h0, 5'h3, 12'h444);
    encodeAndi(5'h3, 5'h5, 12'hF0F);
    
    rst_n = 1'b1;
    waitNclockCycles(6);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h0000404) $display("OK: reg5 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h0000404 but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
  end
endtask
 
task test_slli;
  begin
    $display("SLLI Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd3);
    encodeSlli(5'h3, 5'h5, 5'h2);
          
    rst_n = 1'b1;
    waitNclockCycles(8);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h000000C) $display("OK: reg5 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h000000C but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
  end
endtask
 
task test_slti;
 begin
    $display("SLTI Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'hFFC); //-12
    encodeSlti(5'h3, 5'h5, 12'h8); //1
    encodeSlti(5'h3, 5'h6, 12'hFFF); //-1
    
    rst_n	= 1'b1;
    waitNclockCycles(8);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h0000001) $display("OK: reg5 is : %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h0000001 but is: %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6] == 32'h0000001) $display("OK: reg6 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
    else begin
      $display("ERROR: reg6 has to be h0000001 but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
      //$fatal;
    end
  end
endtask
 
task test_sltiu;
  begin
    $display("SLTIU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'hFFC); // 4092
    encodeSltiu(5'h3, 5'h5, 12'hFFF); // 4095
    encodeSltiu(5'h3, 5'h3, 12'h8);  // 8
    
    rst_n = 1'b1;
    waitNclockCycles(8);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h0000001) $display("    OK: reg5 is : %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h0000001 but is: %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3] == 32'h0000000) $display("OK: reg3 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
    else begin
      $display("ERROR: reg3 has to be h0000000 but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
      //$fatal;
    end
  end
endtask

task test_add; 
  begin
    $display("ADD Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd5);
    encodeAddi(5'h0, 5'h4, 12'd2);
    encodeAdd(5'h3, 5'h4, 5'h5);
    
    rst_n = 1'b1;
    waitNclockCycles(8);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 7) $display("OK: reg5 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 7 but is: %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_and;
  begin
    $display("AND Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'hFFF);
    encodeAddi(5'h0, 5'h4, 12'hFF);
    encodeAnd(5'h3, 5'h4, 5'h5);
    //TEST
    rst_n = 1'b1;
    waitNclockCycles(8);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h000000FF) $display("OK: reg5 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h000000FF but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
  end
endtask

task test_lui;
  begin
    rstProgMem();
    encodeLui(5'h2, 20'hFFFFF);
    encodeLui(5'h3, 20'hAAAAA);
    encodeLui(5'h4, 20'h55555);
    rst_n = 1'b1;
    waitNclockCycles(16);
  end
endtask

task test_auipc;
  begin
    rstProgMem();
    encodeAuipc(5'h2, 20'h0000F);
    //encodeAuipc(5'h3, 20'hAAAAA);
    //encodeAuipc(5'h4, 20'h55555);
    rst_n = 1'b1;
    waitNclockCycles(16);
  end
endtask

task test_load;
  begin
    $display("LOAD Test");
    pc = 32'b0;
    rstProgMem();
	
    encodeLB(5'h0, 5'h3, 12'h4);
    encodeLH(5'h0, 5'h4, 12'h4);
    encodeLW(5'h0, 5'h5, 12'h4);
    encodeLHU(5'h0, 5'h6, 12'h4);
    encodeLBU(5'h0, 5'h7, 12'h4);
    //TEST
    rst_n = 1'b1;
    waitNclockCycles(10);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'hf04a1c0f) $display("OK: reg5 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be hf04a1c0f but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
   
  end
endtask

task test_store;
  begin
    $display("STORE Test");
    pc = 32'b0;
    rstProgMem();
        
    encodeLW(5'h0, 5'h1, 12'h0);
    encodeLW(5'h0, 5'h2, 12'h4);
    encodeLW(5'h0, 5'h3, 12'h8);
    encodeLW(5'h0, 5'h4, 12'hC);
    
    encodeSW(5'h0, 5'h1, 12'h10);
    encodeSH(5'h0, 5'h2, 12'h14);
    encodeSB(5'h0, 5'h3, 12'h18);
    encodeSW(5'h0, 5'h4, 12'h1C);
    
    encodeLW(5'h0, 5'h5, 12'h10);
    encodeLW(5'h0, 5'h6, 12'h14);
    encodeLW(5'h0, 5'h7, 12'h18);
    
    //TEST
    rst_n = 1'b1;
    waitNclockCycles(16);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h10101010) $display("OK: reg5 is : %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be h10101010 but is: %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6] == 32'h00001c0f) $display("OK: reg6 is : %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
    else begin
       $display("ERROR: reg6 has to be h00001c0f but is: %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
       //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[7] == 32'h00000011) $display("OK: reg7 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[7]);
    else begin
      $display("ERROR: reg7 has to be h00000011 but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[7]);
      //$fatal;
    end
  end
endtask

task test_store_stall;
  begin
    $display("STORE Test");
    pc = 32'b0;
    rstProgMem();
    encodeLW(5'h0, 5'h10, 12'h0);
    //encodeAddi(5'h0, 5'h0, 12'h0);//NOOP
    encodeLW(5'h0, 5'h11, 12'h4);
    encodeAdd(5'h10, 5'h11, 5'h15);   
    //TEST
    rst_n = 1'b1;
    waitNclockCycles(17);
  end
endtask 
       
task test_jal;  // Not sure if the JAL works as intended
  begin
    $display("JAL Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'hFFF); 
    encodeAddi(5'h0, 5'h4, 12'hFFF);
    encodeJal(5'h5, {21'h1FFFF8}); // -8
    rst_n = 1'b1;
    waitNclockCycles(16);
    if (top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o == 0) $display("OK: PC is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
    else begin
      $display("ERROR: PC has to be 0 but is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
      //$fatal;
    end
  end
endtask

task test_jalr;  // Not sure if the JAL works as intended
  begin
    $display("JALR Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'h8); 
    encodeAddi(5'h0, 5'h4, 12'h1);
    encodeJalr(5'h7, 5'h3, {21'h1FFFF8}); // -8
    rst_n = 1'b1;
    waitNclockCycles(16);
    if (top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o == 0) $display("OK: PC is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
    else begin
      $display("ERROR: PC has to be 0 but is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
      //$fatal;
    end
  end
endtask


task test_beq;
  begin
    $display("BEQ Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'hFFF);
    encodeAddi(5'h0, 5'h4, 12'hFFF);
    encodeBeq(5'h3, 5'h4, 13'h1FF8);
    rst_n = 1'b1;
    waitNclockCycles(16);
    if (top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o == 252) $display("OK: PC is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
    else begin
      $display("ERROR: PC has to be 252 but is: %d \n", top_CoreMem_inst.core_inst.if_stage_inst.instruction_addr_o);
      //$fatal;
    end
  end
endtask


task test_csr;
  begin
    $display("CSR Test");
    pc = 32'b0;
    rstProgMem();
    encodeCsr(12'hC00, 5'h0, `FUNCT3_CSRRS, 5'h1);
    encodeCsr(12'hC01, 5'h0, `FUNCT3_CSRRS, 5'h2);
    encodeCsr(12'hC02, 5'h0, `FUNCT3_CSRRS, 5'h3);
    rst_n = 1'b1;
    #400;
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3] == 32'h0000002) $display("    OK: reg3 is : %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
    else begin
      $display("ERROR: reg3 has to be h0000002 but is: %h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
      //$fatal;
    end
  end
endtask

task test_csr1;
  begin
    $display("CSR1 Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'h555); 
    encodeCsr(12'h000, 5'h3, `FUNCT3_CSRRW, 5'h0); //Value stored in CSR is stored in rd(0) and value stored in rd(0) in CSR
    encodeCsr(12'h000, 5'h3, `FUNCT3_CSRRW, 5'h0);
    //encodeCsr(12'hC02, 5'h0, `FUNCT3_CSRRS, 5'h3);
    rst_n = 1'b1;
  end
endtask


//*****************************
//** Instruction set M tests **
//***************************** 

task test_mul;
  begin
    $display("MUL Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd5); // Reg3 = 5;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -5; SUB IS RS1-RS2
    encodeAddi(5'h0, 5'h4, 12'd1); // Reg4 = 1;
    encodeSub(5'h0, 5'h4, 5'h4);   // Reg4 = -1;
    encodeMUL(5'h3, 5'h4, 5'h5);   // Reg5 = Reg3*Reg4; -5 x -1 = 5
    rst_n = 1'b1;
    waitNclockCycles(10);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'd5) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 5 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_mulh;
  begin
    $display("MULH Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd8); // Reg3 = 8;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -8;
    encodeAddi(5'h0, 5'h4, 12'd1); // Reg4 = 1;
    encodeSlli(5'h4, 5'h4, 5'h1E); // Reg4 = 2^30;
    encodeMULH(5'h3, 5'h4, 5'h5);  // Reg5 = 32MSB(Reg3*Reg4); aka -8*2^30 = -2^33 => -2 on 32MSB
    rst_n = 1'b1;
    waitNclockCycles(10);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == -32'd2) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be -2 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_mulhsu;
  begin
    $display("MULHSU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd4); // Reg3 = 4;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -4;
    encodeAddi(5'h0, 5'h4, 12'd1); // Reg4 = 1;
    encodeSlli(5'h4, 5'h4, 5'h1F); // Reg4 = -2^31; but in unsigned format is 2^31
    encodeMULHSU(5'h3, 5'h4, 5'h5);   // Reg5 = Reg3*Reg4; -4 x 2^31 = -2^33 => -2 on 32MSB
    rst_n = 1'b1;
    waitNclockCycles(10);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == -32'd2) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be -2 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_mulhu;
  begin
    $display("MULHU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd4); // Reg3 = 4;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -4; but in unsigned format is 0xFFFF FFFC
    encodeAddi(5'h0, 5'h4, 12'd1); // Reg4 = 1;
    encodeSlli(5'h4, 5'h4, 5'h1F); // Reg4 = -2^31; but in unsigned format is 2^31
    encodeMULHU(5'h3, 5'h4, 5'h5);   // Reg5 = Reg3*Reg4; 0xFFFF FFFC x 2^31 => 0x7FFF FFFE on 32MSB
    rst_n = 1'b1;
    waitNclockCycles(10);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h7FFFFFFE) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 0x7FFF FFFE but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_div;
  begin
    $display("DIV Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd5); // Reg3 = 5;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -5; 
    encodeAddi(5'h0, 5'h4, 12'd2); // Reg4 = 2;
    encodeSub(5'h0, 5'h4, 5'h4);   // Reg4 = -2;
    encodeDIV(5'h3, 5'h4, 5'h5);   // Reg5 = Reg3/Reg4; -5/-2 => q = 2, r = -1.
    rst_n = 1'b1;
    waitNclockCycles(8);
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'd2) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 2 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_divu;
  begin
    $display("DIVU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd3); // Reg3 = 3;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -3; but in unsigned format is 0xFFFF FFFD
    encodeAddi(5'h0, 5'h4, 12'd2); // Reg4 = 2;
    encodeDIVU(5'h3, 5'h4, 5'h5);  // Reg5 = Reg3/Reg4; q = 0x7FFF FFFE, r = 1.
    rst_n = 1'b1;
    waitNclockCycles(8);
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h7FFFFFFE) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 0x7FFF FFFE but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_rem;
  begin
    $display("REM Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd5); // Reg3 = 5;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -5; 
    encodeAddi(5'h0, 5'h4, 12'd2); // Reg4 = 2;
    encodeSub(5'h0, 5'h4, 5'h4);   // Reg4 = -2;
    encodeREM(5'h3, 5'h4, 5'h5);   // Reg5 = Reg3/Reg4; -5/-2 => q = 2, r = -1.
    rst_n = 1'b1;
    waitNclockCycles(8);
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == -32'h1) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be -1 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_remu;
  begin
    $display("REMU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd3); // Reg3 = 3;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -3; but in unsigned format is 0xFFFF FFFD
    encodeAddi(5'h0, 5'h4, 12'd2); // Reg4 = 2;
    encodeREMU(5'h3, 5'h4, 5'h5);  // Reg5 = Reg3/Reg4; q = 0x7FFF FFFE, r = 1.
    rst_n = 1'b1;
    waitNclockCycles(8);
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h1) $display("OK: reg5 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 1 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    #400;
  end
endtask

task test_oncecycle_divrem; // Tests the OneCycleRemainder capability.
  begin
    $display("One-Cycle Remainder DIVU/REMU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd3); // Reg3 = 3;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -3; but in unsigned format is 0xFFFF FFFD
    encodeAddi(5'h0, 5'h4, 12'd2); // Reg4 = 2;
    encodeDIVU(5'h3, 5'h4, 5'h5);  // Reg5 = Reg3/Reg4; q = 0x7FFF FFFE.
    encodeREMU(5'h3, 5'h4, 5'h6);  // Reg6 = Reg3/Reg4; r = 1.

    rst_n = 1'b1;
    waitNclockCycles(8);
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h7FFFFFFE) $display("OK: reg5 is : 0x%h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 0x7FFF FFFE but is: 0x%h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6] == 32'h1) $display("OK: reg6 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
    else begin
      $display("ERROR: reg6 has to be 1 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
      //$fatal;
    end
    #400;
  end
endtask

task test_div2; // Tests two multi-cycle operations in a row.
  begin
    $display("DIV/DIVU Test");
    pc = 32'b0;
    rstProgMem();
    encodeAddi(5'h0, 5'h3, 12'd3); // Reg3 = 3;
    encodeSub(5'h0, 5'h3, 5'h3);   // Reg3 = -3; but in unsigned format is 0xFFFF FFFD
    encodeAddi(5'h0, 5'h5, 12'd5); // Reg5 = 5;
    encodeSub(5'h0, 5'h5, 5'h5);   // Reg5 = -5; 
    encodeAddi(5'h0, 5'h6, 12'd2); // Reg6 = 2;
    encodeSub(5'h0, 5'h6, 5'h6);   // Reg6 = -2;
    encodeDIV(5'h5, 5'h6, 5'h5);   // Reg5 = Reg5/Reg6; -5/-2 => q = 2, r = -1.
    encodeDIVU(5'h3, 5'h5, 5'h6);  // Reg6 = Reg3/Reg5; uns(-3)/2  => q = 0x7FFF FFFE.

    rst_n = 1'b1;
    waitNclockCycles(9); // 2 clock cycles to start with the first operation + 6 normal operations (one cycle) + 1 to check when already started.
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk); // Continues at the start of the next operation.
    waitNclockCycles(1);  // 1 clock cycle to check to the next division when already started.
    while (top_CoreMem_inst.core_inst.d_alu_busy_t) @(posedge clk);
    waitNclockCycles(3);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5] == 32'h2) $display("OK: reg5 is : 0x%h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
    else begin
      $display("ERROR: reg5 has to be 2 but is: 0x%h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
      //$fatal;
    end
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6] == 32'h7FFFFFFE) $display("OK: reg6 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
    else begin
      $display("ERROR: reg6 has to be 0x7FFF FFFE but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[6]);
      //$fatal;
    end
    #400;
  end
endtask


//**********************************
//** Instruction set RV32I encode **
//********************************** 

task encodeLui;
  input [4:0] rd;
  input [19:0] immediate;
  begin
    instruction = {immediate[19:0], rd, `OPCODE_U_LUI};
    // top_CoreMem_inst.mem_prog_inst.progArray[pc >> 2] = instruction;
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    // $display("mem[%d] = %b", pc, top_CoreMem_inst.mem_prog_inst.progArray[pc]);
    pc = pc + 32'd4;
  end
endtask

task encodeAuipc;
  input [4:0] rd;
  input [19:0] immediate;
  begin
    instruction = {immediate[19:0], rd, `OPCODE_U_AUIPC};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeJal;
  input [4:0] rd;
  input [20:0] immediate;
  begin
    instruction = {immediate[20], immediate[10:1], immediate[11], immediate[19:12], rd, `OPCODE_J_JAL};
    pc = pc + 32'd4;
  end
endtask

task encodeJalr;
  input [4:0] rd;
  input [4:0] rs1;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b0, rd, `OPCODE_I_JALR};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeBeq;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b0, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeBne;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b1, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBlt;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b100, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBge;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b101, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBltu;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b110, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBgeu;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b11, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLB;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LB, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeLH;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LH, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeLW;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LW, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLBU;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LBU, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLHU;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LHU, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSB;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SB, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeSH;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SH, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeSW;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SW, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeAddi;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b000, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeSlti;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b010, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSltiu;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b011, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
   end
endtask

// TASK XORI

// TASK ORI

task encodeAndi;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b111, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSlli;
  input [4:0] rs1;
  input [4:0] rd;
  input [4:0] immediate;
  begin
    instruction = {7'h0, immediate, rs1, `FUNCT3_SLLI, rd, `OPCODE_I_IMM}; // 3'b001
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

// TASK SRLI

// TASK SRAI

task encodeAdd;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b0, rs2, rs1, 3'b000, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSub; // Added encodeSub because I didn't find it.
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'h20, rs2, rs1, 3'b000, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSll;
  input [4:0] rs1;
  input [4:0] rd;
  input [4:0] immediate;
  begin
    instruction = {7'h0, immediate, rs1, 3'b001, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSlt;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b010, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSltu;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b011, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

// TASK XOR

// TASK SRL

// TASK SRA

// TASK OR

task encodeAnd;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b0, rs2, rs1, 3'b111, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

// TASK FENCE

// TASK ECALL

// TASK EBREAK

task encodeNOOP;
  begin
    instruction = {12'b0, 5'h0, 3'h0, 5'h0, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeCsr;
  input [11:0] addr;
  input [4:0] rs1;
  input [2:0] FUNCT3_OP;
  input [4:0] rd;
  begin
    instruction = {addr, rs1, FUNCT3_OP, rd, `OPCODE_I_SYSTEM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task iniProgMem;
  integer addr;
  begin
    for (addr = 0; addr < 1024; addr = addr + 1)
    begin
      top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[addr][0] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[addr][1] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[addr][2] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[addr][3] = 8'h0;		
    end
  end
endtask

//always @ (negedge clk) begin
		// $display("reg5 = %d\npc = %d\ninst = %b", top_CoreMem_inst.reg_file_inst.regFile[5], top_CoreMem_inst.addr_progMem, top_CoreMem_inst.instruction_progmem);
		// $display("reg1 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[1]);
        // $display("reg2 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[2]);
        //$display("reg3 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
        // $display("reg4 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[4]);
        //$display("reg5 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
		// $display("rs2_exec_unit_t = %d", top_CoreMem_inst.rs2_exec_unit_t);
		// $display("ALU_op_t = %d", top_CoreMem_inst.ALU_op_t);
		//$display("is_imm_t = %d", top_CoreMem_inst.is_imm_t);
		// $display("r_num_write_reg_file = %d", top_CoreMem_inst.r_num_write_reg_file);
        //$display("pc = %d", top_CoreMem_inst.core_inst.program_counter_inst.addr);

//end

//******************************
//** Instruction set M encode **
//****************************** 

task encodeMUL;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b000, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULH;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b001, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULHSU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b010, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULHU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b011, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeDIV;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b100, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeDIVU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b101, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeREM;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b110, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeREMU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b111, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task rstProgMem;
  integer i;
  begin
    instruction = {{`DATA_WIDTH-7{1'b0}}, `OPCODE_I_IMM};
    for (i=0; i<1024; i=i+1) begin
     top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[i][0] = instruction[7:0];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[i][1] = instruction[15:8];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[i][2] = instruction[23:16];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[i][3] = instruction[31:24];
    end
  end
endtask

endmodule   