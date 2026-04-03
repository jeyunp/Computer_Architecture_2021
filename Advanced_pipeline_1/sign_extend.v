`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:03 06/08/2021 
// Design Name: 
// Module Name:    sign_extend 
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
module sign_extend(
		input [15:0] a,
		output [31:0] b
    );
	 
	 assign b[15:0] = a;
	 assign b[31:16] = (a[15]==1)? 16'hFFFF:
							 (a[15]==0)? 16'h0000:
							 16'hxxxx;

endmodule
