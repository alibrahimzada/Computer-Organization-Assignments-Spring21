module signext(in1,out1);   // this module represents the sign extension
input [15:0] in1;       // 16-bit in1 represents the input of sign extension module
output [31:0] out1;     // 32-bit out1 represents the output of the sign extension module
assign 	 out1 = {{ 16 {in1[15]}}, in1};     // concatenation
endmodule