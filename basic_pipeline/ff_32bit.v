`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:34 06/09/2021 
// Design Name: 
// Module Name:    ff_32bit 
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
module ff_32bit(
	input [31:0] a,
	input clk,
	input rst,
	output reg [31:0] b
    );

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			b<=32'b0;
		end
		else begin
			b<=a;
		end
	end
endmodule