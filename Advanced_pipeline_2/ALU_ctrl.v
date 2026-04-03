`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:49 06/08/2021 
// Design Name: 
// Module Name:    ALU_ctrl 
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
module ALU_ctrl(
	input [1:0] ALUop,
	input [5:0] funct,
	output reg [2:0] op_alu
    );
	 
	 always@(*) begin
		if(ALUop == 2'b00)							//lw, sw
			op_alu <=3'b010;
		else if(ALUop == 2'b01)						//beq
			op_alu <= 3'b110;
		else if((ALUop == 2'b10)&&(funct == 6'b100000 || funct ==6'b001000))			//add
			op_alu <= 3'b010;
		else if((ALUop == 2'b10)&&(funct == 6'b100010))			//subtract
			op_alu <= 3'b110;
		else if((ALUop == 2'b10)&&(funct == 6'b100100))			//and
			op_alu <= 3'b000;
		else if((ALUop == 2'b10)&&(funct == 6'b100101))			//or
			op_alu <= 3'b001;
		else if((ALUop == 2'b10)&&(funct == 6'b101010))			//slt
			op_alu <= 3'b111;
		else
			op_alu <=3'bx;
			
	end

endmodule
