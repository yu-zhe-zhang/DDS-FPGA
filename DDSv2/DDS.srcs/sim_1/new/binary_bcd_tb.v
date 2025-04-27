`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 09:47:30
// Design Name: 
// Module Name: binary_bcd_tb
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



module binary_bcd_tb;

// Parameters

//Ports
reg [12:0] bin_in;
wire [15:0] bcd_out;

binary_bcd  binary_bcd_inst (
  .bin_in(bin_in),
  .bcd_out(bcd_out)
);

initial begin
    bin_in<=0;
    while (1) begin
        #100
        bin_in<={$random};
    end
end

endmodule
