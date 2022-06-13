onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+clockMainGen -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.clockMainGen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {clockMainGen.udo}

run -all

endsim

quit -force
