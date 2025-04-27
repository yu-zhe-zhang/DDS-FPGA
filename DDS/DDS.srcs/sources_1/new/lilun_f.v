`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:yuzhe
//
// Create Date: 2023/11/30 11:27:10
// Design Name: 理论频率计算电路
// Module Name: lilun_f
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 根据拨码开关的输入，计算出理论频率值
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module lilun_f(
    input clk_10k,          //分频器输入的10kHz频率
    input [7:0] key_in,     //频率控制字

    output reg [12:0] li_lun_zhi=0     //信号频率理论值 0~5000hz
  );

  always @(posedge clk_10k)
  begin
    //li_lun_zhi<=(10000*key_in)/2^8;       //计算理论频率值  右移8位相当于除以2^8
    if (key_in==8'b0)                       //还没拨码，显示0
    begin
      li_lun_zhi<=0;
    end
    //else if(key_in>8'b10000000)             //拨码大于128,显示0
    //  li_lun_zhi<=0;
    else
      li_lun_zhi<=(10000*key_in)>>8;       //计算理论频率值  右移8位相当于除以2^8
  end
endmodule
