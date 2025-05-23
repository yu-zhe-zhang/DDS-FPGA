onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib square_256x8b_opt

do {wave.do}

view wave
view structure
view signals

do {square_256x8b.udo}

run -all

quit -force
