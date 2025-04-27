`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: yuzhe
//
// Create Date: 2023/12/03 18:54:05
// Design Name: 测频电路
// Module Name: measure_shiji_f
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 测量波形发生器产生的信号的实际频率
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module measure_shiji_f(
    input clk_05,           //输入的0.5Hz时钟信号
    input [7:0] sin,        //波形存储器输入的波形数据
    input   rst_n_shiji,    //使能信号

    output reg [12:0] shi_ji_zhi=0       //信号频率的实际值
  );

  reg wave_s=0;             //整形后的方波信号
  reg [12:0] freq_m=0;      //频率计数
  reg [12:0] lock=0;        //锁存信号

  //将输入信号整形为 方波
  always @(*)
  begin
    if(sin>8'd127)
      wave_s<=1;
    if(sin<=8'd127)
      wave_s<=0;
  end


  always @(posedge wave_s)
  begin
    if(rst_n_shiji)
    begin
      if(clk_05==1 && lock==0)
      begin
        freq_m<=freq_m+1;
      end
      else if(clk_05==1 && lock>0)
      begin
        shi_ji_zhi<=freq_m;
        freq_m<=1;
        lock<=0;
      end
      if(clk_05==0)
      begin
        lock<=lock+1;
        shi_ji_zhi<=freq_m;
      end
    end
    else
      shi_ji_zhi<=0;
  end

  //reg[12:0] cnt_max=0;     //波形计数
  //reg[12:0] lock=0;        //锁存信号，控制频率计数保持
  //always @(posedge sin[7])
  //begin
  //  if(rst_n_shiji)
  //  begin
  //    if (clk_05==1 && lock==0)
  //      cnt_max<=cnt_max+1;
  //    else if(clk_05==1 && lock>0)
  //    begin
  //      shi_ji_zhi<=cnt_max;
  //      cnt_max<=1;
  //      lock<=0;
  //    end
  //    if(clk_05==0)
  //    begin
  //      lock<=lock+1;
  //      shi_ji_zhi<=cnt_max;
  //    end
  //  end
  //end

endmodule
