module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with balrzWrite control-mult4
out5,		//Output of mux with PCSrc control-mult5
out6,		//Output of mux with JSPAL control-mult6
sum,		//ALU result
extad,	//Output of sign-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
jumpout,	//Output of jump which is like {{PC+4[31-28],jumpaddress*4(in 28-bits)}}
sextad;	//Output of shift left 2 unit

wire [25:0] inst25_0;	//25-0 bits of instruction
wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1;		//Write data input of Register File

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [4:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
nout,		//Negative output of ALU
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop1,aluop0,bj2,bj1,bj0,jspal,balrzWrite,balrz,pcsrc1,pcsrc0,mode;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=out6[7:0];
datmem[sum[4:0]+2]=out6[15:8];
datmem[sum[4:0]+1]=out6[23:16];
datmem[sum[4:0]]=out6[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst25_0=instruc[25:0];
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
 registerfile[out1]= regwrite ? out4:registerfile[out1];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],regdest);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,extad,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg);

//mux with balrzWrite control
mult2_to_1_32 mult4(out4, out3,adder1out,balrzWrite);

//mux with PCSrc control
mult4_to_1_32 mult5(out5, adder1out,jumpout,adder2out,dataa,pcsrc1,pcsrc0);

//mux with JSPAL control
mult2_to_1_32 mult6(out6, datab,adder1out,jspal);

// load pc
always @(negedge clk)
// pc=out5;
pc=out5;

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,dataa,out2,mode,zout,nout,gout);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(inst31_26,balrz,regdest,alusrc,memtoreg,regwrite,memread,memwrite,
aluop1,aluop0,bj2,bj1,bj0,mode);

//Sign extend unit
signext sext(inst15_0,extad);

//ALU control unit
alucont acont(aluop1,aluop0,instruc[3],instruc[2], instruc[1], instruc[0] ,gout);

//JB control unit
jbcont jbcont1(bj2,bj1,bj0,zout,nout,pcsrc1,pcsrc0,jspal,balrzWrite);

//Shift-left 2 unit
shift shift2(sextad,extad);

//Shift-left 2 unit the jump address
jumpaddresscalc jac1(jumpout,inst25_0,adder1out);

//xnor unit
xnor_gate xnor1(instruc[5:0],6'b010110,balrz);

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

