`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:47 04/28/2021 
// Design Name: 
// Module Name:    alu_1bit 
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
module alu_1bit(
		input a,
		input b,
		input cin,
		input b_invert,
		input less,
		input [1:0] op,
		output result,
		output cout
    );
	 
	 wire out [3:0];
	 wire b_inv;					//inversion of input b
	 wire b_sel;					//b or b'

	 
	 assign b_inv = ~b;
	 assign b_selected = (b_invert == 0)? b:
						 (b_invert == 1)? b_inv: 1'bx;
						 
	 assign out[0] = a & b_selected;
	 assign out[1] = a | b_selected;
	 
	 full_adder A1(
    .x_in (a),       
    .y_in (b_selected),       
    .c_in (cin),       
    .s_out (out[2]),      
    .c_out (cout)
	 );
	 
	 assign out[3] = less;
	 
	 assign result = (op == 0)? out[0]:
					(op == 1)? out[1]:
					(op == 2)? out[2]:
					(op == 3)? out[3]: 1'bx;
					

endmodule
