module DDS_TOP(
	input clk,
	input rst_n,
	//input fre_c,
	//output dac_clk,
	output [11:0] dac_car_data_ampl,
	output [11:0] dac_modu_data_ampl,
	//output [63:0] freq_c,
	//output [11:0] addr1,
	//output [11:0] addr2,
	output clk_inv,
	output [23:0] result,
	output [11:0] dac_12bit
);


wire clk_50M;
wire clk_100M;
wire clk_120M;
wire clk_div120;
wire clk_200M;
wire [63:0] freq_c_carrier;
wire [63:0] freq_c_modu;

wire [11:0] dac_data_carrier;
wire [11:0]	dac_data_modu;

wire [11:0] addr_carrier;
wire [11:0] addr_modu;

//wire [11:0] dac_modu_data_ampl;
//wire [11:0] dac_car_data_ampl;


assign clk_inv = ~clk_120M;



pll_ip U_pll
(
    .areset(~rst_n),
    .inclk0(clk),
    .c0(clk_50M),
	 .c1(clk_100M),		//
	 .c2(clk_120M),
	 .c3(clk_1M)
);

div_120 u_div_120
(
	.clk(clk_50M),
	.rst(rst_n),
	.clk_div(clk_div120)
);


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


//累加器1
acc_32bit U1_acc_32bit_carrier(
	.clk(clk_120M),
	.rst(rst_n),
	.fre_c(freq_c_carrier),
	.adder(addr_carrier)
);
//累加器2
acc_32bit U2_acc_32bit_modu(
	.clk(clk_120M),
	.rst(rst_n),
	.fre_c(freq_c_modu),
	.adder(addr_modu)
);

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

//rom表输出之后的幅度控制
car_ampl_ctrl u0_car_ampl_ctrl(
	.clk(clk),
	.rst(rst_n),
	.dac_car(dac_data_carrier),
	.dac_car_ampl(dac_car_data_ampl)
);

modu_ampl_ctrl u0_modu_ampl_ctrl(
	.clk(clk),
	.rst(rst_n),
	.dac_modu(dac_data_modu),
	.dac_modu_ampl(dac_modu_data_ampl)
);




//AM信号产生
mult_dac U0_AM
(
	.clk(clk),
	.rst(rst_n),
	.dac_car(dac_car_data_ampl),
	.dac_modu(dac_modu_data_ampl),
	.mul_result(result),
	.dac_12bit(dac_12bit)
);









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

