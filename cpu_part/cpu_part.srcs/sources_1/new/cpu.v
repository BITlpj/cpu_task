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
include reg_file.v;
include signextend.v;

module cpu(

    );

wire clk;
wire rst;

wire [31:0]PC_plus4_f;
wire is_jmp;
wire [31:0]pc_in;

wire [4:0] rom_addr;
wire [31:0] rom_rd;

wire [4:0] ram_addr;
wire [31:0] ram_rd;
wire [31:0] ram_wd;
wire ram_we;


wire [1:0]number_of_stall;

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
wire mem_write_d;
wire [2:0]alu_control_d;
wire alu_src_d;
wire reg_dst_d;


wire [31:0]rd1_src0;
wire [31:0]rd2_src0;
wire [31:0]rd1_src1;
wire [31:0]rd2_src1;
wire rd1_choose;
wire rd2_choose;


wire [31:0]rd1;
wire [31:0]rd2;


wire [31:0] imm_out;

/*选择写入寄存器的相关线*/
wire [4:0] rt_e;
wire [4:0] rd_e;
wire [4:0] write_data_e;
wire reg_dst_e;

/*选择alu_src的相关线*/
wire [31:0] imm_e;
wire alu_src_e;
wire [31:0] alu_src2;

/*alu相关的线*/

wire [31:0] alu_src1;
wire [1:0]  zero;
wire [31:0]alu_out_e;

wire [31:0] PC_plus4_e;
wire [31:0]pc_jmp_out;

/*RAM的相关线*/

wire [31:0]ram_rd;


/*第二个寄存器相关的*/
wire[2:0] branch_e;
wire reg_write_e;
wire mem_to_reg_e;
wire mem_write_e;
wire [2:0]alu_control_e;
wire alu_src_e;
wire reg_dst_e;
wire [31:0]rd1_e;
wire [31:0]rd2_e;


/*第三个寄存器相关*/
wire [4:0]write_reg_e;
wire [2:0]brach_m;
wire reg_write_m;
wire mem_to_reg_m;
wire mem_write_m;
wire [1:0]zero_m;
wire [31:0]alu_out_m;
wire [4:0] write_reg_m;
wire [31:0] write_data_m;
wire [31:0] PC_branch_m;

/*第四个寄存器*/
wire reg_write_w;
wire [31:0] result_w;
wire [4:0]write_reg_w;

ROM rom(
    .rom_addr(rom_addr),
    .rom_rd(rom_rd),
    .clk(clk),
    .rst(rst)
);


mux2_1_32 mux_choose_pc(
    .src1(PC_plus4_f),
    .src2(PC_branch_m),
    .select(is_jmp),
    .out(pc_in)
);

PC cpu_pc(
    .clk(clk),
    .pc_in(pc_in),
    .pc_out(rom_addr)
);

pc_plus4 pc_plus(
    .pc(rom_addr),
    .out(PC_plus4_f)    
);

is_stall cpu_is_stall(
    .opcode(op),
    .number_of_stall(number_of_stall)
);

F_D f_d(
    .clk(clk),
    .reset(rst),
    .number_of_stall(number_of_stall),
    .instr(rom_rd),
    .PC_plus4_f(PC_plus4_f),
    
    .op(op),
    .func(func),
    .addr1(addr1),
    .addr2(addr2),
    .rt_d(rt_d),
    .rd_d(rd_d),
    .imm(imm),
    .PC_plus4_d(PC_plus4_d),
    .PC_stall(PC_stall)
);

control cpu_control(
       .op(op),
       .func(func),
       .branch(branch_d),
       .reg_write(reg_write_d),
       .mem_to_reg(mem_to_reg_d),
       .mem_write(mem_write_d),
       .alu_control(alu_control_d),
       .alu_src(alu_src_d),
       .reg_dst(reg_dst_d)
);


regfile cpu_regfile(
    .clk(clk),
	.reset(reset),
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
    .imm_out(imm_out)
);

forwarding_unit cpu_forwarding_unit(
    .addr1(addr1),
    .addr2(addr2),
    .reg_write_e(reg_write_e),
    .reg_write_m(reg_write_m),
    .write_reg_e(write_reg_e),
    .write_reg_m(write_reg_m),
    .alu_out_m(alu_out_m),
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
    .out(write_reg_e)
);


mux2_1_32 mux_choose_alu_src(
    .src1(imm_e),
    .src2(rd2_e),
    .select(alu_src_e),
    .out(alu_src2)
);

ALU cpu_alu(
    .control(alu_control_e),
    .alu_num1(rd2_e),
    .alu_num2(alu_src2),
    
    .ans(alu_out_e),
    .zero_m(zero)
    );

pc_plus pc_plus_jmp(
    .pc(imm_e),
    .jmp(PC_plus4_e),
    .out(pc_jmp_out)
);

RAM ram(
    .ram_addr(alu_out_m),
    .ram_rd(ram_rd),
    .ram_wd(write_data_m),
    .ram_we(mem_write_m),
    .clk(clk),
    .rst(rst)
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
    .reset(rst),
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
    .PC_plus4_e(PC_plus4_e)//[31:0]
    );
    
E_M e_m(
     .clk(clk),
     .reset(rst),
     .branch_e(branch_e),//[2:0]
     .reg_write_e(reg_write_e),
     .mem_to_reg_e(mem_to_reg_e),
     .mem_write_e(mem_write_e),
     .zero_e(zero),//[1:0]
     .alu_out_e(alu_out_e),//[31:0]
     .write_reg_e(write_reg_e),//[4:0]
     .write_data_e(write_data_e),//[31:0]
     
     .PC_brach_e(PC_brach_e),//[31:0]
     
     .branch_m(branch_m),//[2:0]
     .reg_write_m(reg_write_m),
     .mem_to_reg_m(mem_to_reg_m),
     .mem_write_m(mem_write_m),
     .zero_m(zero_m),//[1:0]
     .alu_out_m(alu_out_m),//[31:0]
     .write_reg_m(write_reg_m),//[4:0]
     .write_data_m(write_data_m),//[31:0]
     .PC_brach_m(PC_brach_m)//[31:0]
    );
    
M_W m_w(
     .clk(clk),
     .reset(rst),
     .reg_write_m(reg_write_m),
     .result_m(result_m),//[31:0]
     .write_reg_m(write_reg_m),//[4:0]
     
     .reg_write_w(reg_write_w),
     .result_w(result_w),//[31:0]
     .write_reg_w(write_reg_w)//[4:0]
    );
endmodule
