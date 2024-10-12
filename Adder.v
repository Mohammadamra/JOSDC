module adder #(parameter dataWidth = 32)
(
    input  [dataWidth - 1:0] in0, in1,  // Two data inputs
    output [dataWidth - 1:0] out        // Output for the result
);
	
    assign out = in0 + in1;  // Combinational addition

endmodule

