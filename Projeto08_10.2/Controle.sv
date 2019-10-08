module Controle(
    	input logic clk,
    	input logic rst,
    	input logic [31:0] INSTR,
	input logic AluZero,
	input logic AluMenor,
    	input logic AluIgual,
	output logic [1:0]Shift,
	output logic [5:0]Num,
    	output logic PCwrite,
    	output logic IRWrite,
    	output logic [2:0] AluOperation,
    	output logic MemRead,
    	output logic loadRegA,
    	output logic loadRegB,
    	output logic loadRegAluOut,
    	output logic [2:0]SelMuxA,
	output logic SelMuxAlu,
    	output logic [2:0]SelMuxMem,
    	output logic RegWrite,
    	output logic PCWriteCond,
    	output logic loadRegMemData,
    	output logic MemData_Write,
    	output logic SelMuxPC,
	output logic SelMuxMul,
	output logic SelMuxShift,
    	output logic [2:0]SelMuxB,
	output logic [2:0]LoadTYPE,
	output logic [2:0]StoreTYPE);
 	
	parameter LOAD = 0; //3'b000
    	parameter SUM = 1; //3'b001
    	parameter SUB = 2; //3'b010
	parameter AND = 3; //3'b011
	parameter CMP = 7; //3'b111
 	
    	//ESTADOS DA MÁQUINA DE ESTADOS
    	parameter RESET = 100;
    	parameter FETCH = 101; 
    	parameter DECODE = 102;

	//TIPO R - 10
    	parameter sumOP = 11;
    	parameter subOP = 12;
	parameter andOP = 13;
	parameter sltOP = 14;
	parameter wreg_op = 15;
	parameter mulOP = 84; ///////////////////////////////////////
	parameter mulhOP = 85; ///////////////////////////////////////

	//TIPO I - 20+30
	parameter addiOP1 = 21;
    	parameter addiOP2 = 22;
	parameter sltiOP = 23;
	parameter jalrOP1 = 24;
	parameter jalrOP2 = 25;
	parameter jalrOP3 = 26; 
	parameter jalrOP4 = 27;
	parameter lbOP1 = 28;
 	parameter lhOP1 = 29;
	parameter lwOP1 = 30;
	parameter ldOP1 = 31;
	parameter lbuOP1 = 32;
	parameter lhuOP1 = 33;
	parameter lwuOP1 = 34;
    	parameter loadOP2 = 35;
	parameter loadOP3 = 36;
	parameter loadOP4 = 99;
	parameter nopOP = 37;
	parameter breakOP = 38;
	
	//TIPO I SHIFTS - 40
	parameter srliOP = 41;
	parameter sraiOP = 42;
	parameter slliOP = 43;

	//TIPO S - 50
	parameter sdOP1 = 51;
	parameter swOP1 = 52;
	parameter shOP1 = 53;
	parameter sbOP1 = 54;
	parameter storeOP2 = 55;
	
	//TIPO SB - 60
	parameter beqOP = 61;
    	parameter bneOP = 62;
	parameter bgeOP = 63;
	parameter bltOP = 64;
	
	//TIPO U - 70
	parameter luiOP1 = 71;
	parameter luiOP2 = 72;
	
	//TIPO UJ - 80
	parameter jalOP1 = 81;
	parameter jalOP2 = 82;
	parameter jalOP3 = 83;
	
	//CONTADOR AUXILIAR PARA O LOOP DO MUX
	localparam CONTADORMUL = 8'b00100000;

    	reg [9:0]Estado;
    	reg [9:0]nextState;
 
	always_ff @(posedge rst or posedge clk) begin
        	if (rst) begin
            		Estado = RESET;
        	end
		else begin
			Estado = nextState;
		end
	end

	always_comb begin
		case(Estado)
			RESET: begin
				Shift = 0;
				//LoadTYPE = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
    	        		SelMuxB = 0;
				SelMuxAlu = 0;
    	       			SelMuxMem = 0;
    	       			PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
    	      			MemRead = 0;
    	       			IRWrite = 0;
    	        		loadRegA = 0;
    	       			loadRegB = 0;
    	        		AluOperation = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
				loadRegAluOut = 0;
    	        		nextState = FETCH;
			end

                	FETCH: begin
				Shift = 0;
				LoadTYPE = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 1;
				SelMuxAlu = 0;
			       	SelMuxMem = 1;
			    	PCwrite = 1;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 1;
			    	IRWrite = 1;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
    	                    	nextState = DECODE;
                	end
 
                	DECODE: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 3;
				SelMuxAlu = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 1;
			    	IRWrite = 0;
			    	loadRegA = 1;
			    	loadRegB = 1;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
                        	
				case(INSTR[6:0])
					7'b0000000: begin
						nextState = FETCH; 
					end

					7'b0110011: begin   // Tipo R
                                		if (INSTR[31:25] == 7'b0000000) begin
							if (INSTR [14:12] == 3'b000) begin // add
								nextState = sumOP;
						   	end
							if (INSTR [14:12] == 3'b111) begin // and
								nextState = andOP;
						   	end
							if (INSTR [14:12] == 3'b010) begin // slt
								nextState = sltOP;
						   	end
                                		end
						if (INSTR[31:25] == 7'b0000001) begin
							if (INSTR [14:12] == 3'b000) begin // mul
								nextState = mulOP;
						   	end
							if (INSTR [14:12] == 3'b001) begin // mulh
								nextState = mulhOP;
						   	end
                                		end
                        	        	if (INSTR[31:25] == 7'b0100000) begin // sub
                        	        		nextState = subOP;
                        	        	end
					end
  
	
					7'b0010011: begin   // Tipo I 
						if (INSTR [14:12] == 3'b000) begin // addi
							if(INSTR [31:20] == 12'd0 ) begin // nop
								nextState = nopOP;
							end
							else 
								nextState = addiOP1;
						end
						else if (INSTR [14:12] == 3'b010) begin // slti
							nextState = sltiOP;
					   	end
						else if (INSTR [14:12] == 3'b101) begin 
						   	if (INSTR [31:26] == 6'b000000) begin// srli
						 		nextState = srliOP;
							end
						   	else if (INSTR [31:26] == 6'b010000) begin // srai
						 		nextState = sraiOP;
							end
					   	end
						if (INSTR [14:12] == 3'b001) begin // slli
							nextState = slliOP;
					   	end  
                        	    	end

					7'b1110011: begin  // break
						nextState = breakOP;
					end 
					
					//jalr junto com o bne, blt e bge
					
					7'b0000011: begin  
						if (INSTR [14:12] == 3'b000) begin //lb
							nextState = lbOP1;
					    	end
						if (INSTR [14:12] == 3'b001) begin //lh
							nextState = lhOP1;
					    	end
						if (INSTR [14:12] == 3'b010) begin //lw
							nextState = lwOP1;
					    	end
						if (INSTR [14:12] == 3'b011) begin //ld
							nextState = ldOP1;
					    	end	
						if (INSTR [14:12] == 3'b100) begin //lbu
							nextState = lbuOP1;
					    	end
						if (INSTR [14:12] == 3'b101) begin //lhu
							nextState = lhuOP1;
					    	end
						if (INSTR [14:12] == 3'b110) begin //lwu
							nextState = lwuOP1;
					    	end
					end               
					
					
					7'b0100011: begin   // Tipo S (store)
						if (INSTR [14:12] == 3'b111) begin //sd
							nextState = sdOP1; 
                        	    	   	end	
						if (INSTR [14:12] == 3'b010) begin //sw
							nextState = swOP1; 
                        	    	   	end	
						if (INSTR [14:12] == 3'b001) begin //sh
							nextState = shOP1; 
                        	    	   	end
						if (INSTR [14:12] == 3'b000) begin //sb
							nextState = sbOP1; 
                        	    	   	end
					end

					7'b1100011: begin   // Tipo SB (beq)
                        	                nextState = beqOP;
                        	    	end
	
					7'b1100111: begin   // Tipo SB + jalr
						if (INSTR [14:12] == 3'b000) begin //jalr
							nextState = jalrOP1;
					     	end
						if (INSTR [14:12] == 3'b001) begin //bne
							nextState = bneOP;
					     	end
						if (INSTR [14:12] == 3'b101) begin  //bge
							nextState = bgeOP;
					    	end
						if (INSTR [14:12] == 3'b100) begin  //blt
							nextState = bltOP;
					     	end

                        	        end

					7'b0110111: begin // Tipo U (lui)
						nextState = luiOP1;
					end

					7'b1101111: begin // Tipo UJ (jal)
						nextState = jalOP1;
					end
				endcase //case(INSTR[6:0])
			end //DECODE


			//INICIO DO TIPO R
			sumOP: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = wreg_op;
			end
                                        
			andOP: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = AND;
				nextState = wreg_op;
			end
                                        
			subOP: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUB;
				nextState = wreg_op;
			end

			sltOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
				SelMuxAlu = 1;
			       	SelMuxMem = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = LOAD;
				nextState = wreg_op;
			end

			sltiOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 2;
				SelMuxMul = 0;
				SelMuxShift = 0;
				SelMuxAlu = 1;
			       	SelMuxMem = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = LOAD;
				nextState = wreg_op;
			end

			wreg_op: begin
				Shift = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxMul = 0;
				//SelMuxA = 0;
			    	//SelMuxB = 1;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	//AluOperation = 0;
				nextState = RESET;
			end

			mulOP: begin
				if (INSTR [0] == 3'b001) begin
				
				end
			end

			mulhOP:	begin
	
			end		


			////////////////////////////////////////////////////////////////
			//FIM DO TIPO R

			//TIPO I
			addiOP1: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
    	        		SelMuxB = 2;
    	       			SelMuxMem = 0;
    	       			PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
    	      			MemRead = 0;
    	       			IRWrite = 0;
    	        		loadRegA = 0;
    	       			loadRegB = 0;
    	        		AluOperation = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
				loadRegAluOut = 1;
    	        		nextState = addiOP2;
			end

			addiOP2: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = RESET;
                 	end								

			jalrOP1: begin 
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 1;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 7;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = jalrOP3;
			end
/*
			jalrOP2: begin
				Shift = 0;
				SelMuxPC = 0;
				//SelMuxA = 1;
			    	SelMuxB = 3;
			       	SelMuxMem = 0;
			    	PCwrite = 1;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 1;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	//AluOperation = 0;
				nextState = jalrOP3;
			end
*/
			jalrOP3: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 3;
			       	SelMuxMem = 0;
			    	PCwrite = 1;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = RESET;
			end



			lbOP1: begin
				LoadTYPE = 4;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;
			end

			lhOP1: begin
				LoadTYPE = 3;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;
			end

			lwOP1: begin
				LoadTYPE = 2;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;
			end

			ldOP1: begin
				LoadTYPE = 1;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;
			end

			loadOP2: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 1;
			    	AluOperation = 0;
				nextState = loadOP3;
			end

			loadOP3: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 1;
			    	AluOperation = 0;
				nextState = loadOP4;
			end

			loadOP4: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 0;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end

			lbuOP1: begin
				LoadTYPE = 7;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;
			end

			lhuOP1: begin
				LoadTYPE = 6;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;

			end

			lwuOP1: begin
				LoadTYPE = 5;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = loadOP2;

			end

			nopOP: begin
				nextState = FETCH;
			end

			breakOP: begin
				break;
			end
			//FIM DO TIPO I


			//INICIO DO TIPO I(Shifts)
			srliOP: begin //SHIFT RIGHT LOGICO
				Shift = 2'b01;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				//SelMuxA = 1;
			    	//SelMuxB = 4;
			       	SelMuxMem = 3;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end

			sraiOP: begin //SHIFT RIGHT ARITMETICO
				Shift = 2'b10;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				//SelMuxA = 1;
			    	//SelMuxB = 4;
			       	SelMuxMem = 3;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end

			slliOP: begin //SHIFT LEFT LOGICO
				Shift = 2'b00;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				//SelMuxA = 1;
			    	//SelMuxB = 4;
			       	SelMuxMem = 3;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end
			//FIM DO TIPO I(Shifts)


			//INICIO DO TIPO S
			sdOP1: begin
				StoreTYPE = 1;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	//loadRegA = 0;
			    	//loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = storeOP2;
			end

			storeOP2: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				//SelMuxA = 0;
			    	//SelMuxB = 0;
			       	SelMuxMem = 0;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 1;
			    	IRWrite = 0;
			    	//loadRegA = 0; 
			    	//loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end

			swOP1: begin
				StoreTYPE = 2;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	//loadRegA = 0;
			    	//loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = storeOP2;
			end

			shOP1: begin
				StoreTYPE = 3;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	//loadRegA = 0;
			    	//loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = storeOP2;
			end

			sbOP1: begin
				StoreTYPE = 4;
				Shift = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				AluOperation = SUM;
				SelMuxA = 1;
			    	SelMuxB = 2;
			       	SelMuxMem = 1;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	//loadRegA = 0;
			    	//loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				nextState = storeOP2;
			end
			//FIM DO TIPO S


			//INICIO DO TIPO SB
			beqOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
			       	SelMuxMem = 1;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = SUB;
                                case (AluZero) 
					1: begin
						PCwrite = 1;
					    	SelMuxPC = 1;
					    	PCWriteCond = 1;
                                   	end
                                        0: begin
                                            	PCwrite = 0;
                                            	PCWriteCond = 0;
					end
				endcase
				nextState = RESET;
			end
          
			bneOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
			       	SelMuxMem = 1;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = SUB;
                                case (AluZero) 
					0: begin
						PCwrite = 1;
					    	SelMuxPC = 1;
					    	PCWriteCond = 1;
                                   	end
                                        1: begin
                                            	PCwrite = 0;
                                            	PCWriteCond = 0;
					end
				endcase
				nextState = RESET;
			end

			bgeOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
			       	SelMuxMem = 1;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = CMP;
                                case (AluMenor) 
					0: begin
						PCwrite = 1;
					    	SelMuxPC = 1;
					    	PCWriteCond = 1;
                                   	end
                                        1: begin
                                            	PCwrite = 0;
                                            	PCWriteCond = 0;
					end
				endcase
				nextState = RESET;
			end 

			bltOP: begin
				Shift = 0;
				SelMuxA = 1;
			    	SelMuxB = 0;
				SelMuxMul = 0;
				SelMuxShift = 0;
			       	SelMuxMem = 1;
				RegWrite = 0;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				AluOperation = CMP;
                                case (AluMenor) 
					1: begin
						PCwrite = 1;
					    	SelMuxPC = 1;
					    	PCWriteCond = 1;
                                   	end
                                        0: begin
                                            	PCwrite = 0;
                                            	PCWriteCond = 0;
					end
				endcase
				nextState = RESET;
			end
			//FIM DO TIPO SB


			//INICIO DO TIPO U
			luiOP1: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				//SelMuxA = 0;
			    	//SelMuxB = 2;
			       	//SelMuxMem = 2;
			    	PCwrite = 0;
				PCWriteCond = 0;
				//RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	//AluOperation = 0;
				nextState = luiOP2;
			end 

			luiOP2: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 0;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 2;
			       	SelMuxMem = 2;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
				MemData_Write = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
			    	AluOperation = 0;
				nextState = RESET;
			end
			//FIM DO TIPO U	
		

			//INICIO DO TIPO UJ
			jalOP1: begin 
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 1;
				SelMuxShift = 0;
				SelMuxA = 0;
			    	SelMuxB = 3;
			       	SelMuxMem = 7;
			    	PCwrite = 0;
				PCWriteCond = 0;
				RegWrite = 1;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = jalOP2;
			end

			jalOP2: begin
				Shift = 0;
				SelMuxMul = 0;
				SelMuxPC = 1;
				SelMuxShift = 0;
				SelMuxA = 1;
			    	SelMuxB = 3;
			       	SelMuxMem = 0;
			    	PCwrite = 1;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 0;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = RESET;
			end



			/*jalOP3: begin
				Shift = 0;
				SelMuxPC = 1;
				//SelMuxA = 2;
			    	SelMuxB = 0;
			       	SelMuxMem = 6;
			    	PCwrite = 1;
				PCWriteCond = 0;
				RegWrite = 0;
			    	MemRead = 0;
			    	IRWrite = 0;
			    	loadRegA = 0;
			    	loadRegB = 0;
				loadRegAluOut = 1;
				loadRegMemData = 0;
				MemData_Write = 0;
			    	AluOperation = SUM;
				nextState = RESET;
				
			end*/
			//FIM DO TIPO UJ

            	endcase //case(state)
        end
endmodule
