`timescale 1ns / 1ps


module miriscv_top(
    input logic clk_i,
    input logic rst_i,
    
    input logic [31:0] int_req_i,
    output logic [31:0] int_fin_o,
    
    
    //input logic uart_rx_i,
    //output logic uart_tx_o
    uart.dut myuart
    );
    
    logic clk_gen;
    
    clkgen clkgen(
        .clkin(clk_i),
        .clkout(clk_gen)
    );
    
    memory MEMORY_IF();
    
    logic [31:0] instr;
    logic [31:0] instr_addr;
    
    logic [31:0] data_rdata;
    logic data_req;
    logic data_we;
    logic [3:0] data_be;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    
    logic [31:0] mcause;
    logic int_i;
    logic int_rst;
    logic [31:0] mie;
    
    riscv_core core(
        .clk_i(clk_gen),
        .rst_i(rst_i),
        // memory interface
        .MEMORY_IF(MEMORY_IF),
        .data_rdata_i(data_rdata),
        /*.instr_i(instr),
        .instr_addr_o(instr_addr),
        
        .data_rdata_i(data_rdata),*/
        .data_req_o(data_req),
        /*.data_we_o(data_we),
        .data_be_o(data_be),
        .data_addr_o(data_addr),
        .data_wdata_o(data_wdata),*/
        
        //interrupt controller
        .mcause_i(mcause),
        .int_i(int_i),
        .int_rst_o(int_rst),
        .mie_o(mie)
    );
     
    intctrl_riscv intctrl(
        .clk_i(clk_gen),
        .int_rst_i(int_rst),
        
        .mie_i(mie),
        .int_req_i(int_req_i),
        .mcause_o(mcause),
        .int_o(int_i),
        .int_fin_o(int_fin_o)
    );
    
    //œŒƒ Àﬁ◊≈Õ»≈ œ≈–»‘≈–»»
    
    logic [7:0] periph_addr;
    logic [31:0] addr_reg; 
    
    logic memory_request;
    logic uart_tx_request;
    logic uart_rx_request;
    
    assign periph_addr = MEMORY_IF.data_addr[31:24];
    assign addr_reg = {8'd0, MEMORY_IF.data_addr[23:0]};
    
    logic [7:0] periph_request;
    
    // one hot encoder
    always_comb begin
        periph_request <= 7'b0;
        periph_request[periph_addr] <= 1;
    end
    //
    assign memory_request = data_req & periph_request[0];
    assign uart_tx_request = data_req & periph_request[6];
    assign uart_rx_request = data_req & periph_request[5];
    
    logic [31:0] mem_rdata;
    logic [31:0] uart_tx_rdata;
    logic [31:0] uart_rx_rdata;
    
    
    miriscv_ram ram(
        .clk_i(clk_gen),
        .rst_n_i(rst_i),
        // memory interface
        .MEMORY_IF(MEMORY_IF),
        .data_rdata_o(mem_rdata),
        //instructions
        /*.instr_data_o(instr),
        .instr_addr_i(instr_addr),
        //data memory
        .data_rdata_o(mem_rdata),*/
        .data_req_i(memory_request)
        /*.data_we_i(data_we),
        .data_be_i(data_be),
        .data_addr_i(addr_reg),
        .data_wdata_i(data_wdata)*/      
    );
    
    //œŒƒ Àﬁ◊¿≈Ã œ≈–≈ƒ¿“◊»  UART
    
    uart_tx uart_tx(
    
        .clk_i(clk_gen),
        .rst_i(rst_i),
        
        .uart_we_i(MEMORY_IF.data_we),
        .uart_req_i(uart_tx_request),
        .uart_data_i(MEMORY_IF.data_wdata),
        
        .addr_i(addr_reg),
        .uart_data_o(uart_tx_rdata),
        .uart_tx_o(myuart.tx_o)
    );
    
    uart_rx uart_rx(
        .clk_i(clk_gen),
        .rst_i(rst_i),
        
        .rx_i(myuart.rx_i),
        .uart_we_i(MEMORY_IF.data_we),
        .uart_req_i(uart_rx_request),
        .uart_data_i(MEMORY_IF.data_wdata),
        
        .addr_i(addr_reg),
        .uart_data_o(uart_rx_rdata)
    );
    
    always_comb begin
        data_rdata <= 0;
        case (periph_addr)
            8'h00: data_rdata <= mem_rdata;
            8'h05: data_rdata <= uart_rx_rdata;
            8'h06: data_rdata <= uart_tx_rdata;
        endcase
    end
endmodule
