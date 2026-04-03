`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:21:21 06/09/2021
// Design Name:   pipeline
// Module Name:   C:/Xilinx/14.7/pipeline/tb_pipeline.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_pipeline;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] result;
	wire zero;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	pipeline uut (
		.clk(clk), 
		.rst(rst), 
		.result(result), 
		.zero(zero), 
		.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		clk <= 0;
		rst <= 0;
		#3;
		rst <= 1;
		// Wait 100 ns for global reset to finish
		#3;
		rst <=0;
	end
	
	always begin
		#10 clk <=~clk;
	end
      
endmodule

