`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:27:00 05/01/2021 
// Design Name: 
// Module Name:    alu_32bit 
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
module alu_32bit(
		input [31:0] a_in,
		input [31:0] b_in,
		input [2:0] op,
		output [31:0] result,
		output zero,
		output overflow
    );

		wire [31:0] cin;
		wire [30:0] cout;
		wire set;
		wire [30:0] less;
		
		alu_1bit alu_1bit_inst [30:0] (
		.a (a_in[30:0]),
		.b (b_in[30:0]),
		.cin (cin[30:0]),
		.b_invert(op[2]),
		.less(less[30:0]),
		.op(op[1:0]),
		.result(result[30:0]),
		.cout(cout[30:0])
		);
		
		alu_msb alu_msb_inst (
		.a (a_in[31]),
		.b (b_in[31]),
		.cin (cin[31]),
		.b_invert(op[2]),
		.less(1'b0),
		.op(op[1:0]),
		.result(result[31]),
		.set(set),
		.overflow(overflow)
		);
		
		
		assign cin[31:1]=cout[30:0];
		assign cin[0]=op[2];					//2's complement needs to invert and add 1
		assign zero = (result == 32'b0)?1'b1:1'b0;
		assign less[0] = set;
		assign less [30:1] = 29'b0;
endmodule
