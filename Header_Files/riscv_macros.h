#ifndef RISCV_MACROS_H_
#define RISCV_MACROS_H_  // guard


// Opcode
#define OPCODE_R                                0b0110011
#define OPCODE_I                                0b0010011
#define OPCODE_L                                0b0000011
#define OPCODE_S                                0b0100011
#define OPCODE_B                                0b1100011
#define OPCODE_LUI                              0b0110111
#define OPCODE_AUIPC                            0b0010111
#define OPCODE_JAL                              0b1101111
#define OPCODE_JALR                             0b1100111

// ALUOp
#define ALUOP_L_S                               0b00
#define ALUOP_B                                 0b01
#define ALUOP_R                                 0b10
#define ALUOP_I                                 0b11

// ALU Operations
#define ALU_NONE                                0b0000
#define ALU_SHIFTL                              0b0001
#define ALU_SHIFTR                              0b0010
#define ALU_SHIFTR_ARITH                        0b0011
#define ALU_ADD                                 0b0100
#define ALU_SUB                                 0b0110
#define ALU_AND                                 0b0111
#define ALU_OR                                  0b1000
#define ALU_XOR                                 0b1001
#define ALU_LESS_THAN_UNSIGNED                  0b1010
#define ALU_LESS_THAN_SIGNED                    0b1011
#define ALU_SUB_UNSIGNED                        0b1100

// instruction funct for R-type
#define INST_ADD                                0b000
#define INST_SUB                                0x020
#define INST_XOR                                0x400
#define INST_OR                                 0x600
#define INST_AND                                0x700
#define INST_SLL                                0x100
#define INST_SRL                                0x500
#define INST_SRA                                0x500
#define INST_SLT                                0x220
#define INST_SLTU                               0x300

// instruction funct for I-type
#define INST_ADDI                               0x0
#define INST_XORI                               0x4
#define INST_ORI                                0x6
#define INST_ANDI                               0x7
#define INST_SLLI                               0x1
#define INST_SRLI                               0x5
#define INST_SRAI                               0x5
#define INST_SLTUI                              0x3

// instruction funct for B-type
#define INST_BEQ                                0x0
#define INST_BNE                                0x1
#define INST_BLT                                0x4
#define INST_BGE                                0x5
#define INST_BLTU                               0x6
#define INST_BGEU                               0x7

#endif