`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 17:07:04
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    // Inputs
    input clk, rstn, Pause, Flush,
    input [31:0] ID_pc4_i,
    input        ID_Branch,     // Controller
    input        ID_Jump,
    input        ID_Jalr,
    input [1:0]  ID_ALUOp,
    input        ID_ALUSrc,
    input        ID_MemRead,
    input        ID_MemWrite,
    input        ID_MemtoReg,
    input        ID_RegWrite,
    // input        ID_ioRead,
    // input        ID_ioWrite,

    input [4:0]  ID_rs1_addr,   // ID
    input [4:0]  ID_rs2_addr,   // ID
    input [4:0]  ID_rd_addr,
    input [31:0] ID_rs1_v,      // ID
    input [31:0] ID_rs2_v,      // ID
    input [31:0] ID_imm32,      // ID
    input [2:0]  ID_funct3,     // ID
    input [6:0]  ID_funct7,     // ID

    // Outputs
    output reg [31:0] EX_pc4_i,
    output reg        EX_Branch,
    output reg        EX_Jump,
    output reg        EX_Jalr,
    output reg [1:0]  EX_ALUOp,     // EX_MEM
    output reg        EX_ALUSrc,
    output reg        EX_MemRead,
    output reg        EX_MemWrite,
    output reg        EX_MemtoReg,
    output reg        EX_RegWrite,
    // output reg        EX_ioRead,
    // output reg        EX_ioWrite,    // EX_MEM

    output reg [4:0]  EX_rs1_addr,  // EX_MEM
    output reg [4:0]  EX_rs2_addr,
    output reg [4:0]  EX_rd_addr,
    output reg [31:0] EX_rs1_v,
    output reg [31:0] EX_rs2_v,
    output reg [31:0] EX_imm32,
    output reg [2:0]  EX_funct3,
    output reg [6:0]  EX_funct7     // EX_MEM
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"
always @(posedge clk) begin
    if (~rstn || Pause || Flush) begin
        EX_pc4_i         = 0;
        EX_Branch        = 0;
        EX_Jump          = 0;
        EX_Jalr          = 0;
        EX_ALUOp         = 0;
        EX_ALUSrc        = 0;
        EX_MemRead       = 0;
        EX_MemWrite      = 0;
        EX_MemtoReg      = 0;
        EX_RegWrite      = 0;
        // EX_ioRead        = 0;
        // EX_ioWrite       = 0;
        EX_rs1_addr      = 0;
        EX_rs2_addr      = 0;
        EX_rd_addr       = 0;

        EX_rs1_v         = 0;
        EX_rs2_v         = 0;
        EX_imm32         = 0;
        EX_funct3        = 0;
        EX_funct7        = 0;
    end
    else begin
        EX_pc4_i         = ID_pc4_i;
        EX_Branch       <= ID_Branch;
        EX_Jump         <= ID_Jump;
        EX_Jalr         <= ID_Jalr;
        EX_ALUOp        <= ID_ALUOp;
        EX_ALUSrc       <= ID_ALUSrc;
        EX_MemRead      <= ID_MemRead;
        EX_MemWrite     <= ID_MemWrite;
        EX_MemtoReg     <= ID_MemtoReg;
        EX_RegWrite     <= ID_RegWrite;
        // EX_ioRead       <= ID_ioRead;
        // EX_ioWrite      <= ID_ioWrite;
        EX_rs1_addr     <= ID_rs1_addr;
        EX_rs2_addr     <= ID_rs2_addr;
        EX_rd_addr      <= ID_rd_addr;

        EX_rs1_v        <= ID_rs1_v;
        EX_rs2_v        <= ID_rs2_v;
        EX_imm32        <= ID_imm32;
        EX_funct3       <= ID_funct3;
        EX_funct7       <= ID_funct7;
    end
end

endmodule
