`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 18:13:32
// Design Name: 
// Module Name: grasshopper
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


module grasshopper(
    input logic clk_i,
    input logic rst_i,
    
    output logic busy_o,
    output logic valid_o,
    
    input logic req_i,
    input logic [127:0] original_data,
    output logic [127:0] ciphered_data
    );
    
    logic [127:0] key [10] = {
        'h8899aabbccddeeff0011223344556677,
        'hfedcba98765432100123456789abcdef,
        'hdb31485315694343228d6aef8cc78c44,
        'h3d4553d8e9cfec6815ebadc40a9ffd04,
        'h57646468c44a5e28d3e59246f429f1ac,
        'hbd079435165c6432b532e82834da581b,
        'h51e640757e8745de705727265a0098b1,
        'h5a7925017b9fdd3ed72a91a222861984,
        'hbb44e25378c73123a5f32f73cdb6e517,
        'h72e9dd7416bcf45b755dbaa88e4a4043
    };
    
    logic [7:0] s_box [256];
    logic [7:0] table16 [256];
    logic [7:0] table32 [256];
    logic [7:0] table133 [256];
    logic [7:0] table148 [256];
    logic [7:0] table192 [256];
    logic [7:0] table194 [256];
    logic [7:0] table251 [256];
    
    initial begin
        $readmemh("L_16.mem", table16);
        $readmemh("L_32.mem", table32);
        $readmemh("L_133.mem", table133);
        $readmemh("L_148.mem", table148);
        $readmemh("L_192.mem", table192);
        $readmemh("L_194.mem", table194);
        $readmemh("L_251.mem", table251);
        $readmemh("L_251.mem", table251);
        $readmemh("S_box.mem", s_box);
    end
    /*logic [7:0] table16 [256] = {
       0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 
       195, 211, 227, 243, 131, 147, 163, 179, 67, 83, 99, 115, 3, 19, 35, 51, 
       69, 85, 101, 117, 5, 21, 37, 53, 197, 213, 229, 245, 133, 149, 165, 181, 
       134, 150, 166, 182, 198, 214, 230, 246, 6, 22, 38, 54, 70, 86, 102, 118, 
       138, 154, 170, 186, 202, 218, 234, 250, 10, 26, 42, 58, 74, 90, 106, 122, 
       73, 89, 105, 121, 9, 25, 41, 57, 201, 217, 233, 249, 137, 153, 169, 185, 
       207, 223, 239, 255, 143, 159, 175, 191, 79, 95, 111, 127, 15, 31, 47, 63, 
       12, 28, 44, 60, 76, 92, 108, 124, 140, 156, 172, 188, 204, 220, 236, 252, 
       215, 199, 247, 231, 151, 135, 183, 167, 87, 71, 119, 103, 23, 7, 55, 39, 
       20, 4, 52, 36, 84, 68, 116, 100, 148, 132, 180, 164, 212, 196, 244, 228, 
       146, 130, 178, 162, 210, 194, 242, 226, 18, 2, 50, 34, 82, 66, 114, 98, 
       81, 65, 113, 97, 17, 1, 49, 33, 209, 193, 241, 225, 145, 129, 177, 161, 
       93, 77, 125, 109, 29, 13, 61, 45, 221, 205, 253, 237, 157, 141, 189, 173, 
       158, 142, 190, 174, 222, 206, 254, 238, 30, 14, 62, 46, 94, 78, 126, 110, 
       24, 8, 56, 40, 88, 72, 120, 104, 152, 136, 184, 168, 216, 200, 248, 232, 
       219, 203, 251, 235, 155, 139, 187, 171, 91, 75, 123, 107, 27, 11, 59, 43
    };
    
    logic [7:0] table32 [256] = {
        0, 32, 64, 96, 128, 160, 192, 224, 195, 227, 131, 163, 67, 99, 3, 35, 69, 
        101, 5, 37, 197, 229, 133, 165, 134, 166, 198, 230, 6, 38, 70, 102, 138, 
        170, 202, 234, 10, 42, 74, 106, 73, 105, 9, 41, 201, 233, 137, 169, 207, 
        239, 143, 175, 79, 111, 15, 47, 12, 44, 76, 108, 140, 172, 204, 236, 215, 
        247, 151, 183, 87, 119, 23, 55, 20, 52, 84, 116, 148, 180, 212, 244, 146, 
        178, 210, 242, 18, 50, 82, 114, 81, 113, 17, 49, 209, 241, 145, 177, 93, 
        125, 29, 61, 221, 253, 157, 189, 158, 190, 222, 254, 30, 62, 94, 126, 24, 
        56, 88, 120, 152, 184, 216, 248, 219, 251, 155, 187, 91, 123, 27, 59, 109, 
        77, 45, 13, 237, 205, 173, 141, 174, 142, 238, 206, 46, 14, 110, 78, 40, 8, 
        104, 72, 168, 136, 232, 200, 235, 203, 171, 139, 107, 75, 43, 11, 231, 199, 
        167, 135, 103, 71, 39, 7, 36, 4, 100, 68, 164, 132, 228, 196, 162, 130, 226, 
        194, 34, 2, 98, 66, 97, 65, 33, 1, 225, 193, 161, 129, 186, 154, 250, 218, 
        58, 26, 122, 90, 121, 89, 57, 25, 249, 217, 185, 153, 255, 223, 191, 159, 
        127, 95, 63, 31, 60, 28, 124, 92, 188, 156, 252, 220, 48, 16, 112, 80, 176, 
        144, 240, 208, 243, 211, 179, 147, 115, 83, 51, 19, 117, 85, 53, 21, 245, 
        213, 181, 149, 182, 150, 246, 214, 54, 22, 118, 86
    };
    
    logic [7:0] table133 [256] = {
        0, 133, 201, 76, 81, 212, 152, 29, 162, 39, 107, 238, 243, 118, 58, 191, 
        135, 2, 78, 203, 214, 83, 31, 154, 37, 160, 236, 105, 116, 241, 189, 56, 
        205, 72, 4, 129, 156, 25, 85, 208, 111, 234, 166, 35, 62, 187, 247, 114, 
        74, 207, 131, 6, 27, 158, 210, 87, 232, 109, 33, 164, 185, 60, 112, 245, 
        89, 220, 144, 21, 8, 141, 193, 68, 251, 126, 50, 183, 170, 47, 99, 230, 
        222, 91, 23, 146, 143, 10, 70, 195, 124, 249, 181, 48, 45, 168, 228, 97, 
        148, 17, 93, 216, 197, 64, 12, 137, 54, 179, 255, 122, 103, 226, 174, 43, 
        19, 150, 218, 95, 66, 199, 139, 14, 177, 52, 120, 253, 224, 101, 41, 172, 
        178, 55, 123, 254, 227, 102, 42, 175, 16, 149, 217, 92, 65, 196, 136, 13, 
        53, 176, 252, 121, 100, 225, 173, 40, 151, 18, 94, 219, 198, 67, 15, 138, 
        127, 250, 182, 51, 46, 171, 231, 98, 221, 88, 20, 145, 140, 9, 69, 192, 
        248, 125, 49, 180, 169, 44, 96, 229, 90, 223, 147, 22, 11, 142, 194, 71, 
        235, 110, 34, 167, 186, 63, 115, 246, 73, 204, 128, 5, 24, 157, 209, 84, 
        108, 233, 165, 32, 61, 184, 244, 113, 206, 75, 7, 130, 159, 26, 86, 211, 
        38, 163, 239, 106, 119, 242, 190, 59, 132, 1, 77, 200, 213, 80, 28, 153, 
        161, 36, 104, 237, 240, 117, 57, 188, 3, 134, 202, 79, 82, 215, 155, 30
    };    
    
    logic [7:0] table148 [256] = {
        0, 148, 235, 127, 21, 129, 254, 106, 42, 190, 193, 85, 63, 171, 212, 64, 
        84, 192, 191, 43, 65, 213, 170, 62, 126, 234, 149, 1, 107, 255, 128, 20, 
        168, 60, 67, 215, 189, 41, 86, 194, 130, 22, 105, 253, 151, 3, 124, 232, 
        252, 104, 23, 131, 233, 125, 2, 150, 214, 66, 61, 169, 195, 87, 40, 188, 
        147, 7, 120, 236, 134, 18, 109, 249, 185, 45, 82, 198, 172, 56, 71, 211, 
        199, 83, 44, 184, 210, 70, 57, 173, 237, 121, 6, 146, 248, 108, 19, 135, 
        59, 175, 208, 68, 46, 186, 197, 81, 17, 133, 250, 110, 4, 144, 239, 123, 
        111, 251, 132, 16, 122, 238, 145, 5, 69, 209, 174, 58, 80, 196, 187, 47, 
        229, 113, 14, 154, 240, 100, 27, 143, 207, 91, 36, 176, 218, 78, 49, 165, 
        177, 37, 90, 206, 164, 48, 79, 219, 155, 15, 112, 228, 142, 26, 101, 241, 
        77, 217, 166, 50, 88, 204, 179, 39, 103, 243, 140, 24, 114, 230, 153, 13, 
        25, 141, 242, 102, 12, 152, 231, 115, 51, 167, 216, 76, 38, 178, 205, 89, 
        118, 226, 157, 9, 99, 247, 136, 28, 92, 200, 183, 35, 73, 221, 162, 54, 34, 
        182, 201, 93, 55, 163, 220, 72, 8, 156, 227, 119, 29, 137, 246, 98, 222, 74, 
        53, 161, 203, 95, 32, 180, 244, 96, 31, 139, 225, 117, 10, 158, 138, 30, 97, 
        245, 159, 11, 116, 224, 160, 52, 75, 223, 181, 33, 94, 202
    };
    
    logic [7:0] table192 [256] = {
        0, 192, 67, 131, 134, 70, 197, 5, 207, 15, 140, 76, 73, 137, 10, 202, 93,
        157, 30, 222, 219, 27, 152, 88, 146, 82, 209, 17, 20, 212, 87, 151, 186, 
        122, 249, 57, 60, 252, 127, 191, 117, 181, 54, 246, 243, 51, 176, 112, 
        231, 39, 164, 100, 97, 161, 34, 226, 40, 232, 107, 171, 174, 110, 237, 
        45, 183, 119, 244, 52, 49, 241, 114, 178, 120, 184, 59, 251, 254, 62, 189, 
        125, 234, 42, 169, 105, 108, 172, 47, 239, 37, 229, 102, 166, 163, 99, 
        224, 32, 13, 205, 78, 142, 139, 75, 200, 8, 194, 2, 129, 65, 68, 132, 7, 
        199, 80, 144, 19, 211, 214, 22, 149, 85, 159, 95, 220, 28, 25, 217, 90, 
        154, 173, 109, 238, 46, 43, 235, 104, 168, 98, 162, 33, 225, 228, 36, 167, 
        103, 240, 48, 179, 115, 118, 182, 53, 245, 63, 255, 124, 188, 185, 121, 
        250, 58, 23, 215, 84, 148, 145, 81, 210, 18, 216, 24, 155, 91, 94, 158, 29, 
        221, 74, 138, 9, 201, 204, 12, 143, 79, 133, 69, 198, 6, 3, 195, 64, 128, 26, 
        218, 89, 153, 156, 92, 223, 31, 213, 21, 150, 86, 83, 147, 16, 208, 71, 135, 
        4, 196, 193, 1, 130, 66, 136, 72, 203, 11, 14, 206, 77, 141, 160, 96, 227, 35, 
        38, 230, 101, 165, 111, 175, 44, 236, 233, 41, 170, 106, 253, 61, 190, 126, 
        123, 187, 56, 248, 50, 242, 113, 177, 180, 116, 247, 55
    };
    
    logic [7:0] table194 [256] = {
        0, 194, 71, 133, 142, 76, 201, 11, 223, 29, 152, 90, 81, 147, 22, 212, 125, 191, 
        58, 248, 243, 49, 180, 118, 162, 96, 229, 39, 44, 238, 107, 169, 250, 56, 189, 
        127, 116, 182, 51, 241, 37, 231, 98, 160, 171, 105, 236, 46, 135, 69, 192, 2, 9, 
        203, 78, 140, 88, 154, 31, 221, 214, 20, 145, 83, 55, 245, 112, 178, 185, 123, 
        254, 60, 232, 42, 175, 109, 102, 164, 33, 227, 74, 136, 13, 207, 196, 6, 131, 
        65, 149, 87, 210, 16, 27, 217, 92, 158, 205, 15, 138, 72, 67, 129, 4, 198, 18, 
        208, 85, 151, 156, 94, 219, 25, 176, 114, 247, 53, 62, 252, 121, 187, 111, 173, 
        40, 234, 225, 35, 166, 100, 110, 172, 41, 235, 224, 34, 167, 101, 177, 115, 246, 
        52, 63, 253, 120, 186, 19, 209, 84, 150, 157, 95, 218, 24, 204, 14, 139, 73, 66, 
        128, 5, 199, 148, 86, 211, 17, 26, 216, 93, 159, 75, 137, 12, 206, 197, 7, 130, 
        64, 233, 43, 174, 108, 103, 165, 32, 226, 54, 244, 113, 179, 184, 122, 255, 61, 
        89, 155, 30, 220, 215, 21, 144, 82, 134, 68, 193, 3, 8, 202, 79, 141, 36, 230,
        99, 161, 170, 104, 237, 47, 251, 57, 188, 126, 117, 183, 50, 240, 163, 97, 228, 
        38, 45, 239, 106, 168, 124, 190, 59, 249, 242, 48, 181, 119, 222, 28, 153, 91, 
        80, 146, 23, 213, 1, 195, 70, 132, 143, 77, 200, 10
    };
    
    logic [7:0] table251 [256] = {
        0, 251, 53, 206, 106, 145, 95, 164, 212, 47, 225, 26, 190, 69, 139, 112, 107, 144, 
        94, 165, 1, 250, 52, 207, 191, 68, 138, 113, 213, 46, 224, 27, 214, 45, 227, 24, 
        188, 71, 137, 114, 2, 249, 55, 204, 104, 147, 93, 166, 189, 70, 136, 115, 215, 44, 
        226, 25, 105, 146, 92, 167, 3, 248, 54, 205, 111, 148, 90, 161, 5, 254, 48, 203, 
        187, 64, 142, 117, 209, 42, 228, 31, 4, 255, 49, 202, 110, 149, 91, 160, 208, 43, 
        229, 30, 186, 65, 143, 116, 185, 66, 140, 119, 211, 40, 230, 29, 109, 150, 88, 163, 
        7, 252, 50, 201, 210, 41, 231, 28, 184, 67, 141, 118, 6, 253, 51, 200, 108, 151, 89,
        162, 222, 37, 235, 16, 180, 79, 129, 122, 10, 241, 63, 196, 96, 155, 85, 174, 181, 
        78, 128, 123, 223, 36, 234, 17, 97, 154, 84, 175, 11, 240, 62, 197, 8, 243, 61, 198, 
        98, 153, 87, 172, 220, 39, 233, 18, 182, 77, 131, 120, 99, 152, 86, 173, 9, 242, 60, 
        199, 183, 76, 130, 121, 221, 38, 232, 19, 177, 74, 132, 127, 219, 32, 238, 21, 101, 
        158, 80, 171, 15, 244, 58, 193, 218, 33, 239, 20, 176, 75, 133, 126, 14, 245, 59, 
        192, 100, 159, 81, 170, 103, 156, 82, 169, 13, 246, 56, 195, 179, 72, 134, 125, 217, 
        34, 236, 23, 12, 247, 57, 194, 102, 157, 83, 168, 216, 35, 237, 22, 178, 73, 135, 124
    };*/
    
    enum logic [2:0]  {
        idle = 3'd0,
        key_phase = 3'd1,
        s_phase = 3'd2,
        l_phase = 3'd3,
        finish = 3'd4
    } state;
    
   /* logic [7:0] s_box [256] = {
        252, 238, 221, 17, 207, 110, 49, 22, 251, 196, 250, 218, 35, 197, 4, 77, 233, 119, 240, 219, 147, 46,
        153, 186, 23, 54, 241, 187, 20, 205, 95, 193, 249, 24, 101, 90, 226, 92, 239, 33, 129, 28, 60, 66, 139, 1, 142,
        79, 5, 132, 2, 174, 227, 106, 143, 160, 6, 11, 237, 152, 127, 212, 211, 31, 235, 52, 44, 81, 234, 200, 72, 171,
        242, 42, 104, 162, 253, 58, 206, 204, 181, 112, 14, 86, 8, 12, 118, 18, 191, 114, 19, 71, 156, 183, 93, 135, 21,
        161, 150, 41, 16, 123, 154, 199, 243, 145, 120, 111, 157, 158, 178, 177, 50, 117, 25, 61, 255, 53, 138, 126,
        109, 84, 198, 128, 195, 189, 13, 87, 223, 245, 36, 169, 62, 168, 67, 201, 215, 121, 214, 246, 124, 34, 185, 3,
        224, 15, 236, 222, 122, 148, 176, 188, 220, 232, 40, 80, 78, 51, 10, 74, 167, 151, 96, 115, 30, 0, 98, 68, 26,
        184, 56, 130, 100, 159, 38, 65, 173, 69, 70, 146, 39, 94, 85, 47, 140, 163, 165, 125, 105, 213, 149, 59, 7, 88,
        179, 64, 134, 172, 29, 247, 48, 55, 107, 228, 136, 217, 231, 137, 225, 27, 131, 73, 76, 63, 248, 254, 141, 83,
        170, 144, 202, 216, 133, 97, 32, 113, 103, 164, 45, 43, 9, 91, 203, 155, 37, 208, 190, 229, 108, 82, 89, 166,
        116, 210, 230, 244, 180, 192, 209, 102, 175, 194, 57, 75, 99, 182
    };*/
    
    logic [3:0] round;
    logic [127:0] data;
    logic [4:0] lcount;
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            state <= idle;
            data <= 'h0;
            round <= 0;
            lcount <= 0;
            busy_o <= 0;
            valid_o <= 0;
        end else begin
            case (state)
                
                idle: begin
                    valid_o <= 0;
                    if (req_i) begin
                        state <= key_phase;
                        data <= original_data;
                        busy_o <= 1;
                    end
                end
                
                key_phase: begin
                    valid_o <= 0;
                    data <= data ^ key[round];
                    state <= s_phase;
                    if (round == 9) begin
                        state <= finish;
                    end    
                end
                
                s_phase: begin
                        data <= {s_box[data[127:120]],
                                 s_box[data[119:112]],
                                 s_box[data[111:104]],
                                 s_box[data[103:96]],
                                 s_box[data[95:88]],
                                 s_box[data[87:80]],
                                 s_box[data[79:72]],
                                 s_box[data[71:64]],
                                 s_box[data[63:56]],
                                 s_box[data[55:48]],
                                 s_box[data[47:40]],
                                 s_box[data[39:32]],
                                 s_box[data[31:24]],
                                 s_box[data[23:16]],
                                 s_box[data[15:8]],
                                 s_box[data[7:0]]};
                        
                        state <= l_phase;
                end
                
                l_phase: begin
                    if (lcount == 16) begin
                        state <= key_phase;
                        lcount <= 0;
                        round <= round + 1;
                    end else begin
                        data <= {table148[data[127:120]]^
                                 table32[data[119:112]]^
                                 table133[data[111:104]]^
                                 table16[data[103:96]]^
                                 table194[data[95:88]]^
                                 table192[data[87:80]]^
                                           data[79:72]^
                                 table251[data[71:64]]^
                                           data[63:56]^
                                 table192[data[55:48]]^
                                 table194[data[47:40]]^
                                 table16[data[39:32]]^
                                 table133[data[31:24]]^
                                 table32[data[23:16]]^
                                 table148[data[15:8]]^
                                            data[7:0], data [127:8]};
                        lcount <= lcount + 1;         
                    end
                end
                
                finish: begin
                    valid_o <= 1;
                    ciphered_data <= data;
                    if (req_i) begin
                        state <= key_phase;
                    end    
                    else begin
                        state <= idle;
                        busy_o <= 0;
                    end
                end
                
            endcase
        end
    end
    
endmodule

     