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
			mem[0] <= 32'h8c410004;
			mem[1] <= 32'h00252022;
			mem[2] <= 32'h00273024;
			mem[3] <= 32'h00294025;
			mem[4] <= 32'h10c0fffb;
			
			for(count = 5; count <16; count = count+1)
				mem[count] <= 32'bx;
		end
		else begin
				Read_data <= mem[MemAddr[5:2]];
				
		end
end

endmodule
