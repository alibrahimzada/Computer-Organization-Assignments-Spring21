module xnor_gate(a,b,out);      // this module represents the XNOR module
input [5:0] a,b;        // 6-bit inputs of the xnor module
output out;             // 1-bit output of the xnor module
assign out=&(a^~b);     // xnor operation and self-bitwise AND
endmodule