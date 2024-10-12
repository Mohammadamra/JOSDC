module IDEX (
input clk, 
input reset, 
input IDEX_En,
input [153:0] IDEX_input,
output reg [153:0] IDEX_output
);

always @ (posedge clk or negedge reset) begin 
	if(reset) begin 
	IDEX_output <= 153'b0;
	end 
	else if(IDEX_En) begin 
	IDEX_output <= IDEX_input;
	end 
	end
		endmodule 
//64 bits for instruction and pc (32 bit each)
