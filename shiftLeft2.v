module shiftLeft2#(parameter IN_WIDTH = 8, parameter OUT_WIDTH = 8)
            (in, out);
	input [IN_WIDTH-1:0] in;
	output [OUT_WIDTH-1:0] out;
	assign out = in << 2;
	assign out = {in, 2'b00};

endmodule
