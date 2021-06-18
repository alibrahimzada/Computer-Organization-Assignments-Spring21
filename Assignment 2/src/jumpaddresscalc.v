module jumpaddresscalc(out,i0,i1);
output [31:0] out;
input [25:0] i0;
input [31:0] i1;
assign out={i1[31:28],i0,2'b00};
endmodule