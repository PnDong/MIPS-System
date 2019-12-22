module signExtend(imm, signImm);
input [15:0] imm;
output [31:0] signImm;

assign signImm={{16{imm[15]}}, imm[15:0]};

endmodule