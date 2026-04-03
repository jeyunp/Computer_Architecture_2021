`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:46:22 05/01/2021
// Design Name:   alu_32bit
// Module Name:   C:/Xilinx/14.7/ALU_32bit/tb_alu32bit.v
// Project Name:  ALU_32bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu_32bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_alu_32bit;

	// Inputs
	reg [31:0] a_in;
	reg [31:0] b_in;
	reg [2:0] op;

	// Outputs
	wire [31:0] result;
	wire zero;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	alu_32bit uut (
		.a_in(a_in), 
		.b_in(b_in), 
		.op(op), 
		.result(result), 
		.zero(zero), 
		.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		a_in = 0;
		b_in = 0;
		op = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		// AND operation check
		a_in = 32'hF0F0;
		b_in = 32'hFF00;
		#50;
		
		// OR operation check
		op = 3'b001;
		#50;
		
		// ADD without overflow check
		op = 3'b010;
		a_in = 32'hFFFFFFFF;						//negative+positive
		b_in = 32'h00000001;		
		#50;
		a_in = 32'h7FFFFFFF;						//positive+negative
		b_in = 32'hC0000000;
		#50;
		
		// ADD with overflow check
		a_in = 32'h80000000;						//negative+negative overflow
		#50;
		a_in = 32'h7FFFFFFF;						//positive+positive overflow
		b_in = 32'h7FFFFFFF;
		#50;
		
		// SUB without overflow check
		op = 3'b110;
		b_in = 32'h7FFFFFF0;						//positive-positive
		
		#50;
		a_in = 32'hF0000000;						//negative-negative
		b_in = 32'h80000000;
		#50;
		
		// SUB with overflow check
		b_in = 32'h7FFFFFFF;						//negative-positive
		#50;
		a_in = 32'h7FFFFFFF;
		b_in = 32'hF0000000;						//positive-negative
		#50;
		
		// zero check
		a_in = 32'h00000000;
		b_in = 32'h00000000;
		#50;
		
		// slt check
		op = 3'b111;
		a_in = 32'h00000001;
		b_in = 32'h00000000;
		#50;
		
		a_in = 32'h00000000;
		b_in = 32'h00000001;
	end
      
endmodule

