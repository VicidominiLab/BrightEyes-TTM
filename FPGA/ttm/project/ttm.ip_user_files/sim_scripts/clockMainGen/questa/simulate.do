onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clockMainGen_opt

do {wave.do}

view wave
view structure
view signals

do {clockMainGen.udo}

run -all

quit -force
