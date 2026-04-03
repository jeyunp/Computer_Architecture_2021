`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:39:24 05/23/2021
// Design Name:   memory_module
// Module Name:   C:/Xilinx/14.7/memory/tb_memory_module.v
// Project Name:  memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: memory_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_memory_module;

	// Inputs
	reg [8:0] MemAddr;
	reg MemRead;
	reg MemWrite;
	reg [31:0] Write_data;

	// Outputs
	wire [31:0] Read_data;

	// Instantiate the Unit Under Test (UUT)
	memory_module uut (
		.MemAddr(MemAddr), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.Write_data(Write_data), 
		.Read_data(Read_data)
	);

	initial begin
		// Initialize Inputs
		MemAddr = 0;
		MemRead = 0;
		MemWrite = 0;
		Write_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here
		
		MemAddr = 9'b000001000;
		MemRead = 0;
		MemWrite = 1;
		Write_data = 20210523;
		
		#100;
		MemRead = 1;
		MemWrite = 0;
		
		#100;
		MemRead = 1;
		MemWrite = 1;
		
		#100;
		MemWrite=0;


	end
      
endmodule

