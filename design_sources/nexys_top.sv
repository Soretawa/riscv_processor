`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2023 14:01:14
// Design Name: 
// Module Name: nexys_top
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

module nexys_top(
    input logic CLK100,
    input logic resetn,
    
    input logic RX,
    output logic TX
    );
    
    logic RST;
    assign RST = !resetn;
    
    uart myuart();
   
    assign myuart.rx_i = RX;
    assign TX = myuart.tx_o;
    
    miriscv_top top(
        .clk_i(CLK100),
        .rst_i(RST),
        .myuart(myuart)
 //       .uart_rx_i(UART_TXD_IN),
 //       .uart_tx_o(UART_RXD_OUT)
    );
    
endmodule
