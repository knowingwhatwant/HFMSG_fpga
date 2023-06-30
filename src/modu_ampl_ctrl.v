module modu_ampl_ctrl(
	input clk,
	input rst,
	input  [11:0]dac_modu,
	//input 	am_ctrl,
	output [11:0]dac_modu_ampl
);

reg [11:0]dac_modu_ampl_reg;

parameter [10:0]BIAS = 0;


 always@(posedge clk or negedge rst)
 begin
	if(!rst)
	begin
	dac_modu_ampl_reg <= dac_modu;
	end
	else begin
	dac_modu_ampl_reg <= (dac_modu) + BIAS;
	end
 end

  
assign dac_modu_ampl = dac_modu_ampl_reg;

 
endmodule
 
 
 
 