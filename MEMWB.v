module MEMWB (
input clk, 
input reset, 
input MEMWB_En,
input [103:0] MEMWB_input,
output reg [103:0] MEMWB_output
);

always @ (posedge clk or negedge reset) begin 
	if(reset) begin 
	MEMWB_output <= 104'b0;
	end 
	else if(MEMWB_En) begin 
	MEMWB_output <= MEMWB_input;
	end 
	end
		endmodule 
//64 bits for instruction and pc (32 bit each)
