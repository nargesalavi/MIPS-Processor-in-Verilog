module IF_adder(input[5:0] mux_out, input[7:0] PC, output[7:0] new_pc);
	assign new_pc=PC+{2'b00,mux_out};
endmodule 