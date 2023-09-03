`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:36:06
// Design Name: 
// Module Name: F_D
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


module F_D(
    input wire clk,
    input wire reset,
    //input wire number_of_stall,
    input wire [31:0]instr,
    input wire [31:0]PC_plus4_f,   
//    output reg [5:0]op,
//    output reg [5:0]func,
    output reg [4:0]addr1,
    output reg [4:0]addr2,
    output reg [4:0]rt_d,
    output reg [4:0]rd_d,
    output reg [15:0]imm,
    output reg [31:0]PC_plus4_d,
    output reg PC_stall,
    output reg [31:0] instr_d,
    
    
    input wire [31:0]debug_wb_pc_f,
    output reg [31:0]debug_wb_pc_d,       
    output reg [4:0] shamt_d,
    
    output reg [25:0] jmp_addr_d
    );
    reg [3:0]stall;
//    initial begin
////        op <= 0;
////        func <= 0;
//        instr_d<=0;
//        addr1 <= 0;
//        addr2 <= 0;
//        rt_d <= 0;
//        rd_d <= 0;
//        imm <= 0;
//        stall <= 0;
//        PC_plus4_d <= 0;
//        PC_stall <= 0;
//        shamt_d<=0;
//        debug_wb_pc_d<=0;
//        jmp_addr_d<=0;
//    end
    always@(posedge clk or posedge reset) begin
        if(reset)begin
//            op <= 0;
//            func <= 0;
            instr_d<=0;
            addr1 <= 0;
            addr2 <= 0;
            rt_d <= 0;
            rd_d <= 0;
            imm <= 0;
            stall <= 0;
            PC_plus4_d <= 0;
            PC_stall <= 0;
            debug_wb_pc_d<=0;
            shamt_d<=0;
            jmp_addr_d<=0;            
        end
        else if(stall > 0)begin
//            op <= 0;
//            func <= 0;
            instr_d<=0;
            addr1 <= 0;
            addr2 <= 0;
            rt_d <= 0;
            rd_d <= 0;
            imm <= 0;
            PC_plus4_d <= 0;
            debug_wb_pc_d<=0;
            shamt_d<=0;
            jmp_addr_d<=0;
            // PC_stall <= 1;
           if (stall>1)begin
                PC_stall <= 1;
                end
            else begin
                PC_stall<=0;
            end
            stall = stall - 1;
        end
        else if(instr[31:26] == 6'b100011||instr[31:26] == 6'b101011) begin// lw ��ͣһ��
//            op <= instr[31:26];
//            func <= instr[5:0];
            instr_d=instr;
            addr1 <= instr[25:21];//rs_d
            addr2 <= instr[20:16];
            rt_d <= instr[20:16];
            rd_d <= instr[15:11];
            imm <= instr[15:0];
            shamt_d<=instr[10:6];
            jmp_addr_d<=instr[25:0];
            debug_wb_pc_d<=debug_wb_pc_f;
            PC_plus4_d <= PC_plus4_f;
            PC_stall <= 1;
            stall <= 2;
        end
        else if(instr[31:26] == 6'b000100||instr[31:26] == 6'b000101
        ||instr[31:26] == 6'b000001||instr[31:26] == 6'b000010||instr[31:26] ==6'b000011||(instr[31:26]==6'b000000 && instr[5:0]==6'b001000)) begin// jmp�ģ���ͣһ�Σ�֮��Ҫ��ͣһ��
//            op <= instr[31:26];
//            func <= instr[5:0];
            instr_d=instr;
            addr1 <= instr[25:21];//rs_d
            addr2 <= instr[20:16];
            rt_d <= instr[20:16];
            rd_d <= instr[15:11];
            imm <= instr[15:0];
            shamt_d<=instr[10:6];
            jmp_addr_d<=instr[25:0];
            debug_wb_pc_d<=debug_wb_pc_f;
            PC_plus4_d <= PC_plus4_f;
            PC_stall <= 1;
            stall <= 3;
        end
        else begin
//            op <= instr[31:26];
//            func <= instr[5:0];
            instr_d=instr;
            addr1 <= instr[25:21];//rs_d
            addr2 <= instr[20:16];
            rt_d <= instr[20:16];
            rd_d <= instr[15:11];
            imm <= instr[15:0];
            shamt_d<=instr[10:6];
            jmp_addr_d<=instr[25:0];
            debug_wb_pc_d<=debug_wb_pc_f;
            PC_plus4_d <= PC_plus4_f;
            PC_stall <= 0;
        end
    end
endmodule