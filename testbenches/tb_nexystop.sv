`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2023 18:17:11
// Design Name: 
// Module Name: tb_nexystop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_nexystop();
    reg CLK;
    reg RST;
    reg TX;
    reg RX;
    
    nexys_top DUT(
        .CLK100(CLK),
        .resetn(RST),
        .RX(RX),
        .TX(TX)
    );
    initial CLK <= 0;
    always #5 CLK <= ~CLK;
    initial begin
        RST = 0;
        RX = 1;
        #20
        RST = 1;
        #95680
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 0;
        #8700
        RX = 0;
        #8700
        RX = 1;
        
        #95680
        RX = 0;
        #8700
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 1;
        #8700
        RX = 1;
        #8700
        RX = 0;
        #8700
        RX = 0;
        #8700
        RX = 1;
        #8700
        RX = 1;
        #8700
        RX = 1;
        #8700
        RX = 1;
    end
    initial #1ms $finish();
    
endmodule
