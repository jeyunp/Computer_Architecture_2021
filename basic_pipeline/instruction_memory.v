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
			mem[0] <= 32'b00000000011001000001000000100000;
			mem[1] <= 32'b00000000011001000000100000100010;
			mem[2] <= 32'b10001100110001010000000000000000;
			mem[3] <= 32'b00010000100000111111111111111100;
			
			for(count = 4; count <16; count = count+1)
				mem[count] <= 32'bx;
		end
		else begin
				Read_data <= mem[MemAddr[5:2]];
				
		end
end

endmodule
