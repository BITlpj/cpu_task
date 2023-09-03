`timescale 1ns / 1ps

module control(
    input wire [31:0] instr,
    output wire [2:0] branch,
    output wire reg_write,
    output wire mem_to_reg,
    output wire [3:0]mem_write,
    output wire [3:0] alu_control,
    output wire unsign,
    output wire alu_src,
    output wire reg_dst
    );
    
    wire [12:0] out;     // all outputs
    wire [5:0] op;
    wire [5:0] func;
    assign op=instr[31:26];
    assign func=instr[5:0];
    assign out = opdec(op, func,instr);   // operation decoder
    function [12:0] opdec(input [5:0] op, input [5:0] func,input [31:0] instr);
    begin
        case(op)
            // R
            6'b000000:begin
                case(func)
                    // unsign   branch  reg_write   mem_to_reg  mem_write alu_control alu_src reg_dst
                    6'b100000: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0001, 1'b0, 1'b0};   // add
                    6'b100010: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0010, 1'b0, 1'b0};   // sub
                    6'b100100: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0011, 1'b0, 1'b0};   // and
                    6'b100101: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0100, 1'b0, 1'b0};   // or
                    6'b100110: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0101, 1'b0, 1'b0};   // xor
                    6'b100001: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0001, 1'b0, 1'b0}; //addu
                    6'b101010: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0111, 1'b0, 1'b0};//SLT
                    6'b101011: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b1000, 1'b0, 1'b0};//sltu
                    6'b100011: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0010, 1'b0, 1'b0};//subu
                    6'b000010: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b1001, 1'b0, 1'b0};//srl
                    6'b001000: opdec = {1'b0,3'b110, 1'b0, 1'b0, 1'b0, 4'b1011, 1'b0, 1'b0};//jr
                    6'b000000: begin
                                if (instr==32'b0) begin
                                opdec = {1'b0,3'b000, 1'b0, 1'b0, 1'b0, 4'b0000, 1'b0, 1'b0};
                                end   // null
                                else begin
                                opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b1010, 1'b0, 1'b0};//sll
                                end                               
                               end
                endcase
            end
            // I
            6'b001000: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0001, 1'b1, 1'b1};   // addi
            6'b001100: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0011, 1'b1, 1'b1};   // andi
            6'b001101: opdec = {1'b1,3'b001, 1'b1, 1'b0, 1'b0, 4'b0100, 1'b1, 1'b1};   // ori
            6'b001110: opdec = {1'b1,3'b001, 1'b1, 1'b0, 1'b0, 4'b0101, 1'b1, 1'b1};   // xori
            6'b001111: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0110, 1'b1, 1'b1};   // lui
            6'b100011: opdec = {1'b0,3'b001, 1'b1, 1'b1, 1'b0, 4'b0001, 1'b1, 1'b1};   // lw
            6'b101011: opdec = {1'b0,3'b001, 1'b0, 1'b0, 1'b1, 4'b0001, 1'b1, 1'b0};   // sw
            6'b000100: opdec = {1'b0,3'b010, 1'b0, 1'b0, 1'b0, 4'b0010, 1'b0, 1'b0};   // beq
            6'b000101: opdec = {1'b0,3'b011, 1'b0, 1'b0, 1'b0, 4'b0010, 1'b0, 1'b0};   // bne
            6'b000001: opdec = {1'b0,3'b100, 1'b0, 1'b0, 1'b0, 4'b0010, 1'b0, 1'b0};   // bgez
            6'b001001: opdec = {1'b0,3'b001, 1'b1, 1'b0, 1'b0, 4'b0001, 1'b1, 1'b1};//addiu
            6'b000011: opdec = {1'b0,3'b111, 1'b1, 1'b0, 1'b0, 4'b1100, 1'b0, 1'b0};//jal
            // J
            6'b000010: opdec = {3'b101, 1'b0, 1'b0, 1'b0, 4'b0000, 1'b0, 1'b0};   // j
            
            
        endcase
    end
    endfunction
    
    assign unsign=out[12];
    assign branch = out[11:9];
    assign reg_write = out[8];
    assign mem_to_reg = out[7];
    assign mem_write = {out[6],out[6],out[6],out[6]};
    assign alu_control = out[5:2];
    assign alu_src = out[1];
    assign reg_dst = out[0];
    
endmodule

