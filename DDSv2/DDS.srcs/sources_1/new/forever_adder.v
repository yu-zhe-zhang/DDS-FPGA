`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:yuzhe 
// 
// Create Date: 2023/11/30 10:42:49
// Design Name: 累加器
// Module Name: forever_adder
// Project Name: 直接数字频率合成器
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


module forever_adder(
    input clk_10k,  //分频电路输入的10KHz频率
    input [7:0] key_in,     //8个拨码开关的输入 频率控制字

    output reg [7:0] address=0    //8位累加和,即所需要寻找的寄存器的地址
  );


  always @(posedge clk_10k)
  begin
    address<=address+key_in;//累加输入信号Key
  end

endmodule