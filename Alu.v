module Alu (
input [31:0] input_1,
input [31:0] input_2,
input [2:0] Op,
output reg [31:0] Result,
output Zero
);

//define parameters to the operation of the Alu 

parameter OR   = 3'b000,  // OR operation
          AND  = 3'b001,  // AND operation
          XOR  = 3'b010,  // XOR operation
          ADD  = 3'b011,  // ADD operation
          NOR  = 3'b100,  // NOR operation
          NAND = 3'b101,  // NAND operation
          SLT  = 3'b110,  // Set Less Than operation (returns 1 if input_1 < input_2, otherwise 0)
          SUB  = 3'b111;  // SUBTRACT operation
	always @* begin 
    // Use a case statement to select the operation based on the Op signal
    case(Op)
        ADD:  Result = input_1 + input_2;          // Addition of input_1 and input_2
        
        AND:  Result = input_1 & input_2;          // Bitwise AND of input_1 and input_2
        
        NAND: Result = ~(input_1 & input_2);       // Bitwise NAND of input_1 and input_2 (AND followed by NOT)
        
        NOR:  Result = ~(input_1 | input_2);       // Bitwise NOR of input_1 and input_2 (OR followed by NOT)
        
        OR:   Result = input_1 | input_2;          // Bitwise OR of input_1 and input_2
        
        SLT:  Result = (input_1 < input_2) ? 32'b1 : 32'b0; // Set Less Than: Result is 1 if input_1 < input_2, otherwise 0
        
        SUB:  Result = input_1 - input_2;          // Subtraction of input_1 and input_2
        
        XOR:  Result = input_1 ^ input_2;          // Bitwise XOR of input_1 and input_2
        
        default: Result = 32'b0;                   // Default case (optional): Assign 0 if no case matches
    endcase
end

//assigning zero flag into 1 if the result is zero 
assign Zero = (Result == 0);

endmodule

