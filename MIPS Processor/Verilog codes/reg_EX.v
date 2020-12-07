module reg_EX(input clk, rst,
					input [37:0] pipeline_reg_out,
					input [2:0] ex_op_dest,
					output reg[37:0] pipeline_reg_out_out,
					output reg[2:0] ex_op_dest_out,
					input load_in,
					output reg load,
					input freeze
					
					);
	always@(posedge clk)begin
		
		if(freeze==1'b0)begin
			pipeline_reg_out_out	=pipeline_reg_out;
			ex_op_dest_out			=ex_op_dest;
			load=load_in;
		end
	end
endmodule 