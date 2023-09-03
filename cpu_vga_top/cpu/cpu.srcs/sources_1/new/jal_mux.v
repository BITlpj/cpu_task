module jal_mux_32(
    input [31:0]src1,
    input [31:0]src2,
    input [2:0] select,
    output [31:0]out
);

assign out=choose(src1,src2,select);

function [31:0]choose(input [31:0] src1,input [31:0] src2,input [2:0]select);

case(select)
    3'b111: choose=src1;
    default: choose=src2;
endcase

endfunction

endmodule


module jal_mux_5(
    input [4:0]src1,
    input [4:0]src2,
    input [2:0] select,
    output [4:0]out
);

assign out=choose(src1,src2,select);

function [4:0]choose(input [4:0] src1,input [4:0] src2,input [2:0]select);

case(select)
    3'b111: choose=src1;
    default: choose=src2;
endcase

endfunction

endmodule