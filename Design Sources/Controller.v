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
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input ALUSrc,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [31:0] ALUResult,
    output zero
    );

reg [3:0] ALUControl;
wire [31:0] operand1 = ReadData1;
wire [31:0] operand2 = (ALUSrc==1) ? imm32 : ReadData2;

wire ADD = !(funct7 ^ 7'b0000000) && !(funct3 ^ 3'b000);
wire SUB = !(funct7 ^ 7'b0100000) && !(funct3 ^ 3'b000);
wire AND = !(funct7 ^ 7'b0000000) && !(funct3 ^ 3'b111);
wire OR = !(funct7 ^ 7'b0000000) && !(funct3 ^ 3'b110);

assign zero = (ALUResult==0) ? 1'b1 : 1'b0;

always @(*) begin
    case(ALUOp)
        2'b00:begin // load or store
            ALUControl = {ALUOp, 2'b10};
        end
        2'b01:begin // B-type
            ALUControl = {ALUOp, 2'b10};
        end
        2'b10:begin // R-type
            if (ADD)
                ALUControl = {4'b0010};
            else if (SUB)
                ALUControl = {4'b0110};
            else if (AND)
                ALUControl = {4'b0000};
            else if (OR)
                ALUControl = {4'b0001};
        end 
        2'b11: ALUControl = {ALUOp, 2'b00};
        default: ALUControl = {4'b1111};
    endcase
end

always @(*) begin
    case (ALUControl)
        4'b0000: ALUResult = operand1 & operand2;
        4'b0001: ALUResult = operand1 | operand2;
        4'b0010: ALUResult = operand1 + operand2;
        4'b0110: ALUResult = operand1 - operand2;
        default: 
            ALUResult = 32'b0;
    endcase
end

endmodule
