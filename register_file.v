module register_file (
input clk, 
input reset,
input ReadEn,
input WriteEn,
input [4:0] rsAddress, 
input [4:0] rtAddress,
input [4:0] rdAddress,
input [31:0] Write_Back,
output [31:0] Data1,
output [31:0] Data2
);

//declare the reg file as 2D array 

reg [31:0] reg_file [31:0]; 

integer i;

//declare the procedure of the reg file 

always @ (posedge clk or negedge reset) begin 
	 if (WriteEn) begin 
	reg_file [rdAddress] = Write_Back;
	end 
	else if (~reset) begin 
	for (i = 0; i < 32; i = i + 1) 
		reg_file[i] <= 0;
	end 
		end 

//for asynchronas read 

assign Data1 = reg_file [rsAddress];
assign Data2 = reg_file [rtAddress];

endmodule 






