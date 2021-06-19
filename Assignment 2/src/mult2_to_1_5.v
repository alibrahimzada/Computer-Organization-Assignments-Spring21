module mult2_to_1_5(out, i0,i1,s0);     // this module represents a 5-bit 2-to-1 mux
output [4:0] out;       // 5-bit output of mux
input [4:0]i0,i1;       // 5-bit inputs of mux
input s0;               // 1-bit control of mux
assign out = s0 ? i1:i0;    // determing the output based on control line
endmodule
