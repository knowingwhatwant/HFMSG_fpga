module DDS_TOP(
	input clk,
	input rst_n,
	//input fre_c,
	//output dac_clk,
	output [11:0] dac_modu_data_ampl,
	output [11:0] dac_car_data_ampl,
	//output [63:0] freq_c,
	output [11:0] addr_carrier,
	output [11:0] addr_modu,
	output clk_inv,		//dac902上升沿读数据，下降沿该数据
	
	//output [11:0] dac_data_carrier,
	//output [11:0]	dac_data_modu,
	
	//output [23:0] result,
	output clk_out,
	output [11:0] dac_12bit
);


assign clk_inv = ~clk_120M2;
assign clk_out = clk;




//各条时钟线
wire clk_50M;
wire clk_25M;
wire clk_120M;
wire clk_div120;
wire clk_200M;
wire clk_120M2;

pll_ip U_pll
(
    .areset(~rst_n),
    .inclk0(clk),
    .c0(clk_50M),
	 .c1(clk_25M),		//
	 .c2(clk_120M),
	 .c3(clk_120M2)
);

div_120 u_div_120
(
	.clk(clk_50M),
	.rst(rst_n),
	.clk_div(clk_div120)
);

//频率控制模块 --> 累加器
wire [63:0] freq_c_carrier;
wire [63:0] freq_c_modu;

//第一个频率控制字
 freq_ctrl_modu U1_freq_ctrl_modu
 (
	.clk(clk_div120),
	.rst(rst_n),
	.freq_c(freq_c_modu)
 );
//第二个频率控制字

 freq_ctrl_carrier U2_freq_ctrl_carrier
 (
	.clk(clk_div120),
	.rst(rst_n),
	.freq_c(freq_c_carrier)
 );

 
 
 //累加器输出rom数据地址线
//wire [11:0] addr_carrier;
//wire [11:0] addr_modu;
//载波相位累加器
acc_32bit U1_acc_32bit_carrier(
	.clk(clk_120M),
	.rst(rst_n),
	//.fre_c(freq_c_carrier),		//这是正常输出载波
	.fre_c(FM_freq_ctrl),			//FM的相位
	.adder(addr_carrier)
);
//调制信号相位累加器
acc_32bit U2_acc_32bit_modu(
	.clk(clk_120M),
	.rst(rst_n),
	.fre_c(freq_c_modu),
	.adder(addr_modu)
);



// rom表输出sin数据 --> 
wire [11:0] dac_data_carrier;
wire [11:0]	dac_data_modu;

//sin_rom表
sin_rom_ip U1_sin_rom_carrier(
	.clock(clk_120M),
	.address(addr_carrier),		//12bit地址
	.q(dac_data_carrier)			//查表输出
);

sin_rom_ip U2_sin_rom_modu(
	.clock(clk_120M),
	.address(addr_modu),		//12bit地址
	.q(dac_data_modu)			//查表输出
);


//幅度控制模块 --> 
//wire [11:0] dac_modu_data_ampl;
//wire [11:0] dac_car_data_ampl;

//rom表输出之后的幅度控制
car_ampl_ctrl u0_car_ampl_ctrl(
	.clk(clk_120M),
	.rst(rst_n),
	.dac_car(dac_data_carrier),
	.dac_car_ampl(dac_car_data_ampl)
);

modu_ampl_ctrl u0_modu_ampl_ctrl(
	.clk(clk_120M),
	.rst(rst_n),
	.dac_modu(dac_data_modu),
	.dac_modu_ampl(dac_modu_data_ampl)
);


//FM频率控制字模块 --> 载波的ACC
wire [63:0]FM_freq_ctrl;

//FM的频率控制字计算模块
FM_Module u0_FM_Module
(
	.clk(clk_120M),
	.rst(rst_n),
	.dac_modu_w12(dac_modu_data_ampl),		//调制信号dac输出
	.freq_ctrl_car(freq_c_carrier),			//频率控制字输入
	.FM_Freq(FM_freq_ctrl)
);







//AM信号产生
mult_dac U0_AM
(
	.clk(clk_120M),
	.rst(rst_n),
	.dac_car(dac_car_data_ampl),
	.dac_modu(dac_modu_data_ampl),
	.dac_12bit(dac_12bit)
);





/*
div_120 u_div_clk
(
	.clk(clk_120M),
	.rst(rst_n),
	.clk_div(test_128)
);
*/
/*
//乘法器
ipcore_mult_ip U1_ipcore_mult_ip
(
	.dataa(dac_data_modu),
	.datab(dac_data_carrier),
	.result(result)
);
*/





endmodule

