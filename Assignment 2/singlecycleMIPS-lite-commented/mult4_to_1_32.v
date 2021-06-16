module mult4_to_1_32(out, i0, i1, i2, i3, s1, s0);
output [31:0] out;
input [31:0] i0,i1,i2,i3;
input s1,s0;
assign out = s1 ? (s0 ? i3 : i2) : (s0 ? i1 : i0);
endmodule
