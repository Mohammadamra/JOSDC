module EXMEM (
input clk, 
input reset, 
input EXMEM_En,
input [105:0] EXMEM_input,
output reg [105:0] EXMEM_output
);

always @ (posedge clk or negedge reset) begin 
	if(reset) begin 
	EXMEM_output <= 105'b0;
	end 
	else if(EXMEM_En) begin 
	EXMEM_output <= EXMEM_input;
	end 
	end
		endmodule 
//64 bits for instruction and pc (32 bit each)
