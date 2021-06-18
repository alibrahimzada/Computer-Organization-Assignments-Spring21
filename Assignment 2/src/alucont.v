module alucont(aluop1,aluop0,f3,f2,f1,f0,gout);//Figure 4.12 
input aluop1,aluop0,f3,f2,f1,f0;	// inputs to the ALU control unit
output [4:0] gout;					// 5-bit output from ALU control unit
reg [4:0] gout;
always @(aluop1 or aluop0 or f3 or f2 or f1 or f0)
begin
if(~(aluop1|aluop0))  gout=5'b00010;// checking if instruction is lw/sw/jspal
if(aluop0)gout=5'b01010;			// checking if instruction is bltz/beq
if(aluop1&aluop0) gout=5'b11000;	// checking if instruction is nor
if(aluop1)							// checking if R-format instruction
begin
	if (~(f3|f2|f1|f0))gout=5'b00010; 	//function code=0000,ALU control=00010 (add)
	if (f1&f3)gout=5'b01011;			//function code=1x1x,ALU control=01011 (set on less than)
	if (f1&~(f3))gout=5'b01010;			//function code=0x10,ALU control=01010 (sub)
	if (f2&f0)gout=5'b00001;			//function code=x1x1,ALU control=00001 (or)
	if (f2&~(f0))gout=5'b00000;			//function code=x1x0,ALU control=00000 (and)
	if (f2&f1)gout=5'b00100;				//function code=x11x,ALU control=00100 (shift right)
end
end
endmodule
