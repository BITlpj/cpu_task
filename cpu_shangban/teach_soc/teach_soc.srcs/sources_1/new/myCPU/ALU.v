module ALU(
    input [3:0] control,
    input [31:0] alu_num1,
    input [31:0] alu_num2,
    input [5:0]  shamt_e,
    
    output [31:0] ans,
    output [1:0]zero_m,
    output  over
    );
    
    function [34:0]ALU_output;//[34:33]over,[33:32]zero, [31:0]ans;
    input [3:0] control;
    input [31:0] alu_num1;
    input [31:0] alu_num2;
    input [5:0]  shamt_e;
    begin
        case(control)
            4'b0001:begin
                ALU_output[31:0] = alu_num1 + alu_num2;
                if (alu_num1[31]==alu_num2[31] && alu_num1[31]!=ALU_output[31]) begin
                        ALU_output[34]=1'b1;
                end
                else begin
                    ALU_output[34]=1'b0;
                end
                
            end
            4'b0010:begin
                ALU_output[31:0] = alu_num1 - alu_num2; 
                if (alu_num1[31]==alu_num2[31] && alu_num1[31]!=ALU_output[31]) begin
                   ALU_output[34]=1'b1;
                end
                else begin
                    ALU_output[34]=1'b0;
                end
            end
            4'b0011:begin
                ALU_output[31:0] = alu_num1&alu_num2; 
                ALU_output[34]=1'b0;
            end
            4'b0100:begin
                ALU_output[31:0] = alu_num1|alu_num2; 
                ALU_output[34]=1'b0;
            end
            4'b0101:begin
                ALU_output[31:0] = alu_num1^alu_num2; 
                ALU_output[34]=1'b0;
            end
            4'b0110:begin
                ALU_output[31:0] = alu_num2 << 16; 
                ALU_output[34]=1'b0;
            end
            4'b0111:begin
                case({alu_num1[31],alu_num2[31]})
                    2'b00:begin
                        if(alu_num1<alu_num2)begin
                            ALU_output[31:0]=32'b1;
                        end
                        else begin
                            ALU_output[31:0]=32'b0;
                        end
                    end
                    2'b10:begin
                        ALU_output[31:0]=32'b1;
                    end
                    2'b01:begin
                        ALU_output[31:0]=32'b0;
                    end
                    2'b11:begin
                         if(alu_num1<alu_num2)begin
                            ALU_output[31:0]=32'b1;
                        end
                        else begin
                            ALU_output[31:0]=32'b0;
                        end
                    end
                endcase
                ALU_output[34]=1'b0;
            end
            
            4'b1000:begin
                if({1'b0, alu_num1}<{1'b0,alu_num2}) begin
                    ALU_output[31:0]=32'b01;
                end
                else begin
                    ALU_output[31:0]=32'b0;
                end
                ALU_output[34]=1'b0;
            end
            
            4'b1001:begin
                ALU_output[31:0]=alu_num2>>shamt_e;
                ALU_output[34]=1'b0;
             end
             
             4'b1010:begin
                ALU_output[31:0]=alu_num2<<shamt_e;
                ALU_output[34]=1'b0;                
             end
            4'b1011:begin
                ALU_output[31:0]=alu_num1;
                ALU_output[34]=1'b0;  
            end
            4'b1100:begin
                ALU_output[31:0]=alu_num1+4;
                ALU_output[34]=1'b0;      
            end
            4'b0000:begin
                ALU_output[31:0]=32'b0;
                ALU_output[33:32] = 2'b00;
                ALU_output[34]=1'b0;
            end
            endcase
            
            if(ALU_output[31:0] > 0) ALU_output[33:32] = 2'b01;
            else if(ALU_output[31:0] == 0) ALU_output[33:32] = 2'b10;
            else if(ALU_output[31:0] < 0) ALU_output[33:32] = 2'b11;
    end
    endfunction
    assign {over,zero_m,ans} = ALU_output(control,alu_num1,alu_num2,shamt_e);
    
endmodule