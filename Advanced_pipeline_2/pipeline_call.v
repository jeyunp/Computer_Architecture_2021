`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:13 06/06/2021 
// Design Name: 
// Module Name:    pipeline 
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
module pipeline_call(
	input clk,
	input rst,
	output[31:0] result,
	output zero,
	output overflow 
    ); 
	 
	//IF에서 쓰는 변수들
	 wire [31:0] fetch_inst;
	 wire [31:0] pc_next;			//현재 PC+4
	 reg [31:0] pc_update;			//branch까지 고려
	 wire [31:0] pc_curr;
	 
	 wire ifid_rst;
	 
	 //ID에서 쓰는 변수들
	 wire [31:0] pc_next_id;
	 wire [31:0] inst_id;
	 
	 wire [8:0] ctrl_sig;
	 wire [31:0] write_data;
	 wire [31:0] read_data_a;
	 wire [31:0] read_data_b;
	 wire [4:0] write_reg_num;
	 wire [31:0] imm_id;
	
	 reg [8:0] control_sig_advanced;
	 wire [31:0] branch_addr;
	 wire compare;
	 wire branch;
	 wire [31:0] branch_addr_cond;
	 
	 wire [31:0] read_data_a_jal;
	 wire [31:0] read_data_b_jal;
	 wire [31:0] imm_id_jal;
	 wire [4:0] dst_reg_jal;	
	 wire [31:0] jump_addr_jal;
	 wire [31:0] jump_addr_jr;
	 wire [31:0] jump_addr;
	 wire jmp;
	 wire [4:0] src_reg_a_jal;
	 wire [4:0] src_reg_b_jal;
	 
	 wire modify_ctrl_sig;
	 
	 //EXE에서 쓰는 변수들
	 wire RegDst;
	 wire [1:0] ALUop;
	 wire ALUSrc;
	 wire [1:0] ctrl_m_ex;
	 wire [1:0] ctrl_wb_ex;
	 wire [31:0] pc_next_ex;
	 wire [31:0] src_a_ex;
	 wire [31:0] src_b_ex;
	 wire [31:0] src_c_ex;
	 wire [4:0] dst_reg_a;
	 wire [4:0] dst_reg_b;

	 wire [4:0] dst_reg_exe;
	 wire [31:0] alu_input_b;
	 wire [31:0] result_alu;
	 wire zero_alu;
	 wire overflow_alu;
	 wire [2:0] op_alu;
	 
	 wire [31:0] src_a_ex_fwd;
	 wire [31:0] src_b_ex_fwd;
	 wire [4:0] source_num_a;
	 
	 //MEM에서 쓰는 변수들
	 wire MemRead;
	 wire MemWrite;
	 wire [1:0] ctrl_wb_mem;

	 wire zero_mem;
	 wire [31:0] result_mem;
	 wire [31:0] wr_data;
	 wire [4:0] dst_reg_mem;
	 wire PCSrc;
	 wire [31:0] Read_data;
	 
	 //WB에서 쓰는 변수들
	 wire [31:0] write_data_a;
	 wire [31:0] write_data_b;
	 
	 //기타 변수
	 wire [1:0] forwardA;
	 wire [1:0] forwardB;
	 wire flush;
	 wire stall;
	 wire stall_lw;
	 wire stall_jr;
												//IF
	 ff2 PC [31:0](				//PC
		.a(pc_update),						//디버깅 수정
		.clk(clk),
		.rst(rst),
		.hold(stall),
		.b(pc_curr)
		);											
												
	 instruction_memory instruction_memory_inst(		//명령어 메모리 접근
		.MemAddr(pc_curr),
		.rst(rst),
		.Read_data(fetch_inst)
		);
		
	 assign pc_next = pc_curr+4;					//다음 PC 계산
	 
	 
	 always@(PCSrc, branch_addr, pc_next) begin
		case(PCSrc)
		0: pc_update = pc_next;
		1: pc_update = branch_addr;
		default: pc_update = pc_next;
		endcase
	 end
	 //assign pc_update = (PCSrc == 1'b1) ? branch_addr : pc_next;
	 
	 flipflop ifid_ff[63:0](				//IF/ID 플립플롭
		.a({pc_next, fetch_inst}),
		.clk(clk),
		.rst(rst),
		.hold(stall),
		.flush(flush),
		.b({pc_next_id, inst_id})
		);
													//ID
	 control control_inst (					//control signal 형성
		.opcode(inst_id[31:26]),
		.ctrl_sig(ctrl_sig)
		);
		
		
	 register register_inst (				//레지스터 파일 접근
		.read_a(inst_id[25:21]),			//주소
		.read_b(inst_id[20:16]),
		.write(write_reg_num),
		.write_data(write_data),			//쓰기데이터
		.regwrite(RegWrite),
		.rst(rst),
		.clk(clk),
		.read_data_a(read_data_a),			//출력데이터
		.read_data_b(read_data_b)
		);
		
	 sign_extend sign_extend_inst (			//부호확장
		.a(inst_id[15:0]),
		.b(imm_id)
		);
		
	 assign modify_ctrl_sig = ({pc_next_id, inst_id} == 64'b0) || stall;				//ISA 자체에서는 rst시 0bit sll이라서 그냥 놔둬도 되지만 과제에서는 ALU에 shift연산이 구현 안되어 부득이하게 필요.
	 always@(modify_ctrl_sig, ctrl_sig) begin
		case(modify_ctrl_sig)
		0: control_sig_advanced = ctrl_sig;
		1: control_sig_advanced = 9'b0;
		default: control_sig_advanced = ctrl_sig;
		endcase
	 end
	 
 
	 //branch 앞으로 당기기
	 assign branch = ((control_sig_advanced[4]==1)&&(compare==1))?1'b1:1'b0;
	 assign branch_addr_cond = pc_next_id + (imm_id<<2);						//branch 주소 결정
	 assign compare = (read_data_a == read_data_b)?1'b1:1'b0;
	 
	 
	 //jal, jr
	 assign read_data_a_jal = (inst_id[31:26]==6'b000011)?pc_next_id:read_data_a;					//리턴주소 저장해야 함: add $ra, pc+1, $0
	 assign read_data_b_jal = (inst_id[31:26]==6'b000011)?32'b0:read_data_b;		
	 assign imm_id_jal = (inst_id[31:26]==6'b000011)?32'h00000020:imm_id;
	 assign dst_reg_jal = (inst_id[31:26]==6'b000011)?5'b11111:inst_id[15:11];
	 assign src_reg_a_jal = (inst_id[31:26]==6'b000011)?5'b00000:inst_id[25:21];				//우연히 번호가 겹치면서 발생할 수 있는 forwarding 관련 문제 때문
	 assign src_reg_b_jal = (inst_id[31:26]==6'b000011)?5'b00000:inst_id[20:16];
	
	 assign jump_addr_jal= {pc_next_id[31:28], inst_id[25:0], 2'b00};
	 assign jmp = (inst_id[31:26] == 6'b000011) || ((inst_id[31:26] == 6'b000000) && (inst_id[5:0] == 6'b001000) && !stall)?32'b1:32'b0;
	 assign jump_addr_jr=read_data_a;
	 assign jump_addr = (inst_id[31:26] == 6'b000011)?jump_addr_jal:
							  ((inst_id[31:26] == 6'b000000) && (inst_id[5:0] == 6'b001000))?jump_addr_jr:32'bx;
							  
	 assign PCSrc = branch||jmp;
	 assign branch_addr = ((branch ==1) && (jmp==0))?branch_addr_cond:
								 ((branch ==0) && (jmp==1))?jump_addr:32'bx;


	 flipflop idex_ff[118:0](								//8+32+32+32+5+5+5 bit
		.a({control_sig_advanced[8:5], control_sig_advanced[3:0], read_data_a_jal, read_data_b_jal, imm_id_jal, src_reg_b_jal, dst_reg_jal, src_reg_a_jal}),
		.clk(clk),
		.rst(rst),
		.hold(1'b0),
		.flush(1'b0),
		.b({RegDst, ALUop, ALUSrc, ctrl_m_ex, ctrl_wb_ex, src_a_ex, src_b_ex, src_c_ex, dst_reg_a, dst_reg_b, source_num_a})
		);
		
		

	 assign dst_reg_exe = (RegDst == 1) ? dst_reg_b :
								 (RegDst == 0) ? dst_reg_a : 5'bx;				//쓰기 주소 결정
	 
//	 assign branch_addr_exe = pc_next_ex + (src_c_ex<<2);						//branch 주소 결정
	 
	 assign alu_input_b = (ALUSrc == 0)? src_b_ex_fwd : 						
								 (ALUSrc == 1)? src_c_ex : 32'bx;					//alu 2 번째 인자 결정

	 ALU_32bit ALU_32bit_inst (							
		.a_in(src_a_ex_fwd),
		.b_in(alu_input_b),
		.op(op_alu),
		.result(result_alu),
		.zero(zero_alu),
		.overflow(overflow_alu)
		);								//alu 계산. 근데 overflow는 뭐에 쓰지?
		
	 ALU_ctrl ALU_ctrl_inst (
		.ALUop(ALUop),
		.funct(src_c_ex[5:0]),
		.op_alu(op_alu)
		);								//alu의 opcode 생성
		
	 flipflop exmem_ff[72:0](								//2+2+32+32+32+5 bit
		.a({ctrl_m_ex, ctrl_wb_ex, result_alu, src_b_ex_fwd, dst_reg_exe}),
		.clk(clk),
		.rst(rst),
		.hold(1'b0),
		.flush(1'b0),
		.b({MemRead, MemWrite, ctrl_wb_mem, result_mem, wr_data, dst_reg_mem})
		);
	
//	 assign PCSrc = ((branch==1)&&(zero_mem==1))?1'b1:1'b0;
	 
	 data_memory data_memory_inst(		//명령어 메모리 접근
		.MemAddr(result_mem),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Write_Data(wr_data),
		.rst(rst),
		.Read_data(Read_data)
		);
		
	 flipflop memwb_ff[70:0](								//2+32+32+5 bit
		.a({ctrl_wb_mem, Read_data, result_mem, dst_reg_mem}),
		.clk(clk),
		.rst(rst),
		.hold(1'b0),
		.flush(1'b0),
		.b({RegWrite, MemtoReg, write_data_a, write_data_b, write_reg_num})
		);
	 
	 assign write_data = (MemtoReg ==1)? write_data_a :
								(MemtoReg ==0)? write_data_b : 32'bx;
								
								
	 Forwarding_unit Forwarding_unit_inst (
			.exmem_RegWrite(ctrl_wb_mem[1]),
			.memwb_RegWrite(RegWrite),
			.exmem_RegRd(dst_reg_mem),
			.memwb_RegRd(write_reg_num),
			.idex_RegRs(source_num_a),
			.idex_RegRt(dst_reg_a),
			.forwardA(forwardA),
			.forwardB(forwardB)
	 );
	 
	 assign src_a_ex_fwd = (forwardA==2'b00)? src_a_ex:
								  (forwardA==2'b10)? result_mem:
								  (forwardA==2'b01)? write_data:32'bx;
								  
	 assign src_b_ex_fwd = (forwardB==2'b00)? src_b_ex:
								  (forwardB==2'b10)? result_mem:
								  (forwardB==2'b01)? write_data:32'bx;
								  
	 //Hazard 관리: stack의 restore에 관한 부분 추가-lw에 의해 ra가 복원될 경우 이때의 hazard 관리
	 assign stall_lw = (ctrl_m_ex[1] && ((dst_reg_a == inst_id[25:21])||(dst_reg_a == inst_id[20:16])))?1'b1:1'b0; 
	 assign stall_jr = MemRead && (inst_id[31:26] == 6'b000000) && (inst_id[5:0] == 6'b001000) && (dst_reg_mem == 5'b11111);		//ID에 jr, MEM에 ra로 lw
	 assign stall = stall_lw||stall_jr;
	 
	 assign flush = (PCSrc)?1'b1:1'b0;
	
								
								
	 //출력: result, zero, overflow를 출력하겠다.
	 assign result = result_alu;
	 assign zero = zero_alu;
	 assign overflow = overflow_alu;
endmodule
