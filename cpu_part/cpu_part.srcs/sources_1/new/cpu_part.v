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
    input ram_we,
    input [4:0]ram_addr,
    input [31:0]ram_wd,
    output [31:0]ram_rd
    );
    reg [31:0] memory[31:0];
    
    
    assign  ram_rd=memory[ram_addr];
    integer i ;
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            for(i=0;i<=31;i=i+1) memory[i]=32'd0;
        end       
        else if (ram_we) begin
            memory[ram_addr]=ram_wd;
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
          3'b011: begin
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
    input  [4:0]rom_addr,
    output [31:0]rom_rd
    );
    reg [31:0] memory[31:0];
    
    initial begin
		$readmemh("path",memory);
	end
    assign  rom_rd=memory[rom_addr];
    
endmodule



/********************************************************************/


module pc_plus4(
    input [31:0] pc,
    output [31:0] out
);

assign out=pc+5'b00001;

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
    input [31:0] jmp,
    output [31:0] out
);

assign out=pc+jmp;

endmodule


/********************************************************************/

module PC(
    input [31:0]pc_in,
    input clk,
    input PC_stall,
    output [31:0]pc_out
);
reg [31:0] pc;
assign pc_out=pc;
always@(posedge clk) begin
        if (PC_stall==1'b0) begin
            pc=pc_in;
        end
     end
endmodule

/********************************************************************/
        
module cpu_part(

    );
endmodule
