`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:00 06/08/2021 
// Design Name: 
// Module Name:    control 
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
module control(
	input [5:0] opcode,
	output reg[8:0] ctrl_sig
    );
	 
	 
	always@(opcode) begin
		if(opcode == 6'b000000 || opcode ==6'b000011) begin										//r type, jal
			ctrl_sig = 9'b110000010;
		end
		else if (opcode == 6'b100011) begin								//lw
			ctrl_sig = 9'b000101011;
		end
		else if (opcode == 6'b101011) begin								//sw
			ctrl_sig = 9'bx0010010x;
		end
		else if (opcode == 6'b000100) begin								//beq
			ctrl_sig = 9'bx0101000x;
		end
		else begin														//otherwise
			ctrl_sig = 9'bx;
		end
	end
endmodule
