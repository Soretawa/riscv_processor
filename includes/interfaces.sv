`timescale 1ns / 1ps
interface uart;
    logic rx_i;
    logic tx_o;
    
    modport dut (input rx_i, output tx_o);
endinterface

interface memory;
    logic [31:0] instr_data;
    logic [31:0] instr_addr;
    
    logic data_we;
    logic [3:0] data_be;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    
    modport ram (
        input instr_addr,
        input data_we,
        input data_be,
        input data_addr,
        input data_wdata,
        output instr_data
        );
        
    modport core (
        output instr_addr,
        output data_we,
        output data_be,
        output data_addr,
        output data_wdata,
        input instr_data
    );    
endinterface    