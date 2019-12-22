module mipsSystem(rst, clk, seg0, seg1, seg2, seg3, seg4, seg5);
input rst, clk;
output reg [6:0] seg0, seg1, seg2, seg3, seg4, seg5;

wire [31:0] pcIn, pcOut, pcP4;
wire [31:0] instruction;
wire [27:0] addrShifted;
wire regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump;
wire [3:0] aluControl;
wire [4:0] writeAddr;
wire [31:0] writeBack, readData1, readData2;
wire [31:0] extendedImm, branchImm, branchAddr, aluIn, aluResult;
wire notZero;
wire [31:0] notJumpAddr, dataRead;

pc pcreg(.rst(rst), .clk(clk), .newPc(pcIn), .pc(pcOut));
pcAdd pcAdder(.pc(pcOut), .pcPlus4(pcP4));
instruction_mem instMem(.rst(rst), .pc(pcOut), .inst(instruction));

shiftLeft2 #(26, 28) jumpSL (.in(instruction[25:0]), .out(addrShifted));
controlUnit controller(
.opcode(instruction[31:26]),
.funct(instruction[5:0]),
.regDst(regDst),
.aluSrc(aluSrc),
.memToReg(memToReg),
.regWrite(regWrite),
.memRead(memRead),
.memWrite(memWrite),
.branch(branch),
.jump(jump),
.aluControl(aluControl)
);
mux2 #(5) dstMux (.d0(instruction[20:16]), .d1(instruction[15:11]), .s(regDst), .y(writeAddr));
registerFile regFile(
.clk(clk), .regWrite(regWrite), .readReg1(instruction[25:21]), .readReg2(instruction[20:16]),
.writeReg(writeAddr), .writeData(writeBack), .readData1(readData1), .readData2(readData2));
signExtend signExt(.imm(instruction[15:0]), .signImm(extendedImm));

shiftLeft2 #(32, 32) branchSL (.in(extendedImm), .out(branchImm));
adder32 add32(.in1(pcP4), .in2(branchImm), .out(branchAddr));
alu mainALU(.srcA(readData1), .srcB(aluIn), .aluControl(aluControl), .shamt(instruction[10:6]), .aluResult(aluResult), .zero(notZero));
mux2 #(32) aluMux (.d0(readData2), .d1(extendedImm), .s(aluSrc), .y(aluIn));

mux2 #(32) branchMux (.d0(pcP4), .d1(branchAddr), .s(branch&notZero), .y(notJumpAddr));
mux2 #(32) jumpMux (.d0(notJumpAddr), .d1({pcP4[31:28], addrShifted}), .s(jump), .y(pcIn));
data_memory dataMem(.rst(rst), .memRead(memRead), .memWrite(memWrite), .address(aluResult), .write_data(readData2), .read_data(dataRead));
mux2 #(32) readMux (.d0(aluResult), .d1(dataRead), .s(memToReg), .y(writeBack));

function [6:0] hex2seg;
	input [3:0] hexIn;
	begin
	case (hexIn)
	0: hex2seg = 7'b1000000;
	1: hex2seg = 7'b1111001;
	2: hex2seg = 7'b0100100;
	3: hex2seg = 7'b0110000;
	4: hex2seg = 7'b0011001;
	5: hex2seg = 7'b0010010;
	6: hex2seg = 7'b0000010;
	7: hex2seg = 7'b1111000;
	8: hex2seg = 7'b0000000;
	9: hex2seg = 7'b0010000;
	'hA: hex2seg = 7'b0001000;
	'hb: hex2seg = 7'b0000011;
	'hC: hex2seg = 7'b1000110;
	'hd: hex2seg = 7'b0100001;
	'hE: hex2seg = 7'b0000110;
	'hF: hex2seg = 7'b0001110;
   default: hex2seg = 7'b1000000;
endcase
	end
endfunction

always @(pcOut, writeBack) begin
seg0 = hex2seg ((pcOut / 16) % 16);
seg1 = hex2seg (pcOut % 16);
seg2 = hex2seg ((((writeBack / 16) / 16) / 16) % 16);
seg3 = hex2seg (((writeBack / 16) / 16) % 16);
seg4 = hex2seg ((writeBack / 16) % 16);
seg5 = hex2seg (writeBack % 16);
end

endmodule