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
            .rst_n          (rst_n),
            .axi_instr_req  (1'b0),
            .axi_data_req   (1'b0)
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
    encodeLui(5'h2, 20'hFFFFF);
    encodeLui(5'h3, 20'hAAAAA);
    encodeLui(5'h4, 20'h55555);
    rst_n = 1'b1;
    waitNclockCycles(16);
  end
endtask

task test_auipc;
  begin
    rstinstrMem();
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
    rstinstrMem();
	
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
    rstinstrMem();
        
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
    rstinstrMem();
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
    rstinstrMem();
    encodeAddi(5'h0, 5'h3, 12'hFFF); 
    encodeAddi(5'h0, 5'h4, 12'hFFF);
    encodeJal(5'h5, 21'h1FFFF8); // -8
    rst_n = 1'b1;
    waitNclockCycles(4);
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
    rstinstrMem();
    encodeAddi(5'h0, 5'h3, 12'h8); 
    encodeAddi(5'h0, 5'h4, 12'h1);
    encodeJalr(5'h7, 5'h3, 21'h1FFFF8); // -8
    rst_n = 1'b1;
    waitNclockCycles(4);
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
    rstinstrMem();
    encodeAddi(5'h0, 5'h3, 12'hFFF);
    encodeAddi(5'h0, 5'h4, 12'hFFF);
    encodeBeq(5'h3, 5'h4, 13'h00F4);
    rst_n = 1'b1;
    waitNclockCycles(4);
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
    rstinstrMem();
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



//*****************************
//** Instruction set M tests **
//***************************** 

task test_mul;
  begin
    $display("MUL Test");
    pc = 32'b0;
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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
    rstinstrMem();
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


//*******************************
//** Instruction set F.S tests **
//*******************************

task test_fcsr;
  begin
    $display("FCSR Test");
    pc = 32'b0;
    rstinstrMem();
    encodeAddi(5'h0, 5'h10, 12'b1);  // Reg10 <- 1;
    encodeSW(5'h0, 5'h10, 12'h0);    // Mem[0] <- 1;
    encodeFLW(5'h0, 5'h10, 12'h0);   // Freg10 <- Mem[0];
    encodeCsr(`FRM_ADDR, 5'h3, `FUNCT3_CSRRSI, 5'h0);  // Set FCSR rm to RUP (h3).
    encodeFDIV(5'h10, 5'h0, 5'h1, `FRM_DYN);           // ?/0 to set DZ fflag high. Reg1 <- +inf;
    encodeCsr(`FFLAGS_ADDR, 5'h0, `FUNCT3_CSRRW, 5'h2);// Reg2 <- fflags. Should be 32'b01000. Clear FFLAGS
    encodeCsr(`FFLAGS_ADDR, 5'h0, `FUNCT3_CSRRW, 5'h3);// Reg3 <- fflags. Should be 32'b00000. Clear FFLAGS
    encodeCsr(`FRM_ADDR, 5'h10, `FUNCT3_CSRRC, 5'h4);  // Reg4 <- frm. Should be RUP (h3). frm <- frm & ~1.
    rst_n = 1'b1;
    while (!top_CoreMem_inst.core_inst.exe_stage_inst.ctrlStartF) @(posedge clk); // Wait until FPU operation at EXE.
    if(top_CoreMem_inst.core_inst.exe_stage_inst.e_frm_i == `FRM_RUP) $display("OK: Correct rounding mode from FCSR. \n");
    else $display("ERROR: Wrong rounding mode being used at EXE, which is %b. \n", top_CoreMem_inst.core_inst.exe_stage_inst.e_frm_i);
    waitNclockCycles(6);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[2] == 5'b01000) $display("OK: reg2 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[2]);
    else $display("ERROR: reg2 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[2]);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3] == 5'b00000) $display("OK: reg3 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
    else $display("ERROR: reg3 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[4] == 5'b00011) $display("OK: reg4 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[4]);
    else $display("ERROR: reg4 is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[4]);
    if (top_CoreMem_inst.core_inst.id_stage_inst.crs_unit_inst.csr_frm_o == 5'b00010) $display("OK: frm is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.crs_unit_inst.csr_frm_o);
    else $display("ERROR: frm is : %b. \n", top_CoreMem_inst.core_inst.id_stage_inst.crs_unit_inst.csr_frm_o);
  end
endtask

task test_FP1;
  begin
    pc = 32'b0;
    rstinstrMem();
	
    // rs1, Frd, offset.        Frd <- Mem(rs1 + sign extended offset)
    encodeFLW(5'h0, 5'h0, 12'h0); // Freg[0] = 0x00000001  exp=0, mantissa 1
    encodeFLW(5'h0, 5'h1, 12'h4); // Freg[1] = 0x007fffff  exp=0, full mantissa
    encodeFLW(5'h0, 5'h2, 12'h8); // Freg[2] = 0x7f7fffff  Inf-1
    encodeFLW(5'h0, 5'h3, 12'hc); // Freg[3] = 0x7fc00001  sNaN
    // Frs1, Frs2, Frd, rm.
    encodeFADD(5'h0, 5'h1, 5'h4, `FRM_RNE); // 0x00000001 + 0x007fffff = 0x00800000
    encodeFADD(5'h4, 5'h1, 5'h5, `FRM_RTZ); // 0x00800000 + 0x007fffff = 0x00ffffff
    encodeFSUB(5'h4, 5'h5, 5'h6, `FRM_RNE); // 0x00800000 - 0x00ffffff = 0x807fffff
    encodeFADD(5'h0, 5'h2, 5'h7, `FRM_RNE); // Inf-1 + mantissa 1 = Inf-1 because RNE (0x7f7fffff)
    encodeFADD(5'h0, 5'h2, 5'h8, `FRM_RUP); // Inf-1 + mantissa 1 = Inf because RUP (0x7f800000)
    encodeFADD(5'h3, 5'h0, 5'h9, `FRM_RNE); // sNaN + 0x00000001 = qNaN
    // rs1, Frs2, offset.       Frs2 -> Mem(rs1 + sign extended offset)
    encodeFSW(5'h0, 5'h4, 12'h10); // Dmem[4] = 0x00800000
    encodeFSW(5'h0, 5'h5, 12'h14); // Dmem[5] = 0x00ffffff
    encodeFSW(5'h0, 5'h6, 12'h18); // Dmem[6] = 0x807fffff
    encodeFSW(5'h0, 5'h7, 12'h1c); // Dmem[7] = 0x7f7fffff
    encodeFSW(5'h0, 5'h8, 12'h20); // Dmem[8] = 0x7f800000 +Inf
    encodeFSW(5'h0, 5'h9, 12'h24); // Dmem[9] = 0x7FC00000 qNaN

    //TEST
    rst_n = 1'b1;
    waitNclockCycles(30);

    $display("FP LOAD Test");
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[3] == 32'h7fc00001)
    $display("OK: freg3 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[3]);
    else begin
      $display("ERROR: freg3 has to be 0x7fc00001 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[3]);
      //$fatal;
    end


    $display("FP ADD/SUB Test");
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[6] == 32'h807fffff)
    $display("OK: freg6 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[6]);
    else begin
      $display("ERROR: freg6 has to be 0x807fffff but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[6]);
      //$fatal;
    end

    $display("FP ADD/SUB rm Test");
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[7] == 32'h7f7fffff)
    $display("OK: freg7 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[7]);
    else begin
      $display("ERROR: freg7 has to be 0x7f7fffff but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[7]);
      //$fatal;
    end

    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[8] == 32'h7f800000)
    $display("OK: freg8 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[8]);
    else begin
      $display("ERROR: freg8 has to be 0x7f800000 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[8]);
      //$fatal;
    end

    $display("FP ADD/SUB NaN Test");
    if (top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[9] == 32'h7fc00000)
    $display("OK: freg9 is : 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[9]);
    else begin
      $display("ERROR: freg9 has to be 0x7fc00000 but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[9]);
      //$fatal;
    end

    $display("FP STORE Test");
    if (TB.top_CoreMem_inst.data_mem.sp_ram_data_i.mem_data[8] == top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[8]) 
    $display("OK: dataMem[8] is : 0x%h \n", TB.top_CoreMem_inst.data_mem.sp_ram_data_i.mem_data[8]);
    else begin
       $display("ERROR: dataMem[8] has to be 0x%h but is: 0x%h \n", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_f_inst.regFile_F[8], TB.top_CoreMem_inst.data_mem.sp_ram_data_i.mem_data[8]);
       //$fatal;
    end
   
  end
endtask

/*
task test_FPMandelbrot; // Coded but not tested. WIP
  begin
    pc = 32'b0;
    rstinstrMem();
    // JMP or branch labels:
    wire Finish = 12'hd4;
    wire LoopX  = 12'h50;
    wire LoopY  = 12'h38;
    wire Res0   = 12'hb4;
    wire Res1   = 12'hb0;
    wire MandelLoop = 12'h68;
    wire STOREres = 12'hc0;
    
    wire Pzoom = 12';
    wire Mzoom = 12';
    wire PX = 12';
    wire MX = 12';
    wire PY = 12';
    wire MY = 12';

    // The step value changes the screen zoom and Mandelbrot precision. Freg 2 and 3 are 
    // XY values of the screen that can be changed to move around. VGA = 640 x 480 px
    //
    // Freg 1  = step value,   Freg 2 = X screen position,   Freg 3 = Y screen position.
    // Freg 17 = X display resolution/8,   Freg 18 = Y display resolution/8.
    //
    //    ///////////////////// <- Y pos + step (Y counter = 1)
    //    //        |        //
    //    //--------+--------//
    //    //        |        //
    //    ///////////////////// <- Y pos - 480 x step (Y counter = 480)
    //    ^                   ^
    //    |                   X pos + 640 x step (X counter = 640)
    //    X pos + step (X counter = 1)


    // Data memory pointer and counters to store the results.
    //
    // Reg 2  = Max X resolution,          Reg 3 = Max Y resolution,
    // Reg 5  = X counter,                 Reg 6 = Y counter, 
    // Reg 7  = Flag of OOB (FP.S value > 2 in magnitude when high).
    // Reg 8  = contains '1' to perform BEQ at Reg 7.
    // Reg 9  = '1' shifted to set the bit position of the result.
    // Reg 10 = '10..0' used to compate Reg 9
    // Reg 11 = Last 32 Mandelbrot results. Store when all 32 are done.
    // Reg 12 = memory pointer counter used to store result.


    // The Mandelbrot set computes Z_(n+1) = Z_n x Z_n + C, where Z_0 is 0 and C is 
    // a complex number equal to the X + iY screen positions values. The equation 
    // is computed up to reg 1 number of times unless the real or imag values goes 
    // over 2 in magnitude, that is stored at Freg 4. 
    // The values at Freg 10 and 11 contain the XY position that changes with each loop 
    // finished, being then C = Freg 10 + iFreg 11. Freg 12 and 13 are the results of each
    // iteration that are updated with the middle operands of Freg[14, 16].
    //
    // Freg  4 = value 2 in FP.S, Freg  5 = value -2 in FP.S, 
    // Freg 10 = Real init value, Freg 11 = Imag init value,  Reg 1 = Max number of iterations.
    // Freg 12 = Real value,      Freg 13 = Imag value,       Reg 4 = iteration counter.
    // Freg 14 = RxR result,      Freg 15 = IxI result,     Freg 16 = 2xRxI result.

       // Boot code, used to update step, X or Y screen position.
/*00/ encodeFLW (5'b0,  5'd1,  12'h0); // Freg 1 <- dataMem #0.  Freg 1 <- step value.
/*04/ encodeFLW (5'b0,  5'd2,  12'h4); // Freg 2 <- dataMem #4.  Freg 2 <- X screen position.
/*08/ encodeFLW (5'b0,  5'd3,  12'h8); // Freg 3 <- dataMem #8.  Freg 3 <- Y screen position.
/*0c/ encodeFLW (5'b0,  5'd4,  12'hc); // Freg 4 <- dataMem #12. Freg 4 <- 2 in single-prec.
/*10/ encodeLW  (5'b0,  5'd17, 12'h10);// Freg 17 <- dataMem #16. Freg 17 <- X screen resolution.
/*14/ encodeLW  (5'b0,  5'd18, 12'h14);// Freg 18 <- dataMem #20. Freg 18 <- Y screen resolution.
/*18/ encodeFSUB(5'b0,  5'd4,  5'd5, `FRM_RTZ);  // Freg 5 <- -2.
/*1c/ encodeLW  (5'b0,  5'd1,  12'h18);// Reg 1  <- dataMem #24. Reg 1 is max Mandelbrot iterations.
/*20/ encodeLW  (5'b0,  5'd2,  12'h1c);// Reg 2  <- dataMem #28. Reg 2 <- X screen resolution.
/*24/ encodeLW  (5'b0,  5'd3,  12'h20);// Reg 3  <- dataMem #32. Reg 3 <- Y screen resolution.
/*28/ encodeAddi(5'b0,  5'd8,  12'h1); // Reg 8  <- '1'.
/*2c/ encodeAddi(5'b0,  5'd9,  12'h1); // Reg 9  <- '1'.
/*30/ encodeSlli(5'd8,  5'd10, 12'd31);// Reg 10 <- '10..0'
    
    
/*  / // Init Y vector
/*34/ encodeFADD(5'b0,  5'd3,  5'd11, `FRM_RTZ);  // Reset Y position

/*  / // Loop Y vector
/*38/ encodeAddi(5'b0,  5'd6,  12'h1); // Increase Y counter
/*3c/ encodeBlt (5'd3,  5'd6,  Finish);// JMP "Finish" if Y > Y resolution
/*40/ encodeFSUB(5'd11, 5'd1,  5'd11, `FRM_RTZ); // Decrease Y step
/*44/ encodeFADD(5'b0,  5'd11, 5'd13, `FRM_RTZ); // Init Imag register
    
/*  / // Init X vector
/*48/ encodeAdd (5'b0,  5'b0,  5'd5 ); // Reset X counter
/*4c/ encodeFADD(5'b0,  5'd2,  5'd10, `FRM_RTZ); // Reset X position
    
/*  / // Loop X vector
/*50/ encodeAddi(5'b0,  5'd5,  12'h1); // Increase X counter
/*54/ encodeBlt (5'd2,  5'd5,  LoopY); // JMP "Loop Y" if X > X resolution
/*58/ encodeFADD(5'd10, 5'd1,  5'd10, `FRM_RTZ); // Increase X step
/*5c/ encodeFADD(5'b0,  5'd10, 5'd12, `FRM_RTZ); // Init Real register
    
/*  / // Init Mandelbrot
/*60/ encodeAdd (5'b0,  5'b0,  5'd7 ); // Flush flag OOB
/*64/ encodeAdd (5'b0,  5'b0,  5'd4 ); // Flush iteration counter
    
/*  / // Mandelbrot iteration loop
/*68/ encodeAddi(5'b0,  5'd4,  12'h1); // Increase iteration counter
/*6c/ encodeBge (5'd4,  5'd1,  Res1 ); // JMP "Result = 1" if count > Max iter.

/*70/ encodeFMUL(5'd10, 5'd10, 5'd14, `FRM_RTZ); // RxR
/*74/ encodeFMUL(5'd13, 5'd13, 5'd15, `FRM_RTZ); // IxI
/*78/ encodeFMUL(5'd10, 5'd13, 5'd16, `FRM_RTZ); // RxI
/*7c/ encodeFSUB(5'd14, 5'd15, 5'd12, `FRM_RTZ); // Real = RxR - IxI
/*80/ encodeFADD(5'd16, 5'd16, 5'd13, `FRM_RTZ); // Imag = 2xRxI

/*84/ encodeFADD(5'd10, 5'd12, 5'd12, `FRM_RTZ); // Real = Real + C_real
/*88/ encodeFADD(5'd11, 5'd13, 5'd13, `FRM_RTZ); // Imag = Imag + C_imag

/*8c/ encodeFlt (5'd4,  5'd12, 5'd7 ); // Rise flag of Real > 2
/*90/ encodeBeq (5'd8,  5'd7,  Res0 ); // JMP "Result = 0" if value OOB.

/*94/ encodeFlt (5'd4,  5'd13, 5'd7 ); // Rise flag of Imag > 2
/*98/ encodeBeq (5'd8,  5'd7,  Res0 ); // JMP "Result = 0" if value OOB.

/*9c/ encodeFlt (5'd12, 5'd5,  5'd7 ); // Rise flag of Real < -2
/*a0/ encodeBeq (5'd8,  5'd7,  Res0 ); // JMP "Result = 0" if value OOB.

/*a4/ encodeFlt (5'd13, 5'd5,  5'd7 ); // Rise flag of Imag < -2
/*a8/ encodeBeq (5'd8,  5'd7,  Res0 ); // JMP "Result = 0" if value OOB.

/*ac/ encodeJal (5'b0,  MandelLoop  ); // JMP Mandelbrot Loop, for next iteration loop
    
/*  / // Mandelbrot result
/*  /   // Result = 1
/*b0/ encodeAdd (5'd9,  5'd11, 5'd11 );// Update result register.
/*  /   // Result = 0
/*b4/ encodeBeq (5'd9,  5'd10, STOREres);// JMP "STORE res" if shifter is '10..0'
/*b8/ encodeSlli(5'd9,  5'd9,  12'b1 );// Prepare counter shifter for next result
/*bc/ encodeJal (5'b0,  LoopX);        // JMP "Loop X" Result recorded, next X.
/*  /   // STORE res
/*c0/ encodeAddi(5'b0,  5d'9,  12'h1 );// Reset shifter counter
/*c4/ encodeSW  (5'd12, 5'd11, 12'h24);// Store 32 Mandelbrot results
/*c8/ encodeAddi(5'd12, 5'd12, 12'h4 );// Increment +4 data store pointer
/*cc/ encodeAdd (5'b0,  5'b0,  5'd11 );// Flush result register after storing
/*d0/ encodeJal (5'b0,  LoopX);        // JMP "Loop X" Result recorded, next X.
    
/*  / // Finish. Check what writes the AXI bus to change screen.
/*d4/ encodeLW  (5'b0,  5'd4,  12'h24); // LOAD AXI bus buttons and check its value.

/*d8/ encodeBeq (5'd8,  5'd4,  Pzoom);  // 1 = JMP +zoom
/*dc/ encodeSlli(5'd4,  5'd4,  12'h1);
/*e0/ encodeBeq (5'd8,  5'd4,  Mzoom);  // 2 = JMP -zoom
/*e4/ encodeSlli(5'd4,  5'd4,  12'h1);
/*e8/ encodeBeq (5'd8,  5'd4,  PX);     // 4 = JMP +X
/*ec/ encodeSlli(5'd4,  5'd4,  12'h1);
/*f0/ encodeBeq (5'd8,  5'd4,  MX);     // 8 = JMP -X
/*f4/ encodeSlli(5'd4,  5'd4,  12'h1);
/*f8/ encodeBeq (5'd8,  5'd4,  PY);     // 16 = JMP +Y
/*fc/ encodeSlli(5'd4,  5'd4,  12'h1);
/*100/encodeBeq (5'd8,  5'd4,  MY);     // 32 = JMP -Y

/*104/encodeJal (5'b0,  12'hd4); // JMP "Finish" Check again if the buttons have been pressed.

/ / // +zoom
/ /
/ /
/ /
/ /

  end
endtask */

//**********************************//**********************************//**********************************/
//**********************************//**********************************//**********************************/
//**********************************
//** Instruction set RV32I encode **
//********************************** 

task encodeLui;
  input [4:0] rd;
  input [19:0] immediate;
  begin
    instruction = {immediate[19:0], rd, `OPCODE_U_LUI};
    // top_CoreMem_inst.mem_instr_inst.mem[pc >> 2] = instruction;
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    // $display("mem[%d] = %b", pc, top_CoreMem_inst.mem_instr_inst.mem[pc]);
    pc = pc + 32'd4;
  end
endtask

task encodeAuipc;
  input [4:0] rd;
  input [19:0] immediate;
  begin
    instruction = {immediate[19:0], rd, `OPCODE_U_AUIPC};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeJal;
  input [4:0] rd;
  input [20:0] immediate;
  begin
    instruction = {immediate[20], immediate[10:1], immediate[11], immediate[19:12], rd, `OPCODE_J_JAL};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeJalr;
  input [4:0] rd;
  input [4:0] rs1;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b0, rd, `OPCODE_I_JALR};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeBeq;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b0, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeBne;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b1, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBlt;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b100, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBge;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b101, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBltu;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b110, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeBgeu;
  input [4:0] rs1;
  input [4:0] rs2;
  input [12:0] immediate;
  begin
    instruction = {immediate[12], immediate[10:5], rs2, rs1, 3'b11, immediate[4:1], immediate[11], `OPCODE_B_BRANCH};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLB;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LB, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeLH;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LH, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeLW;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LW, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLBU;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LBU, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeLHU;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, `FUNCT3_LHU, rd, `OPCODE_I_LOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSB;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SB, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeSH;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SH, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
 endtask

task encodeSW;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] offset;
  begin
    instruction = {offset[11:5], rs2, rs1, `FUNCT3_SW, offset[4:0], `OPCODE_S_STORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeAddi;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b000, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask
 
task encodeSlti;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b010, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSltiu;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b011, rd, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
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
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSlli;
  input [4:0] rs1;
  input [4:0] rd;
  input [4:0] immediate;
  begin
    instruction = {7'h0, immediate, rs1, `FUNCT3_SLLI, rd, `OPCODE_I_IMM}; // 3'b001
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
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
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSub; // Added encodeSub because I didn't find it.
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'h20, rs2, rs1, 3'b000, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSll;
  input [4:0] rs1;
  input [4:0] rd;
  input [4:0] immediate;
  begin
    instruction = {7'h0, immediate, rs1, 3'b001, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSlt;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b010, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeSltu;
  input [4:0] rs1;
  input [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b011, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
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
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

// TASK FENCE

// TASK ECALL

// TASK EBREAK

task encodeNOOP;
  begin
    instruction = {12'b0, 5'h0, 3'h0, 5'h0, `OPCODE_I_IMM};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
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
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task iniinstrMem;
  integer addr;
  begin
    for (addr = 0; addr < 1024; addr = addr + 1)
    begin
      top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[addr][0] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[addr][1] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[addr][2] = 8'h0;
      top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[addr][3] = 8'h0;		
    end
  end
endtask

//always @ (negedge clk) begin
		// $display("reg5 = %d\npc = %d\ninst = %b", top_CoreMem_inst.reg_file_inst.regFile[5], top_CoreMem_inst.addr_instrMem, top_CoreMem_inst.instruction_instrmem);
		// $display("reg1 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[1]);
        // $display("reg2 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[2]);
        //$display("reg3 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[3]);
        // $display("reg4 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[4]);
        //$display("reg5 = %h", top_CoreMem_inst.core_inst.id_stage_inst.reg_file_inst.regFile[5]);
		// $display("rs2_exec_unit_t = %d", top_CoreMem_inst.rs2_exec_unit_t);
		// $display("ALU_op_t = %d", top_CoreMem_inst.ALU_op_t);
		//$display("is_imm_t = %d", top_CoreMem_inst.is_imm_t);
		// $display("r_num_write_reg_file = %d", top_CoreMem_inst.r_num_write_reg_file);
        //$display("pc = %d", top_CoreMem_inst.core_inst.instrram_counter_inst.addr);

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
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULH;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b001, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULHSU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b010, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeMULHU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b011, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeDIV;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b100, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeDIVU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b101, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeREM;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b110, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeREMU;
  input [4:0] rs1;
  input [4:0] rs2;
  input [4:0] rd;
  begin
    instruction = {7'b1, rs2, rs1, 3'b111, rd, `OPCODE_R_ALU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask


//******************************
//** Instruction set F encode **
//******************************

task encodeFLW;
  input  [4:0] rs1;
  input  [4:0] rd;
  input [11:0] immediate;
  begin
    instruction = {immediate, rs1, 3'b010, rd, `OPCODE_I_FLOAD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSW;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input [11:0] immediate;
  begin
    instruction = {immediate[11:5], rs2, rs1, 3'b010, immediate[4:0], `OPCODE_S_FSTORE};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMADD;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rs3;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {rs3, 2'b0, rs2, rs1, rm, rd, `OPCODE_R4_FMADD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMSUB;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rs3;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {rs3, 2'b0, rs2, rs1, rm, rd, `OPCODE_R4_FMSUB};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFNMSUB;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rs3;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {rs3, 2'b0, rs2, rs1, rm, rd, `OPCODE_R4_FNMSUB};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFNMADD;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rs3;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {rs3, 2'b0, rs2, rs1, rm, rd, `OPCODE_R4_FNMADD};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFADD;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FADD, 2'b0, rs2, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSUB;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FSUB, 2'b0, rs2, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMUL;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FMUL, 2'b0, rs2, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFDIV;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FDIV, 2'b0, rs2, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSQRT;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FSQRT, 2'b0, rs2, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSGNJ;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FSGNJ, 2'b0, rs2, rs1, 3'b000, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSGNJN;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FSGNJ, 2'b0, rs2, rs1, 3'b001, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFSGNJX;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FSGNJ, 2'b0, rs2, rs1, 3'b010, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMIN;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FMINMAX, 2'b0, rs2, rs1, 3'b000, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMAX;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FMINMAX, 2'b0, rs2, rs1, 3'b001, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFCVT_W_S;
  input  [4:0] rs1;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FCVT_W_S, 2'b0, 5'b00000, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFCVT_WU_S;
  input  [4:0] rs1;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FCVT_W_S, 2'b0, 5'b00001, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMV_X_W;
  input  [4:0] rs1;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FMV_X_W, 2'b0, 5'b00000, rs1, 3'b000, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFEQ;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FEQ, 2'b0, rs2, rs1, 3'b010, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFLT;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FEQ, 2'b0, rs2, rs1, 3'b001, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFLE;
  input  [4:0] rs1;
  input  [4:0] rs2;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FEQ, 2'b0, rs2, rs1, 3'b000, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFCLASS;
  input  [4:0] rs1;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FMV_X_W, 2'b0, 5'b00000, rs1, 3'b001, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFCVT_S_W;
  input  [4:0] rs1;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FCVT_F_W, 2'b0, 5'b00000, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFCVT_S_WU;
  input  [4:0] rs1;
  input  [4:0] rd;
  input  [2:0] rm;
  begin
    instruction = {`ALU_OP_FCVT_F_W, 2'b0, 5'b00001, rs1, rm, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task encodeFMV_W_X;
  input  [4:0] rs1;
  input  [4:0] rd;
  begin
    instruction = {`ALU_OP_FMV_W_X, 2'b0, 5'b00000, rs1, 3'b000, rd, `OPCODE_R_FPU};
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][0] = instruction[7:0];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][1] = instruction[15:8];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][2] = instruction[23:16];
    top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[pc >> 2][3] = instruction[31:24];		
    pc = pc + 32'd4;
  end
endtask

task rstinstrMem;
  integer i;
  begin
    instruction = {{`DATA_WIDTH-7{1'b0}}, `OPCODE_I_IMM};
    for (i=0; i<1024; i=i+1) begin
     top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[i][0] = instruction[7:0];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[i][1] = instruction[15:8];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[i][2] = instruction[23:16];
     top_CoreMem_inst.instr_mem.sp_ram_wrap_instr_i.sp_ram_instr_i.mem_instr[i][3] = instruction[31:24];
    end
  end
endtask

endmodule   