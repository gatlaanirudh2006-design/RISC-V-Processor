*** Single Cycle RISC-V Processor ***
This project presents the design and implementation of a **32-bit Single-Cycle RISC-V Processor** using **Verilog HDL**.

The processor is capable of executing instructions from the RISC-V instruction set architecture (ISA) by performing instruction fetch, decode, execution, memory access, and write-back operations within a single clock cycle.

The design was developed to gain a deeper understanding of processor architecture, RTL design methodologies, and FPGA-based implementation of modern computing systems.

---

## What is RISC-V?

**RISC-V** is an open-standard Instruction Set Architecture (ISA) based on the principles of Reduced Instruction Set Computing (RISC).

Unlike proprietary architectures, RISC-V is freely available and allows engineers, researchers, and organizations to design processors without licensing restrictions.

Today, RISC-V has become one of the fastest-growing processor architectures in both academia and industry due to its simplicity, flexibility, and scalability.

### Key Features

- Open-source and royalty-free
- Simple and modular architecture
- Easy to learn and implement
- Supports custom instruction extensions
- Widely adopted for embedded and research applications
- Industry-supported ecosystem

---

## Project Objective

The primary objective of this project is to design a functional RISC-V processor capable of:

- Fetching instructions from instruction memory
- Decoding machine instructions
- Generating appropriate control signals
- Performing arithmetic and logical operations
- Reading and writing data memory
- Executing branch and jump instructions
- Updating the program counter
- Writing results back to registers

---

## Processor Architecture

The processor follows a **Single-Cycle Datapath Architecture**.

In this architecture, each instruction completes all stages of execution within a single clock cycle.

### Execution Flow

```text
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
Register Write Back
```

---

## Supported Instructions

### R-Type Instructions

| Instruction | Description |
|------------|-------------|
| ADD | Addition |
| SUB | Subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |
| SLL | Shift Left Logical |
| SRL | Shift Right Logical |
| SRA | Shift Right Arithmetic |
| SLT | Set Less Than |
| SLTU | Set Less Than Unsigned |

### I-Type Instructions

- ADDI
- ANDI
- ORI
- XORI
- SLLI
- SRLI
- SRAI

### Memory Instructions

- LW (Load Word)
- SW (Store Word)

### Branch Instructions

- BEQ
- BNE
- BLT
- BGE

### Jump Instructions

- JAL
- JALR

### Upper Immediate Instructions

- LUI
- AUIPC

---

## Design Modules

### Program Counter (`pc.v`)

Maintains the address of the instruction currently being executed and updates it during every clock cycle.

### Instruction Memory (`instruction_memory.v`)

Stores machine-code instructions and provides instruction fetch functionality.

### Control Unit (`control_unit.v`)

Decodes instructions and generates control signals required by the datapath.

### Immediate Generator (`imm_gen.v`)

Extracts and sign-extends immediate values from different RISC-V instruction formats.

### Register File (`register_file.v`)

Implements 32 general-purpose registers with dual-read and single-write capability.

### ALU Control Unit (`alu_control.v`)

Determines the operation to be performed by the ALU based on instruction fields.

### Arithmetic Logic Unit (`alu.v`)

Performs arithmetic, logical, comparison, and shift operations.

### Branch Unit (`branch_unit.v`)

Evaluates branch conditions and determines the next program counter value.

### Data Memory (`data_memory.v`)

Supports load and store operations required during program execution.

### Top Module (`top_riscv.v`)

Integrates all processor components into a complete RISC-V CPU.

---

## Project Directory

```bash
.
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
```

---

## Simulation and Verification

The processor was functionally verified using a dedicated Verilog testbench.

Verification includes:

- Instruction Fetch Validation
- Register Read/Write Verification
- ALU Functional Testing
- Memory Read/Write Operations
- Branch Instruction Testing
- Complete Program Execution

---

## FPGA Implementation

**Target Board:** Basys 3 FPGA

The processor can be synthesized and deployed on FPGA hardware for real-time execution and verification.

### Demonstrated Features

- Real-time instruction execution
- Hardware validation of datapath
- FPGA-based processor implementation
- Observation of processor outputs through onboard peripherals

---

## Learning Outcomes

This project provided practical exposure to:

- Computer Architecture
- RISC-V ISA
- RTL Design using Verilog HDL
- Datapath and Control Unit Design
- Functional Verification
- FPGA Prototyping
- Digital System Design

---

## Future Enhancements

- Five-Stage Pipelined Architecture
- Hazard Detection Unit
- Forwarding Unit
- UART Communication Interface
- Cache Memory Integration
- Interrupt Handling Mechanism
- RV32IM Extension Support

---

## Author

**Anirudh Gatla**

Electronics & Communication Engineering  
Aspiring VLSI Verification Engineer
