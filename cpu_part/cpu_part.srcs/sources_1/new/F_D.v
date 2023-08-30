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
    input wire number_of_stall,
    input wire [31:0]instr,
    input wire [31:0]PC_plus4_f,
    output reg [5:0]op,
    output reg [5:0]func,
    output reg [4:0]addr1,
    output reg [4:0]addr2,
    output reg [4:0]rt_d,
    output reg [4:0]rd_d,
    output reg [15:0]imm,
    output reg [31:0]PC_plus4_d,
    output reg PC_stall
    );
    reg stall;
    initial begin
        op <= 0;
        func <= 0;
        addr1 <= 0;
        addr2 <= 0;
        rt_d <= 0;
        rd_d <= 0;
        imm <= 0;
        stall <= 0;
        PC_plus4_d <= 0;
        PC_stall <= 0;
    end
    always@(posedge clk or posedge reset) begin
        if(reset)begin
            op <= 0;
            func <= 0;
            addr1 <= 0;
            addr2 <= 0;
            rt_d <= 0;
            rd_d <= 0;
            imm <= 0;
            stall <= 0;
            PC_plus4_d <= 0;
            PC_stall <= 0;
        end
        else if(stall > 0)begin
            op <= 0;
            func <= 0;
            addr1 <= 0;
            addr2 <= 0;
            rt_d <= 0;
            rd_d <= 0;
            imm <= 0;
            PC_plus4_d <= 0;
            PC_stall <= 1;
            stall = stall - 1;
        end
        else begin
            op <= instr[31:26];
            func <= instr[5:0];
            addr1 <= instr[25:21];//rs_d
            addr2 <= instr[20:16];
            rt_d <= instr[20:16];
            rd_d <= instr[15:11];
            imm <= instr[15:0];
            PC_plus4_d <= PC_plus4_f;
            PC_stall <= 0;
        end
    end
endmodule