`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/21 17:56:08
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
    input [31:0] inst,
    output reg[31:0] imm32
    );
wire [6:0] opcode;
wire sign;
assign opcode = inst[6:0];
assign sign = inst[31];
parameter R = 7'b0110011,
        I = 7'b0010011,
        L = 7'b0000011,
        S = 7'b0100011,
        B = 7'b1100011,
        LUI = 7'b0110111,
        AUIPC = 7'b0010111,
        J = 7'b1101111,
        JAL = 7'b1101111;

always @(*) begin
    case (opcode)
        R: imm32 = {32'b0};
        I, L, JAL: imm32 = {{20{sign}},inst[31:20]};
        S: imm32 = {{20{sign}}, inst[31:25], inst[11:7]};
        B: imm32 = {{19{sign}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        LUI, AUIPC: imm32 = {inst[31:12], 12'b0};
        J: imm32 = {{12{sign}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
    endcase
end
endmodule
