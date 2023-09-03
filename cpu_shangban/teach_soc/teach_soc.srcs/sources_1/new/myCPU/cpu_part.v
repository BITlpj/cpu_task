`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:04:27
// Design Name: 
// Module Name: cpu_part
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
include D_E.v;
include E_M.v;
include F_D.v;
include M_W.v;
include ALU.v;



module RAM(
    input clk,
    input rst,
    input data_sram_en,
    input [3:0] data_sram_wen,
    input [31:0] data_sram_addr,
    input [31:0] data_sram_wdata,
    output [31:0] data_sram_rdata
    );


    reg [7:0] memory[127:0];

    assign  data_sram_rdata={memory[data_sram_addr],memory[data_sram_addr+1],memory[data_sram_addr+2],memory[data_sram_addr+3]};

    integer i ;
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            for(i=0;i<=127;i=i+1) memory[i]=32'd0;
        end       
        else if (data_sram_wen==4'b1111) begin
            memory[data_sram_addr]  =data_sram_wdata[31:24];
            memory[data_sram_addr+1]=data_sram_wdata[23:16];
            memory[data_sram_addr+2]=data_sram_wdata[15:8];
            memory[data_sram_addr+3]=data_sram_wdata[7:0];            
        end
    end
    
endmodule

/********************************************************************/

module  judge_is_jmp(
    input   [2:0]branch_m,
    input   [1:0]zero_m,
    output  is_jmp
);
assign is_jmp=judge(branch_m,zero_m);

function judge(input [2:0]branch_m, input [1:0]zero_m);
    case(branch_m)
        3'b001: judge = 1'b0;
        3'b010: begin
                    if (zero_m==2'b10) begin
                        judge=1'b1;
                    end
                    else begin
                        judge=1'b0;
                    end
                end
         3'b011: begin
                    if (zero_m==2'b10) begin
                        judge=1'b0;
                    end
                    else begin
                        judge=1'b1;
                    end
                end
          3'b100: begin
                    if (zero_m==2'b01) begin
                        judge=1'b1;
                    end
                    else if(zero_m==2'b10)begin
                        judge=1'b1;
                    end
                    else begin
                        judge=1'b0;
                    end
                end
           3'b101:begin
                    judge=1'b1;
                  end
           3'b110:begin
                    judge=1'b1;
           end
           3'b111:begin
                    judge=1'b1;
           end
           default: judge=1'b0;         
    endcase
endfunction

endmodule

/********************************************************************/

module mux2_1_32(
    input [31:0]src1,
    input [31:0]src2,
    input select,
    output [31:0]out
);

assign out=choose(src1,src2,select);

function [31:0]choose(input [31:0] src1,input [31:0] src2,input select);

case(select)
    1'b0: choose=src1;
    1'b1: choose=src2;
    default: choose=32'b0;
endcase

endfunction

endmodule

/********************************************************************/


module mux2_1_5(
    input [31:0]src1,
    input [31:0]src2,
    input select,
    output [31:0]out
);

assign out=choose(src1,src2,select);

function [31:0]choose(input [31:0] src1,input [31:0] src2,input select);

case(select)
    1'b0: choose=src1;
    1'b1: choose=src2;
    default: choose=32'b0;
endcase

endfunction

endmodule

/********************************************************************/

module ROM(
    input clk,
    input rst,
    input inst_sram_en,
    input [3:0] inst_sram_wen,
    input [31:0] inst_sram_addr,
    input [31:0] inst_sram_wdata,
    output [31:0] inst_sram_rdata
    );
    reg [7:0] memory[127:0];
    wire [31:0] addr;

    initial begin
		$readmemh("test_cal_version1.txt",memory);
	end
    assign  addr=inst_sram_addr; 
    assign  inst_sram_rdata={memory[addr],memory[addr+1],memory[addr+2],memory[addr+3]};
    
endmodule



/********************************************************************/


module pc_plus4(
    input [31:0] pc,
    input PC_stall,
    output [31:0] out
);


assign out=outs(pc,PC_stall);

function [31:0]outs(input [31:0] pc, input PC_stall);
case(PC_stall)
       1'b0: outs=pc+32'b00100;
       1'b1: outs=pc;
endcase


endfunction
//assign out=pc+32'b00001;

endmodule

/********************************************************************/

module is_stall(
    input [5:0] opcode,
    output [1:0] number_of_stall
);

assign number_of_stall=choose(opcode);

function [1:0]choose(input [5:0] opcode);

case(opcode)
    6'b000010: choose=2'b10;
    6'b000001: choose=2'b10;
    6'b000101: choose=2'b10;
    6'b000100: choose=2'b10;
    6'b100011: choose=2'b01;
    
    default: choose=2'b00;
endcase

endfunction
endmodule


/********************************************************************/

module pc_plus(
    input [31:0] pc,
    input [25:0] jmp,
    input [31:0] rd1_e,
    input [2:0] branch_e,
    output [31:0] out
);
assign out=outs(pc,jmp,branch_e);

function [31:0]outs(input [31:0] pc, input[25:0] jmp ,input [2:0]branch_e);

case(branch_e)
       
       3'b101: begin
            outs={pc[31:28],jmp[25:0],2'b0};
       end//上机请使�? outs={22'b0,jmp[7:0],2'b0};
       3'b110:begin
            outs=rd1_e;
       end
       3'b111:begin
            outs={pc[31:28],jmp[25:0],2'b0};
       end
       default:outs=pc+{{14{jmp[15]}},jmp[15:0],2'b0};
endcase
endfunction
endmodule


/********************************************************************/

module PC(
    input [31:0]pc_in,
    input clk,
    input reset,
//    input PC_stall,
    output [31:0]pc_out
);
reg [31:0] pc;
assign pc_out=pc;
//initial begin
//       pc<=32'hbfc00000;
////    pc<=32'b0;
//end
always@(posedge clk) begin
//        if (PC_stall==1'b0) begin
          if(reset==1'b1) begin
                   pc<=32'hbfc00000;
          end
          else begin
            pc=pc_in;
          end
//        end
     end
endmodule

/********************************************************************/
        
module cpu_part(

    );
endmodule
