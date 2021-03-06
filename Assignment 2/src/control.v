module control(in,balrz,regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop1,aluop0,bj2,bj1,bj0,mode);
input [5:0] in;     // the in input represents the 6 bits of opcode
input balrz;        // the balrz input determines if the current instruction is balrz
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop1,aluop0,bj2,bj1,bj0,mode;
wire rformat,lw,sw,beq,bltz,nori,bz,jspal,j;
assign rformat=~|in;
// the following lines ANDs all of opcode bits in a proper manner to produce 1/0
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign bltz=(~in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&in[0];
assign nori=(~in[5])&(~in[4])&in[3]&in[2]&(~in[1])&in[0];
assign bz=(~in[5])&in[4]&in[3]&(~in[2])&(~in[1])&(~in[0]);
assign jspal=(~in[5])&in[4]&(~in[3])&(~in[2])&in[1]&in[0];
assign j=(~in[5])&(~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]);
// the following lines uses the previous values of wires to determine control lines
assign regdest=rformat;
assign alusrc=nori|lw|sw;
assign memtoreg=lw;
assign regwrite=rformat|lw|nori;
assign memread=lw;
assign memwrite=sw|jspal;
assign aluop0=beq|nori;
assign aluop1=rformat|nori;
assign bj0=bltz|bz|jspal;
assign bj1=jspal|j|beq;
assign bj2=bltz|beq|balrz;
assign mode=bz|balrz;
endmodule
