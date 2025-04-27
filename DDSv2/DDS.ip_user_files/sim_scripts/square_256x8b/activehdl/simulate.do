onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+square_256x8b -L dist_mem_gen_v8_0_11 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.square_256x8b xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {square_256x8b.udo}

run -all

endsim

quit -force
