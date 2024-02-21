`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2023 13:36:10
// Design Name: 
// Module Name: adder
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


module adder(
    input logic a_i,
    input logic b_i,
    input logic carry_i,
    output logic sum_o,
    output logic carry_o
    );
    
    assign sum_o = (a_i ^ b_i) ^ carry_i;
    assign carry_o = ((a_i & b_i)|(a_i & carry_i))|(b_i & carry_i);
    
endmodule
