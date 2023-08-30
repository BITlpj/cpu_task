`timescale 1ns / 1ps

module signextend( 
    input [15:0] imm,
    output [31:0] imm_out
);
  
    assign imm_out = {{16{imm[15]}},imm[15:0]};

endmodule

