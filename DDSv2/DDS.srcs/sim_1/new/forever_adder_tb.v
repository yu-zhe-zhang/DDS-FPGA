`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 14:43:06
// Design Name: 
// Module Name: forever_adder_tb
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



module forever_adder_tb;

// Parameters

//Ports
reg  clk_10k;
reg [7:0] key_in;
wire [7:0] address;

forever_adder  forever_adder_inst (
  .clk_10k(clk_10k),
  .key_in(key_in),
  .address(address)
);

initial begin
    clk_10k=0;
    key_in<=8'b0;
    #10
    key_in<=8'b00000001;
    #10
    key_in<=8'b00000000;
    #10
    key_in<=8'b00000001;
    #10
    key_in<=8'b00000000;
    #10
    key_in<=8'b00000001;
    #10
    key_in<=8'b00000000;
end
always #5  clk_10k = ! clk_10k ;

endmodule