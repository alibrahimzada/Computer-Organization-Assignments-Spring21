module jbcont(bj2,bj1,bj0,sr3,sr2,sr1,sr0,pcsrc,jspal,balrzwrite);
input bj2,bj1,bj0,sr3,sr2,sr1,sr0;
output [1:0] pcsrc;
reg [1:0] pcsrc;
output jspal, balrzwrite;
assign jspal=(~bj2)&bj1&bj0;
assign balrzwrite=bj2&(~bj1)&(~bj0);
assign pcsrc[0]=sr3&(~bj2)&bj0|sr3&bj2&(~bj1)&(~bj0)|(~bj2)&bj1;
assign pcsrc[1]=(~bj2)&bj1&bj0|sr2&bj2&(~bj1)&sr3|sr2&(bj2)&(~bj1)&bj0;
endmodule
