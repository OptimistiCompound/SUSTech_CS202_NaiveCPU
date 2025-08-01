`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/26 23:37:15
// Design Name: 
// Module Name: ALU
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

 
module ALU(
    // Inputs
    input [31:0] ReadData1,         // data from rs1
    input [31:0] ReadData2,         // data from rs2
    input [31:0] imm32,             // immediate
    input ALUSrc,                   // MUX control, operand2 = (ALU == 1) ? rs2 : imm
    input [1:0] ALUOp,              // 2bits control
    input [1:0] Utype,
    input [31:0] pc4_i,
    input [2:0] funct3,             // from instruction
    input [6:0] funct7,             // from instruction

    // Outputs
    output reg [31:0] ALUResult,    // result of ALU
    output reg zero                     // for B-type, from ALU to IFetch
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"

//-------------------------------------------------------------
// Decode ALUOp and funct to ALUControl
//-------------------------------------------------------------
reg [3:0] ALUControl;
wire [31:0] operand1 = ReadData1;
wire [31:0] operand2 = (ALUSrc==1) ? imm32 : ReadData2;
wire [11:0] com_funct = {1'b0, funct3, 1'b0, funct7};
always @(*) begin
    case(ALUOp)
        2'b00:begin // load-type, S-type
            ALUControl = `ALU_ADD;
        end
        2'b01:begin // B-type
            if (funct3 == `INST_BLTU || funct3 == `INST_BGEU)
                ALUControl = `ALU_SUB_UNSIGNED;
            else
                ALUControl = `ALU_SUB;
        end
        2'b10:begin // R-type
            if (com_funct == `INST_ADD)
                ALUControl = `ALU_ADD;
            else if (com_funct == `INST_SUB)
                ALUControl = `ALU_SUB;
            else if (com_funct == `INST_XOR)
                ALUControl = `ALU_XOR;
            else if (com_funct == `INST_OR)
                ALUControl = `ALU_OR;
            else if (com_funct == `INST_AND)
                ALUControl = `ALU_AND;
            else if (com_funct == `INST_SLL)
                ALUControl = `ALU_SHIFTL;
            else if (com_funct == `INST_SRL)
                ALUControl = `ALU_SHIFTR;
            else if (com_funct == `INST_SRA)
                ALUControl = `ALU_SHIFTR_ARITH;
            else if (com_funct == `INST_SLT)
                ALUControl = `ALU_LESS_THAN_SIGNED;
            else if (com_funct == `INST_SLTU)
                ALUControl = `ALU_LESS_THAN_UNSIGNED;
            else 
                ALUControl = `ALU_NONE;
        end 
        2'b11:begin // I-type
            if (funct3 == `INST_ADDI)
                ALUControl = `ALU_ADD;
            else if (funct3 == `INST_XORI)
                ALUControl = `ALU_XOR;
            else if (funct3 == `INST_ORI)
                ALUControl = `ALU_OR;
            else if (funct3 == `INST_ANDI)
                ALUControl = `ALU_AND;
            else if (com_funct == `INST_SLLI)
                ALUControl = `ALU_SHIFTL;
            else if (com_funct == `INST_SRLI)
                ALUControl = `ALU_SHIFTR;
            else if (com_funct == `INST_SRAI)
                ALUControl = `ALU_SHIFTR_ARITH;
            else if (funct3 == `INST_SLTI)
                ALUControl = `ALU_LESS_THAN_SIGNED;
            else if (funct3 == `INST_SLTUI)
                ALUControl = `ALU_LESS_THAN_UNSIGNED;
            else
                ALUControl = `ALU_NONE;
        end
    endcase
end

reg [31:0] Result_1;
reg [31:0] Result_2;
always @(*) begin
    case (Utype)
        `INST_LUI:      Result_2 = imm32;
        `INST_AUIPC:    Result_2 = pc4_i + imm32 + `PC_OFFSET;
        default:        Result_2 = 0;
    endcase
end

always @(*) begin
    case (ALUControl)
        `ALU_NONE:              Result_1 = 0;
        `ALU_SHIFTL:            Result_1 = operand1 << operand2[4:0];
        `ALU_SHIFTR:            Result_1 = operand1 >> operand2[4:0];
        `ALU_SHIFTR_ARITH:      Result_1 = $signed(operand1) >>> operand2[4:0];
        `ALU_ADD:               Result_1 = $signed(operand1) + $signed(operand2);
        `ALU_SUB:               Result_1 = $signed(operand1) - $signed(operand2);
        `ALU_AND:               Result_1 = operand1 & operand2;
        `ALU_OR:                Result_1 = operand1 | operand2;
        `ALU_XOR:               Result_1 = operand1 ^ operand2;
        `ALU_LESS_THAN_UNSIGNED:Result_1 = {31'b0, $unsigned(operand1) < $unsigned(operand2)};
        `ALU_LESS_THAN_SIGNED:  Result_1 = {31'b0, $signed(operand1) < $signed(operand2)};
        `ALU_SUB_UNSIGNED:      Result_1 = $unsigned(operand1) - $unsigned(operand2);
        default: 
            Result_1 = 0;
    endcase
end

//-------------------------------------------------------------
// Branch handling
//-------------------------------------------------------------
always @(*) begin
    if (ALUOp == 2'b01) begin
        case (funct3)
            `INST_BEQ:          zero = (Result_1 == 0);
            `INST_BNE:          zero = (Result_1 != 0);
            `INST_BLT:          zero = ($signed(Result_1) < 0);
            `INST_BGE:          zero = ($signed(Result_1) >= 0);
            `INST_BLTU:         zero = ($unsigned(operand1) < $unsigned(operand2));
            `INST_BGEU:         zero = ($unsigned(operand1) >= $unsigned(operand2));
            default: 
                zero = (Result_1 == 0);
        endcase
    end
    else 
        zero = (Result_1 == 0);
end

//-------------------------------------------------------------
// MUX
//-------------------------------------------------------------
always @(*) begin
    if(Utype)
        ALUResult = Result_2;
    else 
        ALUResult = Result_1;
end

endmodule
