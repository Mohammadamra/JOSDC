module controlUnit(
input [5:0] opcode, func,
output reg [2:0] aluop, 
output reg [1:0] regdst, memtoreg,
output reg alusrc, regwrite, memread, memwrite, branch, jump, pcsrc
);
	
	// Function field parameters for R type
	parameter 
			orFunct  = 6'b000000,
			andFunct = 6'b000001,
			xorFunct = 6'b000010,
			addFunct = 6'b000011,
			norFunct = 6'b000100,
			nandFunct= 6'b000101,
			sltFunct = 6'b000110, 
			subFunct = 6'b000111,
			jrFunct  = 6'b001000;
			  
	// Opcode parameters for all instructino, note that all R type instructions have the same opCode = 0
	parameter  
			_rtype = 6'b000000,
			_ori   = 6'b010000,
			_andi  = 6'b010001,
			_xori  = 6'b010010,
			_addi  = 6'b010011,
			_nori  = 6'b010100,
			_nandi = 6'b010101,
			_slti  = 6'b010110,
			_subi  = 6'b010111,
			_lw    = 6'b100011,
			_sw    = 6'b101011,
			_beq   = 6'b110000,
			_j     = 6'b110001,
			_jal   = 6'b110011;
		
	//Generate signals
	always @ (*) begin
	
		case (opcode)
			
			// R-Type instructions
			_rtype: 
				
				case (func)
					
					// OR 
					orFunct: begin
						aluop    = 3'b000;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc     = 1'b0  ;
					end // ~~~> orFunct: end 
					
					// AND
					andFunct: begin
						aluop    = 3'b001;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> andFunct: end
					
					// XOR
					xorFunct: begin
						aluop    = 3'b010;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> xorFunct: end
					
					// ADD
					addFunct: begin
						aluop    = 3'b011;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> addFunct: end
					
					// NOR
					norFunct: begin
						aluop    = 3'b100;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> norFunct: end
					
					// NAND
					nandFunct: begin
						aluop    = 3'b101;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> nandFunct: end
					
					// SLT
					sltFunct: begin
						aluop    = 3'b110;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> sltFunct: end
					
					// SUB
					subFunct: begin
						aluop    = 3'b111;
						alusrc   = 1'b0  ; 
						regdst   = 2'b01 ;
						memtoreg = 2'b00 ;
						regwrite = 1'b1  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b0  ;
					end // ~~~> subFunct: end
					
					// JR
					jrFunct: begin
						aluop    = 3'bx;
						alusrc   = 1'bx  ; 
						regdst   = 2'bx ;
						memtoreg = 2'bx ;
						regwrite = 1'b0  ;
						memread  = 1'b0  ;
						memwrite = 1'b0  ;
						branch   = 1'b0  ; 
						jump     = 1'b0  ;
						pcsrc    = 1'b1  ;
					end //  jrFunct: ~~~> end
					
				endcase // case (func) ~~~> end
					
			// I-Type Instructions
			
			// ORI
			_ori: begin
				aluop    = 3'b000;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end //  _ori: ~~~> end
			
			// ANDI
			_andi: begin
				aluop    = 3'b001;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end //  _andi: ~~~> end
			
			// XORI
			_xori: begin
				aluop    = 3'b010;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _xori: ~~~> end
			
			// ADDI
			_addi: begin
				aluop    = 3'b011;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _addi: ~~~> end
			
			// NORI
			_nori: begin
				aluop    = 3'b100;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _nori: ~~~> end
			
			// NANDI
			_nandi: begin
				aluop    = 3'b101;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _nandi: ~~~> end
			
			// SLTI
			_slti: begin
				aluop    = 3'b110;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _slti: ~~~> end
			
			// SUBI
			_subi: begin
				aluop    = 3'b111;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b00 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _subi: ~~~> end
			
			// LW
			_lw: begin
				aluop    = 3'b011;
				alusrc   = 1'b1  ; 
				regdst   = 2'b00 ;
				memtoreg = 2'b01 ;
				regwrite = 1'b1  ;
				memread  = 1'b1  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _lw: ~~~> end
			
			// SW
			_sw: begin
				aluop    = 3'b011;
				alusrc   = 1'b1  ; 
				regdst   = 2'bx ;
				memtoreg = 2'bx ;
				regwrite = 1'b0  ;
				memread  = 1'b0  ;
				memwrite = 1'b1  ;
				branch   = 1'b0  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _sw: ~~~> end
			
			// BEQ
			_beq: begin
				aluop    = 3'bx;
				alusrc   = 1'bx  ; 
				regdst   = 2'bx ;
				memtoreg = 2'bx ;
				regwrite = 1'b0  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b1  ; 
				jump     = 1'b0  ;
				pcsrc    = 1'b0  ;
			end // _beq: ~~~> end
			
			// J
			_j: begin
				aluop    = 3'bx;
				alusrc   = 1'bx  ; 
				regdst   = 2'bx ;
				memtoreg = 2'bx ;
				regwrite = 1'b0  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b1  ;
				pcsrc    = 1'b1  ;
			end // _j: ~~~> end
			
			// JAL
			_jal: begin
				aluop    = 3'bx;
				alusrc   = 1'bx  ; 
				regdst   = 2'b10 ;
				memtoreg = 2'b10 ;
				regwrite = 1'b1  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'b0  ; 
				jump     = 1'b1  ;
				pcsrc    = 1'b1  ;
			end // _jal: ~~~> end
			
			// Default 
			default: begin
				aluop    = 3'bx;
				alusrc   = 1'bx  ; 
				regdst   = 2'bx ;
				memtoreg = 2'bx ;
				regwrite = 1'b0  ;
				memread  = 1'b0  ;
				memwrite = 1'b0  ;
				branch   = 1'bx  ; 
				jump     = 1'bx  ;
				pcsrc    = 1'bx  ;
			end // _jal: ~~~> end
	
		endcase //  case (opcode) ~~~> end
		
	end // always @ (*)  ~~~> end 

endmodule
			   

