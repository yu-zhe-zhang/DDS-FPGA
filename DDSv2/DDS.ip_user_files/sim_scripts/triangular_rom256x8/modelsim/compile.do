vlib work
vlib msim

vlib msim/dist_mem_gen_v8_0_11
vlib msim/xil_defaultlib

vmap dist_mem_gen_v8_0_11 msim/dist_mem_gen_v8_0_11
vmap xil_defaultlib msim/xil_defaultlib

vlog -work dist_mem_gen_v8_0_11 -64 -incr \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../../DDS.srcs/sources_1/ip/triangular_rom256x8/sim/triangular_rom256x8.v" \


vlog -work xil_defaultlib \
"glbl.v"

