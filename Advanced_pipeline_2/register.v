`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:44 06/08/2021 
// Design Name: 
// Module Name:    register 
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
module register(
	input [4:0] read_a,
	input [4:0] read_b,
	input [4:0] write,
	input [31:0] write_data,
	input regwrite,
	input clk,
	input rst,
	output [31:0] read_data_a,
	output [31:0] read_data_b
    );
	 
reg [31:0] register [31:0];
integer count;

		
assign read_data_a = register[read_a];
assign read_data_b = register[read_b];	
	 
always @(negedge clk, posedge rst) begin
		if(rst) begin

			for(count = 0; count <32; count = count+1)
				register[count] <= 32'h00000000;
			register[1]<=20;
			register[2]<=8;
			register[4]<=9;
			register[5]<=8;
			register[6]<=7;
			register[7]<=6;
		end
		
		else begin
			if(regwrite) begin
				register[write] <= write_data;
			end
			else begin
				register[write] <= register[write];
			end
		end
end		

endmodule

