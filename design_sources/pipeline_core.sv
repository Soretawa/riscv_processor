`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2024 20:58:11
// Design Name: 
// Module Name: pipeline_core
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


module pipeline_core(
    input logic clk_i,
    input logic rst_i
    );
    
    logic [31:0] PC;
    logic [31:0] instr;
    
    instr_mem instr_mem(
        .addr_i(PC),
        .read_data_o(instr)
    );
    
    logic [4:0] read_addr_1;
    logic [4:0] read_addr_2;
    logic [4:0] write_addr;
    
    logic [31:0] imm_I;
    logic [31:0] imm_U;
    logic [31:0] imm_S;
    logic [31:0] imm_B;
    logic [31:0] imm_J;
    
    assign read_addr_1 = instr[19:15];
    assign read_addr_2 = instr[24:20];
    assign write_addr = instr[11:7];
    
    assign imm_I = {{20{instr[31]}}, instr[31:20]};// знакорасширенные константы
    assign imm_U = {instr[31:12], 12'h000};
    assign imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    assign imm_B = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign imm_J = {{10{instr[31]}}, instr[31], instr[19:12], instr[20], instr[31:21],1'b0};
    
    logic gpr_we;
    logic [31:0] writeback;
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    
    rf_riscv rf_riscv(      //подключение рф
        .clk_i(clk_i),
        .write_enable_i(gpr_we),
        
        .read_addr1_i(read_addr_1),
        .read_addr2_i(read_addr_2),
        .write_addr_i(write_addr),
        
        .write_data_i(writeback),
        .read_data1_o(read_data1),
        .read_data2_o(read_data2)
    );
    
    logic stall;
    logic [2:0] a_sel;
    logic [3:0] b_sel;
    logic [4:0] alu_op;
    logic mem_req;
    logic mem_we;
    logic wb_sel;
    logic branch;
    logic jal;
    logic jalr;
    logic enpc;
    
    decoder_riscv decoder_riscv( // подключение дешифратора
        .fetched_instr_i(instr),
        .stall_i(stall),
        //.int_i(int_i),
        
        .a_sel_o(a_sel),
        .b_sel_o(b_sel),
        .alu_op_o(alu_op),
        
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        //.mem_size_o(mem_size),
        
        .gpr_we_o(gpr_we),
        .wb_sel_o(wb_sel),
        .illegal_instr_o(),
        
        .branch_o(branch),
        .jal_o(jal),
        .jalr_o(jalr),
        
        .enpc_o(enpc)
        
        //.csr_o(csr),
        //.int_rst_o(int_rst_o),
        //.csr_op_o(csr_op)
        
    );
    
endmodule
