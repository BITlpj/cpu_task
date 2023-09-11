set_property SRC_FILE_INFO {cfile:c:/Users/STOVAG/Desktop/cpu_vga_ip_test/cpu_vga_top/cpu/cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip.xdc rfile:../cpu.srcs/sources_1/ip/vga_controller_0/src/clk_wiz_ip/clk_wiz_ip.xdc id:1 order:EARLY scoped_inst:my_vga/inst/clk_wiz/inst} [current_design]
current_instance my_vga/inst/clk_wiz/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
