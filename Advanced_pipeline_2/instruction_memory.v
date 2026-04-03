`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:46 06/08/2021 
// Design Name: 
// Module Name:    memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module instruction_memory(
	input [31:0] MemAddr,
	input rst,
	output reg [31:0] Read_data
    );
	 
reg [31:0] mem [15:0];
integer count;
	 
always @(*) begin
		if(rst) begin
			mem[0] <= 32'h0c000008;
			mem[1] <= 32'h8c410004;
			mem[8] <= 32'h00854022;
			mem[9] <= 32'h00c74822;
			mem[10] <= 32'h01094020;
			mem[11] <= 32'h01001820;
			mem[12] <= 32'h03e0F808;
			
			for(count = 2; count <8; count = count+1)
				mem[count] <= 32'bx;
			for(count = 13; count <16; count = count+1)
				mem[count] <= 32'bx;
		end
		else begin
				Read_data <= mem[MemAddr[5:2]];
				
		end
end

endmodule
