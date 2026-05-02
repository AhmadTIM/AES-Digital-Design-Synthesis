# AES Crypto-Processor Sub-Module Design & Synthesis

## Introduction
This repository features the implementation of core AES encryption transformations—SubBytes and MixColumns—designed as part of the Digital Design and Logic Synthesis course (36113611) at Ben-Gurion University[cite: 1]. The system demonstrates a full hardware development lifecycle, from RTL modeling to gate-level synthesis and power optimization[cite: 1, 11].

## Contents
1. [Project Objective and System Overview](#project-objective-and-system-overview)
2. [Verification and Testing](#verification-and-testing)
3. [SubBytes Module](#subbytes-module)
4. [MixColumns Module](#mixcolumns-module)
5. [FSM Control Unit](#fsm-control-unit)
6. [Synthesis and Clock Gating](#synthesis-and-clock-gating)

## Project Objective and System Overview
The goal of this project was to design, verify, and synthesize a high-performance AES sub-module capable of processing 128-bit data blocks[cite: 1]. The architecture is governed by a Finite State Machine (FSM) that manages data flow between the substitution and diffusion layers[cite: 1, 11].

### System Architecture
The system consists of interconnected hardware modules optimized for parallel processing[cite: 11]. The design separates combinatorial transformation logic from sequential control, ensuring predictable and efficient hardware behavior[cite: 11, 12].

## Verification and Testing
Functional verification was achieved using a SystemVerilog testbench featuring a Bus Functional Model (BFM) and automated scoreboard[cite: 8, 11].
* **Automated Results**: 12 test scenarios were executed with 0 failures, confirming mathematical correctness[cite: 9, 11].
* **Coverage**: Achieved 100% functional covergroup coverage and 100% statement/branch coverage for the FSM[cite: 11].
* **Assertions**: SystemVerilog Assertions (SVA) were used to monitor signal stability and FSM protocol adherence[cite: 8, 11].

## SubBytes Module
The SubBytes module implements a non-linear transformation layer[cite: 1]. It utilizes 16 parallel instances of an S-Box lookup table to substitute every byte in the 128-bit state simultaneously[cite: 7, 12].

## MixColumns Module
The MixColumns module provides data diffusion by performing matrix multiplication in the Rijndael Galois Field[cite: 1, 4]. It processes columns independently using optimized `Mul_2` and `Mul_3` hardware functions to ensure high-speed scattering of data[cite: 4, 11].

## FSM Control Unit
The system is orchestrated by a multi-state FSM that supports three primary operational modes[cite: 1, 11]:
* **Case 1**: Full system reset and signal initialization[cite: 1, 11].
* **Case 2**: Independent SubBytes transformation[cite: 1, 11].
* **Case 3**: Sequential SubBytes followed by MixColumns for full-round simulation[cite: 1, 11].

## Synthesis and Clock Gating
The design was synthesized using Synopsys Design Compiler with an Artisan/TSMC standard-cell library[cite: 3, 12].
* **Clock Gating**: To reduce dynamic power consumption, a gated-clock FSM version was implemented to disable switching when the system is idle[cite: 11, 12].
* **Performance**: The final netlist achieved a maximum operating frequency ($f_{max}$) of approximately 106.5 MHz[cite: 11].

## Project Components
The system is organized into the following directory structure:
* **DUT** – Contains RTL source files: `fsm.v`, `subbytes.v`, `sbox.v`, `mix_coloumns.v`, `fsm_gate.v`, and the library model `slow.v`[cite: 12].
* **TB** – Contains the SystemVerilog verification environment: `sv_tb.sv`[cite: 12].
* **TB Outputs** – Includes ModelSim scripts (`wave.do`, `list.do`) and verification evidence (`TB_console_outputs.png`)[cite: 9, 10, 12].
* **DOC** – Project documentation and technical reports[cite: 12].

## Reference
For detailed explanations of the hardware architecture, synthesis trade-offs, and area/power reports, consult the provided PDF:  
[DDLS-part3.pdf](DOC/DDLS-part3.pdf)[cite: 12]
