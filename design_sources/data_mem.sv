`timescale 1ns / 1ps

module data_mem(
    input logic clk_i,
    input logic mem_req_i,
    input logic write_enable_i,
    input logic [31:0] addr_i,
    input logic [31:0] write_data_i,
    output logic [31:0] read_data_o
    );
    
    logic [31:0] memory [1024];

    always_comb begin
        read_data_o <= 0;
        if( mem_req_i == 1 && write_enable_i == 0)
        read_data_o <= memory[addr_i];
        
   end
    
    always_ff @(posedge clk_i)begin
    
        if(mem_req_i && write_enable_i)begin
                memory [addr_i] <= write_data_i;
        end
    
    end
  
endmodule
