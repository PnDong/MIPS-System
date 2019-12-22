module controlUnit(opcode, funct, regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump, aluControl);
input [5:0] opcode, funct;
output regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump;
output [3:0] aluControl;

wire [1:0] aluOp;

mainDecoder md(opcode, regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump, aluOp);

aluDecoder ad(funct, aluOp, aluControl);

endmodule


module mainDecoder(opcode, regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump, aluOp);
input [5:0] opcode;
output regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump;
output [1:0] aluOp;

reg [9:0] controls;

assign {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump, aluOp} = controls;

always @(*)
begin
	case(opcode)
		6'b000000: controls <= 10'b1001000010; // r-type
		6'b100011: controls <= 10'b0111100000; // lw
		6'b101011: controls <= 10'b0100010000; // sw
		6'b000100: controls <= 10'b0000001001; // beq
		6'b001000, 
		6'b001001: controls <= 10'b0101000000; // addi, addiu
		6'b001101: controls <= 10'b0101000000; // ori
		6'b000010: controls <= 10'b0000000100; // j
		default:   controls <= 10'bxxxxxxxxxx; // unimplemented
    endcase
end

endmodule


module aluDecoder(funct, aluOp, aluControl);

input [5:0] funct;
input [1:0] aluOp;
output reg [3:0] aluControl;

always @(*)
begin
	case(aluOp)
		2'b00: aluControl <= 4'b0010;  // add
		2'b01: aluControl <= 4'b0110;  // sub
		default:	case(funct)          // r-type
			6'b100000,
			6'b100001: aluControl <= 4'b0010; // add, addu
			6'b100010,
			6'b100011: aluControl <= 4'b0110; // sub, subu
			6'b100100: aluControl <= 4'b0000; // and
			6'b100101: aluControl <= 4'b0001; // or
			6'b101010: aluControl <= 4'b0111; // slt
			6'b000000: aluControl <= 4'b1010; // sll
			default:   aluControl <= 4'bxxxx; // unimplemented
        endcase
    endcase
end

endmodule