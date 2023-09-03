module data_preload(
    input clk,
    input [31:0] ram_data, 
    output [31:0] data
);
reg [31:0] pre_data;
always(@ negedge clk) begin
    pre_data=ram_data
end
assign data=pre_data;
endmodule