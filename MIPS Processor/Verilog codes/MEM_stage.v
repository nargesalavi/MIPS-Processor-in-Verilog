module MEM_stage( input clk, rst, input[37:0] pipeline_reg_in,
						output [36:0] pipeline_reg_out,
						output [2:0] mem_op_dest,
						input load_in,
						output load,
						output freeze,
						
						inout [15:0] SRAM_DATA,
						output[17:0] SRAM_ADDRESS,
						output SRAM_UB_N_O,
						output SRAM_LB_N_O,
						output SRAM_WE_N_O,
						output SRAM_CE_N_O,
						output SRAM_OE_N_O,
						output [2:0] counter //xxxxxx
						);
					wire[15:0] q_sig;
					wire ready;
					wire[2:0] counter11; //xxxxxx
					SRAM_Controller sram_controller(clk,rst,(load | pipeline_reg_in[21]),pipeline_reg_in[37:22],pipeline_reg_in[20:5]
																,~pipeline_reg_in[21],q_sig,ready,SRAM_DATA,SRAM_ADDRESS,SRAM_UB_N_O,SRAM_LB_N_O
																,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O,counter11);

					assign pipeline_reg_out[36:21]=pipeline_reg_in[37:22] ;
					assign pipeline_reg_out[20:5]=q_sig;
					assign pipeline_reg_out[4:0]=pipeline_reg_in[4:0]; 
					assign mem_op_dest=pipeline_reg_in[3:1];
					assign load=load_in;
					assign freeze=(rst==1'd1)?1'b0:((~(load | pipeline_reg_in[21]))?1'd0:(ready==1'd0)?1'b1:1'b0);
					assign counter=counter11; //xxxx
endmodule
	