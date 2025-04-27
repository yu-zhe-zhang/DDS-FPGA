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
    input[1:0] sel,         //选通信号，选择输出哪种波形

    output reg[7:0] sin         //输出读取的sin值
  );

  wire[7:0] sin_bo;          //sin信号
  //reg[7:0] sin_bo_1=0;

  wire[7:0] triangular_bo;   //三角波
  //reg[7:0] triangular_bo_1=0;

  wire[7:0] square_bo;      //方波

  wire[7:0] swatooth_bo;    //锯齿波

  //正弦波
  rom_256x8b u0 (
               .a(address),      // input wire [7 : 0] a
               .spo(sin_bo)  // output wire [7 : 0] spo
             );

  //三角波
  triangular_rom256x8 u1 (
                        .a(address),      // input wire [7 : 0] a
                        .spo(triangular_bo)  // output wire [7 : 0] spo
                      );

  //方波
  square_256x8b u2 (
                        .a(address),      // input wire [7 : 0] a
                        .spo(square_bo)  // output wire [7 : 0] spo
                      );

  //锯齿波
  sawtooth_256x8b u3(
                        .a(address),      // input wire [7 : 0] a
                        .spo(swatooth_bo)  // output wire [7 : 0] spo
                      );
  always @(*)
  begin
    case (sel)
      0:            //输出正弦波
      begin
        sin<=sin_bo;
      end
      1:            //输出三角波
      begin
        sin<=triangular_bo;
      end
      2:            //输出方波
      begin
        sin<=square_bo;
      end
      3:            //输出锯齿波
      begin
        sin<=swatooth_bo;
      end
      default:sin<=0;
    endcase
  end
endmodule
