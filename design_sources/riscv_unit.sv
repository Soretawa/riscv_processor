`timescale 1ns / 1ps

module riscv_unit(
        input clk_i,
        input rst_i,
        output [31:0] instruction,
        output [31:0] data_alu,
        output [31:0] PC_out,
        output illegal_instr,
        output [31:0] memory_writedata,
        output [31:0] memory_readdata,
        output mem_request,
        output stall_c,
        output [31:0] wb_data_o
    );
    
    logic [31:0] instr;
    logic [31:0] addr;
    
    instr_mem instr_mem (
        .addr_i(addr),
        .read_data_o(instr)
    );
    
    logic mem_req;
    logic mem_we;
    logic [31:0] mem_wd;
    logic [31:0] data_addr;
    logic [31:0] read_datamem;
    
    logic stall;
    logic stall_i;
    
    assign stall_i = !stall & mem_req;
    
    always_ff @(posedge clk_i) begin  // ошибка со stall
        if (rst_i)
            stall <= 0;
        else
            stall <= stall_i;
    end
    
    riscv_core riscv_core(
        .clk_i (clk_i),
        .rst_i (rst_i),
        .stall_i (stall_i),
        
        .instr_i (instr),
        .mem_rd_i (read_datamem),
        
        .instr_addr_o(addr),
        
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        .mem_size_o(),
        .mem_wd_o(mem_wd),
        
        
        .illegal_instr_o(illegal_instr),
        .data_addr_o(data_addr),
        .wb_data_o(wb_data_o)
    );
    
    data_mem data_mem (
        .clk_i (clk_i),
        .mem_req_i (mem_req),
        .write_enable_i (mem_we),
        .addr_i (data_addr),
        .write_data_i (mem_wd),
        .read_data_o (read_datamem)
    );
    
    assign instruction = instr;
    assign data_alu = data_addr;
    assign PC_out = addr;
    assign memory_writedata = mem_wd;
    assign memory_readdata = read_datamem;
    assign mem_request = mem_req;
    assign stall_c = stall_i;
    
endmodule
