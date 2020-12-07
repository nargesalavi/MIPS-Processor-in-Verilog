module ID_stage(input clk, rst, instruction_decode_en,
						output reg[56:0] pipeline_reg_output,
						//
						input [15:0] instruction,
						output [5:0] branch_offset_imm,
						output reg branch_taken,
						//
						output [2:0] reg_read_addr_1,
						output [2:0] reg_read_addr_2,
						input [15:0] reg_read_data_1,
						input [15:0] reg_read_data_2,
						//
						output [2:0] decoding_op_src1,
						output [2:0] decoding_op_src2,
						output load,
						input [15:0] fw_data1,fw_data2,
						input forward_valid1,forward_valid2,
						output [15:0] insttt //xxxxxx
						
						
						);
						
						assign insttt=instruction; //xxxxxx
						reg branch_taken_enable=1'b0;
						assign reg_read_addr_1=  instruction[15:12]==4'b1011 ? instruction[11:9] :  instruction[5:3];
						assign reg_read_addr_2=instruction[8:6];
						assign branch_offset_imm=instruction[5:0];
					   assign decoding_op_src1=((instruction[15:12]==4'b0001) || (instruction[15:12]==4'b0010) || 
													  (instruction[15:12]==4'b0011) || (instruction[15:12]==4'b0100) ||
													  (instruction[15:12]==4'b0101) || (instruction[15:12]==4'b0110) ||
													  (instruction[15:12]==4'b0111) || (instruction[15:12]==4'b1000) ||
													  (instruction[15:12]==4'b1011))
													  ?reg_read_addr_1:3'd0;
					   assign decoding_op_src2=(instruction[15:12]==4'b0000)
													  ?3'd0:instruction[8:6];
						assign load=((instruction_decode_en==1'b0) && (instruction[15:12]==4'b1010))?1'b1:1'b0;
						
						always@(*)begin
							if(branch_taken_enable==1'b0 && instruction_decode_en==1'b0 && instruction[15:12]!=4'b0000)begin
								pipeline_reg_output[56:54] =   (instruction[15:12]==4'b0001)?3'b000:
																		((instruction[15:12]==4'b0010)?3'b001:
																		((instruction[15:12]==4'b0011)?3'b010:
																		((instruction[15:12]==4'b0100)?3'b011:
																		((instruction[15:12]==4'b0101)?3'b100:
																		((instruction[15:12]==4'b0110)?3'b101:
																		((instruction[15:12]==4'b0111)?3'b110:
																		((instruction[15:12]==4'b1000)?3'b111:3'b000)))))));
																			
								pipeline_reg_output[4:1]  =((instruction[15:12]==4'b0001) || (instruction[15:12]==4'b0010) || 
																	 (instruction[15:12]==4'b0011) || (instruction[15:12]==4'b0100) ||
																	 (instruction[15:12]==4'b0101) || (instruction[15:12]==4'b0110) ||
																	 (instruction[15:12]==4'b0111) || (instruction[15:12]==4'b1000) ||
																	 (instruction[15:12]==4'b1001) || (instruction[15:12]==4'b1010)) 
																	 ? ({1'b1,instruction[11:9]}) : 4'd0;
								pipeline_reg_output[0]  =((instruction[15:12]==4'b0001) || (instruction[15:12]==4'b0010) || 
																	 (instruction[15:12]==4'b0011) || (instruction[15:12]==4'b0100) ||
																	 (instruction[15:12]==4'b0101) || (instruction[15:12]==4'b0110) ||
																	 (instruction[15:12]==4'b0111) || (instruction[15:12]==4'b1000) ||
																	 (instruction[15:12]==4'b1001) )
																	 ? 1'b1 : 1'b0;
																	
								pipeline_reg_output[53:38]=(instruction[15:12]==4'b1001 || instruction[15:12]==4'b1010 || instruction[15:12]==4'b1011)?
									 ((forward_valid2==1'b1)?fw_data2:reg_read_data_2)
									:((forward_valid1==1'b1)?fw_data1:reg_read_data_1);
									
								pipeline_reg_output[37:22]=(instruction[15:12]==4'b1001 || instruction[15:12]==4'b1010 || instruction[15:12]==4'b1011)?
									 ({instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5],instruction[5:0]})
									:((forward_valid2==1'b1)?fw_data2:reg_read_data_2);
									
									
								pipeline_reg_output[21]= instruction[15:12]==4'b1011 ? 1'b1 : 1'b0;
								pipeline_reg_output[20:5]=(forward_valid1==1'b1)?fw_data1:reg_read_data_1 ;
								
								
					
							end
							else begin
								pipeline_reg_output=57'd0;
							end
							
						
							if(instruction[15:12]==4'b1100 && reg_read_data_2==16'd0 && (forward_valid2==1'b0))begin
								branch_taken=1'b1;
							end
							else if(instruction[15:12]==4'b1100 && fw_data2==16'd0 && (forward_valid2==1'b1))begin
								branch_taken=1'b1;
							end
							else begin
								branch_taken=1'b0;
							end
						end
						
						
						
						always@(posedge clk) begin
							if(branch_taken==1'b1)
								branch_taken_enable=1'b1;
							else
								branch_taken_enable=1'b0;
						end
								
					
endmodule
						
						