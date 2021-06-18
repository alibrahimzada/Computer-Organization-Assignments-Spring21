module alu32(sum,a,b,mode,zout,nout,gin);	//ALU operation according to the ALU control line values
output [31:0] sum;	// 32-bit output which represents the result of ALU
input [31:0] a,b;	// 32-bit inputs which represent the input to the ALU
input mode;
input [4:0] gin;	//ALU control line represented in 5 bits (i.e., [bit4: Ainvert, bit3: BNegate, bit2-0: Operation])
reg [31:0] sum;
reg [31:0] less;
output zout, nout;	//status registers
reg zout, nout;
always @(a or b or gin)
begin
	case(gin)
	5'b00010: sum=a+b;		// ALU control line=00010, ADD
	5'b01010: sum=a+1+(~b);	//ALU control line=01010, SUB
	5'b01011: begin less=a+1+(~b);	//ALU control line=01011, set on less than
				if (less[31]) sum=1;	
				else sum=0;
		  	  end
	5'b00000: sum=a & b;	//ALU control line=00000, AND
	5'b00001: sum=a|b;		//ALU control line=00001, OR
	5'b00100: sum=a>>b;		//ALU control line=00100, SRL
	5'b11000: sum=~(a|b);	//ALU control line=11000, NOR
	default: sum=31'bx;	
	endcase
if (~mode) begin
zout=~(|sum);	//setting the zero output based on the result of arithmetic operation
nout=sum[31];	//setting the negative output based on the result of arithmetic operation	
end
end
endmodule
