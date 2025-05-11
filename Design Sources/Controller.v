`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/26 22:38:53
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [31:0] inst,
    output Branch,
    output Jump,
    output [1:0] ALUOp,
    output ALUSrc,
    output MemRead,
    output MemWrite,
    output MemtoReg,
    output RegWrite
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Control signals
//-------------------------------------------------------------
wire [6:0] opcode;
assign opcode = inst[6:0];
assign Branch = (opcode == `OPCODE_B);
assign Jump = (opcode == `OPCODE_JAL);
assign ALUOp = {
            {(opcode != `OPCODE_L) && (opcode != `OPCODE_S) && (opcode != `OPCODE_B)}, 
            {(opcode != `OPCODE_L) && (opcode != `OPCODE_S) && (opcode != `OPCODE_R)}
        };
assign ALUSrc = (opcode == `OPCODE_I) || (opcode == `OPCODE_L) || (opcode == `OPCODE_S) || (opcode == `OPCODE_LUI) ||
            (opcode == `OPCODE_AUIPC);
assign MemRead = opcode == `OPCODE_L;
assign MemWrite = (opcode == `OPCODE_S);
assign MemtoReg = (opcode == `OPCODE_L);
assign RegWrite = (opcode == `OPCODE_R) || (opcode == `OPCODE_I) || (opcode == `OPCODE_L) || (opcode == `OPCODE_LUI) ||
            (opcode == `OPCODE_AUIPC) || (opcode == `OPCODE_JAL) || (opcode == `OPCODE_JALR);

endmodule
