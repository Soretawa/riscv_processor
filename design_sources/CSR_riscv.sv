`timescale 1ns / 1ps

module CSR_riscv(
    input logic clk_i,

    input logic [31:0] write_data_i,
    input logic [2:0] csr_op_i,
    input logic [31:0] pc_i,
    input logic [11:0] addr_i,
    input logic [31:0] mcause_i,
    
    output logic [31:0] mie_o,
    output logic [31:0] mtvec_o,
    output logic [31:0] mepc_o,
    output logic [31:0] read_data_o 
    );
    
    logic [31:0] WD_mux;
    logic mie_en;
    logic mtvec_en;
    logic mscratch_en;
    logic mepc_en;
    logic mcause_en;
    
    always_comb begin
        case (csr_op_i[1:0])
            0: WD_mux <= 32'b0;
            1: WD_mux <= write_data_i;
            2: WD_mux <= !write_data_i & read_data_o;
            3: WD_mux <= write_data_i | read_data_o;
        endcase
    end
    
    always_comb begin
            read_data_o <= 32'b0;
        case (addr_i)
            12'h304: read_data_o <= mie_o;
            12'h305: read_data_o <= mtvec_o;
            12'h340: read_data_o <= mscratch;
            12'h341: read_data_o <= mepc_o;
            12'h342: read_data_o <= mcause_reg;
        endcase
    end
    
    logic [31:0] mepc_mux;
    logic [31:0] mcause_mux;
    
    always_comb begin
        case (csr_op_i[2])
            0: begin
                mepc_mux <= WD_mux;
                mcause_mux <= WD_mux;
            end
            1: begin
                mepc_mux <= pc_i;
                mcause_mux <= mcause_i;
            end
        endcase
    end
    
    logic [31:0] mscratch;
    logic [31:0] mcause_reg;
    
    always_ff @(posedge clk_i) begin
        if (mie_en) mie_o <= WD_mux;
        if (mtvec_en) mtvec_o <= WD_mux;
        if (mscratch_en) mscratch <= WD_mux;
        if (mepc_en | csr_op_i[2]) mepc_o <= mepc_mux;
        if (mcause_en | csr_op_i[2]) mcause_reg <= mcause_mux;
    end
    
    always_comb begin
        case (addr_i)
        
            12'h304: begin
                mie_en <= csr_op_i[1] | csr_op_i[0];
                mtvec_en <= 0;
                mscratch_en <= 0;
                mepc_en <= 0;
                mcause_en <= 0;
            end
            
            12'h305: begin
                mtvec_en <= csr_op_i[1] | csr_op_i[0];
                mie_en <= 0;
                mscratch_en <= 0;
                mepc_en <= 0;
                mcause_en <= 0;
            end
            
            12'h340: begin
                mscratch_en <= csr_op_i[1] | csr_op_i[0];
                mtvec_en <= 0;
                mie_en <= 0;
                mepc_en <= 0;
                mcause_en <= 0;
            end
            
            12'h341: begin 
                mepc_en <= csr_op_i[1] | csr_op_i[0];
                mtvec_en <= 0;
                mscratch_en <= 0;
                mie_en <= 0;
                mcause_en <= 0;
            end
            
            12'h342: begin 
                mcause_en <= csr_op_i[1] | csr_op_i[0];
                mtvec_en <= 0;
                mscratch_en <= 0;
                mepc_en <= 0;
                mie_en <= 0;
            end
            
            default: begin
                mcause_en <= 0;
                mtvec_en <= 0;
                mscratch_en <= 0;
                mepc_en <= 0;
                mie_en <= 0;
            end
            
        endcase
    end

endmodule
