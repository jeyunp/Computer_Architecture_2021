`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:33 06/22/2021 
// Design Name: 
// Module Name:    Forwarding_unit 
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
module Forwarding_unit(
		input exmem_RegWrite,
		input [4:0] exmem_RegRd,
		input [4:0] idex_RegRs,
		input [4:0] idex_RegRt,
		
		input memwb_RegWrite,
		input [4:0] memwb_RegRd,

		output reg[1:0] forwardA,
		output reg[1:0] forwardB
    );
	 
	 always@(*) begin
			if (exmem_RegWrite && (exmem_RegRd != 0) && (exmem_RegRd == idex_RegRs)) begin
				forwardA <= 2'b10;
			end
			else if (memwb_RegWrite && (memwb_RegRd != 0) && (memwb_RegRd == idex_RegRs) && !(exmem_RegWrite && (exmem_RegRd != 0) && (exmem_RegRd == idex_RegRs))) begin
				forwardA <= 2'b01;
			end
			else begin
				forwardA <=2'b00;
			end
			
			if (exmem_RegWrite && (exmem_RegRd != 0) && (exmem_RegRd == idex_RegRt))
				forwardB <= 2'b10;
			else if (memwb_RegWrite && (memwb_RegRd != 0) && (memwb_RegRd == idex_RegRt) && !(exmem_RegWrite && (exmem_RegRd != 0) && (exmem_RegRd == idex_RegRt)))
				forwardB <= 2'b01;
			else
				forwardB <=2'b00;
	end
endmodule
