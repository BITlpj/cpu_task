`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:36:22
// Design Name: 
// Module Name: D_E
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


module D_E(
    input wire clk,
    input wire reset,
    input wire [2:0]branch_d,
    input wire reg_write_d,
    input wire mem_to_reg_d,
    input wire [3:0]mem_write_d,
    input wire [3:0]alu_control_d,
    input wire alu_src_d,
    input wire [4:0]reg_dst_d,
    input wire [31:0]rd1_d,//二路选择的结果
    input wire [31:0]rd2_d,//二路选择的结果
    input wire [4:0]rt_d,
    input wire [4:0]rd_d,
    input wire [31:0]sign_imm_d,
    input wire [31:0]PC_plus4_d,
    output reg [2:0]branch_e,
    output reg reg_write_e,
    output reg mem_to_reg_e,
    output reg [3:0]mem_write_e,
    output reg [3:0]alu_control_e,
    output reg alu_src_e,
    output reg [4:0]reg_dst_e,
    output reg [31:0]rd1_e,
    output reg [31:0]rd2_e,
    output reg [4:0]rt_e,
    output reg [4:0]rd_e,
    output reg [31:0]imm_e,
    output reg [31:0]PC_plus4_e,
    
    input wire [31:0]debug_wb_pc_d,
    output reg [31:0]debug_wb_pc_e,
    
    input wire [4:0] shamt_d,
    output reg [4:0] shamt_e,
    
    
    input wire [25:0] jmp_addr_d,
    output reg [25:0] jmp_addr_e
    );
//    initial begin
//        branch_e <= 0;
//        reg_write_e <= 0;
//        mem_to_reg_e <= 0;
//        mem_write_e <= 0;
//        alu_control_e <= 0;
//        alu_src_e <= 0;
//        reg_dst_e <= 0;
//        rd1_e <= 0;
//        rd2_e <= 0;
//        rt_e <= 0;
//        rd_e <= 0;
//        imm_e <= 0;
//        PC_plus4_e <= 0;
//        jmp_addr_e<=0;
//        shamt_e<=0;
//    end
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            branch_e <= 0;
            reg_write_e <= 0;
            mem_to_reg_e <= 0;
            mem_write_e <= 0;
            alu_control_e <= 0;
            alu_src_e <= 0;
            reg_dst_e <= 0;
            rd1_e <= 0;
            rd2_e <= 0;
            rt_e <= 0;
            rd_e <= 0;
            imm_e <= 0;
            PC_plus4_e <= 0;
            debug_wb_pc_e<=0;
            jmp_addr_e<=0;
            shamt_e<=0;
        end
        else begin
            branch_e <= branch_d;
            reg_write_e <= reg_write_d;
            mem_to_reg_e <= mem_to_reg_d;
            mem_write_e <= mem_write_d;
            alu_control_e <= alu_control_d;
            alu_src_e <= alu_src_d;
            reg_dst_e <= reg_dst_d;
            rd1_e <= rd1_d;
            rd2_e <= rd2_d;
            rt_e <= rt_d;
            rd_e <= rd_d;
            PC_plus4_e <= PC_plus4_d; 
            jmp_addr_e<=jmp_addr_d;
            debug_wb_pc_e<=debug_wb_pc_d;
            shamt_e<=shamt_d;
            imm_e <= sign_imm_d;
        end
    end
endmodule
