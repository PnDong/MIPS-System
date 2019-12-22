module pcAdd(pc, pcPlus4);
input [31:0] pc;
output [31:0] pcPlus4;

assign pcPlus4=pc+4;

endmodule