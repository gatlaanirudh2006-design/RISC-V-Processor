#  Single Cycle RISC-V-Processor
Design and Implementation of Single Cycle RISC-V Processor on Basys 3  FPGA
RISC-V Single-Cycle Processor in Verilog
Overview

This project implements a 32-bit Single-Cycle RISC-V Processor using Verilog HDL. The processor is designed based on the open-source RISC-V Instruction Set Architecture (ISA) and is capable of fetching, decoding, executing, and writing back instructions in a single clock cycle.

The design was simulated and verified using Verilog testbenches and can be implemented on FPGA platforms such as the Basys 3 board.

What is RISC-V?

RISC-V is an open-source Instruction Set Architecture (ISA) based on the Reduced Instruction Set Computer (RISC) philosophy.

Unlike proprietary ISAs, RISC-V is freely available and allows researchers, students, and companies to design custom processors without licensing fees.

Key Features
Open-source architecture
Simple and modular instruction set
Scalable from embedded systems to high-performance processors
Widely used in academia and industry
Supports custom instruction extensions
Project Objective

The objective of this project is to design and implement a functional RISC-V processor capable of:

Fetching instructions from instruction memory
Decoding instruction fields
Generating control signals
Performing arithmetic and logical operations
Accessing data memory
Updating the program counter
Executing branch and jump instructions
Writing results back to the register file
Processor Architecture

The processor follows a Single-Cycle Datapath Architecture.

In a single-cycle processor:

Every instruction completes in one clock cycle.
Fetch, Decode, Execute, Memory Access, and Write Back occur within the same cycle.
The design is simple and easy to understand.
Suitable for learning processor architecture concepts.
Supported Instructions
R-Type Instructions
ADD
SUB
AND
OR
XOR
SLL
SRL
SRA
SLT
SLTU
I-Type Instructions
ADDI
ANDI
ORI
XORI
SLLI
SRLI
SRAI
Memory Instructions
LW
SW
Branch Instructions
BEQ
BNE
BLT
BGE
Jump Instructions
JAL
JALR
Upper Immediate Instructions
LUI
AUIPC
Project Modules
Program Counter (pc.v)

Stores the address of the current instruction and updates it every clock cycle.

Functions
Holds current PC value
Supports reset operation
Updates PC to next instruction address
Instruction Memory (instruction_memory.v)

Stores the machine code instructions.

Functions
Reads instructions from program.mem
Provides instruction corresponding to the current PC
Supports instruction fetch stage
Control Unit (control_unit.v)

Generates control signals based on the instruction opcode.

Control Signals
RegWrite
ALUSrc
MemRead
MemWrite
MemToReg
Branch
Jump
Jalr
Lui
Auipc
Immediate Generator (imm_gen.v)

Extracts and sign-extends immediate values from instructions.

Supported Formats
I-Type
S-Type
B-Type
U-Type
J-Type
Register File (register_file.v)

Contains 32 general-purpose registers.

Features
Two read ports
One write port
Register x0 permanently hardwired to zero
ALU Control Unit (alu_control.v)

Generates ALU operation codes based on:

Opcode
Funct3
Funct7
Arithmetic Logic Unit (alu.v)

Performs arithmetic and logical operations.

Supported Operations
Addition
Subtraction
AND
OR
XOR
Shift Left
Shift Right
Arithmetic Shift Right
Set Less Than
Branch Unit (branch_unit.v)

Evaluates branch conditions and determines whether a branch should be taken.

Data Memory (data_memory.v)

Stores data used by load and store instructions.

Functions
Read data from memory
Write data to memory
Support LW and SW instructions
Top Module (top_riscv.v)

Integrates all processor modules into a complete RISC-V CPU.

Additional Features
Clock divider for FPGA implementation
LED output display
Switch-controlled output selection
Reset support
Design Flow
Instruction Fetch
        ↓
Instruction Decode
        ↓
Control Signal Generation
        ↓
Immediate Generation
        ↓
ALU Execution
        ↓
Memory Access
        ↓
Write Back
Simulation

The processor functionality was verified using:

Verilog Testbench
Functional Simulation
Waveform Analysis

Testbench File:

tb_riscv.v
FPGA Implementation

Target FPGA:

Basys 3 FPGA Board

Constraint File:

riscv.xdc

Features demonstrated on FPGA:

Real-time processor execution
LED output visualization
Hardware verification
File Structure
├── alu.v
├── alu_control.v
├── branch_unit.v
├── control_unit.v
├── data_memory.v
├── imm_gen.v
├── instruction_memory.v
├── pc.v
├── register_file.v
├── top_riscv.v
├── tb_riscv.v
├── riscv.xdc
├── program.mem
└── README.md
Future Enhancements
Five-stage pipelined RISC-V processor
Hazard detection unit
Forwarding unit
UART communication
Cache memory integration
Interrupt handling support
Author

Anirudh Gatla
Electronics and Communication Engineering (ECE)
Aspiring VLSI Verification Engineer
