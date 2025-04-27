`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:yuzhe 
// 
// Create Date: 2023/12/03 21:41:46
// Design Name: 
// Module Name: DDS_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module DDS_top_tb;

// Parameters

//Ports
reg  sys_clk;
reg [7:0] key_in;
//reg  rst_n;
reg  rst_n_shiji;
wire [3:0] l_dis;
wire [6:0] l_seg;
wire [3:0] r_dis;
wire [6:0] r_seg;
wire [7:0] sin;

DDS_top  DDS_top_inst (
  .sys_clk(sys_clk),
  .key_in(key_in),
  //.rst_n(rst_n),
  .rst_n_shiji(rst_n_shiji),
  .l_dis(l_dis),
  .l_seg(l_seg),
  .r_dis(r_dis),
  .r_seg(r_seg),
  .sin(sin)
);


initial begin
    sys_clk=0;
    key_in<=8'b0000_0000;
    //rst_n<=0;
    rst_n_shiji<=1;

    #10
    key_in<=8'b0111_0011;
    //#10
    //rst_n<=1;
    //rst_n_shiji<=1;
    //key_in<=8'b0011_1111;
end
always #5  sys_clk = ! sys_clk ;

endmodule