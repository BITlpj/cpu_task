`timescale 1ns / 1ps

module forwarding_unit(
    input [4:0] addr1,
    input [4:0] addr2,
    input reg_write_e,
    input reg_write_m,
    input [4:0]write_reg_e,
    input [4:0]write_reg_m,
    input [31:0]alu_out_e,
    input [31:0]result_m,
    
    output [31:0]rd1,
    output [31:0]rd2,
    output choose1,
    output choose2
    );

function [65:0]rd_cal;//[65]choose1, [64]choose2, [63:32]rd1, [31:0]rd2;
input [4:0] addr1,addr2;
input reg_write_e;
input reg_write_m;
input [4:0]write_reg_e;
input [4:0]write_reg_m;
input [31:0]alu_out_e;
input [31:0]result_m;
begin
    rd_cal[64] = 0;
    rd_cal[65] = 0;

//    case(reg_write_e)
//    1'b1:begin
//        if(write_reg_e==addr2)begin
//            rd_cal[31:0] = alu_out_e;
//            rd_cal[64] = 1;
//        end
//    end
//    endcase
    
//    case(reg_write_m)
//    1'b1:begin
//        if(write_reg_m==addr2)begin
//            rd_cal[31:0] = result_m;
//            rd_cal[64] = 1;
//        end
//    end
//    endcase
    
//    case(reg_write_e)
//    1'b1:begin
//        if(write_reg_e==addr1)begin
//            rd_cal[63:32] = alu_out_e;
//            rd_cal[65] = 1;
//        end
//    end
//    endcase
    
//    case(reg_write_m)
//    1'b1:begin
//        if(write_reg_m==addr1)begin
//            rd_cal[63:32] = result_m;
//            rd_cal[65] = 1;
//        end
//    end
//    endcase


    case({reg_write_e,reg_write_m})
        2'b01: begin
               if(write_reg_m==addr1) begin
                   rd_cal[63:32] = result_m;
                   rd_cal[65] = 1;
               end 
               if(write_reg_m==addr2) begin
                    rd_cal[31:0] = result_m;
                    rd_cal[64] = 1;
               end
        end
        2'b10:begin
               if(write_reg_e==addr1) begin
                   rd_cal[63:32] = alu_out_e;
                   rd_cal[65] = 1;
               end 
               if(write_reg_e==addr2) begin
                    rd_cal[31:0] = alu_out_e;
                    rd_cal[64] = 1;
               end 
        end
        2'b11:begin
            if(write_reg_e==write_reg_m) begin
               if(write_reg_e==addr1) begin
                   rd_cal[63:32] = alu_out_e;
                   rd_cal[65] = 1;
               end 
               if(write_reg_e==addr2) begin
                    rd_cal[31:0] = alu_out_e;
                    rd_cal[64] = 1;
               end
            end
            else begin
               if(write_reg_e==addr1) begin
                   rd_cal[63:32] = alu_out_e;
                   rd_cal[65] = 1;
               end 
               if(write_reg_e==addr2) begin
                    rd_cal[31:0] = alu_out_e;
                    rd_cal[64] = 1;
               end 
              if(write_reg_m==addr1) begin
                   rd_cal[63:32] = result_m;
                   rd_cal[65] = 1;
               end 
               if(write_reg_m==addr2) begin
                    rd_cal[31:0] = result_m;
                    rd_cal[64] = 1;
               end
            end
        end
    endcase
end
endfunction

assign {choose1,choose2,rd1,rd2} = rd_cal(addr1,addr2,reg_write_e,reg_write_m,write_reg_e,write_reg_m,alu_out_e,result_m);

endmodule