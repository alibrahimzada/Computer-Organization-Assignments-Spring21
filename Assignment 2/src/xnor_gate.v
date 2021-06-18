module xnor_gate(a,b,out);
input [5:0] a,b;
output out;
assign out=&(a^~b);
endmodule