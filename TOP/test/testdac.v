module testdac(
	input clk,
	input rst,
	output reg [11:0]dac
);

always@(posedge clk or negedge rst)
begin 
if(!rst)
begin
	dac <= 12'b0;
end
else begin
	dac <= dac ^ 12'b100000000000;
end
end
endmodule

