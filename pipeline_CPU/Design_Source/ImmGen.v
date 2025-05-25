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
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"

//-------------------------------------------------------------
// Generate immediate
//-------------------------------------------------------------
wire [6:0] opcode;
wire sign;
assign opcode = inst[6:0];
assign sign = inst[31];

always @(*) begin
    case (opcode)
        `OPCODE_R: imm32 = {32'b0};
        `OPCODE_I, `OPCODE_L, `OPCODE_JALR: imm32 = {{20{sign}},inst[31:20]};
        `OPCODE_S: imm32 = {{20{sign}}, inst[31:25], inst[11:7]};
        `OPCODE_B: imm32 = {{19{sign}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        `OPCODE_LUI, `OPCODE_AUIPC: imm32 = {inst[31:12], 12'b0};
        `OPCODE_JAL: imm32 = {{12{sign}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
        default:
            imm32 = 0;
    endcase
end
endmodule
