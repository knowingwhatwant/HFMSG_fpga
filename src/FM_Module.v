module FM_Module(
	input clk,
	input rst,
	input [11:0]  dac_modu_w12,
	input [63:0]  freq_ctrl_car,
	output [63:0]FM_Freq
);


	reg [63:0] FM_Freq_reg;
	reg [75:0] freq_temp;
	parameter Kf = 64'd76861433640456500 ; //对应最大频偏500KHz（120MHz）
always@(posedge clk or negedge rst )
  begin
  if(!rst)
  begin
	FM_Freq_reg <= Kf;			
  end
  else if(dac_modu_w12 > 12'd2047)begin 
  freq_temp <= (Kf*(dac_modu_w12-12'd2047));		//那就直接Kf乘以s(t)
  FM_Freq_reg <= freq_ctrl_car + freq_temp[75:12] ;
  end
  else if(dac_modu_w12 <= 12'd2047)begin
  freq_temp <= (Kf*(12'd2047-dac_modu_w12));
  FM_Freq_reg <= freq_ctrl_car - freq_temp[75:12] ;
  end
  
  end
  
  assign FM_Freq = FM_Freq_reg;
  
  
  
  
  
  
  endmodule
  
  
  
  
  
  
  
  
  
  
  
  
