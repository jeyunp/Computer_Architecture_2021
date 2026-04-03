# Computer_Architecture_2021

My solutions to the 2021 Computer Architecture (ENE1004) assignments at Hanyang University.  
Simple assignments like 4:1 mux or clock divider are not included.  
Solutions may contain errors.

## ALU
Build and test a 32-bit ALU that supports AND, OR, ADD, SUB, SLT. Also it needs to check zero and overflow.
32-bit ALU is constructed with 1-bit ALUs.  
1-bit alu supports OR, AND, ADD. Also, it has input port 'less' and if op==2'b11, its output is 'less' input value.  
1-bit ALU that operates to handle MSB part of 32-bit should be little bit different with other 1-bit ALUs because it is related to overflow.  
Therefore, we have 4 files: 1-bit ALU, 1-bit MSB ALU, 32-bit ALU, testbench.  
Assume full adder is provided.

## Memory
Build and test a memory array with verilog.  
Width 32bit, 128 line, 9bit address.
Input port: MemAddr(9-bit), MemRead(1-bit), MemWrite(1-bit), Write_Data(32-bit)  
Output port: Read_Data(32-bit)  
