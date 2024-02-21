`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2024 17:51:23
// Design Name: 
// Module Name: tb_i2c
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


module tb_i2c();
wire SDA;
logic CLK;
logic RST;
logic EN;
logic SCL;
logic ACKM;
logic [7:0] WD;
logic [6:0] addr = 7'b1010100;
logic eof;
    I2C_module I2C(
        .clk_i(CLK),
        .rst_i(RST),
        .enable_i(EN),
        .SDA(SDA),
        .slave_addr_i(addr),
        .bit_rw_i(1'b0),
        .ack_master_i(ACKM),
        .SCL(SCL),
        .data_write_i(WD),
        .end_of_write_i(eof),
        .mode_i()
    );
//tb bufer    
    logic buf_in;
    logic buf_en;
    logic buf_out;
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
    
logic [7:0] reg_check;
logic [2:0] cnt = 0; 
initial CLK <= 0;

always_ff @(posedge CLK) begin
    WD <= reg_check;
end

always_comb begin
    reg_check <= 0;
    case (cnt)
        0: reg_check <= 8'b10101010;
        1: reg_check <= 8'b11110000;
        2: reg_check <= 8'b00101000;
        3: reg_check <= 8'b01010101;
    endcase
end

always_comb begin
    buf_en <= 1;
    buf_in <= 0;
    eof <= 0;
    ACKM <= 1;
    if (I2C.ST == 4'd4) begin
        buf_en <= 0;
        buf_in <= 1;
    end
    // read
    if (I2C.ST == 4'd5 ) begin
        buf_en <= 0;
        buf_in <= reg_check[7-I2C.counter];
    end
    if (I2C.ST == 4'd7) begin
        if (cnt == 4) begin
            buf_in <= 0;
            ACKM <= 0;
        end else begin
            buf_in <= 1;
        end
        
    end
    // write
    if (I2C.ST == 4'd8) begin
        buf_en <= 0;
        buf_in <= 1;
        if (cnt == 4) begin
            eof <= 1;
            //buf_in <= 0;
        end
    end    
end 

always_ff @(posedge CLK) begin
    if (I2C.ST == 4'd5 & I2C.SDA_cnt == I2C.spdiv & I2C.counter == 7) cnt <= cnt + 1;
    if (I2C.ST == 4'd6 & I2C.SDA_cnt == I2C.spdiv & I2C.counter == 7) cnt <= cnt + 1;
end

always #50 CLK <= ~CLK;     
initial begin
 RST <= 1;
 EN <= 0;
 #100
 RST <= 0;
 #500
 EN <= 1;
 #100
 EN <= 0;
 #1ms
 $finish();
end    
endmodule
