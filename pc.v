module pc(rst, clk, newPc, pc);
input rst, clk;
input [31:0] newPc;
output reg [31:0] pc;

always @(negedge rst or posedge clk)
begin
if (!rst)
	pc <= 0;
else
	pc <= newPc;
end

endmodule