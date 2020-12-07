module reg_MEM(input clk, rst,
						input [36:0] pipeline_reg_out,
						input [2:0] mem_op_dest,
						input freeze,
						output reg[36:0] pipeline_reg_out_out,
						output reg[2:0] mem_op_dest_out,
						input load_in,
						output reg load
						);
	always@(posedge clk)begin
		if(freeze==1'b0)begin
			pipeline_reg_out_out=pipeline_reg_out;
			mem_op_dest_out=mem_op_dest;
			load=load_in;
		end
	end
	
endmodule 