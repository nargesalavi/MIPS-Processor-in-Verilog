module IF_stage(input clk, input rst, instr_fetch_enable, input[5:0] imm_branch_offset
			, input branch_enable, output reg[7:0] pc, output[15:0] instr);

	reg[7:0] pc_reg;

	always@(posedge clk or posedge rst) begin
		if(rst==1'd1)
			pc=8'd0;
		else if(instr_fetch_enable==1'b1)begin
			if(branch_enable==1'b0)
				pc=pc+1'd1;
			else
				pc=pc+{imm_branch_offset[5],imm_branch_offset[5],imm_branch_offset};
		end
	end
	
	inst_mem memory(pc,instr_fetch_enable,clk,instr);
endmodule 