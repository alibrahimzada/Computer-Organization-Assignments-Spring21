module alu32(sum,a,b,sr,gin);//ALU operation according to the ALU control line values
output [31:0] sum;
input [31:0] a,b; 
input [4:0] gin;//ALU control line
reg [31:0] sum;
reg [31:0] less;
output [3:0] sr;//status reg
reg [3:0] sr;
always @(a or b or gin)
begin
	case(gin)
	5'b00010: sum=a+b; 		//ALU control line=010, ADD
	5'b01010: sum=a+1+(~b);	//ALU control line=110, SUB
	5'b01011: begin less=a+1+(~b);	//ALU control line=111, set on less than
				if (less[31]) sum=1;	
				else sum=0;
		  	  end
	5'b00000: sum=a & b;	//ALU control line=000, AND
	5'b00001: sum=a|b;		//ALU control line=001, OR
	5'b00100: sum=a>>b;
	5'b11000: sum=~(a|b);
	default: sum=31'bx;	
	endcase
sr[3]=~(|sum);
sr[2]=sum[31];
end
endmodule
