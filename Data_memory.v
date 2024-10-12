module Data_memory(
  input clk, 
    input [31:0] Address,
    input [31:0] Data_in,
    input ReadEn,
    input WriteEn,
    output reg [31:0] Data_out
); 

    // Declare the memory as a 2D array
    reg [31:0] Data_mem [0:31];

    // Data memory operation
    always @ (posedge clk) begin
        if (WriteEn) begin
            Data_mem[Address >> 2] <= Data_in; // Write operation
        end 
        else if (ReadEn) begin
            Data_out <= Data_mem[Address >> 2]; // Read operation
        end  
    end

endmodule
