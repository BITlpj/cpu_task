`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 10:08:09
// Design Name: 
// Module Name: cpu
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
include D_E.v;
include E_M.v;
include F_D.v;
include M_W.v;
include ALU.v;
include cpu_part.v;
include control.v;
include regfile.v;
include signextend.v;
include jal_mux.v;
include pre_read.v;

module mycpu_top(
    input clk,
    input resetn,
    input int,//ignored
    
    output inst_sram_en,
    output [3:0] inst_sram_wen,//4'b0000
    output [31:0] inst_sram_addr,
    output [31:0] inst_sram_wdata,//ignored
    input  [31:0] inst_sram_rdata,//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
    
    output data_sram_en,
    output [3:0]data_sram_wen,
    output [31:0]data_sram_addr,
    output [31:0]data_sram_wdata,
    input  [31:0]data_sram_rdata,


    output [31:0]debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0]debug_wb_rf_wdata,

    output over
    );

assign inst_sram_wen=4'b0000;


wire [31:0]PC_plus4_f;
wire is_jmp;
wire [31:0]pc_in;

wire [31:0] rom_addr;
wire [31:0] rom_rd;

wire [4:0] ram_addr;
wire [31:0] ram_rd;
wire [31:0] ram_wd;
wire ram_we;


//wire [1:0]number_of_stall;

wire [5:0]op;
wire [5:0]func;
wire [4:0] addr1;
wire [4:0] addr2;
wire [4:0] rt_d;
wire [4:0] rd_d;
wire [15:0] imm;


wire[2:0] branch_d;
wire reg_write_d;
wire mem_to_reg_d;
wire [3:0]mem_write_d;
wire [3:0]alu_control_d;
wire alu_src_d;
wire reg_dst_d;
wire unsign_d;


wire [31:0]rd1_src0;
wire [31:0]rd2_src0;
wire [31:0]rd1_src1;
wire [31:0]rd2_src1;
wire rd1_choose;
wire rd2_choose;


wire [31:0]rd1;
wire [31:0]rd2;


wire [31:0] imm_out;

/*Ñ¡ï¿½ï¿½Ð´ï¿½ï¿½Ä´ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
wire [4:0] rt_e;
wire [4:0] rd_e;
wire [4:0] write_data_e;
wire reg_dst_e;

/*Ñ¡ï¿½ï¿½alu_srcï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?*/
wire [31:0] imm_e;
wire alu_src_e;
wire [31:0] alu_src2;

/*aluï¿½ï¿½Øµï¿½ï¿½ï¿?*/

wire [31:0] alu_src1;
wire [1:0]  zero;
wire [31:0]alu_out_e;
wire [31:0]instr_d;

wire [31:0] PC_plus4_e;
wire [31:0]pc_jmp_out;

/*RAMï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?*/

wire [31:0]ram_rd;


/*ï¿½Ú¶ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½ï¿½ï¿½ï¿½Øµï¿?*/
wire[2:0] branch_e;
wire reg_write_e;
wire mem_to_reg_e;
wire [3:0]mem_write_e;
wire [3:0]alu_control_e;
wire alu_src_e;
wire reg_dst_e;
wire [31:0]rd1_e;
wire [31:0]rd2_e;
wire [31:0]PC_plus4_d;


/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?*/
wire [4:0]write_reg_e;
wire [31:0]write_reg_e_pre;
wire [31:0] rd1_e_final;
wire [2:0]branch_m;
wire reg_write_m;
wire mem_to_reg_m;
wire [3:0]mem_write_m;
wire [1:0]zero_m;
wire [31:0]alu_out_m;
wire [4:0] write_reg_m;
wire [31:0] write_data_m;
wire [31:0] PC_branch_m;

/*ï¿½ï¿½ï¿½Ä¸ï¿½ï¿½Ä´ï¿½ï¿½ï¿½*/
wire reg_write_w;
wire [31:0] result_w;
wire [4:0]write_reg_w;

wire [31:0]result_m;

wire over_flag;
assign over=over_flag;
wire PC_stall;


/*debugï¿½ï¿½*/
wire [31:0]debug_wb_pc_f;
wire [31:0]debug_wb_pc_d;
wire [31:0]debug_wb_pc_e;
wire [31:0]debug_wb_pc_m;
wire [31:0]debug_wb_pc_w;

/*shamtï¿½ï¿½ï¿?*/
wire [4:0]shamt_d;
wire [4:0]shamt_e;


wire [25:0] jmp_addr_e;
wire [25:0] jmp_addr_d;

assign debug_wb_rf_wen={reg_write_w,reg_write_w,reg_write_w,reg_write_w};
assign debug_wb_rf_wdata=result_w;
assign debug_wb_rf_wnum=write_reg_w;
assign debug_wb_pc=debug_wb_pc_w;




assign inst_sram_addr={3'b0,pc_in[28:0]};

pre_read cpu_pre_read(
    .inst_in(inst_sram_rdata),
    .clk(clk),
    .inst_out(rom_rd)
);

//assign rom_rd=inst_sram_rdata;
assign debug_wb_pc_f=rom_addr;
assign inst_sram_en=1'b1;


mux2_1_32 mux_choose_pc(
    .src1(PC_plus4_f),
    .src2(PC_branch_m),
    .select(is_jmp),
    .out(pc_in)
);



PC cpu_pc(
    .clk(clk),
    .reset(~resetn),
    .pc_in(pc_in),
    .pc_out(rom_addr)
//    .PC_stall(PC_stall)
);

pc_plus4 pc_plus(
    .pc(rom_addr),
    .out(PC_plus4_f),    
    .PC_stall(PC_stall)
);

//is_stall cpu_is_stall(
//    .opcode(op),
//    .number_of_stall(number_of_stall)
//);

F_D f_d(
    .clk(clk),
    .reset(~resetn),
//   .number_of_stall(number_of_stall),
    .instr(rom_rd),
    .PC_plus4_f(PC_plus4_f),
    
//    .op(op),
//    .func(func),
    .instr_d(instr_d),
    .addr1(addr1),
    .addr2(addr2),
    .rt_d(rt_d),
    .rd_d(rd_d),
    .imm(imm),
    .PC_plus4_d(PC_plus4_d),
    .PC_stall(PC_stall),
    .shamt_d(shamt_d),
    
    .debug_wb_pc_f(debug_wb_pc_f),
    .debug_wb_pc_d(debug_wb_pc_d),
    
    .jmp_addr_d(jmp_addr_d)
);

control cpu_control(
       .instr(instr_d),
       .branch(branch_d),
       .reg_write(reg_write_d),
       .mem_to_reg(mem_to_reg_d),
       .mem_write(mem_write_d),
       .alu_control(alu_control_d),
       .alu_src(alu_src_d),
       .reg_dst(reg_dst_d),
       .unsign(unsign_d)
);

jal_mux_32 jal_mux_data(
    .src1(debug_wb_pc_e+4),
    .src2(rd1_e),
    .select(branch_e),
    .out(rd1_e_final)
);



jal_mux_5 jal_mux_addr(
    .src1(32'b11111),
    .src2(write_reg_e_pre),
    .select(branch_e),
    .out(write_reg_e)  

);


regfile cpu_regfile(
    .clk(clk),
	.reset(~resetn),
	.addr1(addr1),
	.addr2(addr2),
	.addr3(write_reg_w), // write address
	.wd(result_w),  // write data
	.we(reg_write_w),
	.rd1(rd1_src0),
	.rd2(rd2_src0)
);

signextend cpu_signextend( 
    .imm(imm),
    .unsign(unsign_d),
    .imm_out(imm_out)
);

forwarding_unit cpu_forwarding_unit(
    .addr1(addr1),
    .addr2(addr2),
    .reg_write_e(reg_write_e),
    .reg_write_m(reg_write_m),
    .write_reg_e(write_reg_e),
    .write_reg_m(write_reg_m),
    .alu_out_e(alu_out_e),
    .result_m(result_m),
    
    .rd1(rd1_src1),
    .rd2(rd2_src1),
    .choose1(rd1_choose),
    .choose2(rd2_choose)
    );


mux2_1_32 mux_choose_rd1(
    .src1(rd1_src0),
    .src2(rd1_src1),
    .select(rd1_choose),
    .out(rd1)
);

mux2_1_32 mux_choose_rd2(
    .src1(rd2_src0),
    .src2(rd2_src1),
    .select(rd2_choose),
    .out(rd2)
);

mux2_1_5 mux_choose_reg_write(
    .src1(rd_e),
    .src2(rt_e),
    .select(reg_dst_e),
    .out(write_reg_e_pre)
);


mux2_1_32 mux_choose_alu_src(
    .src1(rd2_e),
    .src2(imm_e),
    .select(alu_src_e),
    .out(alu_src2)
);

ALU cpu_alu(
    .control(alu_control_e),
    .alu_num1(rd1_e_final),
    .alu_num2(alu_src2),
    .shamt_e({1'b0,shamt_e}),
    
    .ans(alu_out_e),
    .zero_m(zero),
    .over(over_flag)
    );

pc_plus pc_plus_jmp(
    .pc(PC_plus4_e),
    .branch_e(branch_e),
    .rd1_e(rd1_e),
    .jmp(jmp_addr_e),
    .out(pc_jmp_out)
);

// RAM ram(
//     .ram_addr(alu_out_m),
//     .ram_rd(ram_rd),
//     .ram_wd(write_data_m),
//     .ram_we(mem_write_m),
//     .clk(clk),
//     .rst(resetn)
// );


//assign data_sram_addr={3'b0,alu_out_e[28:0]};
assign data_sram_wen=mem_write_m;
assign data_sram_wdata=write_data_m;
assign ram_rd=data_sram_rdata;
assign data_sram_en=1'b1;



mux2_1_32 mux_choos_ram_addr(
    .src1({3'b0,alu_out_e[28:0]}),
    .src2({3'b0,alu_out_m[28:0]}),
    .select(mem_write_m),
    .out(data_sram_addr)
);


judge_is_jmp  cpu_judge_is_jmp(
   .branch_m(branch_m),
    .zero_m(zero_m),
    .is_jmp(is_jmp)
);

mux2_1_32 mux_choose_result_src(
    .src1(alu_out_m),
    .src2(ram_rd),
    .select(mem_to_reg_m),
    .out(result_m)
);

D_E d_e(
    .clk(clk),
    .reset(~resetn),
    .branch_d(branch_d),//[2:0]
    .reg_write_d(reg_write_d),
    .mem_to_reg_d(mem_to_reg_d),
    .mem_write_d(mem_write_d),
    .alu_control_d(alu_control_d),//[2:0]
    .alu_src_d(alu_src_d),
    .reg_dst_d(reg_dst_d),//[4:0]
    .rd1_d(rd1),//?
    .rd2_d(rd2),//??
    .rt_d(rt_d),//[4:0]    
    .rd_d(rd_d),//[4:0]    
    .sign_imm_d(imm_out),//[31:0]
    .PC_plus4_d(PC_plus4_d),//[31:0]
    
    .branch_e(branch_e),//[2:0]
    .reg_write_e(reg_write_e),
    .mem_to_reg_e(mem_to_reg_e),
    .mem_write_e(mem_write_e),
    .alu_control_e(alu_control_e),//[2:0]
    .alu_src_e(alu_src_e),
    .reg_dst_e(reg_dst_e),//[4:0]
    .rd1_e(rd1_e),//[31:0]
    .rd2_e(rd2_e),//[31:0]
    .rt_e(rt_e),//[4:0]
    .rd_e(rd_e),//[4:0]
    .imm_e(imm_e),//[31:0]
    .PC_plus4_e(PC_plus4_e),//[31:0]
    
    
    .debug_wb_pc_d(debug_wb_pc_d),
    .debug_wb_pc_e(debug_wb_pc_e),
    
    
    .shamt_d(shamt_d),
    .shamt_e(shamt_e),
    
    
    .jmp_addr_e(jmp_addr_e),
    .jmp_addr_d(jmp_addr_d)
    );
    
E_M e_m(
     .clk(clk),
     .reset(~resetn),
     .branch_e(branch_e),//[2:0]
     .reg_write_e(reg_write_e),
     .mem_to_reg_e(mem_to_reg_e),
     .mem_write_e(mem_write_e),
     .zero_e(zero),//[1:0]
     .alu_out_e(alu_out_e),//[31:0]
     .write_reg_e(write_reg_e),//[4:0]
     .write_data_e(rd2_e),//[31:0]
     
     .PC_branch_e(pc_jmp_out),//[31:0]
     
     .branch_m(branch_m),//[2:0]
     .reg_write_m(reg_write_m),
     .mem_to_reg_m(mem_to_reg_m),
     .mem_write_m(mem_write_m),
     .zero_m(zero_m),//[1:0]
     .alu_out_m(alu_out_m),//[31:0]
     .write_reg_m(write_reg_m),//[4:0]
     .write_data_m(write_data_m),//[31:0]
     .PC_branch_m(PC_branch_m),//[31:0]
     
     .debug_wb_pc_e(debug_wb_pc_e),
    .debug_wb_pc_m(debug_wb_pc_m)
    );
    
M_W m_w(
     .clk(clk),
     .reset(~resetn),
     .reg_write_m(reg_write_m),
     .result_m(result_m),//[31:0]
     .write_reg_m(write_reg_m),//[4:0]
     
     .reg_write_w(reg_write_w),
     .result_w(result_w),//[31:0]
     .write_reg_w(write_reg_w),//[4:0]
     
     
     
     .debug_wb_pc_m(debug_wb_pc_m),
    .debug_wb_pc_w(debug_wb_pc_w)
    );
endmodule
