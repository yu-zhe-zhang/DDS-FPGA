`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/04 12:11:04
// Design Name: 
// Module Name: f_div_tb
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



module f_div_tb;

// Parameters

//Ports
reg  sys_clk;
wire  clk_10k;
wire  clk_05;

f_div  f_div_inst (
  .sys_clk(sys_clk),
  .clk_10k(clk_10k),
  .clk_05(clk_05)
);

initial begin
    sys_clk=0;
end

always #5  sys_clk = ! sys_clk ;

endmodule