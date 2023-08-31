`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 13:41:02
// Design Name: 
// Module Name: cpu_tb
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
//include cpu_part.v;

module cpu_tb(
    
    );
    reg reset;
    reg clk;
    
    wire over;
    wire inst_sram_en;
    wire [3:0]inst_sram_wen;
    wire [31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    
    wire data_sram_en;
    wire [3:0]data_sram_wen;
    wire [31:0]data_sram_addr;
    wire [31:0]data_sram_wdata;
    wire [31:0]data_sram_rdata;
    
    
    wire [31:0]debug_wb_pc;
    wire [3:0] debug_wb_rf_wen;
    wire [4:0] debug_wb_rf_wnum;
    wire [31:0]debug_wb_rf_wdata;
    
    ROM test_rom(
        .clk(clk),
        .rst(reset),
        .inst_sram_en(inst_sram_en),
        .inst_sram_wen(inst_sram_wen),
        .inst_sram_addr(inst_sram_addr),
        .inst_sram_wdata(inst_sram_wdata),
        .inst_sram_rdata(inst_sram_rdata)
    );
    
   RAM test_ram(
        .clk(clk),
        .rst(reset),
        .data_sram_en(data_sram_en),
        .data_sram_wen(data_sram_wen),
        .data_sram_addr(data_sram_addr),
        .data_sram_wdata(data_sram_wdata),
        .data_sram_rdata(data_sram_rdata)
    );
    
    
    
    cpu test_cpu(
       .clk(clk),
       .resetn(reset),
    
       .inst_sram_en(inst_sram_en),
       .inst_sram_wen(inst_sram_wen),//4'b0000
       .inst_sram_addr(inst_sram_addr),//ignored
       .inst_sram_wdata(inst_sram_wdata),//ignored
       .inst_sram_rdata(inst_sram_rdata),//¶ÁÊı¾İ
    
       .data_sram_en(data_sram_en),
       .data_sram_wen(data_sram_wen),
       .data_sram_addr(data_sram_addr),
       .data_sram_wdata(data_sram_wdata),
       .data_sram_rdata(data_sram_rdata),
       .debug_wb_pc(debug_wb_pc),
       .debug_wb_rf_wen(debug_wb_rf_wen),
       .debug_wb_rf_wnum(debug_wb_rf_wnum),
       .debug_wb_rf_wdata(debug_wb_rf_wdata),
       .over(over)
    );
    initial begin
        reset = 1;
        clk = 1;
        # 10 reset = 0;
    end
    always #5 clk = ~clk;
    
endmodule






