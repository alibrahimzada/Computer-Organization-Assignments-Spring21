module mult4_to_1_32(out, i0, i1, i2, i3, s1, s0);  // this module represents a 32-bit 4-to-1 mux
output [31:0] out;      // 32-bit output of mux
input [31:0] i0,i1,i2,i3;   // 32-bit inputs of the mux
input s1,s0;    // these two bits represent the mux's control lines (2 bits because of 4 inputs)
assign out = s1 ? (s0 ? i3 : i2) : (s0 ? i1 : i0);  // determing the output based on control line bits
endmodule
