module processor(clk, reset);
	
	// clock and reset
	input clk, reset;

	/*********    wires in fetch stage    *********/  
	
	// Output of PC Register
	wire [31:0] pcOut;
	// Outputs of Instruction Memory
	wire [31:0] instMemOut;
	//Output of PC Adder
	wire [31:0] pcAdderResult;

	/*********    wires in decode stage    *********/ 
	
	// Outputs of IFID PIPE (decode stage)
	wire [31:0] instMemOut_IFID_out;
	wire [31:0]  pcAdderResult_IFID_out;
	// Instruction fields 
	wire [5:0]  opCode             = instMemOut_IFID_out    [31:26];
	wire [5:0]  funct              = instMemOut_IFID_out    [5 :0 ];
	wire [4:0]  rdAddress          = instMemOut_IFID_out    [15:11];
	wire [4:0]  rtAddress          = instMemOut_IFID_out    [20:16];
	wire [4:0]  rsAddress          = instMemOut_IFID_out    [25:21];
	wire [15:0] immediateData      = instMemOut_IFID_out    [15:0 ];
	wire [31:0] shamt = {{27{1'b0}}, instMemOut_IFID_out    [10:6]};
	wire [25:0] jumpAddress        = instMemOut_IFID_out    [25:0 ];
	
	// Outputs of Register File
	wire [31:0] data1, data2;
	// Output of the Sign extender
	wire [31:0] extendedImm;
	// Output of shifter2bit26input
	wire [27:0] shifter28out;
	// Output of shifter2bit32input
	wire [31:0] shiftedBranchAddress;
	// Output of the Comparator
	wire equal;	
	// branchTaken And gate
	wire branchTaken;
	// Jump target address
	wire [31:0] jumpTA ;
	// Output of the the Adder to calculate branch target address
	wire [31:0] branchTA;
	//Outputs of Control Unit in decode stage
	wire [1:0] RegDst    ;
	wire       Branch    ; 
	wire       MemReadEn ;
	wire [1:0] MemtoReg  ;
	wire [2:0] ALUOp     ;
	wire       MemWriteEn;
	wire       ALUSrc    ;
	wire       RegWriteEn;
	wire       pcSRC     ;
	wire       Jump      ;
	
	/*********    wires in execute stage    *********/ 
	
	// Outputs of IDEX PIPE (execute stage)
	
	// Outputs of the Alu
	wire [31:0] aluResult;	
	wire [31:0] data1_IDEX_out;
	wire [31:0] data2_IDEX_out;
	// Output of ALU Source Mux
	wire [31:0] aluSrcMuxOut;
	wire [4:0]  rdAddress_IDEX_out;
	wire [4:0]  rsAddress_IDEX_out;
	wire [4:0]  rtAddress_IDEX_out;
	wire [31:0] pcAdderResult_IDEX_out;
	
	//Outputs of Control Unit in execute stage
	wire [1:0] RegDst_IDEX_out    ;
	wire       MemReadEn_IDEX_out ;
	wire [1:0] MemtoReg_IDEX_out  ;
	wire [2:0] ALUOp_IDEX_out     ;
	wire       MemWriteEn_IDEX_out;
	wire       ALUSrc_IDEX_out    ;
	wire       RegWriteEn_IDEX_out;
	// Destination Register Address Mux
	wire [4:0] destReg_muxOut;
	wire [31:0] extendedImm_IDEX_out;
	
	/*********    wires in memory stage     *********/ 
	
	
	wire       MemWriteEn_EXMEM_out;
	wire       RegWriteEn_EXMEM_out;
	wire [1:0] MemtoReg_EXMEM_out  ;
	wire       MemReadEn_EXMEM_out ;
	wire [4:0] destReg_muxOut_EXMEM_out;
	wire [31:0] data2_EXMEM_out;
	wire [31:0] aluResult_EXMEM_out;
	wire [31:0] pcAdderResult_EXMEM_out;
	// Output of the Data Memory
	wire [31:0] dataMemOut;
	
	/*********    wires in write back stage     *********/ 
	
	// Output of Write Back Mux
	wire [31:0] WbMuxOut;
	wire [31:0] pcAdderResult_MEMWB_out;
	wire       RegWriteEn_MEMWB_out;
	wire [1:0] MemtoReg_MEMWB_out;
	wire [4:0] destReg_muxOut_MEMWB_out;
	wire [31:0] aluResult_MEMWB_out;
	wire [31:0] dataMemOut_MEMWB_out;
	
	
	// Output of Branch Mux
	wire [31:0] branchMuxOut;
	
	// Output of Jump Mux
	wire [31:0] jumpMuxOut;
	
	// Output of PC Mux
	wire [31:0] pcMuxOut;
	
	// Forwarding Unit Outputs
	wire [1:0] ForwardA, ForwardB;
	
	// output of forwarding mux1
	wire [31:0]op1FwMux_out;
	
	// output of forwarding mux2
	wire [31:0]op2FwMux_out;
	
	// Flush signal
	wire Flush;
	
	// IFID Reset
	wire IFID_RESET;
	
	/*********    Outputs and inputs of Pipes     *********/ 
	
	wire [153:0] IDEX_in , IDEX_out ;
	wire [63:0]  IFID_in , IFID_out ;
	wire [105:0] EXMEM_in, EXMEM_out;
	wire [103:0] MEMWB_in, MEMWB_out;
	
	
	////////////////            Fetch Stage         //////////////////
	
	// PC Register
	pcRegister _pcReg (.in(pcMuxOut), .reset(reset), .PcWriteEn(1'b1), .clk(clk), .out(pcOut) );

	// Instruction Memory
	instructionMemory _instMem (.PC(pcOut), .instruction(instMemOut));
	
	// PC Adder
	adder _pcAdder (.in0(32'd4), .in1(pcOut), .out(pcAdderResult));
	
	// combined inputs of IFID pipe
	assign IFID_in = {pcAdderResult, instMemOut};
	
	// IFID PIPE
	IFID _IFID_PIPE ( .clk(clk), .reset(IFID_RESET), .enable(1'b1), .in(IFID_in), .out(IFID_out) );
	
	
	
	////////////////            Decode Stage         //////////////////
	
	// Outputs of the IFID PIPE
	assign {pcAdderResult_IFID_out, instMemOut_IFID_out} = IFID_out;
		
	// Control Unit
	controlUnit _ctrlUnit(.aluop(ALUOp), .alusrc(ALUSrc), .regdst(RegDst), .memtoreg(MemtoReg), .regwrite(RegWriteEn), .memread(MemReadEn), .memwrite(MemWriteEn), .branch(Branch), .jump(Jump), .pcsrc(pcSRC) , .opcode(opCode), .func(funct)); 

	// Register File
	regFile _regFile(.clock(clk), .reset(reset), .readData1(data1), .readData2(data2), .writeReg(destReg_muxOut_MEMWB_out), .readReg1(rsAddress), .readReg2(rtAddress), .writeEnable(RegWriteEn_MEMWB_out), .writeData(WbMuxOut) );

	// Left Shifter 26 bits by 2
	shift2bit26input _leftShifter_26(.in(jumpAddress), .out(shifter28out));
	
	// Sign extender
	signExtend _signExtender(.in(immediateData), .out(extendedImm));
	
	// Left Shifter 32 bits by 2
	shift2bit32input _leftShifter_32(.in(extendedImm), .out(shiftedBranchAddress));
	
	// Comparator
	comparator _comp (.in0(data1), .in1(data2), .equ(equal));
	
	// Branch Taken
	assign branchTaken = equal && Branch;
	
	// Branch Target Address Adder
	adder _branchTAadder (.in0(pcAdderResult_IFID_out), .in1(shiftedBranchAddress), .out(branchTA));
	
	// Jump Target Address
	assign      jumpTA = {pcAdderResult_IFID_out[31:28],shifter28out};
	
	// combined inputs of IDEX pipe
	assign IDEX_in = {rdAddress, rtAddress, rsAddress, extendedImm, data2, data1, pcAdderResult_IFID_out, MemWriteEn, ALUSrc, RegWriteEn, ALUOp, MemtoReg, MemReadEn, RegDst};
	
	// IDEX PIPE
	IDEX _IDEX_PIPE ( .clk(clk), .reset(reset), .enable(1'b1), .in(IDEX_in), .out(IDEX_out) );
	
	////////////////            Execute Stage         //////////////////
	
	// Outputs of the IDEX PIPE
	assign {rdAddress_IDEX_out, rtAddress_IDEX_out, rsAddress_IDEX_out, extendedImm_IDEX_out, data2_IDEX_out, data1_IDEX_out, pcAdderResult_IDEX_out, MemWriteEn_IDEX_out, ALUSrc_IDEX_out, RegWriteEn_IDEX_out, ALUOp_IDEX_out, MemtoReg_IDEX_out, MemReadEn_IDEX_out, RegDst_IDEX_out} = IDEX_out;
	
	// Operand1 Forwarding Mux 
	mux_4x1 #(.dataWidth(32)) _op1ForwardingMux(.in0(data1_IDEX_out), .in1(aluResult_EXMEM_out), .in2(WbMuxOut), .in3(), .s(ForwardA), .out(op1FwMux_out));
	
	// ALU 
	ALU _alu(.A(op1FwMux_out), .B(aluSrcMuxOut), .m(ALUOp_IDEX_out), .result(aluResult));
	
	//  Destination Register Address Mux (5 bit) 
	mux_4x1 #(.dataWidth(5)) _regDestMux(.in0(rtAddress_IDEX_out), .in1(rdAddress_IDEX_out), .in2(5'd31), .in3(), .s(RegDst_IDEX_out), .out(destReg_muxOut));
	
	// Operand2 Forwarding Mux 
	mux_4x1 #(.dataWidth(32)) _op2ForwardingMux(.in0(data2_IDEX_out), .in1(aluResult_EXMEM_out), .in2(WbMuxOut), .in3(), .s(ForwardB), .out(op2FwMux_out));

	// ALU Source Mux
	mux_2x1 _aluSrcMux(.in0(op2FwMux_out), .in1(extendedImm_IDEX_out), .s(ALUSrc_IDEX_out), .out(aluSrcMuxOut));
	
	// combined inputs of EXMEM pipe
	assign EXMEM_in ={destReg_muxOut, data2_IDEX_out, aluResult, pcAdderResult_IDEX_out, MemWriteEn_IDEX_out, RegWriteEn_IDEX_out, MemtoReg_IDEX_out, MemReadEn_IDEX_out};
	
	// EXMEM PIPE
	EXMEM _EXMEM_PIPE ( .clk(clk), .reset(reset), .enable(1'b1), .in(EXMEM_in), .out(EXMEM_out) );
	
	////////////////            Memory Stage         //////////////////
	
	// Outputs of the EXMEM PIPE
	assign {destReg_muxOut_EXMEM_out, data2_EXMEM_out, aluResult_EXMEM_out,pcAdderResult_EXMEM_out,  MemWriteEn_EXMEM_out, RegWriteEn_EXMEM_out, MemtoReg_EXMEM_out, MemReadEn_EXMEM_out} = EXMEM_out;
	
	// Data Memory
	dataMemory _dataMemory(.readdata(dataMemOut), .address(aluResult_EXMEM_out), .writedata(data2_EXMEM_out), .memwrite(MemWriteEn_EXMEM_out), .memread(MemReadEn_EXMEM_out), .clk(clk)); 
	
	// combined inputs of MEMWB pipe
	assign MEMWB_in = {destReg_muxOut_EXMEM_out, aluResult_EXMEM_out, dataMemOut, pcAdderResult_EXMEM_out, RegWriteEn_EXMEM_out, MemtoReg_EXMEM_out};
	
	// MEMWB PIPE
	MEMWB _MEMWB_PIPE ( .clk(clk), .reset(reset), .enable(1'b1), .in(MEMWB_in), .out(MEMWB_out) );
	
	
	////////////////            Write Back Stage         //////////////////
	
	// Outputs of the MEMWB PIPE
	assign {destReg_muxOut_MEMWB_out, aluResult_MEMWB_out, dataMemOut_MEMWB_out, pcAdderResult_MEMWB_out, RegWriteEn_MEMWB_out, MemtoReg_MEMWB_out} = MEMWB_out;
	
	// Write Back Mux 
	mux_4x1 #(.dataWidth(32)) _rightBackMux(.in0(aluResult_MEMWB_out), .in1(dataMemOut_MEMWB_out), .in2(pcAdderResult_MEMWB_out), .in3(), .s(MemtoReg_MEMWB_out), .out(WbMuxOut));
	
	
	//////////////////////////////////////////////////////////////////////
	// Branch Mux
	mux_2x1 _branchMux(.in0(pcAdderResult), .in1(branchTA), .s(branchTaken), .out(branchMuxOut));

	// Jump Mux
	mux_2x1 _jumpMux(.in0(data1), .in1(jumpTA), .s(Jump), .out(jumpMuxOut));
	
	// PC Mux
	mux_2x1 _pcMux(.in0(branchMuxOut), .in1(jumpMuxOut), .s(pcSRC), .out(pcMuxOut));
	//////////////////////////////////////////////////////////////////////
	
	
	/////////////        Forwarding Unit        ///////////////////////////
	
	forwardingUnit _forwardingUnit(.ForwardA(ForwardA), .ForwardB(ForwardB), .EXMEM_Rd(destReg_muxOut_EXMEM_out), .MEMWB_Rd(destReg_muxOut_MEMWB_out), .IDEX_Rs(rsAddress_IDEX_out), .IDEX_Rt(rtAddress_IDEX_out), .EXMEM_RegWrite(RegWriteEn_EXMEM_out), .MEMWB_RegWrite(RegWriteEn_MEMWB_out));
	
		
	/////////////         Hazard Detection Unit       //////////////////////////
	hazardDetectionUnit _HDU(.Flush(Flush), .pcsrc(pcSRC), .takenbranch(branchTaken));	
	assign IFID_RESET = (~Flush) && reset;
	
endmodule
