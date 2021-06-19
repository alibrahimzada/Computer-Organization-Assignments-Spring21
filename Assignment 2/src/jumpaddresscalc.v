module jumpaddresscalc(out,i0,i1);  // this module is used to calculate the target address of j/bz
output [31:0] out;      // 32-bit out represents the output of the module
input [25:0] i0;        // 26-bits of the J-format instruction
input [31:0] i1;        // 32-bit i1 represents the the value of PC+4
assign out={i1[31:28],i0,2'b00};    // concatenating PC+4[31:28] with 2 left shifted jump address
endmodule