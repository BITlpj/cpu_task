`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/03 13:15:20
// Design Name: 
// Module Name: cache
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


module cache(
    input rstn,
    input clk,
    input [31:0]cache_data,
    output [31:0] cache_addr,
    output [31:0] cache_out
);

      reg [3:0] middle_cach[7:0];
      reg [31:0]addr;
      integer i ;
      assign cache_addr=addr;
      assign cache_out={middle_cach[0],middle_cach[1],middle_cach[2],middle_cach[3],middle_cach[4],middle_cach[5],middle_cach[6],middle_cach[7]};
      always@(posedge clk) begin
             if(rstn==0) begin
                 for(i=0;i<=7;i=i+1) middle_cach[i]<=4'd0;
                 addr=0;
             end
             else begin
                  middle_cach[addr]=cache_data;
                  addr=addr+1;
                  if(addr==8) begin
                    addr=0;
                  end
             end
      end
//    reg [3:0] tmp_reg[511:0];
//    reg [31:0]outputs;
//    integer i ;
//    reg [8:0] count;
//    reg [31:0] addr;
//    reg [31:0] tmp_cul;
//    reg [3:0] read_in_addr;
//    reg [3:0] middle[7:0];
//    assign cache_addr={28'b0,read_in_addr};
//    assign cache_out=outputs;
//    always@(posedge clk) begin
//        if(rstn==0) begin
//           for(i=0;i<=511;i=i+1) tmp_reg[i]<=4'd0;
//           for(i=0;i<=7;i=i+1) middle[i]<=4'd0;
//           outputs<=0;
//           count<=0;
//           addr <=0;
//           tmp_cul<=1;
//           read_in_addr<=0;
//        end
//        else begin
//           if(cache_data!=tmp_reg[(tmp_cul-1)*8+read_in_addr]) begin
//                middle[read_in_addr]=cache_data;
                                
//           end
//           if (count==0 && addr<tmp_cul) begin

//                outputs={tmp_reg[addr*8],tmp_reg[addr*8+1],tmp_reg[addr*8+2],tmp_reg[addr*8+3],tmp_reg[addr*8+4],tmp_reg[addr*8+5],tmp_reg[addr*8+6],tmp_reg[addr*8+7]};               
//                addr=addr+1;

//           end
//        end
//    end
    
//    always@(negedge clk) begin
//          if(cache_data!=tmp_reg[(tmp_cul-1)*8+read_in_addr]) begin
//                tmp_reg[tmp_cul*8]<=middle[0];
//                tmp_reg[tmp_cul*8+1]<=middle[1];
//                tmp_reg[tmp_cul*8+2]<=middle[2];
//                tmp_reg[tmp_cul*8+3]<=middle[3];
//                tmp_reg[tmp_cul*8+4]<=middle[4];
//                tmp_reg[tmp_cul*8+5]<=middle[5];
//                tmp_reg[tmp_cul*8+6]<=middle[6];
//                tmp_reg[tmp_cul*8+7]<=middle[7];
                
//                tmp_cul=tmp_cul+1;
//          end

//          read_in_addr=read_in_addr+1;
//          if(read_in_addr==8) begin
//                read_in_addr=0;
//           end
//          count=count+1;
//          if(count==32'd8) begin
//                count=0;
//          end
          
//    end
endmodule
