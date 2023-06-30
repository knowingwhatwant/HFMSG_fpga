module mult_dac(
	input clk,
	input rst,
	input [11:0] dac_car,
	input [11:0] dac_modu,
	output [11:0] dac_12bit
	//output dac_clk
);

reg [23:0] mul_result_reg;
reg [11:0] dac_12bit_reg ;//= 12'b010101010101;
//reg [35:0] scaled_value;
//reg dac_clk = 1'b0;

parameter [22:0] MAX_23 = 23'd8388607;		//输出最大值的中点位置

assign dac_12bit = dac_12bit_reg ;

always@(posedge clk or negedge rst )
begin
	if(!rst) begin
	dac_12bit_reg <= dac_car;//24'd0;
	end
	else if(dac_car > 12'd2047) 
	begin
	mul_result_reg <= MAX_23 + (dac_modu - 12'd2047) * (dac_car-12'd2047);	//2047基准以上
	dac_12bit_reg <= mul_result_reg[23:12];
	end
	else if(dac_car <=12'd2047) begin
	mul_result_reg <= MAX_23 - (dac_modu - 12'd2047) * (12'd2047- dac_car);	//2047基准以下
	dac_12bit_reg <= mul_result_reg[23:12];
	end
end












endmodule