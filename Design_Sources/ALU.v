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
    input [2:0] funct3,             // from instruction
    input [6:0] funct7,             // from instruction
    input [3:0] Ftype,              // from instruction

    // Outputs
    output reg [31:0] ALUResult,    // result of ALU
    output reg zero                     // for B-type, from ALU to IFetch
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../Header_Files/riscv_defs.v"

//-------------------------------------------------------------
// Decode ALUOp and funct to ALUControl
//-------------------------------------------------------------
reg [3:0] ALUControl;
wire [31:0] operand1 = ReadData1;
wire [31:0] operand2 = (ALUSrc==1) ? imm32 : ReadData2;
wire [31:0] fadd_result;
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
            else if (Ftype == `INST_FADD)
                ALUControl = `ALU_FADD;
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

always @(*) begin
    case (ALUControl)
        `ALU_NONE:              ALUResult = 0;
        `ALU_SHIFTL:            ALUResult = operand1 << operand2[4:0];
        `ALU_SHIFTR:            ALUResult = operand1 >> operand2[4:0];
        `ALU_SHIFTR_ARITH:      ALUResult = $signed(operand1) >>> operand2[4:0];
        `ALU_ADD:               ALUResult = $signed(operand1) + $signed(operand2);
        `ALU_SUB:               ALUResult = $signed(operand1) - $signed(operand2);
        `ALU_AND:               ALUResult = operand1 & operand2;
        `ALU_OR:                ALUResult = operand1 | operand2;
        `ALU_XOR:               ALUResult = operand1 ^ operand2;
        `ALU_LESS_THAN_UNSIGNED:ALUResult = {31'b0, $unsigned(operand1) < $unsigned(operand2)};
        `ALU_LESS_THAN_SIGNED:  ALUResult = {31'b0, $signed(operand1) < $signed(operand2)};
        `ALU_SUB_UNSIGNED:      ALUResult = $unsigned(operand1) - $unsigned(operand2);
        `ALU_FADD:              ALUResult = fadd_result;
        default: 
            ALUResult = 0;
    endcase
end

//-------------------------------------------------------------
// Branch handling
//-------------------------------------------------------------
always @(*) begin
    if (ALUOp == 2'b01) begin
        case (funct3)
            `INST_BEQ:          zero = (ALUResult == 0);
            `INST_BNE:          zero = (ALUResult != 0);
            `INST_BLT:          zero = ($signed(ALUResult) < 0);
            `INST_BGE:          zero = ($signed(ALUResult) >= 0);
            `INST_BLTU:         zero = ($signed(ALUResult) < 0);
            `INST_BGEU:         zero = ($signed(ALUResult) >= 0);
            default: 
                zero = (ALUResult == 0);
        endcase
    end
    else 
        zero = (ALUResult == 0);
end

Float_Addition fadd(
    .operand1(operand1),
    .operand2(operand2),
    .addition_result(fadd_result)
);

endmodule

module Float_Addition(
    input [31:0]operand1,
    input [31:0]operand2,
    output reg [31:0]addition_result
);

wire [11:0] float1 = {operand1[7:0], 4'b0};  
wire [11:0] float2 = {operand2[7:0], 4'b0};  

reg  sign1, sign2, final_sign;       
reg  [2:0] exp1, exp2;       
reg  [15:0] m_align1, m_align2;
reg  [15:0] sum_m;        

always @(*) begin
    sign1 = float1[11];
    exp1  = float1[10:8];
    
    sign2 = float2[11];
    exp2  = float2[10:8];
    
    m_align1 = {7'b0, 1'b1, float1[7:0]};
    m_align2 = {7'b0, 1'b1, float2[7:0]};
    
    if (exp1 < 3) begin
        m_align1 = m_align1 >> (3 - exp1);
    end else if (exp1 > 3) begin
        m_align1 = m_align1 << (exp1 - 3);
    end

    if (exp2 < 3) begin
        m_align2 = m_align2 >> (3 - exp2);
    end else if (exp2 > 3) begin
        m_align2 = m_align2 << (exp2 - 3);
    end
    
    if(sign1 == sign2) begin
        sum_m = m_align1 + m_align2;
        final_sign = sign1;
    end else begin
        if(m_align1 >= m_align2) begin
            sum_m = m_align1 - m_align2;
            final_sign = sign1;
        end else begin
            sum_m = m_align2 - m_align1;
            final_sign = sign2;
        end
    end
    
    if (final_sign == 1) begin
        addition_result[31:24] = 8'hFF;
    end else begin
        addition_result[31:24] = 8'h00;
    end
    addition_result[23:0] = {16'b0, sum_m[15:8]};
    
end

endmodule
