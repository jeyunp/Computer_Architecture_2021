`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:23 06/08/2021 
// Design Name: 
// Module Name:    flipflop 
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
module flipflop(
	input a,
	input clk,
	input rst,
	output reg b
    );

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			b<=1'b0;
		end
		else begin
			b<=a;
		end
	end
endmodule
