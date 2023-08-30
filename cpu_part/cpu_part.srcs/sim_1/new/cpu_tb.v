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

module cpu_tb(
    
    );
    reg reset;
    reg clk;
    cpu test_cpu(.clk(clk),.rst(reset));
    initial begin
        reset = 1;
        clk = 1;
        # 10 reset = 0;
    end
    always #5 clk = ~clk;
    
endmodule






