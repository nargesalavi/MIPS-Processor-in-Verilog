module hazard_detection_unit ( input[2:0] decoding_op_src1,decoding_op_src2,ex_op_dest,mem_op_dest,wb_op_dest,
										 output reg pipeline_stall_n,forward_valid1,forward_valid2,input [15:0] ex_fw_data,mem_fw_data,wb_fw_data
										 ,input ex_load,mem_load,output reg[15:0] fw_data1,fw_data2);
										 
	always@(*)begin
		pipeline_stall_n=( (( ((decoding_op_src1==ex_op_dest) && (ex_load==1'b1))||((decoding_op_src1==mem_op_dest) && (mem_load==1'b1)) )
									&& (decoding_op_src1!=3'd0) )
									||
								  (( ((decoding_op_src2==ex_op_dest) && (ex_load==1'b1))||((decoding_op_src2==mem_op_dest) && (mem_load==1'b1)) )
									&& (decoding_op_src2!=3'd0) ) )?
							1'b1:1'b0;
		fw_data1=((decoding_op_src1==ex_op_dest) && (ex_load==1'b0)) ? ex_fw_data :
				  (((decoding_op_src1==mem_op_dest) && (mem_load==1'b0)) ? mem_fw_data :
					((decoding_op_src1==wb_op_dest)? wb_fw_data:16'd0));
		fw_data2=((decoding_op_src2==ex_op_dest) && (ex_load==1'b0)) ? ex_fw_data :
				  (((decoding_op_src2==mem_op_dest) && (mem_load==1'b0)) ? mem_fw_data :
					((decoding_op_src2==wb_op_dest)? wb_fw_data:16'd0));
					
		forward_valid1=((((decoding_op_src1==ex_op_dest) && (ex_load==1'b0)) ||
							((decoding_op_src1==mem_op_dest) && (mem_load==1'b0)) ||
							(decoding_op_src1==wb_op_dest))&& (decoding_op_src1!=3'd0) )?1'b1:1'b0;
		forward_valid2=((((decoding_op_src2==ex_op_dest) && (ex_load==1'b0)) ||
							((decoding_op_src2==mem_op_dest) && (mem_load==1'b0)) ||
							(decoding_op_src2==wb_op_dest))&& (decoding_op_src2!=3'd0) )?1'b1:1'b0;
	end
endmodule 