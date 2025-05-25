`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 10:33:52
// Design Name: 
// Module Name: riscv_defs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// PC_Offset
`define PC_OFFSET                               32'h003FFFF8

// Opcode
`define OPCODE_R                                7'b0110011
`define OPCODE_I                                7'b0010011
`define OPCODE_L                                7'b0000011
`define OPCODE_S                                7'b0100011
`define OPCODE_B                                7'b1100011
`define OPCODE_LUI                              7'b0110111
`define OPCODE_AUIPC                            7'b0010111
`define OPCODE_JAL                              7'b1101111
`define OPCODE_JALR                             7'b1100111
`define OPCODE_E                                7'b1110011
`define OPCODE_FADD                             7'b1010011

// ALUOp
`define ALUOP_L_S                               2'b00
`define ALUOP_B                                 2'b01
`define ALUOP_R                                 2'b10
`define ALUOP_I                                 2'b11

// ALU Operations
`define ALU_NONE                                4'b0000
`define ALU_SHIFTL                              4'b0001
`define ALU_SHIFTR                              4'b0010
`define ALU_SHIFTR_ARITH                        4'b0011
`define ALU_ADD                                 4'b0100
`define ALU_SUB                                 4'b0110
`define ALU_AND                                 4'b0111
`define ALU_OR                                  4'b1000
`define ALU_XOR                                 4'b1001
`define ALU_LESS_THAN_UNSIGNED                  4'b1010
`define ALU_LESS_THAN_SIGNED                    4'b1011
`define ALU_SUB_UNSIGNED                        4'b1100
`define ALU_FADD                                4'b1101

// instruction funct for R-type
`define INST_ADD                                12'h0_00
`define INST_SUB                                12'h0_20
`define INST_XOR                                12'h4_00
`define INST_OR                                 12'h6_00
`define INST_AND                                12'h7_00
`define INST_SLL                                12'h1_00
`define INST_SRL                                12'h5_00
`define INST_SRA                                12'h5_20
`define INST_SLT                                12'h2_00
`define INST_SLTU                               12'h3_00
`define INST_FADD                               4'b0001
 
// instruction funct for I-type
`define INST_ADDI                               3'h0
`define INST_XORI                               3'h4
`define INST_ORI                                3'h6
`define INST_ANDI                               3'h7
`define INST_SLLI                               12'h1_00
`define INST_SRLI                               12'h5_00
`define INST_SRAI                               12'h5_20
`define INST_SLTI                               3'h2
`define INST_SLTUI                              3'h3

// instruction funct for Load
`define INST_LB                                 3'h0
`define INST_LH                                 3'h1
`define INST_LW                                 3'h2
`define INST_LBU                                3'h4
`define INST_LHU                                3'h5

// instruction funct for S-type
`define INST_SB                                 3'h0
`define INST_SH                                 3'h1
`define INST_SW                                 3'h2

// instruction funct for B-type
`define INST_BEQ                                3'h0
`define INST_BNE                                3'h1
`define INST_BLT                                3'h4
`define INST_BGE                                3'h5
`define INST_BLTU                               3'h6
`define INST_BGEU                               3'h7

// instruction funct for Ecall
`define INST_ECALL                              12'h0
`define INST_EBREAK                             12'h1

// Operation code for EcallOp
`define EOP_PRINT_INT                           12'h1
`define EOP_READ_INT                            12'h5