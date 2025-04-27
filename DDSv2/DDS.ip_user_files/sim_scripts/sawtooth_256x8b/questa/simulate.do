onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib sawtooth_256x8b_opt

do {wave.do}

view wave
view structure
view signals

do {sawtooth_256x8b.udo}

run -all

quit -force
