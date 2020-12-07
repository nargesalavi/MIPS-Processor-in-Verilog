module EX_stage(input clk, rst,
					//from ID_stage
					input[56:0] pipeline_reg_in,
					//to MEM_stage
					output reg[37:0] pipeline_reg_out,
						//[37:22] ,16bits:ex_alu_result[15:0]
						//[21:5],17bits: mem_write_en, mem_write_data[15:0]
						//[4:0] , 5bits: write_back_en, write_back_dest[2:0], write_back_result_mux
					
					//to HD_Unit
					output [2:0] ex_op_dest,
					input load_in,
					output load
					);
					always@(*)begin
						case ( pipeline_reg_in[56:54]) 
							3'b000: pipeline_reg_out[37:22]=pipeline_reg_in[53:38]+pipeline_reg_in[37:22];
							3'b001: pipeline_reg_out[37:22]=pipeline_reg_in[37:22]-pipeline_reg_in[53:38];
							3'b010: pipeline_reg_out[37:22]=pipeline_reg_in[53:38]&pipeline_reg_in[37:22];
							3'b011: pipeline_reg_out[37:22]=pipeline_reg_in[53:38]|pipeline_reg_in[37:22];
							3'b100: pipeline_reg_out[37:22]=pipeline_reg_in[53:38]^pipeline_reg_in[37:22];
							3'b101: pipeline_reg_out[37:22]=pipeline_reg_in[37:22]<<<pipeline_reg_in[53:38];
							3'b110: pipeline_reg_out[37:22]=pipeline_reg_in[37:22]>>pipeline_reg_in[53:38];
							3'b111: pipeline_reg_out[37:22]=pipeline_reg_in[37:22]>>>pipeline_reg_in[53:38];
						endcase
						pipeline_reg_out[21:0] = pipeline_reg_in[21:0];
					end
					
					assign ex_op_dest=pipeline_reg_in[3:1];
					assign load=load_in;
							
					
endmodule 