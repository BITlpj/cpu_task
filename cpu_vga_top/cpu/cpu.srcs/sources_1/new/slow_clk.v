`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/03 16:39:16
// Design Name: 
// Module Name: slow_clk
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


module slow_clk(
        input clk,
        input rstn,
        output reg slow_clk
    );
    reg [32:0]tmp;
    always@(posedge clk) begin
        if(rstn==0)begin
            tmp=0;
        end
        else  begin
            tmp=tmp+1;
            slow_clk=0;
        end
        
        if(tmp==32'd2000000) begin
            tmp=0;
            slow_clk=slow_clk^1'b1;
         end
    end
endmodule
