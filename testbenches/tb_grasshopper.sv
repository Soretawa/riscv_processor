`timescale 1ns / 1ps

module tb_grasshopper();
    
    logic CLK, RST, REQ;
    
    logic [127:0] original_data, ciphered_data;
                  
    grasshopper gh(
        .clk_i(CLK),
        .rst_i(RST),
        
        .req_i(REQ),
        .original_data(original_data),
        .ciphered_data(ciphered_data)
    );
    
    initial begin
        CLK <= 0;
        original_data <= 'h1122334455667700ffeeddccbbaa9988;
    end
    
    always #5 CLK <= ~CLK;
    
    initial begin
        REQ <= 0;
        RST <= 1;
        #10
        RST <= 0;
        #100
        REQ <= 1;
        #10
        REQ <= 0;
    end
    
    initial#2500 $finish();
endmodule
