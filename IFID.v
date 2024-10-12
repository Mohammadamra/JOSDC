module IFID (
input clk, 
input reset, 
input IFID_En,
input [63:0] IFID_input,
output reg [63:0] IFID_output
);

always @ (posedge clk or negedge reset) begin 
	if(reset) begin 
	IFID_output <= 64'b0;
	end 
	else if(IFID_En) begin 
	IFID_output <= IFID_input;
	end 
	end
		endmodule 
//64 bits for instruction and pc (32 bit each)