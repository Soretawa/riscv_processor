module decoder_riscv (
  input  logic [31:0]  fetched_instr_i,
  input  logic         stall_i,
  input  logic         int_i,
  
  output logic         csr_o,
  output logic [2:0]   csr_op_o,
  output logic         int_rst_o,
  
  output logic [1:0]   a_sel_o,
  output logic [2:0]   b_sel_o,
  output logic [4:0]   alu_op_o,
  output logic         mem_req_o,
  output logic         mem_we_o,
  output logic [2:0]   mem_size_o,
  output logic         gpr_we_o,
  output logic         wb_sel_o,        //write back selector
  output logic         illegal_instr_o,
  output logic         branch_o,
  output logic         jal_o,
  output logic [1:0]   jalr_o,
  output logic         enpc_o
);
  import riscv_pkg::*;
  import alu_opcodes_pkg::*;
  
  assign enpc_o = stall_i;
  
  always_comb begin
  
    a_sel_o <= '0;
    b_sel_o <= '0;
    alu_op_o <= '0;
    wb_sel_o <= 1'b0;
    gpr_we_o <= 1'b0;
    jal_o <= 1'b0;
    jalr_o <= 2'b0;
    branch_o <= 1'b0;
    mem_size_o <= 3'b0;
    mem_we_o <= 1'b0;
    mem_req_o <= 1'b0;
    illegal_instr_o <= 0;
    csr_o <= 0;
    int_rst_o <= 0;
    csr_op_o <= 3'b000;
  
    if (int_i) begin
    
        a_sel_o <= OP_A_RS1;
        b_sel_o <= OP_B_IMM_I;
        alu_op_o <= ALU_ADD;
        wb_sel_o <= 1'b0;
        gpr_we_o <= 1'b0;
        jal_o <= 1'b0;
        jalr_o <= 2'b11;
        branch_o <= 1'b0;
        mem_size_o <= 3'b0;
        mem_we_o <= 1'b0;
        mem_req_o <= 1'b0;
        illegal_instr_o <= 0;
        csr_o <= 0;
        int_rst_o <= 0;
        csr_op_o <= 3'b100;
        
    end else begin
    
    case (fetched_instr_i[6:0])
    
        {LOAD_OPCODE,2'b11}: begin
            case (fetched_instr_i[14:12])
            
                LDST_B: begin
                    if (!stall_i) begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b1;
                        gpr_we_o <= 1'b1;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_B;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end else begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_B;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0; 
                    end    
                end
                
                LDST_H: begin
                    if (!stall_i) begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b1;
                        gpr_we_o <= 1'b1;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_H;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end else begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_H;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end
                end
                
                LDST_W: begin
                    if (!stall_i) begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b1;
                        gpr_we_o <= 1'b1;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_W;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end else begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_W;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end
                end
                
                LDST_BU: begin
                    if (!stall_i) begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b1;
                        gpr_we_o <= 1'b1;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_BU;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end else begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_BU;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end
                end
                
                LDST_HU: begin
                    if (!stall_i) begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b1;
                        gpr_we_o <= 1'b1;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_HU;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end else begin
                        a_sel_o <= OP_A_RS1;
                        b_sel_o <= OP_B_IMM_I;
                        alu_op_o <= ALU_ADD;
                        wb_sel_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        jal_o <= 1'b0;
                        jalr_o <= 2'b0;
                        branch_o <= 1'b0;
                        mem_size_o <= LDST_HU;
                        mem_we_o <= 1'b0;
                        mem_req_o <= 1'b1;
                        illegal_instr_o <= 0;
                        csr_o <= 0;
                        int_rst_o <= 0;
                        csr_op_o <= 3'b0;
                    end
                end
                
                default: begin
                    illegal_instr_o <= 1;
                    gpr_we_o <= 0;
                    mem_req_o <= 0;
                end
            endcase
                     
        end
        
        {MISC_MEM_OPCODE, 2'b11}: begin
            case (fetched_instr_i[14:12])
                3'b000: illegal_instr_o <= 0; //nop
                default: illegal_instr_o <= 1; 
            endcase
        end
        
        {OP_IMM_OPCODE,2'b11}: begin
        
            case (fetched_instr_i[14:12])
            
                3'b000: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b100: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_XOR;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b110: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_OR;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b111: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_AND;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b010: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_SLTS;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b011: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_SLTU;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b001: begin
                
                    case (fetched_instr_i[31:25])
                              
                        7'd0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_IMM_I;
                            alu_op_o <= ALU_SLL;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        default: begin
                            gpr_we_o <= 0;
                            illegal_instr_o <= 1;
                        end
                        
                    endcase
                    
                end
                
                3'b101: begin 
                
                    case (fetched_instr_i[31:25])
                    
                        7'd0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_IMM_I;
                            alu_op_o <= ALU_SRL;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        7'd32: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_IMM_I;
                            alu_op_o <= ALU_SRA;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        default: begin
                            gpr_we_o <= 0;
                            illegal_instr_o <= 1;
                        end
                    endcase
                    
                end
                
                default: begin 
                    illegal_instr_o <= 1;
                    gpr_we_o <= 0;
                end
            endcase
            
        end
        
        {AUIPC_OPCODE,2'b11}: begin
                    a_sel_o <= OP_A_CURR_PC;
                    b_sel_o <= OP_B_IMM_U;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
        end
        
        {STORE_OPCODE, 2'b11}: begin
        
            case (fetched_instr_i[14:12])
            
                3'b000: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_S;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= LDST_B;
                    mem_we_o <= 1'b1;
                    mem_req_o <= 1'b1;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b001: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_S;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= LDST_H;
                    mem_we_o <= 1'b1;
                    mem_req_o <= 1'b1;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b010: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_S;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= LDST_W;
                    mem_we_o <= 1'b1;
                    mem_req_o <= 1'b1;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                default: begin
                    mem_we_o <= 0;
                    mem_req_o <= 0;
                    illegal_instr_o <= 1;
                end
            endcase
            
        end
        
        {OP_OPCODE,2'b11}: begin
    
            case (fetched_instr_i[14:12]) 
                
                3'b000: begin

                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_ADD;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 1'b0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        7'h20: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SUB;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 1'b0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end
                    endcase
                
                end
                
                3'b001: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SLL;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase
                end
                
                3'b010: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SLTS;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                         default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase
                end
                
                3'b011: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SLTU;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                         default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase
                end
                
                3'b100: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_XOR;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                         default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase 
                end
                
                3'b101: begin
                
                    case (fetched_instr_i[31:25])
                        7'b0000000: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SRL;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        7'b0100000: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_SRA;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                        default: begin 
                            illegal_instr_o <= 1;
                            gpr_we_o <= 1'b0;
                        end
                    endcase
                    
                end
                
                3'b110: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_OR;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                         default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase
                end
                
                3'b111: begin
                    case (fetched_instr_i[31:25])
                        7'b0: begin
                            a_sel_o <= OP_A_RS1;
                            b_sel_o <= OP_B_RS2;
                            alu_op_o <= ALU_AND;
                            wb_sel_o <= 1'b0;
                            gpr_we_o <= 1'b1;
                            jal_o <= 1'b0;
                            jalr_o <= 2'b0;
                            branch_o <= 1'b0;
                            mem_size_o <= 3'b0;
                            mem_we_o <= 1'b0;
                            mem_req_o <= 1'b0;
                            illegal_instr_o <= 0;
                            csr_o <= 0;
                            int_rst_o <= 0;
                            csr_op_o <= 3'b0;
                        end
                        
                         default: begin
                            illegal_instr_o <= 1;
                            gpr_we_o <= 0; 
                        end 
                        
                    endcase
                end
                
                default: begin
                    illegal_instr_o <= 1;
                    gpr_we_o <= 0;
                end
            endcase
            
        end
        
        {LUI_OPCODE,2'b11}: begin
            a_sel_o <= OP_A_ZERO;
            b_sel_o <= OP_B_IMM_U;
            alu_op_o <= ALU_ADD;
            wb_sel_o <= 1'b0;
            gpr_we_o <= 1'b1;
            jal_o <= 1'b0;
            jalr_o <= 2'b0;
            branch_o <= 1'b0;
            mem_size_o <= 3'b0;
            mem_we_o <= 1'b0;
            mem_req_o <= 1'b0;
            illegal_instr_o <= 0;
            csr_o <= 0;
            int_rst_o <= 0;
            csr_op_o <= 3'b0;
        end
        
        {BRANCH_OPCODE,2'b11}: begin
        
            case (fetched_instr_i[14:12])
            
                3'b000: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_EQ;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b001: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_NE;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b100: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_LTS;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b101: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_GES;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b110: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_LTU;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                3'b111: begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_GEU;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b1;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                default: begin
                    branch_o <= 0;
                    illegal_instr_o <= 1;
                end
            endcase
            
        end
        
        {JALR_OPCODE,2'b11}: begin 
        
            case (fetched_instr_i[14:12])
            
                3'b000: begin
                    a_sel_o <= OP_A_CURR_PC;
                    b_sel_o <= OP_B_INCR;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b1;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
                
                default: begin
                    illegal_instr_o <= 1;
                    jalr_o <= 0;
                    gpr_we_o <= 0;
                end
            endcase
            
        end
        
        {JAL_OPCODE,2'b11}: begin
        
            a_sel_o <= OP_A_CURR_PC;
            b_sel_o <= OP_B_INCR;
            alu_op_o <= ALU_ADD;
            wb_sel_o <= 1'b0;
            gpr_we_o <= 1'b1;
            jal_o <= 1'b1;
            jalr_o <= 2'b0;
            branch_o <= 1'b0;
            mem_size_o <= 3'b0;
            mem_we_o <= 1'b0;
            mem_req_o <= 1'b0;
            illegal_instr_o <= 0;
            csr_o <= 0;
            int_rst_o <= 0;
            csr_op_o <= 3'b0;
        end
        
        {SYSTEM_OPCODE,2'b11}: begin
            case (fetched_instr_i[14:12])
                3'b000: begin
                    a_sel_o <= OP_A_RS1; //MRET
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b0;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b10;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 1;
                    csr_op_o <= 3'b0;
                end
                
                3'b001: begin
                    a_sel_o <= OP_A_RS1; //CSRRW
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 1;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b1;
                end
                
                3'b010: begin
                    a_sel_o <= OP_A_RS1; //CSRRS
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 1;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b11;
                end
                
                3'b011: begin
                    a_sel_o <= OP_A_RS1; //CSRRC
                    b_sel_o <= OP_B_RS2;
                    alu_op_o <= ALU_ADD;
                    wb_sel_o <= 1'b0;
                    gpr_we_o <= 1'b1;
                    jal_o <= 1'b0;
                    jalr_o <= 2'b0;
                    branch_o <= 1'b0;
                    mem_size_o <= 3'b0;
                    mem_we_o <= 1'b0;
                    mem_req_o <= 1'b0;
                    illegal_instr_o <= 0;
                    csr_o <= 1;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b10;
                end
                
                default: begin
                    illegal_instr_o <= 1;
                    gpr_we_o <= 0;
                    jal_o <= 0;
                    csr_o <= 0;
                    int_rst_o <= 0;
                    csr_op_o <= 3'b0;
                end
            endcase
        end
        
        default: begin
            mem_we_o <= 0;
            mem_req_o <= 0;
            gpr_we_o <= 0;
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 0;
            illegal_instr_o <= 1;
            csr_o <= 0;
            int_rst_o <= 0;
            csr_op_o <= 3'b0;
            alu_op_o <= '0;
        end
        
    endcase
    
    end
    
  end
 
endmodule