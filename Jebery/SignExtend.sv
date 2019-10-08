module SignExtend (
	input logic [31:0] entrada,
     	output logic [63:0] saida);
 
	reg [31:0] immed;
	reg[6:0] aux;
 
	assign aux[6:0] = entrada[6:0];
 
	always_comb begin
		if(aux == 7'b0010011) begin // tipo I(LD)
			if(entrada[14:12] == 3'b000)begin
    				immed[11:0] = entrada[31:20];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   	
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end
		end

    		if(aux == 7'b0000011) begin // tipo I(LD)
			if(entrada[14:12] == 3'b011)begin
    				immed[11:0] = entrada[31:20];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   	
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end

			if(entrada[14:12] == 3'b000)begin // TIPO I LB
        			saida [7:0] = entrada[27:20];
        			if(saida[7] == 1) begin
            			saida [63:8] = 56'hffffffffffffff;
            			end
   
        			else begin
            			saida [63:8] = 56'h00000000000000;
            			end

			end

			if(entrada[14:12] == 3'b001)begin // TIPO I LH
        			saida [11:0] = entrada[31:20];
				
				if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end

			end

			if(entrada[14:12] == 3'b010)begin // TIPO I LW
        			saida [11:0] = entrada[31:20];
				
				if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end

			end

			if(entrada[14:12] == 3'b100)begin // TIPO I LBU
        			saida [7:0] = entrada[27:20];
        			if(saida[7] == 1) begin
            			saida [63:8] = 56'hffffffffffffff;
            			end
   
        			else begin
            			saida [63:8] = 56'h00000000000000;
            			end

			end

			if(entrada[14:12] == 3'b101)begin // TIPO I LHU
        			saida [11:0] = entrada[31:20];
				
				if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end

			end

			if(entrada[14:12] == 3'b110)begin // TIPO I LWU
        			saida [11:0] = entrada[31:20];
				
				if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end
     		end

    		if(aux == 7'b0100011) begin //tipo S(SD)
			if(entrada[14:12] == 3'b111)begin
        			immed[4:0] = entrada[11:7];
        			immed[11:5]= entrada[31:25];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end

			if(entrada[14:12] == 010) begin	//SW
        			immed[4:0] = entrada[11:7];
        			immed[11:5]= entrada[31:25];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end

			if(entrada[14:12] == 001) begin		//SH
        			immed[4:0] = entrada[11:7];
        			immed[11:5]= entrada[31:25];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end

			if(entrada[14:12] == 000) begin		//SB
        			immed[4:0] = entrada[11:7];
        			immed[11:5]= entrada[31:25];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
			end

    		end
 
		if(aux == 7'b1100111) begin
			if(entrada[14:12] == 3'b000 ) begin //jalr
				immed[11:0] = entrada[31:20];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
     			end

	        	if(entrada[14:12] == 3'b001 || entrada[14:12] == 3'b100 || entrada[14:12] == 3'b101) begin //bne blt bge
        			
        			if(entrada[31] == 0) begin
            				saida = {51'd0, entrada[31], entrada[7], entrada[30:25], entrada[11:8],1'b0};
            			end
        			else begin
            				saida = {51'h7ffffffffffff, entrada[31], entrada[7], entrada[30:25], entrada[11:8],1'b0};
            			end
        		end
		end

		if(aux == 7'b1101111) begin
			if(entrada[14:12] == 3'b000 ) begin //jal
				immed[11:0] = entrada[31:20];
        			saida [11:0] = immed [11:0];
        			if(immed[11] == 1) begin
            				saida [63:12] = 52'hfffffffffffff;
            			end
   
        			else begin
            				saida [63:12] = 52'h0000000000000;
            			end
     			end
		end

        	if(aux == 7'b1100011) begin //Tipo SB(beq)
        		immed[12] = entrada[31];
        		immed[11] = entrada[7];
        		immed[10:5] = entrada[30:25];
        		immed[4:1] = entrada[11:8];
        		immed[0] = 0;
        		saida [12:0] = immed [12:0];
        		if(immed[12] == 1) begin
            			saida [63:12] = 52'hfffffffffffff;
            		end
   
        		else begin
            			saida [63:12] = 52'h0000000000000;
            		end
        	end
 
        	if(aux == 7'b0110111) begin //Tipo U(lui)
			immed [11:0] = 12'h000;  
        		immed [31:12]= entrada[31:12];
        		saida [31:0] = immed [31:0];
        		if(immed[31]) begin
            			saida [63:32] = 32'hffffffff;
            		end
        		else begin
            			saida [63:32] = 32'h00000000;
            		end
        	end
 	end
endmodule 