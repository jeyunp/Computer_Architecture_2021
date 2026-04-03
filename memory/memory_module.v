`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:03 05/23/2021 
// Design Name: 
// Module Name:    memory_module 
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
module memory_module(
	input [8:0] MemAddr,
	input MemRead,
	input MemWrite,
	input [31:0] Write_data,
	output[31:0]  Read_data
    );
	 
	 reg [31:0] mem [127:0];
	 reg [31:0] RDDATA_sig;
	 
	 always @ (MemRead, MemWrite, MemAddr) begin
			if(MemRead == 1 & MemWrite ==0) begin
					RDDATA_sig <= mem[MemAddr[8:2]];
			end else if(MemRead == 0 & MemWrite ==1) begin
					mem[MemAddr[8:2]] <= Write_data;
			end else begin
					RDDATA_sig <= 32'b0;
			end
	 end
	 
	 assign Read_data = RDDATA_sig;
	 
endmodule
