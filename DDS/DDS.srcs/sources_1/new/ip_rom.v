`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:yuzhe
//
// Create Date: 2023/12/03 13:22:54
// Design Name: ROM波形存储器
// Module Name: ip_rom
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 由累加器的和得到正弦波形 输出值
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ip_rom(
    input[7:0] address,     //输入累加器和

    output [7:0] sin         //输出读取的sin值
  );

  //正弦波
  rom_256x8b ip_rom (
               .a(address),      // input wire [7 : 0] a
               .spo(sin)  // output wire [7 : 0] spo
             );
endmodule