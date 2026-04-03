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
module pipeline(
	input clk,
	input rst,
	output[31:0] result,
	output zero,
	output overflow 
    ); 
	 
	//IF에서 쓰는 변수들
	 wire [31:0] fetch_inst;		//fetch된 명렁어
	 wire [31:0] pc_next;			//현재 PC+4
	 reg [31:0] pc_update;			//branch까지 고려
	 wire [31:0] pc_curr;			//현재 PC
	 
	 //ID에서 쓰는 변수들
	 wire [31:0] pc_next_id;		//id stage에 있는 명령어의 다음 명령어 주소
	 wire [31:0] inst_id;			//id stage에 있는 명령어
	 
	 wire [8:0] ctrl_sig;					//control signal
	 reg [8:0] control_sig_modified;			//초기화 때문에 존재. 아래 참고
	 wire [31:0] write_data;				//register file의 쓰기데이터
	 wire [31:0] read_data_a;				//register file에서 읽은 데이터 a
	 wire [31:0] read_data_b;				//register file에서 읽은 데이터 b
	 wire [4:0] write_reg_num;				//register file에 쓰기 할 번호
	 wire [31:0] imm_id;						//상수 부호확장
	 wire modify_control_signal;			//초기화 때문에 존재
	 
	 //EXE에서 쓰는 변수들
	 wire RegDst;								//exe서 쓰는 control signal 들: 목적지 레지스터 선택, ALU control signal 만들기 위한 입력, alu 입력 선택
	 wire [1:0] ALUop;
	 wire ALUSrc;
	 wire [2:0] ctrl_m_ex;					//exe서 처리되는 현재 명령어가 mem에서 쓸 control signal들
	 wire [1:0] ctrl_wb_ex;					//exe서 처리되는 현재 명령어가 wb에서 쓸 control signal들
	 wire [31:0] pc_next_ex;				//exe stage에 있는 명령어의 다음 명령어 주소
	 wire [31:0] src_a_ex;					//현재 명령어가 id 때 register file에서 읽은 데이터 a
	 wire [31:0] src_b_ex;					//현재 명령어가 id 때 register file에서 읽은 데이터 b
	 wire [31:0] src_c_ex;					//현재 명령어가 id 때 부호확장한 상수
	 wire [4:0] dst_reg_a;					//I type의 목적지 레지스터 
	 wire [4:0] dst_reg_b;					//R type의 목적지 레지스터

	 wire [4:0] dst_reg_exe;				//목적지 레지스터(위의 목적지 중 명령어 타입에 맞춰 하나 선택)
	 wire [31:0] branch_addr_exe;				//계산된 branch address
	 wire [31:0] alu_input_b;					//alu 입력 b: 위의 레지스터/상수 입력 중 선택
	 wire [31:0] result_alu;				//alu연산 결과
	 wire zero_alu;						
	 wire overflow_alu;
	 wire [2:0] op_alu;						//alu로 들어가는 control signal
	 
	 //MEM에서 쓰는 변수들
	 wire branch;									//beq이면 1
	 wire MemRead;								//데이터 메모리 읽기(lw)
	 wire MemWrite;							//데이터 메모리 쓰기(sw)
	 wire [1:0] ctrl_wb_mem;				//mem서 처리되는 현재 명령어가 wb서 쓸 control signal들
	 wire [31:0] branch_addr;				//branch 주소(exe때 계산됨)
	 wire zero_mem;							//alu결과들
	 wire [31:0] result_mem;
	 wire [31:0] wr_data;					//data memory에 쓸 데이터
	 wire [4:0] dst_reg_mem;				//현재 처리되는 명령어의 목적지 레지스터
	 wire PCSrc;								//beq이고 조건 만족하면 1
	 wire [31:0] Read_data;					//data memory서 읽힌 데이터
	 
	 //WB에서 쓰는 변수들
	 wire [31:0] write_data_a;				//lw에서 읽은 쓰기 데이터와 alu서 계산한 쓰기 데이터 중 하나를 골라 쓴다. 이때의 두 쓰기 데이터들
	 wire [31:0] write_data_b;
												//IF
	 ff2 PC [31:0](				//PC
		.a(pc_update),						
		.clk(clk),
		.rst(rst),
		.b(pc_curr)
		);											
												
	 instruction_memory instruction_memory_inst(		//명령어 메모리 접근
		.MemAddr(pc_curr),
		.rst(rst),
		.Read_data(fetch_inst)
		);
		
	 assign pc_next = pc_curr+4;					//다음 PC 계산
	 
	 always@(PCSrc, branch_addr, pc_next) begin				//branch와 branch아닐 때 다음 pc가 다름
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
		
	 assign modify_ctrl_sig = ({pc_next_id, inst_id} == 64'b0);				//ISA 자체에서는 rst시 0bit sll이라서 그냥 놔둬도 되지만 과제에서는 ALU에 shift연산이 구현 안되어 부득이하게 필요.
	 always@(modify_ctrl_sig, ctrl_sig) begin									//초기화 시 ID/EXE FF에서 명령어의 opcode부분이 0이 되어서 이 부분이 없으면 0번 레지스터에서 쓰레기 값을 저장하게 된다.
		case(modify_ctrl_sig)
		0: control_sig_modified = ctrl_sig;
		1: control_sig_modified = 9'b0;
		default: control_sig_modified = ctrl_sig;
		endcase
	 end
		
		
	 flipflop idex_ff[146:0](								//ID/EXE FF: 9+32+32+32+32+5+5 bit
		.a({control_sig_modified, pc_next_id, read_data_a, read_data_b, imm_id, inst_id[20:16], inst_id[15:11]}),
		.clk(clk),
		.rst(rst),
		.b({RegDst, ALUop, ALUSrc, ctrl_m_ex, ctrl_wb_ex, pc_next_ex, src_a_ex, src_b_ex, src_c_ex, dst_reg_a, dst_reg_b })
		);
		
		

	 assign dst_reg_exe = (RegDst == 1) ? dst_reg_b :
								 (RegDst == 0) ? dst_reg_a : 5'bx;				//쓰기 주소 결정
	 
	 assign branch_addr_exe = pc_next_ex + (src_c_ex<<2);						//branch 주소 결정
	 
	 assign alu_input_b = (ALUSrc == 0)? src_b_ex : 						
								 (ALUSrc == 1)? src_c_ex : 32'bx;					//alu 2 번째 인자 결정

	 ALU_32bit ALU_32bit_inst (							
		.a_in(src_a_ex),
		.b_in(alu_input_b),
		.op(op_alu),
		.result(result_alu),
		.zero(zero_alu),
		.overflow(overflow_alu)
		);								//alu 계산.
		
	 ALU_ctrl ALU_ctrl_inst (
		.ALUop(ALUop),
		.funct(src_c_ex[5:0]),
		.op_alu(op_alu)
		);								//alu의 control signal 생성
		
	 flipflop exmem_ff[106:0](								//EX/MEM register: 3+2+32+1+32+32+5 bit
		.a({ctrl_m_ex, ctrl_wb_ex, branch_addr_exe, zero_alu, result_alu, src_b_ex, dst_reg_exe}),
		.clk(clk),
		.rst(rst),
		.b({branch, MemRead, MemWrite, ctrl_wb_mem, branch_addr, zero_mem, result_mem, wr_data, dst_reg_mem})
		);
	
	 assign PCSrc = ((branch==1)&&(zero_mem==1))?1'b1:1'b0;					//beq 조건검사
	 
	 data_memory data_memory_inst(		//명령어 메모리 접근
		.MemAddr(result_mem),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Write_Data(wr_data),
		.rst(rst),
		.Read_data(Read_data)
		);
		
	 flipflop memwb_ff[70:0](								//MEM/WB FF 2+32+32+5 bit
		.a({ctrl_wb_mem, Read_data, result_mem, dst_reg_mem}),
		.clk(clk),
		.rst(rst),
		.b({RegWrite, MemtoReg, write_data_a, write_data_b, write_reg_num})
		);
	 
	 assign write_data = (MemtoReg ==1)? write_data_a :						//쓸 데이터 선택
								(MemtoReg ==0)? write_data_b : 32'bx;
								
								
	 //출력: result, zero, overflow를 출력하겠다.
	 assign result = result_alu;
	 assign zero = zero_alu;
	 assign overflow = overflow_alu;
endmodule
