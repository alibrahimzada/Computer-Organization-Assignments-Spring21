module jbcont(bj2,bj1,bj0,zout,nout,pcsrc,jspal,balrzwrite);
input bj2,bj1,bj0,zout,nout;
output [1:0] pcsrc;
reg [1:0] pcsrc;
output jspal, balrzwrite;
assign jspal=(~bj2)&bj1&bj0;
assign balrzwrite=bj2&(~bj1)&(~bj0);
assign pcsrc[0]=zout&(~bj2)&bj0|zout&bj2&(~bj1)&(~bj0)|(~bj2)&bj1;
assign pcsrc[1]=(~bj2)&bj1&bj0|nout&bj2&(~bj1)&zout|nout&(bj2)&(~bj1)&bj0|zout&bj2&bj1&(~bj0)|zout&bj2&(~bj0)&(~nout);
endmodule
