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
`define ALU_LESS_THAN                           4'b1010
`define ALU_LESS_THAN_SIGNED                    4'b1011

`define INST_ADD                                10'h0_00
`define INST_SUB                                10'h0_20
`define INST_XOR                                10'h4_00
`define INST_OR                                 10'h6_00
`define INST_AND                                10'h7_00
`define INST_SLL                                10'h1_00
`define INST_SRL                                10'h5_00
`define INST_SRA                                10'h5_00
`define INST_SLT                                10'h2_20
`define INST_SLTU                               10'h3_00

`define INST_ADDI                               3'h0
`define INST_XORI                               3'h4
`define INST_ORI                                3'h6
`define INST_ANDI                               3'h7
`define INST_SLLI                               3'h1
`define INST_SRLI                               3'h5
`define INST_SRAI                               3'h5
`define INST_SLTUI                              3'h3














