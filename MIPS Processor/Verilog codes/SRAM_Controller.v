module SRAM_Controller(
			input Clock_50,
			input Resetn,
			input mem_op,
			input [17:0] SRAM_address,
			input [15:0] SRAM_write_data,
			input SRAM_we_n,
			output [15:0] SRAM_read_data,
			output reg ready,
			
			inout reg[15:0] SRAM_DATA,
			output reg[17:0] SRAM_ADDRESS,
			output reg SRAM_UB_N_O,
			output reg SRAM_LB_N_O,
			output reg SRAM_WE_N_O,
			output reg SRAM_CE_N_O,
			output reg SRAM_OE_N_O,
			output reg[2:0] counter //xxxxxx
			);  
			//reg[2:0] counter;  xxxxxxx
			assign SRAM_read_data=(SRAM_we_n==1'd1 && ready==1'd1)?SRAM_DATA:16'd0;
			
			always@(*)begin
				SRAM_ADDRESS = SRAM_address;
				SRAM_DATA=(SRAM_we_n==1'd1)?16'dz:SRAM_write_data;
				SRAM_WE_N_O=SRAM_we_n;
				SRAM_UB_N_O=1'd0;
				SRAM_LB_N_O=1'd0;
				SRAM_CE_N_O=1'd0;
				SRAM_OE_N_O=1'd0;
			end
			
			always@(negedge Clock_50 or posedge Resetn)begin
				if(Resetn==1'b1)
				begin
					counter=3'd0;
					ready=1'd1;
				end
				else
				begin
					if(mem_op==1'b0) 
					begin
						counter=3'd0;
						ready=1'b1;
					end
					else 
					begin
						if(counter==3'd3)
						begin
							counter=3'd0;
							ready=1'd1;
						end
						else 
						begin
							counter=counter+3'd1;
							ready=1'b0;
						end
					end
				end
				
			end

endmodule
