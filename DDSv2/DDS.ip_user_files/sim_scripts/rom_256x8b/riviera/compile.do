vlib work
vlib riviera

vlib riviera/dist_mem_gen_v8_0_11
vlib riviera/xil_defaultlib

vmap dist_mem_gen_v8_0_11 riviera/dist_mem_gen_v8_0_11
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work dist_mem_gen_v8_0_11  -v2k5 \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../DDS.srcs/sources_1/ip/rom_256x8b/sim/rom_256x8b.v" \


vlog -work xil_defaultlib \
"glbl.v"

