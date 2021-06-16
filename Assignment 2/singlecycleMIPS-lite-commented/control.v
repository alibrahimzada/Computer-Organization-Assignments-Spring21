module control(in,regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop0,aluop1,bj0,bj1,bj2);
input [5:0] in;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop0,aluop1,bj0,bj1,bj2;
wire rformat,lw,sw,beq,bltz,nori,bz,jspal,j;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign bltz=(~in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&in[0];
assign nori=(~in[5])&(~in[4])&in[3]&in[2]&(~in[1])&in[0];
assign bz=(~in[5])&in[4]&in[3]&(~in[2])&(~in[1])&(~in[0]);
assign jspal=(~in[5])&in[4]&(~in[3])&(~in[2])&in[1]&in[0];
assign j=(~in[5])&(~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]);
assign regdest=rformat;
assign alusrc=nori|lw|sw;
assign memtoreg=lw;
assign regwrite=rformat|lw|nori;
assign memread=lw;
assign memwrite=sw|jspal;
assign aluop0=beq|bltz|nori;
assign aluop1=rformat|nori;
assign bj0=bltz|bz|jspal;
assign bj1=jspal|j|beq;
assign bj2=bltz|beq;
endmodule
