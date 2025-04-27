`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/04 13:52:32
// Design Name: 
// Module Name: trans_BCD_tb
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



module trans_BCD_tb;

// Parameters

//Ports
reg [15:0] BCD_in;
wire [27:0] show_in;

trans_BCD  trans_BCD_inst (
  .BCD_in(BCD_in),
  .show_in(show_in)
);

initial begin
    BCD_in<=16'b1000_1000_1000_1000;
    #100
    BCD_in<=16'b0001_0010_0011_0100;
end
//always #5  clk = ! clk ;

endmodule