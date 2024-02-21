`timescale 1ns / 1ps

module miriscv_ram(
        input logic clk_i,
        input logic rst_n_i,
        
        input logic data_req_i,
        /*output logic [31:0] instr_data_o,
        input logic [31:0] instr_addr_i,
        
        output logic [31:0] data_rdata_o,
        input logic data_req_i,
        input logic data_we_i,
        input logic [3:0] data_be_i,
        input logic [31:0] data_addr_i,
        input logic [31:0] data_wdata_i*/
        
        memory.ram MEMORY_IF,
        output logic [31:0] data_rdata_o
    );
    
    logic [7:0] instr_rom [1024];
    logic [7:0] data_ram [1024];
    
    initial begin
        $readmemh("init_instr.mem", instr_rom);
    end
    
    
    logic [9:0] instr_loaddr, data_loaddr;
    assign instr_loaddr = {MEMORY_IF.instr_addr[9:2], 2'b00};  
    assign data_loaddr = {MEMORY_IF.data_addr[9:2], 2'b00};
    
    always_comb begin // œ¿Ãﬂ“‹ »Õ—“–” ÷»…
        MEMORY_IF.instr_data <= {instr_rom[instr_loaddr+3], instr_rom[instr_loaddr+2], instr_rom[instr_loaddr+1], instr_rom[instr_loaddr]};
    end
    
    always_ff @(posedge clk_i) begin //◊“≈Õ»≈ »« œ¿Ãﬂ“» ƒ¿ÕÕ€’
    
        if (data_req_i & MEMORY_IF.data_we) begin
            if (MEMORY_IF.data_be[0]) data_ram[data_loaddr] <= MEMORY_IF.data_wdata[7:0];
            if (MEMORY_IF.data_be[1]) data_ram[data_loaddr+1] <= MEMORY_IF.data_wdata[15:8];
            if (MEMORY_IF.data_be[2]) data_ram[data_loaddr+2] <= MEMORY_IF.data_wdata[23:16];
            if (MEMORY_IF.data_be[3]) data_ram[data_loaddr+3] <= MEMORY_IF.data_wdata[31:24];
        end
    end
    
    always_comb begin
        data_rdata_o <= 0;
        if (data_req_i & !MEMORY_IF.data_we)
        data_rdata_o <= {data_ram[data_loaddr+3], data_ram[data_loaddr+2], data_ram[data_loaddr+1], data_ram[data_loaddr]};
    end

endmodule
