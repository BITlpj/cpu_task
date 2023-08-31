`timescale 1ns / 1ps

module regfile(
    input wire clk,
	input wire reset,
	input wire [4:0] addr1,
	input wire [4:0] addr2,
	input wire [4:0] addr3, // write address
	input wire [31:0] wd,  // write data
	input wire we,
	output wire [31:0] rd1,
	output wire [31:0] rd2
);
	
	reg [31:0] data[31:0];

	assign rd1 = data[addr1];
	assign rd2 = data[addr2];
	
	integer i;
	always @(posedge reset or negedge clk)
		if (reset)
			for (i = 0; i < 32; i = i + 1)
				data[i] <= 32'h00000000;
		else if (we)
			data[addr3] <= wd;

endmodule
