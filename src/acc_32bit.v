module acc_32bit(
	input clk,
	input rst,
	input [63:0] fre_c,
	output [11:0] adder
);




reg [63:0] add;


always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		add <= 64'd0;
	end
	else
	begin
		add <= add + fre_c;		//125M采样率，32位ACC，100Hz
	end
end

assign adder = add[63:52];

endmodule