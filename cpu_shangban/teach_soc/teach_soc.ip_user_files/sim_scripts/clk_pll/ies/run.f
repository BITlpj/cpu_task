-makelib ies_lib/xpm -sv \
  "D:/verilog/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/verilog/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/verilog/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../teach_soc.srcs/sources_1/ip/clk_pll/clk_pll_clk_wiz.v" \
  "../../../../teach_soc.srcs/sources_1/ip/clk_pll/clk_pll.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

