module UP (
	input logic clk,
	input logic rst,
	output logic MemRead, 
	output logic [2:0]SelMuxA,
	output logic [2:0]SelMuxB,
	output logic [2:0]SelMuxMem,
	output logic SelMuxAlu,
	output logic [2:0]SelMuxPC,
    	output logic SelMuxMul,
	output logic SelMuxShift,
	output logic [2:0]SelMuxExcecao,
	output logic [2:0]LoadTYPE,
	output logic [2:0]StoreTYPE,
    	output logic PCwrite,
	output logic EPCwrite,
	output logic IRWrite,
	output logic RegWrite,
	output logic loadRegA,
	output logic loadRegB,
	output logic loadRegMemData,
	output logic loadRegAluOut,
	output logic MemData_Write,	
	output logic [63:0] PC,
	output logic [63:0] EPC,
	output logic [63:0] AluExit,
 	output logic [63:0] RegA_Exit,
 	output logic [63:0] RegB_Exit,
 	output logic [63:0] AluOut,
	output logic [63:0] MemData,
	output logic [63:0] MemDataReg_Exit,
	output logic [4:0] i19_15,
	output logic [4:0] i24_20,
	output logic [4:0] WriteRegister, //i11_7
	output logic [6:0] i6_0,
	output logic [31:0] i31_0,
	output logic [63:0] SignExit,
	output logic [63:0] ShiftExit,
	output logic [63:0] ShiftLeftExit,
	output logic [63:0] ShiftLeftMulExit,
	output logic [31:0] MemExit,
	output logic [63:0] MuxA_Exit,
	output logic [63:0] MuxB_Exit,
	output logic [63:0] WriteDataReg,
	output logic [63:0] MuxMul_Exit,
	output logic [63:0] MuxPC_Exit,
	output logic [63:0] MuxShift_Exit,
	output logic [63:0] MuxExcecao_Exit,
	output logic [63:0] ExcecaoExtend_Exit,
	output logic [63:0] MuxAlu_Exit,
	output logic [63:0] dataout1,
	output logic [63:0] dataout2,
	logic [63:0] extensaoPC,
	output logic [5:0] Num,
   	output logic [1:0] Shift,
	output logic [2:0] AluOperation,
	output logic PCWriteCond,
	output logic AluZero,
	output logic AluMenor,
	output logic AluIgual,
	output logic [63:0]LoadResultExit,
	output logic [63:0]Store_Exit);

	
	LoadBlock BlocoLoad (
		.Entrada(MemData),
		.LoadTYPE(LoadTYPE),
		.LoadResult(LoadResultExit));

	StoreBlock BlocoStore (
		.StoreTYPE(StoreTYPE),
		.RegBIn_Mem(RegB_Exit),
		.Entrada(MemData),
		.StoreResult(Store_Exit));

	Controle UnitCtrl (
		.clk(clk),
		.rst(rst),
		.INSTR(i31_0), //
		.PCwrite(PCwrite), // PCwrite
		.EPCwrite(EPCwrite),// EPCwrite
		.MemRead(MemRead), // IMemRead
		.SelMuxA(SelMuxA), // AluSrcA
	    	.SelMuxB(SelMuxB), // AluSrcB
		.SelMuxMem(SelMuxMem), //MemToReg
		.SelMuxAlu(SelMuxAlu),
		.MemData(MemData),
		.LoadTYPE(LoadTYPE),
		.StoreTYPE(StoreTYPE),
		.Shift(Shift), //SelShift
		.Num(Num), //N Shifts
		.AluOperation(AluOperation), //AluFct
		.IRWrite(IRWrite), //IRWrite
		.RegWrite(RegWrite), //WriteReg
		.loadRegA(loadRegA), //LoadRegA
		.loadRegB(loadRegB), //LoadRegB
		.AluZero(AluZero), //
		.AluMenor(AluMenor),
		.AluIgual(AluIgual), //
		.SelMuxExcecao(SelMuxExcecao),
		.SelMuxPC(SelMuxPC), //PCSource
        	.SelMuxMul(SelMuxMul),
		.SelMuxShift(SelMuxShift), 
		.extensaoPC(extensaoPC),
		.loadRegMemData(loadRegMemData), //LoadMDR
		.loadRegAluOut(loadRegAluOut), //LoadAOut
		.MemData_Write(MemData_Write), //DMemRead
		.PCWriteCond(PCWriteCond)); //PCWriteCond

	register PCRegister (
		.clk(clk),
		.reset(rst),
		.regWrite(PCwrite),
		.DadoIn(MuxPC_Exit),
		.DadoOut(PC));

	//register ExcesaoExtend (
		//.clk(clk),
		//.reset(rst),
		//.regWrite(PCwrite),
		//.DadoIn(MuxPC_Exit),
		//.DadoOut(PC));

/////////////////////////////////////////////

	register EPCRegister (
		.clk(clk),
		.reset(rst),
		.regWrite(EPCwrite),
		.DadoIn(AluOut),
		.DadoOut(EPC));

	Memoria32 MemoryInstruction (
		.raddress(PC[31:0]), 
		.Clk(clk),
		.Dataout(MemExit),
		.Wr(1'b0));

	Instr_Reg_RISC_V RegInstruction ( 
		.Clk(clk),
		.Reset(rst),
		.Load_ir(IRWrite),
		.Entrada(MemExit),
		.Instr19_15(i19_15),
		.Instr24_20(i24_20),
		.Instr11_7(WriteRegister),//i11_7
		.Instr6_0(i6_0),
		.Instr31_0(i31_0));

	SignExtend sinalExt (
		.entrada(i31_0),
		.saida(SignExit));

	Deslocamento ShiftDesloc (
		.In(RegA_Exit),
 		.Num(i31_0[25:20]),
		.Shift(Shift),
		.Out(ShiftExit)); 

	Deslocamento ShiftLeft (
		.In(MuxShift_Exit),
 		.Num(6'd1),
		.Shift(2'd0),
		.Out(ShiftLeftExit));

	Deslocamento ShiftLeftMul (
		.In(AluExit),
 		.Num(6'd1),
		.Shift(2'd0),
		.Out(ShiftLeftMulExit));

	bancoReg Banco_Reg (
		.clock(clk),
		.regreader1(i19_15),
		.regreader2(i24_20),
		.regwriteaddress(WriteRegister),//i11_7
		.datain(WriteDataReg), 
		.dataout1(dataout1),
		.dataout2(dataout2),
		.reset(rst),
		.write(RegWrite));

	register A (
		.clk(clk),
		.reset(rst),
		.regWrite(loadRegA),
		.DadoIn(MuxMul_Exit),
		.DadoOut(RegA_Exit));

	register B (
		.clk(clk),
		.reset(rst),
		.regWrite(loadRegB), 
		.DadoIn(dataout2),
		.DadoOut(RegB_Exit));

	mux4_in MuxA (
		.SelMux4(SelMuxA),
		.MuxA_a(PC),
		.MuxA_b(RegA_Exit),
		.MuxA_c(64'b0),
		.MuxA_d(ShiftLeftMulExit),
		.f_4in(MuxA_Exit));

//////////////////////////////////////////////

	mux4_in MuxExcecao (
		.SelMux4(SelMuxExcecao),
		.MuxA_a(AluOut),
		.MuxA_b(64'd254),
		.MuxA_c(64'd255),
		.MuxA_d(2'b00),
		.f_4in(MuxExcecao_Exit));

	mux8_in MuxB (
		.SelMux8(SelMuxB),
		.MuxB_a(RegB_Exit),
		.MuxB_b(64'd4),
		.MuxB_c(SignExit),
		.MuxB_d(ShiftLeftExit),
		.MuxB_e(64'd0),
		.MuxB_f(64'd0),
		.MuxB_g(AluOut),
		.MuxB_h(64'd0),
		.f_8in(MuxB_Exit));

	ExcecaoExtend ExcecaoExtend (
		.entrada(MemData),
		.saida(ExcecaoExtend_Exit));

	mux4_in MuxPC (
		.SelMux4(SelMuxPC),
		.MuxA_a(MuxAlu_Exit),
		.MuxA_b(AluOut),
		.MuxA_c(ExcecaoExtend_Exit),
		.f_4in(MuxPC_Exit));

	mux_2in MuxMul (
		.SelMux2(SelMuxMul),
		.MuxA_a(dataout1),
		.MuxA_b(WriteDataReg),
		.f_2in(MuxMul_Exit));	

	mux_2in MuxShift (
		.SelMux2(SelMuxShift),
		.MuxA_a(SignExit),
		.MuxA_b(MuxB_Exit),
		.f_2in(MuxShift_Exit));

	ula64 Ula (
		.A(MuxA_Exit),
		.B(MuxB_Exit),
		.Seletor(AluOperation),
		.z(AluZero),
		.Igual(AluIgual),
		.S(AluExit),
		.Menor(AluMenor));
	
	register AluOutRegister (
		.clk(clk),
		.reset(rst),
		.regWrite(loadRegAluOut), 
		.DadoIn(MuxAlu_Exit),
		.DadoOut(AluOut));

	Memoria64 MemoryData (
		.raddress(MuxExcecao_Exit),
		.waddress(MuxExcecao_Exit),
		.Clk(clk),
		.Datain(Store_Exit),
		.Dataout(MemData),
		.Wr(MemData_Write));

	register MemDataReg (
		.clk(clk),
		.reset(rst),
		.regWrite(loadRegMemData), 
		.DadoIn(LoadResultExit),
		.DadoOut(MemDataReg_Exit));

	mux8_in MuxMem (
		.SelMux8(SelMuxMem),
		.MuxB_a(MuxAlu_Exit),
		.MuxB_b(MemDataReg_Exit),
		.MuxB_c(SignExit),
		.MuxB_d(ShiftExit),
		.MuxB_e(64'd0),
		.MuxB_f(64'd0),
		.MuxB_g(64'd0),
		.MuxB_h(PC),
		.f_8in(WriteDataReg));

	mux_2inAlu MuxAlu(
		.SelMux2(SelMuxAlu),
		.MuxA_a(AluExit),
		.MuxA_b(AluMenor),
		.f_2in(MuxAlu_Exit));	

endmodule 
