`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 19:28:56
// Design Name: 
// Module Name: measure_shiji_f_tb
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



module measure_shiji_f_tb;

// Parameters

//Ports
reg  clk_05;
reg [7:0] sin;
reg  rst_n_shiji;
wire [12:0] shi_ji_zhi;

measure_shiji_f  measure_shiji_f_inst (
  .clk_05(clk_05),
  .sin(sin),
  .rst_n_shiji(rst_n_shiji),
  .shi_ji_zhi(shi_ji_zhi)
);


initial begin
    clk_05=0;
    sin<=8'b0;
    rst_n_shiji=1;
end
always  begin
  #100 clk_05=~clk_05;
end
always  begin
  #10 sin<=8'd1;
  #10 sin<=8'd128;
  #100
  #20 sin<=8'd1;
  #20 sin<=8'd128;
end
endmodule