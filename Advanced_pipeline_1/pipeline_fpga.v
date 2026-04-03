`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:11 06/22/2021 
// Design Name: 
// Module Name:    pipeline_fpga 
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
module pipeline_fpga(
		input clk,
		input reset,
		output[15:0] result
    );
	 
	 wire [33:0] pipeline_result;
	 wire clk_div;
	 
	 counter counter_inst(
		.clk(clk),
		.clk_operating(clk_div)
	 );
	 
	 advanced_pipeline advanced_pipeline_inst(
		.clk(clk_div),
		.rst(!reset),
		.result(pipeline_result[31:0]),
		.stall_out(pipeline_result[32]),
		.overflow(pipeline_result[33])
	 );
	 
	 assign result[12:0] = pipeline_result[12:0];
	 assign result[15] = clk_div;
	 assign result[14] = !reset;
	 assign result[13] = pipeline_result[32];

endmodule
