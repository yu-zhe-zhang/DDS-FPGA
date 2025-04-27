`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 南京理工大学
// Engineer:yuzhe
//
// Create Date: 2023/11/29 09:49:57
// Design Name: 分频器
// Module Name: f_div
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 输入：系统时钟100MHz
//              输出：10KHz(用于累加器时钟信号、动态显示扫描信号) 0.5Hz(测量基准信号)
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module f_div(
    input sys_clk,      //系统输入时钟信号
    //input rst_n,        //使能信号，高有效

    output reg clk_10k=0,     //输出10KHz
    output reg clk_05=0      //输出0.5Hz

  );

  reg[13:0] cnt_10k=0;//分频计数
  reg[27:0] cnt_05=0;//分频计数
  parameter div_10k=4999;    //分频数 从100MHz分出10KHz的
  parameter div_05=99999999;    //分频数 从100MHz分出0.5Hz的


  always @(posedge sys_clk)
  begin
    //分频器 分出10KHz
    cnt_10k=cnt_10k+1;
    if(cnt_10k==div_10k)
    begin
      clk_10k<=~clk_10k;
      cnt_10k<=0;
    end


    //分频器 分出0.5Hz
    cnt_05=cnt_05+1;
    if(cnt_05==div_05)
    begin
      clk_05<=~clk_05;
      cnt_05<=0;
    end
  end
endmodule
