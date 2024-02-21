`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2023 16:35:58
// Design Name: 
// Module Name: I2C
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


module I2C_module(
    input logic clk_i,
    input logic rst_i,
    //i2c interface
    inout logic SDA,
    output logic SCL,
    //writedata registers
    input logic [6:0] slave_addr_i,
    input logic bit_rw_i,
    input logic [7:0] data_write_i,
    input logic ack_master_i,
    //status registers
    output logic busy_o,
    output logic valid_o,
    //control registers
    input logic [31:0] mode_i,
    input logic enable_i,
    output logic byte_sent_o,
    input logic end_of_write_i
    );
    
    enum logic [3:0] {
        IDLE = 4'd0,
        START = 4'd1,
        ADDR = 4'd2,
        RW = 4'd3,//чтение - 1, запись - 0
        ACK = 4'd4,
        DATAR = 4'd5,
        DATAW = 4'd6,
        ACKM = 4'd7,
        ACKS = 4'd8, 
        STOP = 4'd9   
    }ST;
    
    logic buf_out;
    logic buf_in;
    logic buf_en;
    logic [6:0] spdiv;
// IOBUF: Single-ended Bi-directional Buffer
//        All devices
// Xilinx HDL Language Template, version 2021.2
    
    IOBUF #(
        .DRIVE(12), // Specify the output drive strength
        .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
        .IOSTANDARD("DEFAULT"), // Specify the I/O standard
        .SLEW("SLOW") // Specify the output slew rate
    ) IOBUF_inst (
        .O(buf_out),     // Buffer output
        .IO(SDA),   // Buffer inout port (connect directly to top-level port)
        .I(buf_in),     // Buffer input
        .T(buf_en)      // 3-state enable input, high=input, low=output
    );
    
// End of IOBUF_inst instantiation
    always_ff @(posedge clk_i) begin
      if (rst_i) spdiv <= 7'd100;
      else begin
        if (!busy_o) begin
          case (mode_i)
                32'd100000: spdiv <= 7'd100; //standard
                32'd400000: spdiv <= 7'd25 ; // full speed
                32'd1000000: spdiv <= 7'd10; // fast mode
                32'd3200000: spdiv <= 7'd3; //high speed
                default: spdiv <= spdiv;
           endcase
        end     
       end   
    end 
    //SDA state machine
    logic [7:0] SDA_cnt;
    logic [3:0] counter;
    logic [7:0] addr;
    logic rw_bit;
    
    logic ack; // ack register
    
    logic [31:0] data_read; // read register
    
    logic [7:0] data_write;// write register
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            busy_o <= 0;
            buf_en <= 1;
            valid_o <= 0;
            ST <= IDLE;
            SDA_cnt <= 0;
            counter <= 0;
            addr <= 0;
            rw_bit <= 0;
        end else begin
            case (ST)
                //IDLE -> START
                IDLE: begin
                    if(enable_i) begin
                        ST <= START;
                        busy_o <= 1;
                        SDA_cnt <= 0;
                        buf_en <= 0;
                    end
                end
                
                START: begin
                    if (SDA_cnt == spdiv) begin
                        ST <= ADDR;
                        SDA_cnt <= 0;
                        addr <= slave_addr_i;
                        counter <= 0;
                    end else SDA_cnt <= SDA_cnt + 1;
                end
                
                ADDR: begin
                    if (SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        if (counter == 6) begin
                            counter <= 0;
                            ST <= RW;
                        end else begin
                            counter <= counter + 1;
                            addr <= {addr[5:0],1'b0};
                        end
                    end
                    else SDA_cnt <= SDA_cnt + 1;    
                end
                
                RW: begin
                    if (SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        ST <= ACK;
                        rw_bit <= bit_rw_i;
                        buf_en <= 1;    
                    end else SDA_cnt <= SDA_cnt + 1;
                end
                
                ACK: begin //slave ack
                    if (SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        counter <= 0;
                        if (ack & rw_bit) ST <= DATAR;
                        if (ack & !rw_bit) begin
                            ST <= DATAW;
                            buf_en <= 0;
                            data_write <= data_write_i;
                        end    
                        if (!ack) ST <= STOP; 
                    end else begin
                        SDA_cnt <= SDA_cnt + 1;
                    end
                end
                // READ
                DATAR: begin
                    if(SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        if (counter == 7) begin
                            counter <= 0;
                            buf_en <= 0;
                            ST <= ACKM;
                        end else begin
                            counter <= counter + 1;
                        end
                    end
                    else SDA_cnt <= SDA_cnt + 1;  
                end
                
                ACKM: begin
                    if (SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        counter <= 0;
                        if (ack_master_i)begin
                            ST <= DATAR;
                            buf_en <= 1;
                        end    
                        if (!ack_master_i) begin
                            ST <= STOP;
                            valid_o <= 1;
                        end    
                    end else SDA_cnt <= SDA_cnt + 1;
                end
                //end of read or cnt
                
                //write
                DATAW: begin
                    if(SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        if (counter == 7) begin
                            counter <= 0;
                            buf_en <= 1;
                            byte_sent_o <= 1;
                            ST <= ACKS;
                        end else begin
                            counter <= counter + 1;
                            data_write <= {data_write[6:0],1'b0};
                        end
                    end   
                    else SDA_cnt <= SDA_cnt + 1;    
                end
                
                ACKS: begin //slave ack
                    byte_sent_o <= 0;
                    if (SDA_cnt == spdiv) begin
                        SDA_cnt <= 0;
                        counter <= 0;
                        if (ack & !end_of_write_i) begin
                            data_write <= data_write_i;
                            ST <= DATAW;
                            buf_en <= 0;
                        end else begin
                            ST <= STOP;
                            buf_en <= 0;
                        end
                       
                    end else begin
                        SDA_cnt <= SDA_cnt + 1;
                    end
                end
                
                STOP: begin
                    valid_o <= 0;
                    
                    if (SDA_cnt == spdiv) begin
                        ST <= IDLE;
                        buf_en <= 1;
                        SDA_cnt <= 0;
                        busy_o <= 0;
                    end else SDA_cnt <= SDA_cnt + 1;
                end
                
            endcase
        end
    end
    
    logic [7:0] SCL_cnt;
    logic flag;
    //SCL state machine
    always_ff @(posedge clk_i) begin 
        if (rst_i) begin
            SCL <= 1;
            SCL_cnt <= 0;
            flag <= 0;
        end else begin
            if (ST == START & SCL_cnt == 3*spdiv/4 & !flag) begin
                SCL <= 0;
                flag <= 1;
            end 
            
            if (flag & (SCL_cnt == spdiv/4 | SCL_cnt == 3*spdiv/4)) begin
                SCL <= ~SCL;
            end 
            
            if (ST == STOP) begin
                SCL <= 1;
                flag <= 0;
            end
            
            if (SCL_cnt == spdiv) SCL_cnt <= 0;
            else if (busy_o) SCL_cnt <= SCL_cnt + 1;
        end
    end
    
    always_comb begin
        buf_in <= 0;
        if (ST == IDLE) buf_in <= 1;
        if (ST == START) buf_in <= 0;
        if (ST == ADDR) buf_in <= addr[6];
        if (ST == RW) buf_in <= bit_rw_i;
        if (ST == STOP & SCL & SCL_cnt > 1) buf_in <= 1;
        if (ST == ACKM) buf_in <= ack_master_i;
        if (ST == DATAW) buf_in <= data_write[7];
    end
    
    always_ff @(posedge rst_i or negedge SCL) begin
        if (rst_i) begin
            ack <= 0;
            data_read <= 0;
        end else begin
            case (ST)
                ACK: ack <= buf_out;
                DATAR: data_read <= {data_read[30:0], buf_out};
                ACKS: ack <= buf_out;
            endcase
        end
    end
    
endmodule
