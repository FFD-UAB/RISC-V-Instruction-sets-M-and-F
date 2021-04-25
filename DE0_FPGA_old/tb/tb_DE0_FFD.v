`timescale 1ns/1ns

module tb_DE0_FFD();

reg       clk;
reg [2:0] buttons;
reg [9:0] SW;

top_DE0 DE0(
        ////////////////////    Clock Input         ////////////////////     
        .CLOCK_50      ( clk          ),  // 50 MHz
        .CLOCK_50_2    ( 1'b0         ),  // 50 MHz
        ////////////////////    Push Button        ////////////////////
        .ORG_BUTTON    ( buttons[2:0] ),  // Pushbutton[2:0]
        ////////////////////    DPDT Switch        ////////////////////
        .SW            ( SW[9:0]      )   // Toggle Switch[9:0]
        ////////////////////    Debug I/O to make it synthesize everything
    );

always #10 clk = !clk;

initial begin
clk = 1'b0;
SW = 10'b1; // Select 1MHz PLL clock to core
buttons = 3'b1;

#100 buttons[0] = 1'b0;

#100 buttons[0] = 1'b1;


#10000 $stop;

end


endmodule