`timescale 10ns/1ns
module mips_tb();
reg rst, clk;
wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5;
mipsSystem sm (rst, clk, seg0, seg1, seg2, seg3, seg4, seg5);

initial
begin
clk=0;
forever #5 clk=~clk;
end

initial
begin
rst=0;
# 10; rst=1;
end
endmodule