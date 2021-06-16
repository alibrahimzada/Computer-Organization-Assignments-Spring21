module jumpaddresscalc(out,i0,i1);
output [31:0] out;
input [25:0] i0;
input [31:0] i1;
assign shout={i1[3:0],i0,2'b00};
endmodule