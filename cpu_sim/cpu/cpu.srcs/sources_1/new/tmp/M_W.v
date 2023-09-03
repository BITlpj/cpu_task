`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:37:02
// Design Name: 
// Module Name: M_W
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


module M_W(
    input wire clk,
    input wire reset,
    input wire reg_write_m,
    input wire [31:0]result_m,
    input wire [4:0]write_reg_m,
    output reg reg_write_w,
    output reg [31:0]result_w,
    output reg [4:0]write_reg_w,
    
    input wire [31:0]debug_wb_pc_m,
    output reg [31:0]debug_wb_pc_w
    );
//    initial begin
//        reg_write_w <= 0;
//        result_w <= 0;
//        write_reg_w <= 0;
//    end
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            reg_write_w <= 0;
            result_w <= 0;
            write_reg_w <= 0;
            debug_wb_pc_w<=0;
        end
        else begin
            reg_write_w <= reg_write_m;
            result_w <= result_m;
            write_reg_w <= write_reg_m;
            debug_wb_pc_w<=debug_wb_pc_m;
        end
    end
endmodule
