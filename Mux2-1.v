module mux_2x1 #(parameter dataWidth = 32) 
(
input [dataWidth - 1:0] in0, in1,  // 2 data inputs
input s,                            // Select input
output reg [dataWidth - 1:0] out    // Output data
);
	
	always @ (*) begin
		case (s)
			1'b0: out = in0;    // If s = 0, output in0
			1'b1: out = in1;    // If s = 1, output in1
			default: out = 'hx; // In case of unknown select value
		endcase
	end

endmodule
