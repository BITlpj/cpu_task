vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic/vga_controller_0/src/clk_wiz_ip" "+incdir+../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip" \
"D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/vga_controller_0/src/clk_wiz_ip" "+incdir+../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip" \
"../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip_clk_wiz.v" \
"../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip.v" \
"../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/vga.v" \
"../../../../cpu.srcs/sources_1/ip/vga_controller_0/sim/vga_controller_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

