`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: yuzhe
//
// Create Date: 2023/12/03 20:01:32
// Design Name: 顶层文件
// Module Name: DDS_top
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 连线
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module DDS_top(
    input   sys_clk,        //板载时钟信号
    input[7:0]  key_in,     //8个拨码开关
    //input   rst_n,          //分频器使能信号
    input   rst_n_shiji,    //测频电路的使能信号



    //控制左边4个数码管的输出信号
    output [3:0] l_dis,    //选通数码管的信号(动态显示)
    output [6:0] l_seg,    //控制数码管亮哪些段的信号

    //控制右边4个数码管的输出信号
    output [3:0] r_dis,    //选通数码管的信号(动态显示)
    output [6:0] r_seg,    //控制数码管亮哪些段的信号

    //波形存储器输出，连接到AD转换器
    output [7:0] sin,
    output [4:0] rst_n_AD   //AD转换器的一些使能信号
  );

  ///////////////////////////////////////////////////////////////////////
  wire clk_10k;               //10kHz时钟信号
  wire clk_05;                //0.5Hz时钟信号
  wire[7:0] address;          //波形存储器需要的地址信号

  wire[12:0] bin_in_lilun;    //理论频率计算模块 与 进制转换器 之间的连线
  wire[15:0] bcd_in_lilun;    //理论频率计算中 进制转换器 与 BCD翻译 之间的连线
  wire[27:0] f_lilun_value;   //BCD码翻译电路 与 显示模块 之间的连线

  wire[12:0] bin_in_shiji;    //测频模块 与 进制转换器 之间的连线
  wire[15:0] bcd_in_shiji;    //测频模块中 进制转换器 与 BCD翻译 之间的连线
  wire[27:0] f_shiji_value;   //BCD码翻译电路 与 显示模块 之间的连线
  ///////////////////////////////////////////////////////////////////////////
  //实例化分频器模块
  f_div fen_pin_qi            //分频器
        (
          .sys_clk(sys_clk),      //系统时钟信号
          //.rst_n(rst_n),          //使能信号

          .clk_10k(clk_10k),      //10kHz时钟信号
          .clk_05(clk_05)         //0.5Hz时钟信号
        );

  //实例化累加器模块
  forever_adder leijiaqi      //累加器
                (
                  .clk_10k(clk_10k),      //累加器输入10KHz时钟信号
                  .key_in(key_in),        //外部8个拨码开关输入

                  .address(address)       //累加器输出的ROM地址
                );

  //实例化ROM波形存储器
  ip_rom rom
         (
           .address(address),      //读取存储器地址

           .sin(sin)               //波形输出值
         );
  //////////////////////////////////////////////////////////////
  //实例化理论频率计算模块
  lilun_f lilun_f_inst
          (
            .clk_10k(clk_10k),          //输入10k时钟信号
            .key_in(key_in),            //输入8个拨码开关信号

            .li_lun_zhi(bin_in_lilun)   //输出计算的频率理论值
          );

  //实例化进制转换器模块,将13位无符号二进制数转换为对应十进制数的8421BCD码
  binary_bcd binary_bcd_inst_lilun    //频率理论值的转换
             (
               .bin_in(bin_in_lilun),      //输入的13位二进制数

               .bcd_out(bcd_in_lilun)      //输出的16位二进制数对应十进制数的BCD码
             );

  //实例化BCD码翻译电路，将BCD码翻译成适合于直接用在显示电路上的二进制码
  trans_BCD trans_BCD_inst_lilun      //理论频率BCD转换为数码管二进制
            (
              .BCD_in(bcd_in_lilun),      //输入的16位BCD码

              .show_in(f_lilun_value)     //将BCD输入到显示模块中
            );
  ///////////////////////////////////////////////////////////////////////
  //实例化测频电路(测量实际频率的电路)
  measure_shiji_f measure_shiji_f_inst
                  (
                    .clk_05(clk_05),            //输入的0.5Hz时钟信号
                    .sin(sin),                  //输入 波形存储器输出 的信号
                    .rst_n_shiji(rst_n_shiji),  //测频电路的使能信号

                    .shi_ji_zhi(bin_in_shiji)   //输出测量的频率值
                  );

  //实例化进制转换器模块,将13位无符号二进制数转换为对应十进制数的8421BCD码
  binary_bcd binary_bcd_inst_shiji    //频率理论值的转换
             (
               .bin_in(bin_in_shiji),      //输入的13位二进制数

               .bcd_out(bcd_in_shiji)      //输出的16位二进制数对应十进制数的BCD码
             );

  //实例化BCD码翻译电路，将BCD码翻译成适合于直接用在显示电路上的二进制码
  trans_BCD trans_BCD_inst_shiji      //理论频率BCD转换为数码管二进制
            (
              .BCD_in(bcd_in_shiji),      //输入的16位BCD码

              .show_in(f_shiji_value)     //将BCD输入到显示模块中
            );
  ///////////////////////////////////////////////////////////////////////
  //显示模块，左边显示理论值，右边显示实际值
  show show_inst
       (
         .f_lilun_value(f_lilun_value),  //频率理论值
         .f_shiji_value(f_shiji_value),  //频率实际值
         .clk_10k(clk_10k),              //输入10k时钟信号

         .l_dis(l_dis),                  //输出左边数码管位码
         .l_seg(l_seg),                  //输出左边数码管对应值
         .r_dis(r_dis),                  //输出右边数码管位码
         .r_seg(r_seg)                  //输出右边数码管对应值
       );
  ////////////////////////////////////////////////////////////////////////
  assign rst_n_AD=5'b00001;
endmodule
