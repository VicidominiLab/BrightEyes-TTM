onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_dataprep_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_dataprep.udo}

run -all

quit -force
