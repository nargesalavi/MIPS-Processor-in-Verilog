module MIPS(input CLOCK_50,input [17:0] SW,output[17:0] SRAM_ADDR,inout[15:0] SRAM_DQ,output SRAM_UB_N,
						output SRAM_LB_N,
						output SRAM_WE_N,
						output SRAM_CE_N,
						output SRAM_OE_N);
						
						
						
	wire rst,clk,reg_write_en,branch_taken,branch_enable,pipeline_stall_n,load1,load2,load3,load4,load5,load6;
	wire[15:0] write_data,instr,reg_read_data_2,reg_read_data_1,fw_data1,fw_data2,xxx,xx;
	
	wire instr_fetch_enable,forward_valid2,forward_valid1,freeze;
	wire[5:0] imm_branch_offset,branch_offset_imm;
	wire[7:0] pc2;
	wire[56:0] pipeline_reg_output2,pipeline_reg_output3;
	wire[2:0] reg_read_addr_1,reg_read_addr_2,decoding_op_src1,decoding_op_src2,ex_op_dest,reg_write_dest,mem_op_dest,wb_op_dest;
	wire [36:0] temp,temp2;
	wire[37:0] pipeline_reg_out2,pipeline_reg_out_out2;
	assign pc=pc2;
	assign rst=SW[0];
	assign clk=CLOCK_50;
	wire[2:0] counter; //xxxxx
	
	
	IF_stage ifs(clk,rst, (~pipeline_stall_n&~freeze),branch_offset_imm, branch_taken, pc2,instr);
	
	
	
	
	ID_stage id		 (.clk(clk),.rst(rst),.instruction(rst?16'd0:instr),.reg_read_addr_1(reg_read_addr_1),.reg_read_addr_2(reg_read_addr_2)
							,.reg_read_data_1(reg_read_data_1),.reg_read_data_2(reg_read_data_2),.pipeline_reg_output(pipeline_reg_output2)
							,.branch_offset_imm(branch_offset_imm),.branch_taken(branch_taken),.instruction_decode_en(pipeline_stall_n)
							,.decoding_op_src1(decoding_op_src1),.decoding_op_src2(decoding_op_src2),.load(load1)
							,.fw_data1(fw_data1),.fw_data2(fw_data2),.forward_valid1(forward_valid1),.forward_valid2(forward_valid2)  
							,.insttt(xxx));				
	reg_ID id_reg	 (.clk(clk),.rst(rst),.pipeline_reg_output(pipeline_reg_output2),	.pipeline_reg_output_out(pipeline_reg_output3)
							,.load_in(load1),.load(load2),.freeze(freeze),.instruction(xxx),.instt(xx));
	
	
	
	
	EX_stage ex		 (.clk(clk),.rst(rst),.pipeline_reg_in(pipeline_reg_output3),.pipeline_reg_out(pipeline_reg_out2)
							,.ex_op_dest(ex_op_dest),.load_in(load2),.load(load3));
	reg_EX ex_reg	 (.clk(clk),.rst(rst),.pipeline_reg_out(pipeline_reg_out2),.pipeline_reg_out_out(pipeline_reg_out_out2)
							,.freeze(freeze),.load_in(load3),.load(load4));
	
	
	
	
	MEM_stage mem	 (.clk(clk),.rst(rst),.pipeline_reg_in(pipeline_reg_out_out2),.pipeline_reg_out(temp),.freeze(freeze)
							,.mem_op_dest(mem_op_dest),.load_in(load4),.load(load5)
							,.SRAM_DATA(SRAM_DQ),.SRAM_ADDRESS(SRAM_ADDR)
							,.SRAM_UB_N_O(SRAM_UB_N),.SRAM_LB_N_O(SRAM_LB_N),.SRAM_WE_N_O(SRAM_WE_N),.SRAM_CE_N_O(SRAM_CE_N),.SRAM_OE_N_O(SRAM_OE_N)
							, .counter(counter) /*////xxxxx*/ );
	reg_MEM  mem_reg(.clk(clk),.rst(rst),.pipeline_reg_out(temp),.pipeline_reg_out_out(temp2),.load_in(load5),.load(load6),.freeze(freeze));
	
	
	
	WB_stage wb		 (.pipeline_reg_in(temp2),
						  .reg_write_data(write_data),.reg_write_en(reg_write_en),.reg_write_dest(reg_write_dest),.wb_op_dest(wb_op_dest));
	
	
	
	
	reg_file rf(.clk(clk),.rst(rst), .rg_wrt_enable(rst?1'b0:reg_write_en), 
				.rg_rd_addr1(reg_read_addr_1),.rg_rd_data1(reg_read_data_1),.rg_rd_addr2(reg_read_addr_2),.rg_rd_data2(reg_read_data_2)
				,.rg_wrt_dest(reg_write_dest),.rg_wrt_data(write_data)
				);
	
	
	
	
	hazard_detection_unit hazard( .decoding_op_src1(decoding_op_src1),.decoding_op_src2(decoding_op_src2),
											.ex_op_dest(ex_op_dest),.mem_op_dest(mem_op_dest),.wb_op_dest(wb_op_dest),
											.pipeline_stall_n(pipeline_stall_n),
											.forward_valid1(forward_valid1),.forward_valid2(forward_valid2),
											.ex_fw_data(pipeline_reg_out2[37:22]),.mem_fw_data(temp[36:21]),.wb_fw_data(write_data),
											.ex_load(load3),.mem_load(load5),
											.fw_data1(fw_data1),.fw_data2(fw_data2));

		
endmodule 