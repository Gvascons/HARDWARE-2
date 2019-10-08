module LoadBlock(
	input logic [63:0]Entrada,
	input logic [2:0]LoadTYPE,
	output logic [63:0]LoadResult);
	
	always_comb begin
		case(LoadTYPE)
			1: begin //LD
				LoadResult = Entrada;
			end		
			
			2: begin //LW
				if(Entrada[31] == 0) begin
					LoadResult = {32'b0, Entrada[31:0]};
				end
				else begin
					LoadResult = {32'hFFFFFFFF, Entrada[31:0]};
				end
			end
			
			3: begin //LH
				if(Entrada[15] == 0) begin
					LoadResult = {48'b0, Entrada[15:0]};
				end
				else begin
					LoadResult = {48'hFFFFFFFFFFFF, Entrada[15:0]};
				end
			end
			
			4: begin //LB
				if(Entrada[7] == 0) begin
					LoadResult = {56'b0, Entrada[7:0]};
				end
				else begin
					LoadResult = {56'hFFFFFFFFFFFFFF, Entrada[7:0]};
				end
			end
			
			5: begin //LWU
				LoadResult = {32'b0, Entrada[31:0]};
			end
			
			6: begin //LHU
				LoadResult = {48'b0, Entrada[15:0]};
			end
			
			7: begin //LBU
				LoadResult = {56'b0, Entrada[7:0]};
			end
		endcase	
	end
endmodule //LoadBlock




