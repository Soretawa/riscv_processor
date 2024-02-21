`timescale 1ns / 1ps

module tb_miriscv_top();

  // clock, reset
  reg clk;
  reg rst;
  reg [31:0] int_req;
  wire [31:0] int_fin;
  reg  RX;
  uart myuart();
  
  miriscv_top top(
    .clk_i    ( clk   ),
    .rst_i  ( rst ),
    //.int_req_i(int_req),
    //.int_fin_o(int_fin),
    .myuart (myuart)
  );

 initial clk = 0;
    always #10 clk = ~clk;
    assign myuart.rx_i = myuart.tx_o;
    initial begin
        $display( "\nStart test: \n\n==========================\nCLICK THE BUTTON 'Run All'\n==========================\n"); $stop();
        rst = 1;
        int_req = 32'b0;
        #20;
        rst = 0;
        #8000000
        $display("\n The test is over \n See the internal signals of the module on the waveform \n");
        $finish;
    end
endmodule
