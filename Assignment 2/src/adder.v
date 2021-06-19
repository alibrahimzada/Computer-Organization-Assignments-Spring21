module adder(a,b,out);  // this module represents the adder
input [31:0]  a,b;      // 32-bit a and b are the inputs of the adder
output [31:0] out;      // 32-bit out represents the sum
assign out=a+b;         // addition operation
endmodule