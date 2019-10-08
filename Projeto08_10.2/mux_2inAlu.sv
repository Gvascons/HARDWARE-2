module mux_2inAlu (
	output logic [64-1:0] f_2in,
	input logic [64-1:0] MuxA_a,
	input logic MuxA_b,
	input logic SelMux2);

	always_comb begin
	    	case(SelMux2) 
			0: begin
				f_2in = MuxA_a;
			end 

			1: begin
				f_2in[63:1] = 63'd0;
				f_2in[0] = MuxA_b;
			end 
		endcase 
	end
endmodule
