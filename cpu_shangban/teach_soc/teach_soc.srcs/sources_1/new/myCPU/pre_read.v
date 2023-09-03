module pre_read(
    input [31:0]inst_in,
    input clk,
    output [31:0]inst_out
);
reg [31:0] pc;
assign inst_out=pc;

always@(negedge clk) begin
//        if (PC_stall==1'b0) begin
            pc=inst_in;
//        end
     end
endmodule
