module reg_file(input clk, rst, input rg_wrt_enable, input[2:0]rg_wrt_dest,input[15:0] rg_wrt_data, 
				input[2:0] rg_rd_addr1,output[15:0] rg_rd_data1,input[2:0] rg_rd_addr2,output[15:0] rg_rd_data2
				);
				
				reg[15:0] registers[0:7];
				
				
				assign rg_rd_data1 = registers[rg_rd_addr1];
				assign rg_rd_data2 = registers[rg_rd_addr2];
				
				always@(posedge clk or posedge rst) begin
					if(rst==1'd1)begin
						registers[0]=16'd0;
						registers[1]=16'd0;
						registers[2]=16'd0;
						registers[3]=16'd0;
						registers[4]=16'd0;
						registers[5]=16'd0;
						registers[6]=16'd0;
						registers[7]=16'd0;
					end
					else begin
						if(rg_wrt_enable==1'b1 && rg_wrt_dest!=3'b000)begin
							registers[rg_wrt_dest] = rg_wrt_data;
						end
					end
				end
endmodule
