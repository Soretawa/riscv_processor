`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2023 13:40:02
// Design Name: 
// Module Name: fulladder32
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
module fulladder32(
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        carry_i,
    output logic [31:0] sum_o,
    output logic        carry_o
);

    logic [32:0] carry;
    genvar i;
    generate 
            assign carry[0] = carry_i;
            for(i = 0; i < 32; i = i + 1)begin: newgen
               adder add(
                .a_i(a_i[i]),
                .b_i(b_i[i]),
                .carry_i(carry[i]),
                .carry_o(carry[i+1]),
                .sum_o(sum_o[i])
               );
            end
            assign carry_o = carry[32];
    endgenerate
endmodule