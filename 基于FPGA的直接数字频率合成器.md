# 前言
**本实验利用FPGAA芯片设计一款直接数字频率合成器（DDS）**
**发开板**：EGO1(xc7a35tcst324-1)
**开发软件**：Vivado,Vscode
**实现功能**：
1、设计测频电路，将测量的波形频率值显示在实验板卡的右面4位数码管；
2、基于DDS原理，计算波形频率的；理论值，将理论计算值显示在实验板卡上的左面4位数码管上；
3、输出三角波、锯齿波、方波等多种波形。
# 前期准备
利用"mif精灵"生成容量为$2^{8}\times8$的.coe文件
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/799a07f493cc89f9560589c49be86f28.png#pic_center)
整体设计框架如下
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/10e5b177af7ba616b65b09700dba06ca.png#pic_center)
# 开始设计电路
## 分频器模块
分频电路模块利用系统时钟的100MHz信号，分出10KHz和0.5Hz两种时钟信号，以便用于后续模块中。其中sys_clk为输入的系统时钟信号，大小为100MHz，clk_10k为分频器输出的10kHz的时钟信号，clk_05为分频器输出的0.5Hz的时钟信号。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/88c98c154cdef4de8928c26a5e3be9be.png)
**源代码如下**
```
`timescale 1ns / 1ps  
module f_div(  
    input sys_clk,      //系统输入时钟信号  
  
    output reg clk_10k=0,     //输出10KHz  
    output reg clk_05=0      //输出0.5Hz  
  
  );  
  reg[13:0] cnt_10k=0;//分频计数  
  reg[27:0] cnt_05=0;//分频计数  
  parameter div_10k=4999;    //分频数 从100MHz分出10KHz的  
  parameter div_05=99999999;    //分频数 从100MHz分出0.5Hz的  
  always @(posedge sys_clk)  
  begin  
    //分频器 分出10KHz  
    cnt_10k=cnt_10k+1;  
    if(cnt_10k==div_10k)  
    begin  
      clk_10k<=~clk_10k;  
      cnt_10k<=0;  
    end  
    //分频器 分出0.5Hz  
    cnt_05=cnt_05+1;  
    if(cnt_05==div_05)  
    begin  
      clk_05<=~clk_05;  
      cnt_05<=0;  
    end  
  end  
endmodule  
```
**激励脚本如下**
```
`timescale 1ns / 1ps  
module f_div_tb;  
reg  sys_clk;  
wire  clk_10k;  
wire  clk_05;  
f_div  f_div_inst (  
  .sys_clk(sys_clk),  
  .clk_10k(clk_10k),  
  .clk_05(clk_05)  
);  
initial begin  
    sys_clk=0;  
end  
always #5  sys_clk = ! sys_clk ;  
endmodule  
```
**仿真结果如下**

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/8bba3d64703137b6edd6cc5f061fc43b.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ff353b3c46fd2efbb58a76cc3cdec2ba.png)
## 累加器模块

累加器模块利用分频器模块产生的10kHz时钟信号与8个拨码开关输入的频率控制字作为累加步长，输出8位的累加和。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/00c2ede936cd343191d4ed7e4a00d0f4.png)
以输入端口clk_10k输入的10KHz时钟信号作为触发，将地址与拨码开关的输入key_in相加，由此得到新的地址信号，不断地累加，从而使地址信号不断变大，当地址信号产生溢出时，又重复进行累加操作，从而实现地址信号以一定步长进行循环递增。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module forever_adder(  
3.	    input clk_10k,  //分频电路输入的10KHz频率  
4.	    input [7:0] key_in,     //8个拨码开关的输入 频率控制字  
5.	  
6.	    output reg [7:0] address=0    //8位累加和,即所需要寻找的寄存器的地址  
7.	  );  
8.	  always @(posedge clk_10k)  
9.	  begin  
10.	    address<=address+key_in;//累加输入信号Key  
11.	  end  
12.	endmodule  
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module forever_adder_tb;  
3.	reg  clk_10k;  
4.	reg [7:0] key_in;  
5.	wire [7:0] address;  
6.	forever_adder  forever_adder_inst (  
7.	  .clk_10k(clk_10k),  
8.	  .key_in(key_in),  
9.	  .address(address)  
10.	);  
11.	initial begin  
12.	    clk_10k=0;  
13.	    key_in<=8'b0;  
14.	    #10  
15.	    key_in<=8'b00000001;  
16.	    #10  
17.	    key_in<=8'b00000000;  
18.	    #10  
19.	    key_in<=8'b00000001;  
20.	    #10  
21.	    key_in<=8'b00000000;  
22.	    #10  
23.	    key_in<=8'b00000001;  
24.	    #10  
25.	    key_in<=8'b00000000;  
26.	end  
27.	always #5  clk_10k = ! clk_10k ;  
28.	endmodule 
```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f443a5812d477213de5b2256f7b392da.png)
## ROM波形存储器模块
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f167e1cb602dd155df63ffaa2944b2f5.png)
在设计ROM波形存储器之前，首先要利用程序生成一个容量为2^8\times8的.coe正弦波、三角波、方波、锯齿波文件，然后生成存储器IP核，将.coe文件导入进去。最后在程序中调用IP核，读取波形数据，最后生成波形。
先生成4种波形存储器的IP核，然后在源文件中调用这些IP核，将该模块的输入信号address送入各IP核的地址信号中。不同模块在模块内引入不同的输出信号sin_bo、triangular_bo、square_bo、swatooth_bo，最后利用case语句，根据波形选通信号sel，选择不同波形的数据传送给模块的输出端口sin，从而实现不同波形的输出。当sel=2’b00时，输出正弦波，当sel=2’b01时，输出三角波，当sel=2’b10时，输出方波，当sel=2’b11时，输出锯齿波。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module ip_rom(  
3.	    input[7:0] address,     //输入累加器和  
4.	    input[1:0] sel,         //选通信号，选择输出哪种波形  
5.	  
6.	    output reg[7:0] sin         //输出读取的sin值  
7.	  );  
8.	  
9.	  wire[7:0] sin_bo;          //sin信号  
10.	  wire[7:0] triangular_bo;   //三角波  
11.	  wire[7:0] square_bo;      //方波  
12.	  wire[7:0] swatooth_bo;    //锯齿波  
13.	  //正弦波  
14.	  rom_256x8b u0 (  
15.	               .a(address),      // input wire [7 : 0] a  
16.	               .spo(sin_bo)  // output wire [7 : 0] spo  
17.	             );  
18.	  //三角波  
19.	  triangular_rom256x8 u1 (  
20.	                        .a(address),      // input wire [7 : 0] a  
21.	                        .spo(triangular_bo)  // output wire [7 : 0] spo  
22.	                      );  
23.	  //方波  
24.	  square_256x8b u2 (  
25.	                        .a(address),      // input wire [7 : 0] a  
26.	                        .spo(square_bo)  // output wire [7 : 0] spo  
27.	                      );  
28.	  //锯齿波  
29.	  sawtooth_256x8b u3(  
30.	                        .a(address),      // input wire [7 : 0] a  
31.	                        .spo(swatooth_bo)  // output wire [7 : 0] spo  
32.	                      );  
33.	  always @(*)  
34.	  begin  
35.	    case (sel)  
36.	      0:            //输出正弦波  
37.	      begin  
38.	        sin<=sin_bo;  
39.	      end  
40.	      1:            //输出三角波  
41.	      begin  
42.	        sin<=triangular_bo;  
43.	      end  
44.	      2:            //输出方波  
45.	      begin  
46.	        sin<=square_bo;  
47.	      end  
48.	      3:            //输出锯齿波  
49.	      begin  
50.	        sin<=swatooth_bo;  
51.	      end  
52.	      default:sin<=0;  
53.	    endcase  
54.	  end  
55.	endmodule 
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module ip_rom_tb;  
3.	reg [7:0] address;  
4.	reg [1:0] sel;  
5.	wire [7:0] sin;  
6.	reg clk;  
7.	ip_rom  ip_rom_inst (  
8.	  .address(address),  
9.	  .sel(sel),  
10.	  .sin(sin)  
11.	);  
12.	initial begin  
13.	    address<=0;  
14.	    clk=0;  
15.	    sel<=2'b11;  
16.	end  
17.	always #5  clk = ! clk ;  
18.	always @(posedge clk) begin  
19.	    if(address==8'd255)  
20.	        address<=0;  
21.	    else  
22.	        address<=address+1'b1;  
23.	end  
24.	endmodule 
```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/c3b3c46c373e3f1d44dc7a6a4cc77b24.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/b2a4e38306d0b49269a8df5bee3b1974.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9fbf87fe1ffe77eeecff645225b3eff4.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/1dc6d3707fa928bceb00b6580537a8d1.png)
**注意**：
1、在生成方波时，可能仿真出的波形是三角波的形状
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/8c02159cfc638cacc7b5866687048995.png)

这时右键点击sin[7:0]，选择“Waveform Style”下面的“Analog Settigns”
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9d805ae376c46b6fc86d7854ae1846dd.png)

在“Interpolation style”选项中选择“Hold”，这样就可以变成方波了。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a626291dde69d4857478c2cfa6cd33e5.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f6d431d0f728cfe0fef6d284be58b39d.png)
## 理论频率计算模块
理论频率计算模块，是根据8位频率控制字的输入k，从而计算产生波形的理论值。该模块基于公式$\frac{kf_c}{2^n}$进行频率理论值的计算。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/81716812aa69cecf888c7f98b48f75ba.png)
**源代码如下**
```
1.	`timescale 1ns / 1ps  
2.	module lilun_f(  
3.	    input clk_10k,          //分频器输入的10kHz频率  
4.	    input [7:0] key_in,     //频率控制字  
5.	  
6.	    output reg [12:0] li_lun_zhi=0     //信号频率理论值 0~5000hz  
7.	  );  
8.	  always @(posedge clk_10k)  
9.	  begin  
10.	    if (key_in==8'b0)                       //还没拨码，显示0  
11.	    begin  
12.	      li_lun_zhi<=0;  
13.	    end  
14.	    else  
15.	      li_lun_zhi<=(10000*key_in)>>8;       //计算理论频率值  右移8位相当于除以2^8  
16.	  end  
17.	endmodule
```
在Verilog中，一个数除以2的n次方，与右移8位的计算结果相同，但是移位操作占用资源较少，所以优先选择使用移位操作对数据进行计算。
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module lilun_f_tb;  
3.	reg  clk_10k;  
4.	reg [7:0] key_in;  
5.	wire  [12:0] li_lun_zhi;  
6.	lilun_f  lilun_f_inst (  
7.	  .clk_10k(clk_10k),  
8.	  .key_in(key_in),  
9.	  .li_lun_zhi(li_lun_zhi)  
10.	);  
11.	initial begin  
12.	    clk_10k=0;  
13.	    key_in<=8'b0;  
14.	    #10   
15.	    key_in <= 8'b1;  
16.	    #10   
17.	    key_in <= 8'b00000010;  
18.	    #10   
19.	    key_in <= 8'b01111111;  
20.	    #10   
21.	    key_in <= 8'b11111111;  
22.	    #10   
23.	    key_in <= 8'b10000000;  
24.	end  
25.	always #5  clk_10k = ! clk_10k ;  
26.	endmodule 
```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/e9d03041fe73306db3cadd426ad414b3.png)
## 测频电路模块
测频电路在使能信号有效时，利用0.5Hz的信号，在1s的高电平时间内，对ROM波形存储器产生的波形进行计数，从而得到ROM波形存储器产生信号的实际频率。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/35b9d4abe9072ac8de91c8364a91e11e.png)
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module measure_shiji_f(  
3.	    input clk_05,           //输入的0.5Hz时钟信号  
4.	    input [7:0] sin,        //波形存储器输入的波形数据  
5.	    input   rst_n_shiji,    //使能信号  
6.	  
7.	    output reg [12:0] shi_ji_zhi=0       //信号频率的实际值  
8.	  );  
9.	  reg wave_s=0;             //整形后的方波信号  
10.	  reg [12:0] freq_m=0;      //频率计数  
11.	  reg [12:0] lock=0;        //锁存信号  
12.	  //将输入信号整形为 方波  
13.	  always @(*)  
14.	  begin  
15.	    if(sin>8'd127)  
16.	      wave_s<=1;  
17.	    if(sin<8'd127)  
18.	      wave_s<=0;  
19.	  end  
20.	  always @(posedge wave_s)  
21.	  begin  
22.	    if(rst_n_shiji)  
23.	    begin  
24.	      if(clk_05==1 && lock==0)  
25.	      begin  
26.	        freq_m<=freq_m+1;  
27.	      end  
28.	      else if(clk_05==1 && lock>0)  
29.	      begin  
30.	        shi_ji_zhi<=freq_m;  
31.	        freq_m<=1;  
32.	        lock<=0;  
33.	      end  
34.	      if(clk_05==0)  
35.	      begin  
36.	        lock<=lock+1;  
37.	        shi_ji_zhi<=freq_m;  
38.	      end  
39.	    end  
40.	    else  
41.	      shi_ji_zhi<=0;  
42.	  end  
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module measure_shiji_f_tb;  
3.	reg  clk_05;  
4.	reg [7:0] sin;  
5.	reg  rst_n_shiji;  
6.	wire [12:0] shi_ji_zhi;  
7.	measure_shiji_f  measure_shiji_f_inst (  
8.	  .clk_05(clk_05),  
9.	  .sin(sin),  
10.	  .rst_n_shiji(rst_n_shiji),  
11.	  .shi_ji_zhi(shi_ji_zhi)  
12.	);  
13.	initial begin  
14.	    clk_05=0;  
15.	    sin<=8'b0;  
16.	    rst_n_shiji=1;  
17.	end  
18.	always  begin  
19.	  #100 clk_05=~clk_05;  
20.	end  
21.	always  begin  
22.	  #10 sin<=8'd1;  
23.	  #10 sin<=8'd128;  
24.	  #100  
25.	  #20 sin<=8'd1;  
26.	  #20 sin<=8'd128;  
27.	end  
28.	endmodule 
```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/79e34283ae9f672a9ad6541786d9d704.png)
## 显示模块
显示模块利用分频器产生的10kHz的信号作时钟信号，测频电路测量出的信号频率实际值与理论频率计算电路输出的信号频率的理论值作为输入，输出七段显示译码器的位码与段码。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/134151b60649b2aeb9af2c0d5c89f912.png)
### 进制转换器
进制转换器的作用是将频率计算模块或者测频模块输出13位无符号二进制数，转换为对应十进制数的8421BCD码。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module binary_bcd(  
3.	    input [12:0] bin_in,    //输入的二进制数  
4.	  
5.	    output [15:0] bcd_out  //输出的8421BCD码  
6.	  );  
7.	reg [3:0] ones;             //个位  
8.	reg [3:0] tens;             //十位  
9.	reg [3:0] hundreds;         //百位  
10.	reg [3:0] thousands;        //千位  
11.	integer i;  
12.	always @(bin_in) begin  
13.	    ones        = 4'd0;  
14.	    tens        = 4'd0;  
15.	    hundreds    = 4'd0;  
16.	  thousands = 4'd0;  
17.	    for(i = 12; i >= 0; i = i - 1) begin  
18.	        if (ones >= 4'd5)        ones = ones + 4'd3;  
19.	        if (tens >= 4'd5)        tens = tens + 4'd3;  
20.	        if (hundreds >= 4'd5)    hundreds = hundreds + 4'd3;  
21.	    if(thousands >= 4'd5) thousands = thousands + 4'd3;  
22.	    thousands = {thousands[1:0],hundreds[3]};  
23.	        hundreds = {hundreds[2:0],tens[3]};  
24.	        tens     = {tens[2:0],ones[3]};  
25.	        ones     = {ones[2:0],bin_in[i]};  
26.	    end  
27.	end   
28.	assign bcd_out = {thousands, hundreds, tens, ones};  
29.	endmodule  
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module binary_bcd_tb;  
3.	reg [12:0] bin_in;  
4.	wire [15:0] bcd_out;  
5.	binary_bcd  binary_bcd_inst (  
6.	  .bin_in(bin_in),  
7.	  .bcd_out(bcd_out)  
8.	);  
9.	initial begin  
10.	    bin_in<=0;  
11.	    while (1) begin  
12.	        #100  
13.	        bin_in<={$random};  
14.	    end  
15.	end  
16.	endmodule 
```
**仿真结果**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f54d7be5959e00cb7545ff6215992fdb.png)
### BCD码翻译电路
BCD码翻译电路是将进制转换器产生的16位8421BCD码，按照个十百千位转换成用于在七段数码管上显示的段码。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module trans_BCD(  
3.	    input [15:0] BCD_in,    //输入的16位BCD码  
4.	  
5.	    output  reg[27:0] show_in  //数码管显示电路输入信号  
6.	  );  
7.	  reg[3:0] thousand;       //千位  
8.	  reg[3:0] hundred;         //百位  
9.	  reg[3:0] tens;            //十位  
10.	  reg[3:0] units;           //个位  
11.	  //转换部分  
12.	  always @(*)  
13.	  begin  
14.	    thousand<=BCD_in[15:12];  
15.	    hundred<=BCD_in[11:8];  
16.	    tens<=BCD_in[7:4];  
17.	    units<=BCD_in[3:0];  
18.	    //个位  
19.	    case (units)  
20.	      0:  
21.	        show_in[6:0]<= 7'b1111110;//0  
22.	      1:  
23.	        show_in[6:0]<= 7'b0110000;//1  
24.	      2:  
25.	        show_in[6:0]<= 7'b1101101;//2  
26.	      3:  
27.	        show_in[6:0]<= 7'b1111001;//3  
28.	      4:  
29.	        show_in[6:0]<= 7'b0110011;//4  
30.	      5:  
31.	        show_in[6:0]<= 7'b1011011;//5  
32.	      6:  
33.	        show_in[6:0]<= 7'b1011111;//6  
34.	      7:  
35.	        show_in[6:0]<= 7'b1110000;//7  
36.	      8:  
37.	        show_in[6:0]<= 7'b1111111;//8  
38.	      9:  
39.	        show_in[6:0]<= 7'b1111011;//9  
40.	      default:  
41.	        show_in[6:0]<= 7'b1111110;//不显示  
42.	    endcase  
43.	    //十位  
44.	    case (tens)  
45.	      0:  
46.	        show_in[13:7]<= 7'b1111110;//0  
47.	      1:  
48.	        show_in[13:7]<= 7'b0110000;//1  
49.	      2:  
50.	        show_in[13:7]<= 7'b1101101;//2  
51.	      3:  
52.	        show_in[13:7]<= 7'b1111001;//3  
53.	      4:  
54.	        show_in[13:7]<= 7'b0110011;//4  
55.	      5:  
56.	        show_in[13:7]<= 7'b1011011;//5  
57.	      6:  
58.	        show_in[13:7]<= 7'b1011111;//6  
59.	      7:  
60.	        show_in[13:7]<= 7'b1110000;//7  
61.	      8:  
62.	        show_in[13:7]<= 7'b1111111;//8  
63.	      9:  
64.	        show_in[13:7]<= 7'b1111011;//9  
65.	      default:  
66.	        show_in[13:7]<= 7'b0000000;//不显示  
67.	    endcase  
68.	    //百位  
69.	    case (hundred)  
70.	      0:  
71.	        show_in[20:14]<= 7'b1111110;//0  
72.	      1:  
73.	        show_in[20:14]<= 7'b0110000;//1  
74.	      2:  
75.	        show_in[20:14]<= 7'b1101101;//2  
76.	      3:  
77.	        show_in[20:14]<= 7'b1111001;//3  
78.	      4:  
79.	        show_in[20:14]<= 7'b0110011;//4  
80.	      5:  
81.	        show_in[20:14]<= 7'b1011011;//5  
82.	      6:  
83.	        show_in[20:14]<= 7'b1011111;//6  
84.	      7:  
85.	        show_in[20:14]<= 7'b1110000;//7  
86.	      8:  
87.	        show_in[20:14]<= 7'b1111111;//8  
88.	      9:  
89.	        show_in[20:14]<= 7'b1111011;//9  
90.	      default:  
91.	        show_in[20:14]<= 7'b0000000;//不显示  
92.	    endcase  
93.	    //千位  
94.	    case (thousand)  
95.	      0:  
96.	        show_in[27:21]<= 7'b1111110;//0  
97.	      1:  
98.	        show_in[27:21]<= 7'b0110000;//1  
99.	      2:  
100.	        show_in[27:21]<= 7'b1101101;//2  
101.	      3:  
102.	        show_in[27:21]<= 7'b1111001;//3  
103.	      4:  
104.	        show_in[27:21]<= 7'b0110011;//4  
105.	      5:  
106.	        show_in[27:21]<= 7'b1011011;//5  
107.	      6:  
108.	        show_in[27:21]<= 7'b1011111;//6  
109.	      7:  
110.	        show_in[27:21]<= 7'b1110000;//7  
111.	      8:  
112.	        show_in[27:21]<= 7'b1111111;//8  
113.	      9:  
114.	        show_in[27:21]<= 7'b1111011;//9  
115.	      default:  
116.	        show_in[27:21]<= 7'b0000000;//不显示  
117.	    endcase  
118.	  end  
119.	endmodule 
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module trans_BCD_tb;  
3.	reg [15:0] BCD_in;  
4.	wire [27:0] show_in;  
5.	trans_BCD  trans_BCD_inst (  
6.	  .BCD_in(BCD_in),  
7.	  .show_in(show_in)  
8.	);  
9.	initial begin  
10.	    BCD_in<=16'b1000_1000_1000_1000;  
11.	    #100  
12.	    BCD_in<=16'b0001_0010_0011_0100;  
13.	end  
14.	endmodule  
```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/0c5ed11cdfd3da2154d6a38974a40efa.png)
### 动态显示部分
利用输入的28位七段数码的段码，在数码管上显示频率的理论值与实际值。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module show(  
3.	    input [27:0] f_lilun_value,       //信号频率理论值  从trans_BCD模块输入       
4.	    input [27:0] f_shiji_value,       //信号频率实际值  从trans_BCD模块输入  
5.	    input clk_10k,                    //从分频器输入的10KHz信号  
6.	      
7.	    //数码管输出  
8.	    //控制左边4个数码管的输出信号  
9.	    output reg[3:0] l_dis=0,    //选通数码管的信号(动态显示)  
10.	    output reg[6:0] l_seg=0,    //控制数码管亮哪些段的信号  
11.	  
12.	    //控制右边4个数码管的输出信号  
13.	    output reg[3:0] r_dis=0,    //选通数码管的信号(动态显示)  
14.	    output reg[6:0] r_seg=0     //控制数码管亮哪些段的信号  
15.	  );  
16.	  reg[1:0] sel=0; //数码管选通信号  
17.	  always @(posedge clk_10k)  
18.	  begin  
19.	    sel=sel+1;  
20.	    //左边数码管的显示频率的 理论值  
21.	    case (sel)  
22.	      0:  
23.	      begin  
24.	        l_dis<=4'b1000;  
25.	        l_seg<=f_lilun_value[27:21];  
26.	      end  
27.	      1:  
28.	      begin  
29.	        l_dis<=4'b0100;  
30.	        l_seg<=f_lilun_value[20:14];  
31.	      end  
32.	      2:  
33.	      begin  
34.	        l_dis<=4'b0010;  
35.	        l_seg<=f_lilun_value[13:7];  
36.	      end  
37.	      3:  
38.	      begin  
39.	        l_dis<=4'b0001;  
40.	        l_seg<=f_lilun_value[6:0];  
41.	      end  
42.	      default:  
43.	      begin  
44.	        l_dis<=4'b1000;  
45.	        l_seg<=7'b0000000;  
46.	      end  
47.	    endcase  
48.	    //右边数码管显示频率的 实际值  
49.	    case (sel)  
50.	      0:  
51.	      begin  
52.	        r_dis<=4'b1000;  
53.	        r_seg<=f_shiji_value[27:21];  
54.	      end  
55.	      1:  
56.	      begin  
57.	        r_dis<=4'b0100;  
58.	        r_seg<=f_shiji_value[20:14];  
59.	      end  
60.	      2:  
61.	      begin  
62.	        r_dis<=4'b0010;  
63.	        r_seg<=f_shiji_value[13:7];  
64.	      end  
65.	      3:  
66.	      begin  
67.	        r_dis<=4'b0001;  
68.	        r_seg<=f_shiji_value[6:0];  
69.	      end  
70.	      default:  
71.	      begin  
72.	        r_dis<=4'b1000;  
73.	        r_seg<=7'b0000000;  
74.	      end  
75.	    endcase  
76.	  end  
77.	endmodule
```
**激励脚本如下**

```
1.	module show_tb;  
2.	  reg [27:0] f_lilun_value;  
3.	  reg [27:0] f_shiji_value;  
4.	  reg  clk_10k;  
5.	  wire [3:0] l_dis;  
6.	  wire [6:0] l_seg;  
7.	  wire [3:0] r_dis;  
8.	  wire [6:0] r_seg;  
9.	  initial  
10.	  begin  
11.	    clk_10k=0;  
12.	    f_lilun_value<=0;  
13.	    f_shiji_value<=0;  
14.	    #50  
15.	    f_lilun_value<=28'b0110000_1101101_1111001_0110011;  
16.	    f_shiji_value<=28'b0110000_1101101_1111001_0110011;  
17.	    #50  
18.	    f_lilun_value<=28'b1011011_1011111_1110000_1111111;  
19.	    f_shiji_value<=28'b1011011_1011111_1110000_1111111;  
20.	  end  
21.	  always #5  clk_10k = ! clk_10k ;  
22.	  show  show_inst (  
23.	          .f_lilun_value(f_lilun_value),  
24.	          .f_shiji_value(f_shiji_value),  
25.	          .clk_10k(clk_10k),  
26.	          .l_dis(l_dis),  
27.	          .l_seg(l_seg),  
28.	          .r_dis(r_dis),  
29.	          .r_seg(r_seg)  
30.	        );  
31.	endmodule 

```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/579d816b578d76e4a2d8b39fd716ca59.png)
## TOP顶层文件
将上面完成的各模块按照下图在顶层实体中连接起来。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/417d058329da3f213af77d9f30cd8e2b.png)
![模块示意图](https://i-blog.csdnimg.cn/blog_migrate/331bb8c0a1ab6d014e7d473a8cd48239.png)
其中，sys_clk是板载100MHz时钟信号，key_in为8位拨码开关作为频率控制字的输入，sel为2位的拨码开关输入，作为波形选通信号，用于选择产生不同波形，rst_n_shiji为测频电路的使能信号，控制测频电路是否能够工作。
**源代码如下**

```
1.	`timescale 1ns / 1ps  
2.	module DDS_top(  
3.	    input   sys_clk,        //板载时钟信号  
4.	    input[7:0]  key_in,     //8个拨码开关  
5.	    input   [1:0]sel,       //输出波形的选通信号  
6.	    input   rst_n_shiji,    //测频电路的使能信号  
7.	    //控制左边4个数码管的输出信号  
8.	    output [3:0] l_dis,    //选通数码管的信号(动态显示)  
9.	    output [6:0] l_seg,    //控制数码管亮哪些段的信号  
10.	    //控制右边4个数码管的输出信号  
11.	    output [3:0] r_dis,    //选通数码管的信号(动态显示)  
12.	    output [6:0] r_seg,    //控制数码管亮哪些段的信号  
13.	    //波形存储器输出，连接到AD转换器  
14.	    output [7:0] sin,  
15.	    output [4:0] rst_n_AD   //AD转换器的一些使能信号  
16.	  );  
17.	  ///////////////////////////////////////////////////////////////////////  
18.	  wire clk_10k;               //10kHz时钟信号  
19.	  wire clk_05;                //0.5Hz时钟信号  
20.	  wire[7:0] address;          //波形存储器需要的地址信号  
21.	  wire[12:0] bin_in_lilun;    //理论频率计算模块 与 进制转换器 之间的连线  
22.	  wire[15:0] bcd_in_lilun;    //理论频率计算中 进制转换器 与 BCD翻译 之间的连线  
23.	  wire[27:0] f_lilun_value;   //BCD码翻译电路 与 显示模块 之间的连线  
24.	  wire[12:0] bin_in_shiji;    //测频模块 与 进制转换器 之间的连线  
25.	  wire[15:0] bcd_in_shiji;    //测频模块中 进制转换器 与 BCD翻译 之间的连线  
26.	  wire[27:0] f_shiji_value;   //BCD码翻译电路 与 显示模块 之间的连线  
27.	  ///////////////////////////////////////////////////////////////////////////  
28.	  //实例化分频器模块  
29.	  f_div fen_pin_qi            //分频器  
30.	        (  
31.	          .sys_clk(sys_clk),      //系统时钟信号  
32.	          //.rst_n(rst_n),          //使能信号  
33.	  
34.	          .clk_10k(clk_10k),      //10kHz时钟信号  
35.	          .clk_05(clk_05)         //0.5Hz时钟信号  
36.	        );  
37.	  //实例化累加器模块  
38.	  forever_adder leijiaqi      //累加器  
39.	                (  
40.	                  .clk_10k(clk_10k),      //累加器输入10KHz时钟信号  
41.	                  .key_in(key_in),        //外部8个拨码开关输入  
42.	  
43.	                  .address(address)       //累加器输出的ROM地址  
44.	                );  
45.	  //实例化ROM波形存储器  
46.	  ip_rom rom  
47.	         (  
48.	           .address(address),      //读取存储器地址  
49.	           .sel(sel),              //输出波形的选通信号  
50.	  
51.	           .sin(sin)               //波形输出值  
52.	         );  
53.	  //////////////////////////////////////////////////////////////  
54.	  //实例化理论频率计算模块  
55.	  lilun_f lilun_f_inst  
56.	          (  
57.	            .clk_10k(clk_10k),          //输入10k时钟信号  
58.	            .key_in(key_in),            //输入8个拨码开关信号  
59.	  
60.	            .li_lun_zhi(bin_in_lilun)   //输出计算的频率理论值  
61.	          );  
62.	  //实例化进制转换器模块,将13位无符号二进制数转换为对应十进制数的8421BCD码  
63.	  binary_bcd binary_bcd_inst_lilun    //频率理论值的转换  
64.	             (  
65.	               .bin_in(bin_in_lilun),      //输入的13位二进制数  
66.	  
67.	               .bcd_out(bcd_in_lilun)      //输出的16位二进制数对应十进制数的BCD码  
68.	             );  
69.	  //实例化BCD码翻译电路，将BCD码翻译成适合于直接用在显示电路上的二进制码  
70.	  trans_BCD trans_BCD_inst_lilun      //理论频率BCD转换为数码管二进制  
71.	            (  
72.	              .BCD_in(bcd_in_lilun),      //输入的16位BCD码  
73.	  
74.	              .show_in(f_lilun_value)     //将BCD输入到显示模块中  
75.	            );  
76.	  ///////////////////////////////////////////////////////////////////////  
77.	  //实例化测频电路(测量实际频率的电路)  
78.	  measure_shiji_f measure_shiji_f_inst  
79.	                  (  
80.	                    .clk_05(clk_05),            //输入的0.5Hz时钟信号  
81.	                    .sin(sin),                  //输入 波形存储器输出 的信号  
82.	                    .rst_n_shiji(rst_n_shiji),  //测频电路的使能信号  
83.	  
84.	                    .shi_ji_zhi(bin_in_shiji)   //输出测量的频率值  
85.	                  );  
86.	  //实例化进制转换器模块,将13位无符号二进制数转换为对应十进制数的8421BCD码  
87.	  binary_bcd binary_bcd_inst_shiji    //频率理论值的转换  
88.	             (  
89.	               .bin_in(bin_in_shiji),      //输入的13位二进制数  
90.	  
91.	               .bcd_out(bcd_in_shiji)      //输出的16位二进制数对应十进制数的BCD码  
92.	             );  
93.	  //实例化BCD码翻译电路，将BCD码翻译成适合于直接用在显示电路上的二进制码  
94.	  trans_BCD trans_BCD_inst_shiji      //理论频率BCD转换为数码管二进制  
95.	            (  
96.	              .BCD_in(bcd_in_shiji),      //输入的16位BCD码  
97.	  
98.	              .show_in(f_shiji_value)     //将BCD输入到显示模块中  
99.	            );  
100.	  ///////////////////////////////////////////////////////////////////////  
101.	  //显示模块，左边显示理论值，右边显示实际值  
102.	  show show_inst  
103.	       (  
104.	         .f_lilun_value(f_lilun_value),  //频率理论值  
105.	         .f_shiji_value(f_shiji_value),  //频率实际值  
106.	         .clk_10k(clk_10k),              //输入10k时钟信号  
107.	  
108.	         .l_dis(l_dis),                  //输出左边数码管位码  
109.	         .l_seg(l_seg),                  //输出左边数码管对应值  
110.	         .r_dis(r_dis),                  //输出右边数码管位码  
111.	         .r_seg(r_seg)                  //输出右边数码管对应值  
112.	       );  
113.	  ////////////////////////////////////////////////////////////////////////  
114.	  assign rst_n_AD=5'b00001;  
115.	endmodule  
```
**激励脚本如下**

```
1.	`timescale 1ns / 1ps  
2.	module DDS_top_tb;  
3.	reg  sys_clk;  
4.	reg [7:0] key_in;  
5.	reg [1:0] sel;  
6.	reg  rst_n_shiji;  
7.	wire [3:0] l_dis;  
8.	wire [6:0] l_seg;  
9.	wire [3:0] r_dis;  
10.	wire [6:0] r_seg;  
11.	wire [7:0] sin;  
12.	wire [4:0] rst_n_AD;  
13.	DDS_top  DDS_top_inst (  
14.	  .sys_clk(sys_clk),  
15.	  .key_in(key_in),  
16.	  .sel(sel),  
17.	  .rst_n_shiji(rst_n_shiji),  
18.	  .l_dis(l_dis),  
19.	  .l_seg(l_seg),  
20.	  .r_dis(r_dis),  
21.	  .r_seg(r_seg),  
22.	  .sin(sin),  
23.	  .rst_n_AD(rst_n_AD)  
24.	);  
25.	initial begin  
26.	    sys_clk=0;  
27.	    key_in<=8'b0000_0000;  
28.	    sel<=2'b01;  
29.	    rst_n_shiji<=1;  
30.	    #10  
31.	    key_in<=8'b0000_0001;  
32.	end  
33.	always #5  sys_clk = ! sys_clk ;  
34.	  
35.	endmodule

```
**仿真结果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/8b9be74e723d1e6f940011eea54d4a0c.png)
上图为运行3s后的波形
**顶层模块的约束文件**

```
1.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[7]}]  
2.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[6]}]  
3.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[5]}]  
4.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[4]}]  
5.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[3]}]  
6.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[2]}]  
7.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[1]}]  
8.	set_property IOSTANDARD LVCMOS33 [get_ports {key_in[0]}]  
9.	set_property IOSTANDARD LVCMOS33 [get_ports {l_dis[3]}]  
10.	set_property IOSTANDARD LVCMOS33 [get_ports {l_dis[2]}]  
11.	set_property IOSTANDARD LVCMOS33 [get_ports {l_dis[1]}]  
12.	set_property IOSTANDARD LVCMOS33 [get_ports {l_dis[0]}]  
13.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[6]}]  
14.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[5]}]  
15.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[4]}]  
16.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[3]}]  
17.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[2]}]  
18.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[1]}]  
19.	set_property IOSTANDARD LVCMOS33 [get_ports {l_seg[0]}]  
20.	set_property IOSTANDARD LVCMOS33 [get_ports {r_dis[3]}]  
21.	set_property IOSTANDARD LVCMOS33 [get_ports {r_dis[2]}]  
22.	set_property IOSTANDARD LVCMOS33 [get_ports {r_dis[1]}]  
23.	set_property IOSTANDARD LVCMOS33 [get_ports {r_dis[0]}]  
24.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[6]}]  
25.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[5]}]  
26.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[4]}]  
27.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[3]}]  
28.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[2]}]  
29.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[1]}]  
30.	set_property IOSTANDARD LVCMOS33 [get_ports {r_seg[0]}]  
31.	set_property IOSTANDARD LVCMOS33 [get_ports {rst_n_AD[4]}]  
32.	set_property IOSTANDARD LVCMOS33 [get_ports {rst_n_AD[3]}]  
33.	set_property IOSTANDARD LVCMOS33 [get_ports {rst_n_AD[2]}]  
34.	set_property IOSTANDARD LVCMOS33 [get_ports {rst_n_AD[1]}]  
35.	set_property IOSTANDARD LVCMOS33 [get_ports {rst_n_AD[0]}]  
36.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[7]}]  
37.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[6]}]  
38.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[5]}]  
39.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[4]}]  
40.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[3]}]  
41.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[2]}]  
42.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[1]}]  
43.	set_property IOSTANDARD LVCMOS33 [get_ports {sin[0]}]  
44.	set_property IOSTANDARD LVCMOS33 [get_ports rst_n_shiji]  
45.	set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]  
46.	set_property PACKAGE_PIN P5 [get_ports {key_in[7]}]  
47.	set_property PACKAGE_PIN P4 [get_ports {key_in[6]}]  
48.	set_property PACKAGE_PIN P3 [get_ports {key_in[5]}]  
49.	set_property PACKAGE_PIN P2 [get_ports {key_in[4]}]  
50.	set_property PACKAGE_PIN R2 [get_ports {key_in[3]}]  
51.	set_property PACKAGE_PIN M4 [get_ports {key_in[2]}]  
52.	set_property PACKAGE_PIN N4 [get_ports {key_in[1]}]  
53.	set_property PACKAGE_PIN R1 [get_ports {key_in[0]}]  
54.	set_property PACKAGE_PIN U3 [get_ports rst_n_shiji]  
55.	set_property PACKAGE_PIN P17 [get_ports sys_clk]  
56.	set_property PACKAGE_PIN G2 [get_ports {l_dis[3]}]  
57.	set_property PACKAGE_PIN C2 [get_ports {l_dis[2]}]  
58.	set_property PACKAGE_PIN C1 [get_ports {l_dis[1]}]  
59.	set_property PACKAGE_PIN H1 [get_ports {l_dis[0]}]  
60.	set_property PACKAGE_PIN B4 [get_ports {l_seg[6]}]  
61.	set_property PACKAGE_PIN A3 [get_ports {l_seg[4]}]  
62.	set_property PACKAGE_PIN B1 [get_ports {l_seg[3]}]  
63.	set_property PACKAGE_PIN A1 [get_ports {l_seg[2]}]  
64.	set_property PACKAGE_PIN A4 [get_ports {l_seg[5]}]  
65.	set_property PACKAGE_PIN B3 [get_ports {l_seg[1]}]  
66.	set_property PACKAGE_PIN B2 [get_ports {l_seg[0]}]  
67.	set_property PACKAGE_PIN G1 [get_ports {r_dis[3]}]  
68.	set_property PACKAGE_PIN F1 [get_ports {r_dis[2]}]  
69.	set_property PACKAGE_PIN E1 [get_ports {r_dis[1]}]  
70.	set_property PACKAGE_PIN G6 [get_ports {r_dis[0]}]  
71.	set_property PACKAGE_PIN D4 [get_ports {r_seg[6]}]  
72.	set_property PACKAGE_PIN E3 [get_ports {r_seg[5]}]  
73.	set_property PACKAGE_PIN D3 [get_ports {r_seg[4]}]  
74.	set_property PACKAGE_PIN F4 [get_ports {r_seg[3]}]  
75.	set_property PACKAGE_PIN F3 [get_ports {r_seg[2]}]  
76.	set_property PACKAGE_PIN E2 [get_ports {r_seg[1]}]  
77.	set_property PACKAGE_PIN D2 [get_ports {r_seg[0]}]  
78.	set_property PACKAGE_PIN V7 [get_ports {rst_n_AD[4]}]  
79.	set_property PACKAGE_PIN R6 [get_ports {rst_n_AD[3]}]  
80.	set_property PACKAGE_PIN V6 [get_ports {rst_n_AD[2]}]  
81.	set_property PACKAGE_PIN N6 [get_ports {rst_n_AD[1]}]  
82.	set_property PACKAGE_PIN R5 [get_ports {rst_n_AD[0]}]  
83.	set_property PACKAGE_PIN U9 [get_ports {sin[7]}]  
84.	set_property PACKAGE_PIN V9 [get_ports {sin[6]}]  
85.	set_property PACKAGE_PIN U7 [get_ports {sin[5]}]  
86.	set_property PACKAGE_PIN U6 [get_ports {sin[4]}]  
87.	set_property PACKAGE_PIN R7 [get_ports {sin[3]}]  
88.	set_property PACKAGE_PIN T6 [get_ports {sin[2]}]  
89.	set_property PACKAGE_PIN R8 [get_ports {sin[1]}]  
90.	set_property PACKAGE_PIN T8 [get_ports {sin[0]}]  
91.	  
92.	set_property IOSTANDARD LVCMOS33 [get_ports {sel[1]}]  
93.	set_property IOSTANDARD LVCMOS33 [get_ports {sel[0]}]  
94.	set_property PACKAGE_PIN U2 [get_ports {sel[1]}]  
95.	set_property PACKAGE_PIN V2 [get_ports {sel[0]}] 
```
到此，电路设计完成。
# 上板验证
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9faa474553c1c9dd997f7ecd73b7a372.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/3a314d35a17f9d2d89fb27273079e510.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ee54177393acc14bd035e1d43bddf3de.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/0c44f86a5c4b640eefb9ad706c8b4afc.png)
可以正常输出4中波形。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/e5dfb82ecf23cec15cbb8a3155a8ed5d.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/b813f555d7a4422c0c611c23d662ece1.png)
# 碎碎念
在设计过程中还犯了一个低级错误，在写二进制数时，应当在前面定义“[位宽]’b”，这样程序在运行时才能将数以二进制数进行处理，否则就会以十进制数进行编译，这样写的结果虽然在语法上并没有问题，但是逻辑上并不正确。
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/51ee4f3262066813e6314dad4c053995.jpeg)
找一找左右两边有什么不同。哎，当时找了一下午才反映过来
