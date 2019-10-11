 `timescale 1ps/1ps

module simulacao32;

	logic clk;
	logic rst;
	logic MemRead; 
	logic [2:0]SelMuxA;
	logic [2:0]SelMuxB;
	logic [2:0]SelMuxMem;
	logic SelMuxAlu;
	logic SelMuxPC;
	logic SelMuxMul;
	logic SelMuxShift;
     	logic PCwrite;
	logic IRWrite;
	logic RegWrite;
	logic loadRegA;
	logic loadRegB;
	logic loadRegMemData;
	logic loadRegAluOut;
	logic MemData_Write;
	logic [63:0] PC;
	logic [63:0] EPC;
	logic [63:0] AluExit;
 	logic [63:0] RegA_Exit;
	logic [63:0] RegB_Exit;
 	logic [63:0] AluOut;
	logic [63:0] MemData;
	logic [63:0] MemDataReg_Exit;
	logic [4:0] i19_15;
	logic [4:0] i24_20;
	logic [4:0] WriteRegister;
	logic [6:0] i6_0;
	logic [31:0] i31_0;
	logic [63:0] SignExit;
	logic [63:0] ShiftExit;
	logic [63:0] ShiftLeftExit;
	logic [31:0] MemExit;
	logic [63:0] MuxA_Exit;
	logic [63:0] MuxB_Exit;
	logic [63:0] WriteDataReg;
	logic [63:0] MuxPC_Exit;
	logic [63:0] MuxMul_Exit;
	logic [63:0] MuxShift_Exit;
	logic [63:0] MuxAlu_Exit;
	logic [63:0]dataout1;
	logic [63:0]dataout2;
	logic [5:0] Num;
        logic [1:0] Shift;
	logic [2:0] AluOperation;
	logic AluZero;
	logic AluMenor;
	logic AluIgual;
	logic PCWriteCond;
        logic [2:0]LoadTYPE;
        logic [2:0]StoreTYPE;
	logic [63:0]LoadResultExit;
	logic [63:0]Store_Exit;
	//Memoria32 meminst (.raddress(rdaddress), .waddress(wdaddress),
	//.Clk(clk), .Datain(data), .Dataout(q), .Wr(Wr));

	UP up(
	   .clk(clk),
	   .rst(rst),
	   .MemRead(MemRead), 
	   .SelMuxA(SelMuxA),
	   .SelMuxB(SelMuxB),
	   .SelMuxMem(SelMuxMem),
	   .SelMuxPC(SelMuxPC),
	   .SelMuxMul(SelMuxMul),
	   .SelMuxShift(SelMuxShift),
	   .SelMuxAlu(SelMuxAlu),
     	   .PCwrite(PCwrite),
	   .IRWrite(IRWrite),
	   .RegWrite(RegWrite),
	   .loadRegA(loadRegA),
	   .loadRegB(loadRegB),
	   .loadRegMemData(loadRegMemData),
	   .loadRegAluOut(loadRegAluOut),
	   .LoadResultExit(LoadResultExit),
	   .MemData_Write(MemData_Write),	
	   .PC(PC),
	   .EPC(EPC),
	   .AluExit(AluExit),
 	   .RegA_Exit(RegA_Exit),
	   .RegB_Exit(RegB_Exit),
 	   .AluOut(AluOut),
	   .MemData(MemData),
	   .ShiftExit(ShiftExit),
	   .MemDataReg_Exit(MemDataReg_Exit),
	   .i19_15(i19_15),
	   .i24_20(i24_20),
	   .WriteRegister(WriteRegister),
	   .i6_0(i6_0),
	   .i31_0(i31_0),
	   .SignExit(SignExit),
	   .ShiftLeftExit(ShiftLeftExit),
	   // .ShiftExit(ShiftExit),
	   .MemExit(MemExit),
	   .MuxA_Exit(MuxA_Exit),
	   .MuxB_Exit(MuxB_Exit),
	   .WriteDataReg(WriteDataReg),
	   .MuxPC_Exit(MuxPC_Exit),
	   .MuxMul_Exit(MuxMul_Exit),
	   .MuxShift_Exit(MuxShift_Exit),
	   .MuxAlu_Exit(MuxAlu_Exit),
	   .dataout1(dataout1),
	   .dataout2(dataout2),
	   .Num(Num),
           .Shift(Shift),
	   .AluOperation(AluOperation),
	   .PCWriteCond(PCWriteCond),
	   //.AluMenor(AluMenor),
	   .AluMenor(AluMenor),
	   .AluZero(AluZero),
	   .AluIgual(AluIgual),
	   .LoadTYPE(LoadTYPE),
	   .StoreTYPE(StoreTYPE),
	   .Store_Exit(Store_Exit));


	//gerador de clock e reset
	localparam CLKPERIOD = 10000;
	localparam CLKDELAY = CLKPERIOD / 2;
	
	initial begin
		clk = 1'b1;
		rst = 1'b0; 
		#(CLKPERIOD)
			rst = 1'b1;
		#(CLKPERIOD)
		rst = 1'b0;
		
	end
	
	always #(CLKDELAY) clk = ~clk;

endmodule 
