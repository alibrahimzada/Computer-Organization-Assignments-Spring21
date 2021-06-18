module mult2_to_1_3(bj2,bj1,bj0,i0,s0);
output bj2,bj1,bj0;
input [2:0]i0;
input s0;
reg bj2,bj1,bj0;

always @(s0)
begin
    case(s0)
    1'b1: begin
        bj2=i0[2];
        bj1=i0[1];
        bj0=i0[0];    
    end
    default: begin
        
    end
    endcase
end
endmodule
