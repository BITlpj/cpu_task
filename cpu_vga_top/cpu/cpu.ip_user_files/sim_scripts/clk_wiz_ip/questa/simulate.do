onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_wiz_ip_opt

do {wave.do}

view wave
view structure
view signals

do {clk_wiz_ip.udo}

run -all

quit -force
