# 32-bit-ALU
#  32-bit ALU Design using Verilog (Xilinx Vivado)

##  Overview
This project implements a **32-bit Arithmetic Logic Unit (ALU)** using **Verilog HDL**, designed for **FPGA synthesis and simulation** via **Xilinx Vivado**. The ALU performs core arithmetic, logic, shift, and comparison operations commonly used in CPU architecture.

The design includes:
- Parameterized ALU (`alu32.v`)
- Self-checking Testbench (`tb_alu32.v`)
- Optional Top Module for FPGA implementation (`top_alu.v`)

---

##  Theory – What is an ALU?
An **Arithmetic Logic Unit (ALU)** is a critical component of the CPU responsible for executing arithmetic (`+`, `-`) and logical operations (`AND`, `OR`, `XOR`). Modern processors use ALUs to perform most computations.  
This 32-bit ALU mimics the behavior of a processor ALU, providing **flags** for zero, negative, carry, and overflow detection.

---

## 🔧 Supported Operations

| Op Code | Operation | Description |
|--------:|-----------|-------------|
| `0000`  | ADD       | `a + b` |
| `0001`  | SUB       | `a - b` |
| `0010`  | AND       | Bitwise AND |
| `0011`  | OR        | Bitwise OR |
| `0100`  | XOR       | Bitwise XOR |
| `0101`  | NOR       | Bitwise NOR |
| `0110`  | SLL       | Logical left shift |
| `0111`  | SRL       | Logical right shift |
| `1000`  | SRA       | Arithmetic right shift |
| `1001`  | SLT       | Set if `a < b` (signed) |
| `1010`  | SLTU      | Set if `a < b` (unsigned) |

---

##  ALU Status Flags

| Flag | Definition |
|------|------------|
| `Zero (Z)` | Result is `0` |
| `Negative (N)` | Sign bit (`result[31]`) is `1` |
| `Carry (C)` | Carry out from addition/subtraction |
| `Overflow (V)` | Signed overflow occurred |

---

