module StoreBlock(
	input logic [63:0]Entrada,
	input logic [63:0]RegBIn_Mem,
	input logic [2:0]StoreTYPE,
	output logic [63:0]StoreResult);
	
	always_comb begin
		case (StoreTYPE)
			1: begin // sd
				StoreResult = RegBIn_Mem;
			end

			2: begin // sw
				StoreResult={Entrada[63:32],RegBIn_Mem[31:0]};
			end

			3: begin // sh
				StoreResult={Entrada[63:16],RegBIn_Mem[15:0]};
			end

			4: begin // sb
				StoreResult={Entrada[63:8],RegBIn_Mem[7:0]};
			end

			default: begin
				
			end
		endcase	
	end
endmodule //StoreBlock





