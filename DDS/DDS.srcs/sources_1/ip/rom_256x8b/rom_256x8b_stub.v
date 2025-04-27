// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Mon Dec  4 13:35:13 2023
// Host        : zhangyuzhe running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top rom_256x8b -prefix
//               rom_256x8b_ dist_mem_gen_0_stub.v
// Design      : dist_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_11,Vivado 2017.2" *)
module rom_256x8b(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],spo[7:0]" */;
  input [7:0]a;
  output [7:0]spo;
endmodule
