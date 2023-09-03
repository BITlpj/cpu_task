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
    reg rstn;
    reg clk;
    wire led;
cpu_vga_top test(
    .clk(clk),
    .rstn(rstn),
    .led(led)
);
    initial begin
        rstn = 0;
        clk = 1;
        # 10 rstn = 1;
    end
    always #5 clk = ~clk;
    
endmodule






