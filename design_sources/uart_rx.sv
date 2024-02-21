`timescale 1ns / 1ps

module uart_rx #(parameter int SPEED = 86)(
    input logic clk_i, // тактирование
    input logic rst_i, // сброс
    
    input logic rx_i, // сигнал линии приема
    input logic [31:0] addr_i, // адрес регистров
    input logic uart_req_i,
    input logic [31:0] uart_data_i,
    input logic  uart_we_i,
    
    output logic [31:0] uart_data_o
    );
    
    enum logic [2:0] { IDLE = 3'b000,
                       START = 3'b001,
                       DATA = 3'b010,
                       STOP = 3'b011,
                       PARITY = 3'b100} STATE;
    logic [7:0] data;
    logic valid;
    logic busy;
    logic uart_rst;
    logic parity_bit;
    
    logic [14:0] chk_data;
    
    logic [15:0] counter_sp;
    logic [2:0] data_count;
    
    logic flag;
    logic [2:0] prev_data;
    
    always_comb begin
        if( uart_req_i == 1 & uart_we_i == 0) begin
            case (addr_i)
                32'h0: uart_data_o <= {24'b0, data};
                32'h4: uart_data_o <= {31'b0, valid};
                32'h8: uart_data_o <= {31'b0, busy};
                32'h10: uart_data_o <= {31'b0, parity_bit};
                default: uart_data_o <= 0; 
            endcase
        end    
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            flag <= 1;
            data <= 0;
            parity_bit <= 0;
        end else begin
            chk_data <= {chk_data[14:0], rx_i};
            if ((STATE == DATA) & counter_sp == SPEED) flag <= 1;
            if (STATE == IDLE)flag <= 1;
            if (STATE == PARITY & counter_sp > 15 & flag) begin
                parity_bit <= rx_i;
                flag <= 0;
            end        
            if (STATE == DATA & flag & (chk_data == 15'd0 | (&chk_data)) & counter_sp > 15) begin
                data <= {rx_i, data[7:1]};
                flag <= 0;
            end
        end
    end    
       
    always_ff @(posedge clk_i) begin
        if (uart_req_i == 1 & uart_we_i == 0 & valid == 1 & addr_i == 32'h0) valid <= 0;
        if (rst_i) begin
            busy <= 0;
            STATE <= IDLE;
            valid <= 0;
            counter_sp <= 0;
            data_count <= 0;
                        
        end else begin
            case (STATE)
                IDLE: begin
                    if (chk_data == 15'b0) begin
                        STATE <= START;
                        counter_sp <= 0;
                    end
                end
                
                START: begin
                    if (counter_sp == SPEED-15) begin
                        counter_sp <= 0;
                        STATE <= DATA;
                        data_count <= 0;
                    end
                    else counter_sp <= counter_sp + 1;
                end
                
                DATA: begin
                    if (counter_sp == SPEED) begin
                        counter_sp <= 0;
                        if (data_count == 7) begin
                            STATE <= PARITY;
                        end    
                        else begin
                           prev_data <= data_count;
                           data_count <= data_count + 1;
                        end
                    end else counter_sp <= counter_sp + 1;
                    
                end
                
                PARITY: begin
                    if (counter_sp == SPEED) begin
                        counter_sp <= 0;
                        STATE <= STOP; 
                    end 
                    
                    else counter_sp <= counter_sp + 1; 
                end
                
                STOP: begin
                    if (counter_sp == SPEED) begin
                        valid <= 1;
                        STATE <= IDLE;
                    end else counter_sp <= counter_sp + 1;
                end
                
            endcase
        end
    end         
endmodule
