module Deslocamento (
	input logic [63:0]In, 
        input [5:0]Num, //numero de deslocamento
        input logic [1:0]Shift,
        output logic [63:0]Out);

	always_comb begin
		case(Shift)
	  		2'b00: begin
				Out = In << Num; //LEFT LOGICO
	  		end

	  		2'b01: begin
	     			Out = In >> Num; //RIGHT LOGICO
	  		end

	  		2'b10: begin
	     			Out = In >>> Num; //RIGHT ARITMETICO
	  		end

	  		2'b11: begin
	     			Out = In;
	  		end
        	endcase 
	end
endmodule
