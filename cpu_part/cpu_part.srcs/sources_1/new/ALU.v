module ALU(
    input [2:0] control,
    input [31:0] alu_num1,
    input [31:0] alu_num2,
    
    output [31:0] ans,
    output [1:0]zero_m,
    output  over
    );
    
    function [34:0]ALU_output;//[34:33]over,[33:32]zero, [31:0]ans;
    input [2:0] control;
    input [31:0] alu_num1;
    input [31:0] alu_num2;
    begin
        case(control)
            3'b001:begin
                ALU_output[31:0] = alu_num1 + alu_num2;
                if (alu_num1[31]==alu_num2[31] && alu_num1[31]!=ALU_output[31]) begin
                        ALU_output[33]=1'b1;
                    end
            end
            3'b010:begin
                ALU_output[31:0] = alu_num1 - alu_num2; 
                if (alu_num1[31]==alu_num2[31] && alu_num1[31]!=ALU_output[31]) begin
                   ALU_output[33]=1'b1;
                end
            end
            3'b011:begin
                ALU_output[31:0] = alu_num1&alu_num2; 
                ALU_output[33]=1'b0;
            end
            3'b100:begin
                ALU_output[31:0] = alu_num1|alu_num2; 
                ALU_output[33]=1'b0;
            end
            3'b101:begin
                ALU_output[31:0] = alu_num1^alu_num2; 
                ALU_output[33]=1'b0;
            end
            3'b110:begin
                ALU_output[31:0] = alu_num2 << 16; 
                ALU_output[33]=1'b0;
            end
            3'b000:begin
                ALU_output[33:32] = 2'b00;
                ALU_output[33]=1'b0;
            end
            endcase
            
            if(ALU_output > 0) ALU_output[33:32] = 2'b01;
            else if(ALU_output == 0) ALU_output[33:32] = 2'b10;
            else if(ALU_output < 0) ALU_output[33:32] = 2'b11;
    end
    endfunction

    assign {over,zero_m,ans} = ALU_output(control,alu_num1,alu_num2);
    
endmodule