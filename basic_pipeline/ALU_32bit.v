`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:06 06/08/2021 
// Design Name: 
// Module Name:    ALU_32bit 
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
module ALU_32bit(
	input [31:0] a_in,
	input [31:0] b_in,
	input [2:0] op,
	output [31:0] result,
	output zero,
	output overflow
    );
	 
	 wire [31:0] result_and;
	 wire [31:0] result_or;
	 wire [31:0] result_add;
	 wire [31:0] result_sub;
	 wire [31:0] result_slt;
	 
	 assign result_and = a_in&b_in;
	 assign result_or = a_in|b_in;
	 assign result_add = a_in+b_in;
	 assign result_sub = a_in-b_in;
	 assign result_slt = (result_sub[31] == 0) ? 32'h0000 : 32'hFFFF;
	 
	 assign result = (op == 0) ? result_and :
						  (op == 1) ? result_or :
						  (op == 2) ? result_add :
						  (op == 6) ? result_sub :
						  (op == 7) ? result_slt : 32'bx;				//°¢°¢ 000, 001, 010, 110, 111
	 assign zero = (result == 0) ? 1'b1 : 1'b0;
	 assign overflow = (op[2]~^(a_in[31]^b_in[31])) & (a_in[31]^result[31]) & op[1];


endmodule
