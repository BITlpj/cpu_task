`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 20:51:41
// Design Name: 
// Module Name: cpu_part_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_part_tb();

reg [4:0] addr;
reg [31:0]data;
reg [31:0]test;
wire [31:0] out;
reg [1:0]select;
reg clk;
reg rst;
reg ram_we;
reg [2:0]branch_m;
reg [1:0]zero_m;
wire is_jmp;
reg  [4:0]pc;
wire [4:0]tests;
RAM test_ram(.clk(clk),
             .rst(rst),
             .ram_we(ram_we),
             .ram_addr(addr),
             .ram_wd(data),
             .ram_rd(out)
         );
judge_is_jmp test_judge_is_jmp(
            .branch_m(branch_m),
            .zero_m(zero_m),
            .is_jmp(is_jmp)
);

pc_plus4 test_pc_plus4(
            .pc(pc),
            .out(tests)
);

initial
begin
pc<=5'b0;
clk<=1'b0;
rst<=1'b1;
ram_we<=1'b0;
addr<=5'b00001;
data<=32'b0001;
branch_m<=3'b010;
zero_m<=2'b10;
end

always #10 clk =~clk;    

initial begin
#40
rst<=1'b0;
ram_we<=1'b1;
#20
ram_we<=1'b0;
end

endmodule
