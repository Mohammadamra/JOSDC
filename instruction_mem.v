module instruction_mem (
input[31:0] PcAddress,
output reg[31:0] instruction
); 

//declare the inst mem as 2D array 

reg [31:0] I_mem [31:0]; 

always @ (*) begin 
	if((PcAddress >> 2) > 32) begin
	instruction = I_mem [PcAddress >> 2];
	end 
	else begin
	instruction = 32'h0000000;
	end
end
	endmodule 