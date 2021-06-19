module mult2_to_1_32(out, i0,i1,s0);    // this module represents a 32-bit 2-to-1 mux
output [31:0] out;      // 32-bit output of mux
input [31:0]i0,i1;      // 32-bit inputs of mux
input s0;               // 1-bit control line of mux
assign out = s0 ? i1:i0;    // determing the output based on control line
endmodule
