module registerFile(clk, regWrite, readReg1, readReg2, writeReg, writeData, readData1, readData2);
	input clk, regWrite;
	input [4:0] readReg1, readReg2, writeReg;
	input [31:0] writeData;
	output [31:0] readData1, readData2;
	reg [31:0] rf [31:0];

	always @(posedge clk) begin
    if (regWrite) rf[writeReg] <= writeData;
	end

	assign readData1 = (readReg1 != 0) ? rf[readReg1] : 0;
	assign readData2 = (readReg2 != 0) ? rf[readReg2] : 0;
endmodule