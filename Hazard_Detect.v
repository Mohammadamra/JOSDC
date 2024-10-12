module Hazard_Detect (
input pcsrc, 
input B_Taken,
output reg flush
);

//hazard detection logic 

assign Flush = (pcsrc) ? 1'b1 : (B_Taken) ? 1'b1 : 1'b0;

//if the pcsrc is high we will set the flush signal to high (high pcsrc => branch or jump)
//if its low we will check the branch if its taken or not 
endmodule 