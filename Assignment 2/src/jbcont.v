module jbcont(bj2,bj1,bj0,zout,nout,pcsrc1,pcsrc0,jspal,balrzwrite);
input bj2,bj1,bj0,zout,nout;    // these wires correspond to the input of J/B control unit
output jspal, balrzwrite,pcsrc1,pcsrc0;     // these wires correspond to the out of J/B control unit
// determining the value of J/B control unit's output based on a boolean eqn. which is 
// derived from the truth table
assign jspal=(~bj2)&bj1&bj0;
assign balrzwrite=bj2&(~bj1)&(~bj0);
assign pcsrc0=zout&(~bj2)&bj0|zout&bj2&(~bj1)&(~bj0)|(~bj2)&bj1;
assign pcsrc1=(~bj2)&bj1&bj0|nout&bj2&(~bj1)&zout|nout&(bj2)&(~bj1)&bj0|zout&bj2&bj1&(~bj0)|zout&bj2&(~bj0)&(~nout);
endmodule
