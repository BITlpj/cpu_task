`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 15:41:16
// Design Name: 
// Module Name: debounce
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


module debounce(
    input rstn,
    input clk,
    input button_in,
    output button_out
    );
    reg [31:0] count;
    reg tmp_state;
    reg pre_state;
assign button_out=pre_state;
always @(posedge clk) begin
    if(rstn==0)begin
        pre_state<=button_in;
        count<=32'b0;
    end
    else begin
       if(button_in!=pre_state) begin
            count=count+1;
       end 
       else begin
            count=0;
       end
       if(count>=50) begin
            pre_state=button_in;
            count=0;
       end
    end
end
endmodule
