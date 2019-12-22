module alu(srcA, srcB, aluControl, shamt, aluResult, zero);
input [31:0] srcA, srcB;
input [3:0] aluControl;
input [4:0] shamt;
output reg [31:0] aluResult;
output zero;

always @(aluControl, srcA, srcB)
begin
	case(aluControl)
		4'b0000 : aluResult=srcA&srcB;
		4'b0001 : aluResult=srcA|srcB;
		4'b0010 : aluResult=srcA+srcB;
		4'b0110 : aluResult=srcA-srcB;
		4'b0111 : aluResult=srcA<srcB?1:0;
		4'b1010 : aluResult=srcB<<shamt;
		4'b1100 : aluResult=~(srcA|srcB);
		default : aluResult=0;
	endcase
end

assign zero=aluResult==0?1:0;

endmodule
