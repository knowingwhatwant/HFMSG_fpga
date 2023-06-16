module div_10(
	input clk,
	input rst,
	output clk_div
);
 reg [31:0] counter;
    parameter DIV_VALUE = 10;
 
 
 assign clk_div = (counter == DIV_VALUE - 1) ? ~clk_div : clk_div;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 0;
        end
        else begin
            counter <= (counter == DIV_VALUE - 1) ? 0 : counter + 1;
        end
    end

endmodule