module mux3_in
	(output logic [64-1:0] f_3in,
	input logic [64-1:0] MuxA_a,MuxA_b,MuxA_c,
	input logic [2:0]SelMux3);

	always_comb begin
	    	case(SelMux3) 
			0: begin
				f_3in = MuxA_a;
			end 
	
			1: begin
				f_3in = MuxA_b;
			end
	
			2: begin
				f_3in = MuxA_c;
			end  
		endcase 
	end
endmodule
