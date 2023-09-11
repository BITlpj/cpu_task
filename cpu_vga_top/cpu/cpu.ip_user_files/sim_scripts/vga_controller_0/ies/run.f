-makelib ies_lib/xpm -sv \
  "D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip_clk_wiz.v" \
  "../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip.v" \
  "../../../../cpu.srcs/sources_1/ip/vga_controller_0/src/vga.v" \
  "../../../../cpu.srcs/sources_1/ip/vga_controller_0/sim/vga_controller_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

