`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:36:46
// Design Name: 
// Module Name: E_M
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


module E_M(
    input wire clk,
    input wire reset,
    input wire [2:0]branch_e,
    input wire reg_write_e,
    input wire mem_to_reg_e,
    input wire [3:0]mem_write_e,
    input wire [1:0]zero_e,
    input wire [31:0]alu_out_e,
    input wire [4:0]write_reg_e,
    input wire [31:0]write_data_e,
    input wire [31:0]PC_branch_e,
    output reg [2:0]branch_m,
    output reg reg_write_m,
    output reg mem_to_reg_m,
    output reg [3:0]mem_write_m,
    output reg [1:0]zero_m,
    output reg [31:0]alu_out_m,
    output reg [4:0]write_reg_m,
    output reg [31:0]write_data_m,
    output reg [31:0]PC_branch_m,
    
    input wire [31:0]debug_wb_pc_e,
    output reg [31:0]debug_wb_pc_m
    );
//    initial begin
//        branch_m <= 0;
//        reg_write_m <= 0;
//        mem_to_reg_m <= 0;
//        mem_write_m <= 0;
//        zero_m <= 0;
//        alu_out_m <= 0;
//        write_reg_m <= 0;
//        write_data_m <= 0;
//        PC_branch_m <= 0;
//        debug_wb_pc_m<=0;
//    end
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            branch_m <= 0;
            reg_write_m <= 0;
            mem_to_reg_m <= 0;
            mem_write_m <= 0;
            zero_m <= 0;
            alu_out_m <= 0;
            write_reg_m <= 0;
            write_data_m <= 0;
            PC_branch_m <= 0;
            debug_wb_pc_m<=0;
        end
        else begin
            branch_m <= branch_e;
            reg_write_m <= reg_write_e;
            mem_to_reg_m <= mem_to_reg_e;
            mem_write_m <= mem_write_e;
            zero_m <= zero_e;
            alu_out_m <= alu_out_e;
            write_reg_m <= write_reg_e;
            write_data_m <= write_data_e;
            PC_branch_m <= PC_branch_e;
            debug_wb_pc_m<=debug_wb_pc_e;
        end
    end
endmodule
