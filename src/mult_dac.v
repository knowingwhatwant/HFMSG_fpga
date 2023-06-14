module mult_dac(
	input clk,
	input rst,
	input [11:0] dac_car,
	input [11:0] dac_modu,
	output [23:0] mul_result,
	output [11:0] dac_12bit
);

reg [23:0] mul_result_reg;
reg [11:0] dac_12bit_reg;
reg [35:0] scaled_value;

parameter [22:0] MAX_23 = 23'd8388607;		//输出最大值的中点位置

assign mul_result = mul_result_reg;
assign dac_12bit = dac_12bit_reg;

always@(posedge clk or negedge rst )
begin
	if(!rst) begin
	mul_result_reg <= 24'd0;
	end
	else if(dac_car > 12'd2047) begin
	mul_result_reg <= MAX_23 + (dac_modu - 12'd2047) * (dac_car-12'd2047);	//2047基准以上
	end
	else if(dac_car <=12'd2047) begin
	mul_result_reg <= MAX_23 - (dac_modu - 12'd2047) * (12'd2047- dac_car);	//2047基准以下
	end

end


always@(mul_result_reg)
begin
	scaled_value <= (mul_result_reg * 12'hFFF);
	dac_12bit_reg <= scaled_value[35:24];
end






endmodule













