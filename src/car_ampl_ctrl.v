module car_ampl_ctrl(
	input clk,
	input rst,
	input  [11:0]dac_car,
	//input 	am_ctrl,
	output [11:0]dac_car_ampl
);

reg [11:0]dac_car_ampl_reg;

parameter [10:0]BIAS = 1023;


 always@(posedge clk or negedge rst)
 begin
	if(!rst)
	begin
	dac_car_ampl_reg <= dac_car;
	end
	else begin
	dac_car_ampl_reg <=dac_car; //(dac_car>>1) + BIAS;
	end
 end


assign dac_car_ampl = dac_car_ampl_reg;


endmodule
 
 
 
 