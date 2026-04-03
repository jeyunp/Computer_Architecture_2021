`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:31:26 06/23/2021
// Design Name:   pipeline_call
// Module Name:   C:/Xilinx/14.7/pipeline_call/tb_pipeline_call.v
// Project Name:  pipeline_call
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline_call
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_pipeline_call;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] result;
	wire zero;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	pipeline_call uut (
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

