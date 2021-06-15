module xnor(a, b, out);
input [4:0] a,b;
output out;
assign out = ~ (~A&&B || A&&~B);
endmodule
