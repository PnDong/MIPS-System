module slowerMips(rst, clk, seg0, seg1, seg2, seg3, seg4, seg5);
input rst, clk;
output [6:0] seg0, seg1, seg2, seg3, seg4, seg5;
wire out_clk;

clk_dll prescaler(rst, clk, out_clk);
mipsSystem mipsCPU(rst, out_clk, seg0, seg1, seg2, seg3, seg4, seg5);

endmodule