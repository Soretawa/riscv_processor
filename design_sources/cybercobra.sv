`timescale 1ns / 1ps

module CYBERcobra(
    input logic clk_i,
    input logic rst_i,
    input logic [15:0] sw_i,
    output logic [31:0] out_o
    );
    
    //подключение памяти инструкций к счетчику
    logic [31:0] PC;
    logic [31:0] PC_add;
    
    always_ff @(posedge clk_i) begin
    
        if (rst_i)
        PC <= 32'd0;
        
        else
        PC <= PC + PC_add;
    end
    
    instr_mem instr_mem (
                .addr_i(PC),
                .read_data_o(read_data_instr_mem)
    );
    
    //подключение регистрового файла к АЛУ
    
    logic [31:0] read_data1_rf;
    logic [31:0] read_data2_rf;
    logic [31:0] result_alu;
    logic [31:0] write_rf;
    logic alu_flag;
    
    rf_riscv rf_riscv (
                .clk_i(clk_i),
                .write_enable_i(!(read_data_instr_mem[31] || read_data_instr_mem[30])),
                
                .write_addr_i(read_data_instr_mem[4:0]),
                .read_addr1_i(read_data_instr_mem[22:18]),
                .read_addr2_i(read_data_instr_mem[17:13]),
                
                .write_data_i(write_rf),
                .read_data1_o(read_data1_rf),
                .read_data2_o(read_data2_rf)
    );
    
   assign out_o = read_data1_rf;
    
    alu_riscv alu_riscv (
                .a_i(read_data1_rf),
                .b_i(read_data2_rf),
                .alu_op_i(read_data_instr_mem[27:23]),
                .flag_o(alu_flag),
                .result_o(result_alu)
    );
    
   //реализация шины данных для вычислительных инструкций
   
   logic [31:0] read_data_instr_mem;
   
   //реализация загрузки константы и данных с внешних устройств в регистровый файл
   
   logic [31:0] sign_extension1;
   logic [31:0] sign_extension2;
   logic [31:0] sign_extension3;
   
   
   assign sign_extension1 = {{9{read_data_instr_mem[27]}},read_data_instr_mem[27:5]};
   assign sign_extension2 = {{16{sw_i[15]}},sw_i[15:0]};
   assign sign_extension3 = {{22{read_data_instr_mem[12]}},read_data_instr_mem[12:5],2'b0};
   
   always_comb begin
   
        case(read_data_instr_mem[29:28])
            
            2'b00: write_rf <= sign_extension1;
            2'b01: write_rf <= result_alu;
            2'b10: write_rf <= sign_extension2;
            2'b11: write_rf <= 32'd0;
            
        endcase
        
   end
   
   //реализация условного и безусловного перехода
   
   assign multiplexor_PC = (read_data_instr_mem[30] & alu_flag) | read_data_instr_mem[31];
   always_comb begin
        case (multiplexor_PC)
            
            1'b0: PC_add <= 32'd4;
            1'b1: PC_add <= sign_extension3;
            
        endcase
   end
           

endmodule
