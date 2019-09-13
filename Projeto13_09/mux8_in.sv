module mux8_in ( 
	output logic [64-1:0] f_8in,
	input logic [64-1:0] MuxB_a,MuxB_b,MuxB_c,MuxB_d,MuxB_e,MuxB_f, MuxB_g,MuxB_h,
	input logic [2:0]SelMux8);

	always_comb begin
    		case(SelMux8) 
			0: begin
				f_8in = MuxB_a;
			end 

			1: begin
				f_8in = MuxB_b;
			end 

			2: begin
				f_8in = MuxB_c;
			end 

			3: begin
	 			f_8in = MuxB_d;
			end 

			4: begin 
				f_8in = MuxB_e;
			end

			5: begin 
				f_8in = MuxB_f;
			end

			6: begin 
				f_8in = MuxB_g;
			end

			7: begin 
				f_8in = MuxB_h;
			end
		endcase 
	end
endmodule
