`timescale 1ns / 1ps

module instr_mem(
    input  logic [31:0] addr_i,
    output logic [31:0] read_data_o
    );
    
        logic [7:0] memory [1024];
        
    initial begin
        $readmemh("program.txt", memory);
    end
    
    always_comb begin
    
        if(addr_i < 1021)begin
            read_data_o <= {memory[addr_i+3],memory[addr_i+2],memory[addr_i+1],memory[addr_i]};    
        end
        
        else begin
            read_data_o <= 0;
        end
       
    end
    
endmodule
