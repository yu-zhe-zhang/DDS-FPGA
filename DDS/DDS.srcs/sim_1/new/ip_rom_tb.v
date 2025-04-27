`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 13:28:36
// Design Name: 
// Module Name: ip_rom_tb
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



module ip_rom_tb;

// Parameters

//Ports
reg [7:0] address;
wire [7:0] sin;
reg clk;

ip_rom  ip_rom_inst (
  .address(address),
  .sin(sin)
);

initial begin
    address<=0;
    clk=0;
    //#10
    //address<=8'b1;
    //#10
    //address<=8'b00000011;
end
always #5  clk = ! clk ;
always @(posedge clk) begin
    if(address==8'd255)
        address<=0;
    else
        address<=address+1'b1;
end
endmodule