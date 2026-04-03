`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:35 04/10/2021 
// Design Name: 
// Module Name:    counter 
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
module counter(
		input clk,
//		input rst,
		output reg clk_operating
    );
	 reg [25:0] count;
	 
	 always @(posedge clk/*, posedge rst*/) begin
/*		if (rst) begin
			count <= 25'b0;
			clk_operating <= 1'b0;
		end*/
		
	//	else begin
			count <= count + 1;
			if (count == 26'h3FFFFFF)
				clk_operating <= clk_operating+1;
		//end
	end
endmodule
