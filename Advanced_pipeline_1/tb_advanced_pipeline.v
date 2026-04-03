`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:42:41 06/22/2021
// Design Name:   advanced_pipeline
// Module Name:   C:/Xilinx/14.7/advanced_pipeline/tb_advanced_pipeline.v
// Project Name:  advanced_pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: advanced_pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_advanced_pipeline;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] result;
	wire stall;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	advanced_pipeline uut (
		.clk(clk), 
		.rst(rst), 
		.result(result), 
		.stall_out(stall), 
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
		#30
		rst<=1;
		#2
		rst<=0;
	end
	
	always begin
		#10 clk <=~clk;
	end
      
endmodule

