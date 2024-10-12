module comparator(
input [31:0] in0, in1,
output equ
);
assign equ = ( in0 == in1 ) ? 1'b1 : 1'b0;

endmodule