`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:yuzhe
//
// Create Date: 2023/12/01 10:04:20
// Design Name: 动态显示电路
// Module Name: show
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 利用binary_bcd模块输出的8421BCD码，实现显示数字的控制
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module show(
    input [27:0] f_lilun_value,       //信号频率理论值  从trans_BCD模块输入     
    input [27:0] f_shiji_value,       //信号频率实际值  从trans_BCD模块输入
    input clk_10k,                    //从分频器输入的10KHz信号
    
    //数码管输出
    //控制左边4个数码管的输出信号
    output reg[3:0] l_dis=0,    //选通数码管的信号(动态显示)
    output reg[6:0] l_seg=0,    //控制数码管亮哪些段的信号

    //控制右边4个数码管的输出信号
    output reg[3:0] r_dis=0,    //选通数码管的信号(动态显示)
    output reg[6:0] r_seg=0     //控制数码管亮哪些段的信号

    //
  );

  reg[1:0] sel=0; //数码管选通信号

  always @(posedge clk_10k)
  begin
    sel=sel+1;
    //左边数码管的显示频率的 理论值
    case (sel)
      0:
      begin
        l_dis<=4'b1000;
        l_seg<=f_lilun_value[27:21];
      end
      1:
      begin
        l_dis<=4'b0100;
        l_seg<=f_lilun_value[20:14];
      end
      2:
      begin
        l_dis<=4'b0010;
        l_seg<=f_lilun_value[13:7];
      end
      3:
      begin
        l_dis<=4'b0001;
        l_seg<=f_lilun_value[6:0];
      end
      default:
      begin
        l_dis<=4'b1000;
        l_seg<=7'b0000000;
      end
    endcase

    //右边数码管显示频率的 实际值
    case (sel)
      0:
      begin
        r_dis<=4'b1000;
        r_seg<=f_shiji_value[27:21];
      end
      1:
      begin
        r_dis<=4'b0100;
        r_seg<=f_shiji_value[20:14];
      end
      2:
      begin
        r_dis<=4'b0010;
        r_seg<=f_shiji_value[13:7];
      end
      3:
      begin
        r_dis<=4'b0001;
        r_seg<=f_shiji_value[6:0];
      end
      default:
      begin
        r_dis<=4'b1000;
        r_seg<=7'b0000000;
      end
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