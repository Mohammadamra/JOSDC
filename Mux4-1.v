module mux_4x1 #(parameter dataWidth = 32) 
(
    input  [dataWidth - 1:0] in0, in1, in2, in3,  // 4 data inputs
    input  [1:0] s,                               // 2-bit select input
    output reg [dataWidth - 1:0] out              // Output data
);
	
	always @ (*) begin
		case (s)
			2'b00: out = in0;    // Select input in0 if s is 00
			2'b01: out = in1;    // Select input in1 if s is 01
			2'b10: out = in2;    // Select input in2 if s is 10
			2'b11: out = in3;    // Select input in3 if s is 11
			default: out = 'hxxxx; // Undefined state for invalid select
		endcase
	end

endmodule

