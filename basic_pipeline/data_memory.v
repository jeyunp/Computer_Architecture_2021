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
module data_memory(
	input [31:0] MemAddr,
	input MemRead,
	input MemWrite,
	input [31:0] Write_Data,
	input rst,
	output reg [31:0] Read_data
    );
	 
reg [31:0] mem [32:0];
	 
always @(*) begin
	if(rst) begin
		mem[16] <=30;
	end
	else begin
		if(MemRead && !MemWrite) begin
			Read_data <= mem[MemAddr[6:2]];
		end
		
		else if(MemWrite && !MemRead) begin
			mem[MemAddr[6:2]] <= Write_Data;
		end
		
		else begin
			Read_data <= 32'bx;
		end
	end
end

endmodule
