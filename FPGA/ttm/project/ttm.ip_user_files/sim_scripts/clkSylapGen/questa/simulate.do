onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clkSylapGen_opt

do {wave.do}

view wave
view structure
view signals

do {clkSylapGen.udo}

run -all

quit -force
