`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 11:45:25
// Design Name: 
// Module Name: lilun_f_tb
// Project Name: 
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



module lilun_f_tb;

// Parameters

//Ports
reg  clk_10k;
reg [7:0] key_in;
wire  [12:0] li_lun_zhi;

lilun_f  lilun_f_inst (
  .clk_10k(clk_10k),
  .key_in(key_in),
  .li_lun_zhi(li_lun_zhi)
);
initial begin
    clk_10k=0;
    key_in<=8'b0;
    #10 
    key_in <= 8'b1;
    #10 
    key_in <= 8'b00000010;
    #10 
    key_in <= 8'b01111111;
    #10 
    key_in <= 8'b11111111;
    #10 
    key_in <= 8'b10000000;
end
always #5  clk_10k = ! clk_10k ;
//always #10 key_in <= {$random};

endmodule
