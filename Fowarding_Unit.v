module Forwarding_Unit (
    input [4:0] ex_mem_dest_reg,      // Destination register in EX/MEM stage
    input [4:0] mem_wb_dest_reg,      // Destination register in MEM/WB stage
    input [4:0] id_ex_source_reg1,    // Source register 1 (Rs) in ID/EX stage
    input [4:0] id_ex_source_reg2,    // Source register 2 (Rt) in ID/EX stage
    input ex_mem_reg_write,           // RegWrite signal in EX/MEM stage (indicates if the destination register is written)
    input mem_wb_reg_write,           // RegWrite signal in MEM/WB stage (indicates if the destination register is written)
    output reg [1:0] forward_a,       // Forwarding control signal for ALU input A (source 1)
    output reg [1:0] forward_b        // Forwarding control signal for ALU input B (source 2)
);

// Forwarding from EX/MEM stage to ALU input A and B
// Check if the EX/MEM stage destination register matches the source registers in the ID/EX stage
// and whether the EX/MEM stage is writing to a register (ex_mem_reg_write == 1).

always @(*) begin
    // Forward to ALU input A (source register 1)
    forward_a[0] = (ex_mem_reg_write && (ex_mem_dest_reg == id_ex_source_reg1) && (ex_mem_dest_reg != 0));

    // Forward to ALU input B (source register 2)
    forward_b[0] = (ex_mem_reg_write && (ex_mem_dest_reg == id_ex_source_reg2) && (ex_mem_dest_reg != 0));
end

// Forwarding from MEM/WB stage to ALU input A and B
// Similar to the EX/MEM stage, but forwarding occurs if the MEM/WB stage destination register
// matches the source registers in the ID/EX stage, as long as the EX/MEM stage isn't already forwarding
// to those registers or the EX/MEM stage isn't writing.

always @(*) begin
    // Forward to ALU input A (source register 1)
    forward_a[1] = (mem_wb_reg_write && (mem_wb_dest_reg == id_ex_source_reg1) && 
                   ((ex_mem_dest_reg != id_ex_source_reg1) || (ex_mem_reg_write == 0)) && (mem_wb_dest_reg != 0));

    // Forward to ALU input B (source register 2)
    forward_b[1] = (mem_wb_reg_write && (mem_wb_dest_reg == id_ex_source_reg2) &&
                   ((ex_mem_dest_reg != id_ex_source_reg2) || (ex_mem_reg_write == 0)) && (mem_wb_dest_reg != 0));
end

endmodule
