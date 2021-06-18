module jbcont(bj2,bj1,bj0,zout,nout,pcsrc1,pcsrc0,jspal,balrzwrite);
input bj2,bj1,bj0,zout,nout;
output jspal, balrzwrite,pcsrc1,pcsrc0;
assign jspal=(~bj2)&bj1&bj0;
assign balrzwrite=bj2&(~bj1)&(~bj0);
assign pcsrc0=zout&(~bj2)&bj0|zout&bj2&(~bj1)&(~bj0)|(~bj2)&bj1;
assign pcsrc1=(~bj2)&bj1&bj0|nout&bj2&(~bj1)&zout|nout&(bj2)&(~bj1)&bj0|zout&bj2&bj1&(~bj0)|zout&bj2&(~bj0)&(~nout);
endmodule
