module reg_ID(input clk, rst,
						input [56:0] pipeline_reg_output,
						input [5:0] branch_offset_imm,
						input branch_taken,
						input [2:0] reg_read_addr_1,
						input [2:0] reg_read_addr_2,
						input [2:0] decoding_op_src1,
						input [2:0] decoding_op_src2,
						input load_in,
						
						output reg[56:0] pipeline_reg_output_out,
						output reg[5:0] branch_offset_imm_out,
						output reg branch_taken_out,
						output reg[2:0] reg_read_addr_1_out,
						output reg[2:0] reg_read_addr_2_out,
						output reg[2:0] decoding_op_src1_out,
						output reg[2:0] decoding_op_src2_out,
						output reg load,
						input freeze,
						input[15:0] instruction, //xxxxx
						output reg[15:0] instt //xxxxx
						);

	always@(posedge clk)begin
		if(freeze==1'b0)begin	
			pipeline_reg_output_out	=pipeline_reg_output;
			branch_offset_imm_out	=branch_offset_imm;
			branch_taken_out			=branch_taken;
			reg_read_addr_1_out		=reg_read_addr_1;
			reg_read_addr_2_out		=reg_read_addr_2;
			decoding_op_src1_out		=decoding_op_src1;
			decoding_op_src2_out		=decoding_op_src2;
			load = load_in;
			instt=instruction; //xxxx
		end
	end

endmodule 