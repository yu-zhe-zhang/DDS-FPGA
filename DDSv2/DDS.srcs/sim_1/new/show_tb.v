
module show_tb;

  // Parameters

  //Ports
  reg [27:0] f_lilun_value;
  reg [27:0] f_shiji_value;
  reg  clk_10k;
  wire [3:0] l_dis;
  wire [6:0] l_seg;
  wire [3:0] r_dis;
  wire [6:0] r_seg;

  initial
  begin
    clk_10k=0;
    f_lilun_value<=0;
    f_shiji_value<=0;
    #50
    f_lilun_value<=28'b0110000_1101101_1111001_0110011;
    f_shiji_value<=28'b0110000_1101101_1111001_0110011;
    #50
    f_lilun_value<=28'b1011011_1011111_1110000_1111111;
    f_shiji_value<=28'b1011011_1011111_1110000_1111111;
  end

  always #5  clk_10k = ! clk_10k ;


  show  show_inst (
          .f_lilun_value(f_lilun_value),
          .f_shiji_value(f_shiji_value),
          .clk_10k(clk_10k),
          .l_dis(l_dis),
          .l_seg(l_seg),
          .r_dis(r_dis),
          .r_seg(r_seg)
        );



endmodule
