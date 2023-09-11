`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 16:53:30
// Design Name: 
// Module Name: top
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
include vga.v;


module cpu_vga_top(
    input clk,
    input rstn,
    input change1,
    input change2,
    output hs,
    output vs,
    output [3:0]red,
    output [3:0] green,
    output [3:0] blue,
    output led
    );
    
debounce rstn_debounce(
    .rstn(rstn),
    .clk(clk),
    .button_in(rstn),
    .button_out(rstn_stable)
    );   
    wire rstn_stable;
    wire over;
    wire inst_sram_en;
    wire [3:0]inst_sram_wen;
    wire [31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    
    wire data_sram_en;
    wire [3:0]data_sram_wen;
    wire [31:0]data_sram_addr;
    wire [31:0]data_sram_wdata;
    wire [31:0]data_sram_rdata;
    
    
    wire [31:0]debug_wb_pc;
    wire [3:0] debug_wb_rf_wen;
    wire [4:0] debug_wb_rf_wnum;
    wire [31:0]debug_wb_rf_wdata;
    
    
    
    wire [31:0]cache_addr;
    wire [31:0]cache_data;
    wire [31:0]cache_out;    
    wire slow_clk;
    
    
slow_clk   test_clk(.clk(clk),.rstn(rstn),.slow_clk(slow_clk));   
 
assign led=rstn;    

//    ROM test_rom(
//        .clk(clk),
//        .rst(reset),
//        .inst_sram_en(inst_sram_en),
//        .inst_sram_wen(inst_sram_wen),
//        .inst_sram_addr(inst_sram_addr),
//        .inst_sram_wdata(inst_sram_wdata),
//        .inst_sram_rdata(inst_sram_rdata)
//    );
 
 
  cache test_cache(
    .rstn(rstn_stable),
    .clk (slow_clk),
    .cache_data(cache_data),
    .cache_addr(cache_addr),
    .cache_out(cache_out)
);
 
 
 blk_mem_gen_0 test_rom(
       .clka(slow_clk),
       .ena(inst_sram_en),
       .wea(inst_sram_wen),
       .addra(inst_sram_addr[7:2]),
       .dina(inst_sram_wdata),
       .douta(inst_sram_rdata) 
 );
   RAM test_ram(
        .clk(slow_clk),
        .rst(~rstn_stable),
        .data_sram_en(data_sram_en),
        .data_sram_wen(data_sram_wen),
        .data_sram_addr(data_sram_addr),
        .data_sram_wdata(data_sram_wdata),
        .data_sram_rdata(data_sram_rdata),
        .cache_addr(cache_addr),
        .cache_data(cache_data)
    );
    
// blk_mem_gen_1 test_ram(
//       .clka(clk),
//       .rsta(reset),
//       .ena(data_sram_en),
//       .wea(data_sram_wen),
//       .addra(data_sram_addr[7:2]),
//       .dina(data_sram_wdata),
//       .douta(data_sram_rdata) 
// );    
    
mycpu_top test_cpu(
   .clk(slow_clk),
   .resetn(rstn_stable),

   .inst_sram_en(inst_sram_en),
   .inst_sram_wen(inst_sram_wen),//4'b0000
   .inst_sram_addr(inst_sram_addr),//ignored
   .inst_sram_wdata(inst_sram_wdata),//ignored
   .inst_sram_rdata(inst_sram_rdata),//¶ÁÊı¾İ

   .data_sram_en(data_sram_en),
   .data_sram_wen(data_sram_wen),
   .data_sram_addr(data_sram_addr),
   .data_sram_wdata(data_sram_wdata),
   .data_sram_rdata(data_sram_rdata),
   .debug_wb_pc(debug_wb_pc),
   .debug_wb_rf_wen(debug_wb_rf_wen),
   .debug_wb_rf_wnum(debug_wb_rf_wnum),
   .debug_wb_rf_wdata(debug_wb_rf_wdata),
   .over(over)
);
    vga_controller_0 my_vga(
        .data(cache_out),
        .clk(clk),
        .change1(change1),
        .change2(change2),
        .rstn(rstn_stable),
        .hs(hs),
        .vs(vs),
        .r(red),
        .g(green),
        .b(blue)        
    );
endmodule
