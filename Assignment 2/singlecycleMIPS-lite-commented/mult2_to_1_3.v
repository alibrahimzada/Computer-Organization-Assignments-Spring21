module mult2_to_1_3(bj2,bj1,bj0,i0,s0);
output bj2,bj1,bj0;
input [2:0]i0;
input s0;
reg [2:0] tmp;
assign tmp = s0 ? i0:{bj2,bj1,bj0};
assign bj2 = tmp[2];
assign bj1 = tmp[1];
assign bj0 = tmp[0];
endmodule
