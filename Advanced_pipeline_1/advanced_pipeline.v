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
module advanced_pipeline(
	input clk,
	input rst,
	output[31:0] result,
	output stall_out,
	output overflow 
    ); 
	 
	//IF에서 쓰는 변수들
	 wire [31:0] fetch_inst;
	 wire [31:0] pc_next;			//현재 PC+4
	 reg [31:0] pc_update;			//branch까지 고려
	 wire [31:0] pc_curr;
	 
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
	 wire modify_control_sig;
	 
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
												//IF
	 ff2 PC [31:0](				//PC
		.a(pc_update),						//디버깅 수정
		.clk(clk),
		.rst(rst),
		.hold(stall),						//stall시 내용물 유지
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
	 
	 flipflop ifid_ff[63:0](				//IF/ID 플립플롭
		.a({pc_next, fetch_inst}),
		.clk(clk),
		.rst(rst),
		.hold(stall),						
		.flush(flush),							//flush시 명령어 하나 지워야 함
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
		
	 assign modify_ctrl_sig = ({pc_next_id, inst_id} == 64'b0) || stall;				//ISA 자체에서는 rst시 0bit sll이라서 그냥 놔둬도 되지만 과제에서는 ALU에 shift연산이 구현 안되어 부득이하게 필요.(없으면 0번 reg에 0을 쓰는 에러)
	 always@(modify_ctrl_sig, ctrl_sig) begin
		case(modify_ctrl_sig)
		0: control_sig_advanced = ctrl_sig;
		1: control_sig_advanced = 9'b0;
		default: control_sig_advanced = ctrl_sig;
		endcase
	 end
	 
 
	 //branch 앞으로 당기기
	 assign PCSrc = ((control_sig_advanced[4]==1)&&(compare==1))?1'b1:1'b0;					//branch이고 두 피연산자 크기 같으면 branch		
	 assign branch_addr = pc_next_id + (imm_id<<2);						//branch 주소 결정
	 assign compare = (read_data_a == read_data_b)?1:0;				//eq조건 비교

	 flipflop idex_ff[150:0](								//8+32+32+32+32+5+5+5 bit. 앞에서 control signal하나 썼으며, forwarding이나 hazard detection위해서는 레지스터 내용 외에 번호도 같이 전달.
		.a({control_sig_advanced[8:5], control_sig_advanced[3:0], pc_next_id, read_data_a, read_data_b, imm_id, inst_id[20:16], inst_id[15:11], inst_id[25:21]}),
		.clk(clk),
		.rst(rst),
		.hold(1'b0),						//이 FF 부터는 stall이나 flush와 상관이 없다.
		.flush(1'b0),
		.b({RegDst, ALUop, ALUSrc, ctrl_m_ex, ctrl_wb_ex, pc_next_ex, src_a_ex, src_b_ex, src_c_ex, dst_reg_a, dst_reg_b, source_num_a})
		);
		
		

	 assign dst_reg_exe = (RegDst == 1) ? dst_reg_b :
								 (RegDst == 0) ? dst_reg_a : 5'bx;				//쓰기 주소 결정

	 
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
		
	 flipflop exmem_ff[72:0](								//2+2+32+32+32+5 bit. 위와 마찬가지 이유로 basic과는 약간 다름
		.a({ctrl_m_ex, ctrl_wb_ex, result_alu, src_b_ex_fwd, dst_reg_exe}),
		.clk(clk),
		.rst(rst),
		.hold(1'b0),
		.flush(1'b0),
		.b({MemRead, MemWrite, ctrl_wb_mem, result_mem, wr_data, dst_reg_mem})
		);
	

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
								
								
	 //Forwarding Unit 추가
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
	 
	 //Forwarding unit에서 내린 결론을 바탕으로 forwarding수행. 00은 그대로, 10은 exe 결과 forwarding, 01은 mem 결과 forwarding 
	 
	 assign src_a_ex_fwd = (forwardA==2'b00)? src_a_ex:								
								  (forwardA==2'b10)? result_mem:
								  (forwardA==2'b01)? write_data:32'bx;							
								  
	 assign src_b_ex_fwd = (forwardB==2'b00)? src_b_ex:
								  (forwardB==2'b10)? result_mem:
								  (forwardB==2'b01)? write_data:32'bx;
								  
	 //Hazard 관리
	 assign stall = (ctrl_m_ex[1] && ((dst_reg_a == inst_id[25:21])||(dst_reg_a == inst_id[20:16])))?1'b1:1'b0; 		//lw결과를 소스로 활용하는지 체크
	 assign flush = (PCSrc)?1'b1:1'b0;					//branch 발생 시 flush
	
								
								
	 //출력: result, stall, overflow를 출력하겠다.
	 assign result = result_alu;
	 assign stall_out = stall;
	 assign overflow = overflow_alu;
endmodule
