module mult4_to_1_32(out, i0, i1, i2, i3, s);
output [31:0] out;
input [31:0] i0,i1,i2,i3;
input [1:0] s;
assign out = s[1] ? (s[0] ? i3 : i2) : (s[0] ? i1 : i0);
endmodule
