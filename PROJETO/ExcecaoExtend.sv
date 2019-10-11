module ExcecaoExtend (
	input logic [7:0] entrada,
     	output logic [63:0] saida);
 
	reg[7:0] aux;
 
	assign aux[7:0] = entrada[7:0];
 
	always_comb begin
		saida [7:0] = entrada [7:0];
            	saida [63:8] = 56'd0;
        end
endmodule

