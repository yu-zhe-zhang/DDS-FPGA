`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:yuzhe
//
// Create Date: 2023/12/01 09:29:06
// Design Name: 进制转换器
// Module Name: binary_bcd
// Project Name: 直接数字频率合成器
// Target Devices:
// Tool Versions:
// Description: 将13位无符号二进制数转换为对应十进制数的8421BCD码
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module binary_bcd(
    input [12:0] bin_in,    //输入的二进制数

    output [15:0] bcd_out  //输出的8421BCD码
  );

reg [3:0] ones;             //个位
reg [3:0] tens;             //十位
reg [3:0] hundreds;         //百位
reg [3:0] thousands;        //千位
integer i;
 
always @(bin_in) begin
	ones 		= 4'd0;
	tens 		= 4'd0;
	hundreds 	= 4'd0;
  thousands = 4'd0;
	
	for(i = 12; i >= 0; i = i - 1) begin
		if (ones >= 4'd5) 		ones = ones + 4'd3;
		if (tens >= 4'd5) 		tens = tens + 4'd3;
		if (hundreds >= 4'd5)	hundreds = hundreds + 4'd3;
    if(thousands >= 4'd5) thousands = thousands + 4'd3;
    thousands = {thousands[1:0],hundreds[3]};
		hundreds = {hundreds[2:0],tens[3]};
		tens	 = {tens[2:0],ones[3]};
		ones	 = {ones[2:0],bin_in[i]};
	end
end	
assign bcd_out = {thousands, hundreds, tens, ones};
  
endmodule
