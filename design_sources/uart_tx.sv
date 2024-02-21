`timescale 1ns / 1ps

module uart_tx #(parameter int SPEED = 86)(

        input logic clk_i, // ������������
        input logic rst_i, // ����� ���������� ���������
        //core protocol
        input logic uart_we_i, // ������ � �������
        input logic uart_req_i, // ��������� � �����������
        input logic [31:0] uart_data_i,//������� ������ � ����������
        
        //�������� �������
        input logic [31:0] addr_i, //������ ��� ������� � �������
        
        output logic [31:0] uart_data_o, // ������ �� ��������� ���������
        output logic uart_tx_o // �������� ����������������
    );
    
    enum logic [2:0] { IDLE = 3'b000,
                       START = 3'b001,
                       DATA = 3'b010,
                       STOP = 3'b011,
                       PARITY = 3'b100} STATE;
    
    
    logic busy;
    logic [2:0] data_count;
    logic [7:0] data;
    logic [63:0] clock_count;
    logic parity_bit;
    
    always_comb begin
        if (uart_req_i == 1 & uart_we_i == 0) begin
            case (addr_i)
                32'h0: uart_data_o <= {24'b0, data};
                32'h8: uart_data_o <= {31'b0, busy};
            endcase
        end
    end
    
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            STATE <= IDLE;
            data_count <= 0;
            data <= 0;
            busy <= 0;
            clock_count <= 0;
            parity_bit <= 0;
        end
        
        else begin
            case (STATE)
                
                IDLE: begin
                    if (uart_we_i & uart_req_i) begin
                        STATE <= START;
                        busy <= 1;
                        data <= uart_data_i[7:0];
                        parity_bit <= ^uart_data_i[7:0];
                    end
                end
                
                START: begin
                    if (clock_count == SPEED) begin
                        STATE <= DATA;
                        data_count <= 0;
                        clock_count <= 0;                       
                    end
                    
                    else clock_count <= clock_count + 1;
                end
                
                DATA: begin
                    if (clock_count == SPEED) begin
                        clock_count <= 0;
                        if (data_count == 7) begin
                            STATE <= PARITY;
                        end    
                        else begin
                            data_count <= data_count + 1;
                            data <= {1'b0, data[7:1]};
                        end
                    end
                    
                    else clock_count <= clock_count + 1;
                end
                
                PARITY: begin
                    if (clock_count == SPEED) begin
                        clock_count <= 0;
                        STATE <= STOP;
                    end
                    
                    else clock_count <= clock_count + 1;
                end
                
                STOP: begin
                    if (clock_count == SPEED) begin
                        clock_count <= 0;
                        if (uart_we_i & uart_req_i)
                            STATE <= START;   
                        else begin
                            busy <= 0;
                            STATE <= IDLE;
                        end    
                    end            
                    else clock_count <= clock_count + 1;
                end
                
            endcase 
        end
    end
    
    always_comb begin
        uart_tx_o <= 1;
        if (STATE == IDLE) uart_tx_o <= 1;
        if (STATE == START) uart_tx_o <= 0;
        if (STATE == DATA) uart_tx_o <= data[0];
        if (STATE == PARITY) uart_tx_o <= parity_bit;
        if (STATE == STOP) uart_tx_o <= 1;
    end
    
endmodule
