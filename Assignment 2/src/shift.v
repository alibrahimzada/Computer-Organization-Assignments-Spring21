module shift(shout,shin);   // this module represents the shift operator
output [31:0] shout;    // 32-bit shout represents the output of shift
input [31:0] shin;      // 32-bit shin represents the input of shift
assign shout=shin<<2;   // left shift by 2
endmodule