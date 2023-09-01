`timescale 1ns / 1ps

module signextend( 
    input [15:0] imm,
    input unsign,
    output [31:0] imm_out
);
function [31:0] outs(input [15:0] imm,input unsign);
begin
case(unsign)
    1'b0:
        outs = {{16{imm[15]}},imm[15:0]};
    1'b1:
        outs = {16'b0,imm[15:0]};    
endcase
end
endfunction

assign imm_out=outs(imm,unsign);

endmodule

