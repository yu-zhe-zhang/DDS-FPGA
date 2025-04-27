`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:yuzhe
//
// Create Date: 2023/12/01 10:52:32
// Design Name: BCD码翻译电路
// Module Name: trans_BCD
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 将BCD码翻译成适合于直接用在显示电路上的二进制码
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module trans_BCD(
    input [15:0] BCD_in,    //输入的16位BCD码

    output  reg[27:0] show_in  //数码管显示电路输入信号
  );

  //integer i;
  reg[3:0] thousand;       //千位
  reg[3:0] hundred;         //百位
  reg[3:0] tens;            //十位
  reg[3:0] units;           //个位

  //转换部分
  always @(*)
  begin
    thousand<=BCD_in[15:12];
    hundred<=BCD_in[11:8];
    tens<=BCD_in[7:4];
    units<=BCD_in[3:0];
    //个位
    case (units)
      0:
        show_in[6:0]<= 7'b1111110;//0
      1:
        show_in[6:0]<= 7'b0110000;//1
      2:
        show_in[6:0]<= 7'b1101101;//2
      3:
        show_in[6:0]<= 7'b1111001;//3
      4:
        show_in[6:0]<= 7'b0110011;//4
      5:
        show_in[6:0]<= 7'b1011011;//5
      6:
        show_in[6:0]<= 7'b1011111;//6
      7:
        show_in[6:0]<= 7'b1110000;//7
      8:
        show_in[6:0]<= 7'b1111111;//8
      9:
        show_in[6:0]<= 7'b1111011;//9
      default:
        show_in[6:0]<= 7'b1111110;//不显示
    endcase
    //十位
    case (tens)
      0:
        show_in[13:7]<= 7'b1111110;//0
      1:
        show_in[13:7]<= 7'b0110000;//1
      2:
        show_in[13:7]<= 7'b1101101;//2
      3:
        show_in[13:7]<= 7'b1111001;//3
      4:
        show_in[13:7]<= 7'b0110011;//4
      5:
        show_in[13:7]<= 7'b1011011;//5
      6:
        show_in[13:7]<= 7'b1011111;//6
      7:
        show_in[13:7]<= 7'b1110000;//7
      8:
        show_in[13:7]<= 7'b1111111;//8
      9:
        show_in[13:7]<= 7'b1111011;//9
      default:
        show_in[13:7]<= 7'b0000000;//不显示
    endcase
    //百位
    case (hundred)
      0:
        show_in[20:14]<= 7'b1111110;//0
      1:
        show_in[20:14]<= 7'b0110000;//1
      2:
        show_in[20:14]<= 7'b1101101;//2
      3:
        show_in[20:14]<= 7'b1111001;//3
      4:
        show_in[20:14]<= 7'b0110011;//4
      5:
        show_in[20:14]<= 7'b1011011;//5
      6:
        show_in[20:14]<= 7'b1011111;//6
      7:
        show_in[20:14]<= 7'b1110000;//7
      8:
        show_in[20:14]<= 7'b1111111;//8
      9:
        show_in[20:14]<= 7'b1111011;//9
      default:
        show_in[20:14]<= 7'b0000000;//不显示
    endcase
    //千位
    case (thousand)
      0:
        show_in[27:21]<= 7'b1111110;//0
      1:
        show_in[27:21]<= 7'b0110000;//1
      2:
        show_in[27:21]<= 7'b1101101;//2
      3:
        show_in[27:21]<= 7'b1111001;//3
      4:
        show_in[27:21]<= 7'b0110011;//4
      5:
        show_in[27:21]<= 7'b1011011;//5
      6:
        show_in[27:21]<= 7'b1011111;//6
      7:
        show_in[27:21]<= 7'b1110000;//7
      8:
        show_in[27:21]<= 7'b1111111;//8
      9:
        show_in[27:21]<= 7'b1111011;//9
      default:
        show_in[27:21]<= 7'b0000000;//不显示
    endcase
  end
endmodule
/*七段数码管 数字 与 二进制数对照
0   1111110
1   0110000
2   1101101
3   1111001
4   0110011
5   1011011
6   1011111
7   1110000
8   1111111
9   1111011
*/
