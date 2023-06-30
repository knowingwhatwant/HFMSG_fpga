module freq_ctrl_modu(
	input clk,
	input rst,

	output [63:0] freq_c
);

wire [1:0] sweep_mode = 2'b00;
//00: Normal sin
//01: Line sweep 
//10: Log sweep
reg [63:0] freq_c_reg = 64'd153722867281;



always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
	freq_c_reg <= 64'd153722867281;     //default:1Hz
	end
	else begin
		
	case(sweep_mode)
	2'b00: 
	begin
	freq_c_reg <=64'd153722867280913 ;		//1kHz(120M)

	//freq_c_reg <= 64'd15372286728091300; //100khz(120M)
	//freq_c_reg <= 64'd3074457345618260000;  //20M(120M)
	//freq_c_reg <= 64'd1537228672809130000;	//10M(120M)
	//freq_c_reg <= 64'd153722867280913000;	//1M(120M)
	//freq_c_reg <= 64'd3689348814741910000;	//20M(100M)
	//freq_c_reg <= 64'd7378697629483820000;	 //20M(50M)
	//freq_c_reg <= 64'd3689348814741910000; //10M(50M)
	end
	2'b01: begin
	freq_c_reg <= freq_c_reg + 64'd153722867281;
	if(freq_c_reg > 64'd3074457345618260000)  //exceed 20MHz
	begin
		freq_c_reg  <= 64'd153722867281; 
	end
	end	
	2'b10: begin
	freq_c_reg <= (freq_c_reg << 3) + (freq_c_reg << 1);
	if(freq_c_reg > 64'd3074457345618260000)  //exceed 20MHz
	begin
		freq_c_reg  <= 64'd153722867281; 
	end 
	end
		default:  freq_c_reg <= 64'd153722867280913000;  //20M(120M)
	endcase
	end
end


assign freq_c = freq_c_reg;

endmodule
