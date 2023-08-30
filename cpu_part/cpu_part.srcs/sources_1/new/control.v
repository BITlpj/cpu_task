`timescale 1ns / 1ps

module control(
    input wire [5:0] op,
    input wire [5:0] func,
    output wire [2:0] branch,
    output wire reg_write,
    output wire mem_to_reg,
    output wire mem_write,
    output wire [2:0] alu_control,
    output wire alu_src,
    output wire reg_dst
    );
    
    wire [10:0] out;     // all outputs
    assign out = opdec(op, func);   // operation decoder
    function [10:0] opdec(input [5:0] op, input [5:0] func);
    begin
        case(op)
            // R
            6'b000000:begin
                case(func)
                    6'b100000: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b001, 1'b0, 1'b0};   // add
                    6'b100010: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b010, 1'b0, 1'b0};   // sub
                    6'b100100: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b011, 1'b0, 1'b0};   // and
                    6'b100101: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b100, 1'b0, 1'b0};   // or
                    6'b100110: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b101, 1'b0, 1'b0};   // xor
                    // 
                    6'b000000: opdec = {3'b000, 1'b0, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0};   // NULL
                endcase
            end
            // I
            6'b001000: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b001, 1'b1, 1'b1};   // addi
            6'b001100: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b011, 1'b1, 1'b1};   // andi
            6'b001101: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b100, 1'b1, 1'b1};   // ori
            6'b001110: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b101, 1'b1, 1'b1};   // xori
            6'b001111: opdec = {3'b001, 1'b1, 1'b0, 1'b0, 3'b110, 1'b1, 1'b1};   // lui
            6'b100011: opdec = {3'b001, 1'b1, 1'b1, 1'b0, 3'b001, 1'b1, 1'b1};   // lw
            6'b101011: opdec = {3'b001, 1'b0, 1'b0, 1'b1, 3'b001, 1'b1, 1'b0};   // sw
            6'b000100: opdec = {3'b010, 1'b0, 1'b0, 1'b0, 3'b010, 1'b0, 1'b0};   // beq
            6'b000101: opdec = {3'b011, 1'b0, 1'b0, 1'b0, 3'b010, 1'b0, 1'b0};   // bne
            6'b000001: opdec = {3'b100, 1'b0, 1'b0, 1'b0, 3'b010, 1'b0, 1'b0};   // bgez
            // J
            6'b000010: opdec = {3'b101, 1'b0, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0};   // j
            
            
        endcase
    end
    endfunction
    
    assign branch = out[10:8];
    assign reg_write = out[7];
    assign mem_to_reg = out[6];
    assign mem_write = out[5];
    assign alu_control = out[4:2];
    assign alu_src = out[1];
    assign reg_dst = out[0];
    
endmodule

